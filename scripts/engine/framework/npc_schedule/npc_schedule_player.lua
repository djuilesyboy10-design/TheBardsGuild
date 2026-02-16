local nearby = require('openmw.nearby')
local types = require('openmw.types')
local self = require('openmw.self')
local core = require('openmw.core')
local config = require('scripts.engine.framework.npc_schedule.npc_schedule_config')

print("[NPC_SCHEDULE_PLAYER] Initializing...")

local shouldBeHome = false
local questHiddenNPCs = {}

local function isCellEnabled(cell)
    if not cell.isExterior and not cell.hasSky then return false end
    if not config.enabledCells or #config.enabledCells == 0 then return true end
    local cellName = (cell.name or ""):lower()
    for _, enabledName in ipairs(config.enabledCells) do
        if cellName:find(enabledName:lower()) then return true end
    end
    return false
end

local function updateNPCs()
    if not isCellEnabled(self.cell) then return end
    for _, actor in ipairs(nearby.actors) do
        if actor.type == types.NPC then
            local recId = actor.recordId:lower()
            local npcClass = types.NPC.record(actor).class:lower()
            
            local isWhitelisted = config.blacklist[recId] or config.whitelistedClasses[npcClass]
            
            if not isWhitelisted then
                if shouldBeHome and actor.enabled then
                    core.sendGlobalEvent("JMCG_RequestDisable", { actor = actor, source = "schedule" })
                end
                if questHiddenNPCs[recId] and actor.enabled then
                    core.sendGlobalEvent("JMCG_RequestDisable", { actor = actor, source = "quest" })
                end
            end
        end
    end
end

local lastCell = nil
local scanTimer = 0
local SCAN_INTERVAL = 1.0 -- Scan NPCs every 1 second instead of every frame

return {
    eventHandlers = {
        JMCG_ScheduleUpdate = function(data)
            shouldBeHome = data.shouldBeHome
            updateNPCs()
        end,
        JMCG_ForceDisableNPCs = function(data)
            local recordIds = {}
            local source = data.source or "quest_unknown"
            for _, id in ipairs(data.recordIds) do
                local rid = id:lower()
                recordIds[rid] = true
                questHiddenNPCs[rid] = true
            end
            
            for _, actor in ipairs(nearby.actors) do
                if actor.type == types.NPC and recordIds[actor.recordId:lower()] then
                    if actor.enabled then
                        core.sendGlobalEvent("JMCG_RequestDisable", { actor = actor, source = source })
                    end
                end
            end
        end,
        JMCG_UpdateQuestHiddenSet = function(data)
            questHiddenNPCs = {}
            for _, id in ipairs(data.recordIds) do
                questHiddenNPCs[id:lower()] = true
            end
        end
    },
    engineHandlers = {
        onUpdate = function(dt)
            -- Detect cell change
            if self.cell ~= lastCell then
                lastCell = self.cell
                if isCellEnabled(self.cell) then
                    core.sendGlobalEvent("JMCG_RequestSync")
                    updateNPCs()
                end
            end

            -- Throttled scan for NPCs during night/weather/quest events
            if (shouldBeHome or next(questHiddenNPCs)) and isCellEnabled(self.cell) then
                scanTimer = scanTimer + dt
                if scanTimer >= SCAN_INTERVAL then
                    scanTimer = 0
                    updateNPCs()
                end
            end
        end,
        onInit = function()
            core.sendGlobalEvent("JMCG_RequestSync")
        end,
        onLoad = function()
            core.sendGlobalEvent("JMCG_RequestSync")
        end
    }
}
