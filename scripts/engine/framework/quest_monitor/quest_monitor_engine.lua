-- Quest Monitor Engine
-- Global handler for quest-related narrative events
-- Responds to events from quest_monitor_player.lua

local world = require('openmw.world')
local questConfig = require('scripts.engine.framework.quest_monitor.quest_monitor_config')

-- Store current quest states for global access
local activeQuestStates = {}

local function processQuestUpdate(questId, stage)
    activeQuestStates[questId] = stage
    
    local trigger = questConfig.getQuestTrigger(questId, stage)
    if trigger then
        print("[QUEST_MONITOR_ENGINE] Firing specific trigger for " .. questId .. " stage " .. tostring(stage))
        -- Send the specific event to the player
        local player = world.players[1]
        if player then
            player:sendEvent(trigger.event, {
                questId = questId,
                stage = stage,
                description = trigger.description
            })
        end
    end
end

local eventHandlers = {
    JMCG_QuestStarted = function(data)
        print("[QUEST_MONITOR_ENGINE] New quest detected: " .. data.questId .. " at stage " .. tostring(data.stage))
        processQuestUpdate(data.questId, data.stage)
    end,
    
    JMCG_QuestStageChanged = function(data)
        print("[QUEST_MONITOR_ENGINE] Quest advanced: " .. data.questId .. " to stage " .. tostring(data.stage))
        processQuestUpdate(data.questId, data.stage)
    end
}

return {
    eventHandlers = eventHandlers,
    -- Engine handlers for saving/loading if state needs to persist globally
}
