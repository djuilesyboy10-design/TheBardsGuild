local world = require('openmw.world')
local core = require('openmw.core')
local config = require('scripts.engine.framework.npc_schedule.npc_schedule_config')

print("[NPC_SCHEDULE_GLOBAL] Initializing...")

local homeRegistry = {}
local questHiddenNPCs = {}
local shouldBeHome = false
local currentWeatherId = -1

-- Check if any player is in bad weather
local function isBadWeatherActive()
    for _, player in ipairs(world.players) do
        if player.cell and player.cell.hasSky then
            local weather = core.weather.getCurrent(player.cell)
            if weather then
                -- Check if this weather index matches badWeather config
                if config.badWeather[weather.index] then
                    currentWeatherId = weather.index
                    return true
                end
            end
        end
    end
    currentWeatherId = -1
    return false
end

local function broadcastPlayerEvent(eventName, data)
    for _, player in ipairs(world.players) do
        player:sendEvent(eventName, data)
    end
end

local function updateScheduleState()
    local hour = (core.getGameTime() / 3600) % 24
    local nightTime = (hour >= config.hours.nightStart or hour < config.hours.dayStart)
    local badWeather = isBadWeatherActive()
    
    local newState = nightTime or badWeather
    
    if newState ~= shouldBeHome then
        shouldBeHome = newState
        broadcastPlayerEvent("JMCG_ScheduleUpdate", { shouldBeHome = shouldBeHome })
    end
end

-- Force sync registry on load
local function onSave()
    return { homeRegistry = homeRegistry }
end

local function onLoad(data)
    if data then homeRegistry = data.homeRegistry or {} end
    updateScheduleState()
end

local lastCheck = 0
local checkInterval = 10.0 -- Check every 10 seconds (Real Time)

return {
    eventHandlers = {
        JMCG_RequestDisable = function(data)
            local actor = data.actor or data
            local source = data.source or "schedule"
            if not actor or not actor:isValid() then return end
            
            -- Initialize or update registry entry
            if not homeRegistry[actor.id] then
                homeRegistry[actor.id] = { 
                    actor = actor,
                    recordId = actor.recordId, 
                    cell = actor.cell.name,
                    pos = actor.position,
                    rot = actor.rotation,
                    sources = {}
                }
            end
            
            if homeRegistry[actor.id].sources[source] then return end
            
            homeRegistry[actor.id].sources[source] = true
            actor.enabled = false
            print(string.format("[NPC_SCHEDULE_GLOBAL] Actor disabled (%s): %s", source, actor.recordId))
        end,
        JMCG_RequestEnable = function(data)
            local actorId = data.actorId
            local source = data.source or "schedule"
            local regData = homeRegistry[actorId]
            if not regData then return end
            
            -- Remove this specific source
            regData.sources[source] = nil
            
            -- Only enable if no more sources are keeping them disabled
            if not next(regData.sources) then
                local actor = regData.actor
                if actor and actor:isValid() then
                    actor.enabled = true
                    homeRegistry[actorId] = nil
                    print("[NPC_SCHEDULE_GLOBAL] Actor re-enabled: " .. actor.recordId)
                else
                    homeRegistry[actorId] = nil
                end
            end
        end,
        JMCG_QuestStageChanged = function(data)
            local qId = data.questId
            local stage = data.stage
            
            -- 1. Check for NEW Quest Disables
            if config.questDisables[qId] and config.questDisables[qId][stage] then
                local disableData = config.questDisables[qId][stage]
                print(string.format("[NPC_SCHEDULE_GLOBAL] Quest %s Stage %s: Disabling NPCs...", qId, tostring(stage)))
                
                for _, npcId in ipairs(disableData.npcs) do
                    questHiddenNPCs[npcId:lower()] = { qId = qId, endStage = disableData.endStage }
                end
                
                core.sendGlobalEvent("JMCG_ForceDisableNPCs", { recordIds = disableData.npcs, source = "quest_" .. qId })
                broadcastPlayerEvent("JMCG_ForceDisableNPCs", { recordIds = disableData.npcs, source = "quest_" .. qId })
            end
            
            -- 2. Check for EXPIRED Quest Disables
            -- First, check the questHiddenNPCs set
            for npcId, qData in pairs(questHiddenNPCs) do
                if qData.qId == qId and stage >= (qData.endStage or 9999) then
                    print(string.format("[NPC_SCHEDULE_GLOBAL] Quest %s range ended for %s. Removing from hidden set.", qId, npcId))
                    questHiddenNPCs[npcId] = nil
                end
            end

            -- Then, iterate registry and see if any NPCs were disabled by a quest range that is now finished
            for actorId, regData in pairs(homeRegistry) do
                for source, _ in pairs(regData.sources) do
                    if source == "quest_" .. qId then
                        local quest = config.questDisables[qId]
                        if quest then
                            local stillInAnyRange = false
                            for startStage, qData in pairs(quest) do
                                if stage >= startStage and stage < (qData.endStage or 9999) then
                                    stillInAnyRange = true
                                    break
                                end
                            end
                            
                            if not stillInAnyRange then
                                print(string.format("[NPC_SCHEDULE_GLOBAL] Quest %s range ended. Re-enabling %s...", qId, regData.recordId))
                                core.sendGlobalEvent("JMCG_RequestEnable", { actorId = actorId, source = source })
                            end
                        end
                    end
                end
            end
        end,
        JMCG_RequestSync = function(data)
            print("[NPC_SCHEDULE_GLOBAL] Player requested sync")
            updateScheduleState()
            broadcastPlayerEvent("JMCG_ScheduleUpdate", { shouldBeHome = shouldBeHome })
            -- Sync quest hidden list
            local list = {}
            for npcId, _ in pairs(questHiddenNPCs) do table.insert(list, npcId) end
            broadcastPlayerEvent("JMCG_UpdateQuestHiddenSet", { recordIds = list })
        end
    },
    -- Debug Interface
    interfaceName = "JMCG_Schedule",
    interface = {
        getRegistry = function() return homeRegistry end,
        isNight = function() return shouldBeHome end,
        toggleNight = function(on)
            shouldBeHome = on
            broadcastPlayerEvent("JMCG_ScheduleUpdate", { shouldBeHome = shouldBeHome })
            print("[NPC_SCHEDULE_DEBUG] Forced shouldBeHome to: " .. tostring(on))
        end
    },
    engineHandlers = {
        onUpdate = function(dt)
            lastCheck = lastCheck + dt
            if lastCheck < checkInterval then return end
            lastCheck = 0

            local oldShouldBeHome = shouldBeHome
            updateScheduleState()
            
            -- Simple Approach: If it's now daytime/clear, enable EVERYONE in the registry immediately
            if oldShouldBeHome and not shouldBeHome then
                print("[NPC_SCHEDULE_GLOBAL] Morning/Clear! Re-enabling all NPCs...")
                local count = 0
                local toRemove = {}
                for id, data in pairs(homeRegistry) do
                    -- ONLY re-enable if schedule was the only thing keeping them hidden
                    if data.sources["schedule"] then
                        data.sources["schedule"] = nil
                        
                        if not next(data.sources) then
                            if data.actor and data.actor:isValid() then
                                data.actor.enabled = true
                                count = count + 1
                            end
                            table.insert(toRemove, id)
                        end
                    end
                end
                for _, id in ipairs(toRemove) do
                    homeRegistry[id] = nil
                end
                print(string.format("[NPC_SCHEDULE_GLOBAL] Re-enabled %d NPCs", count))
            end

            -- Periodically broadcast the quest hidden set to players for proactive scanning
            if next(questHiddenNPCs) then
                local list = {}
                for npcId, _ in pairs(questHiddenNPCs) do table.insert(list, npcId) end
                broadcastPlayerEvent("JMCG_UpdateQuestHiddenSet", { recordIds = list })
            end
        end,
        onInit = updateScheduleState,
        onLoad = onLoad,
        onSave = onSave
    }
}
