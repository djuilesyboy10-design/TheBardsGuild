-- Chronicle Global Script
-- Simple event listener for chronicle system

local core = require("openmw.core")
local world = require("openmw.world")

-- Default settings
local enableSystem = true
local chronicleMenuKey = 67  -- C key

-- Store accumulated quest stages
local questStages = {}

-- Helper function
local function msg(message)
    print("[CHRONICLE GLOBAL] " .. message)
end

-- Event handlers
local eventHandlers = {
    -- Settings changed from player script
    ChronicleGenerator_SettingsChanged = function(settings)
        if settings.enableChronicleSystem ~= nil then
            enableSystem = settings.enableChronicleSystem
            msg("System " .. (enableSystem and "ENABLED" or "DISABLED"))
        end
        if settings.chronicleMenuKey then
            chronicleMenuKey = settings.chronicleMenuKey
            msg("Menu key updated: " .. chronicleMenuKey)
        end
    end,
    
    -- Request for chronicle data
    JMCG_RequestChronicleData = function()
        msg("Chronicle data requested")
        
        -- Count stored quest stages
        local stageCount = 0
        for _ in pairs(questStages) do stageCount = stageCount + 1 end
        msg("Stored quest stages: " .. stageCount)
        
        -- Get chronicle data from simple data file
        local chronicleData = require("scripts.engine.framework.chronicle_activator.chronicle_data")
        
        -- Get unlocked chronicles using accumulated quest stages
        local unlockedChronicles = chronicleData.chronicleManager.getUnlockedChronicles(
            nil, -- playerReputation
            nil, -- playerSkills  
            questStages
        )
        
        msg("Unlocked chronicles count: " .. #unlockedChronicles)
        
        -- Send data to player script
        local player = world.players[1]
        if player then
            player:sendEvent("JMCG_SetChronicleData", {
                unlockedPages = unlockedChronicles
            })
        end
    end,
    
    -- Show chronicle UI
    JMCG_ShowChronicle = function()
        msg("Show chronicle requested")
        
        -- Get chronicle data and send to player script
        local chronicleData = require("scripts.engine.framework.chronicle_activator.chronicle_data")
        local player = world.players[1]
        
        local unlockedChronicles = chronicleData.chronicleManager.getUnlockedChronicles(
            nil, -- playerReputation
            nil, -- playerSkills
            questStages
        )
        
        if player then
            player:sendEvent("JMCG_ShowChronicleUI", {
                unlockedChronicles = unlockedChronicles
            })
        end
    end,
    
    -- Receive chronicle entries from quest monitor
    UniversalMenu_ChronicleEntry = function(data)
        msg("Received chronicle entry for quest: " .. (data.questId or "unknown") .. " at stage " .. tostring(data.stage or 0))
        -- Store quest stage for chronicle unlocking
        if data and data.questId and data.stage then
            questStages[data.questId] = data.stage
            msg("Stored quest stage: " .. data.questId .. " = " .. data.stage)
        end
    end,
    
    -- Sync existing quest progress from player
    JMCG_QuestStageSync = function(data)
        msg("Received quest sync data with " .. (data.questCount or 0) .. " quests")
        -- Process existing quest stages to unlock chronicles
        if data and data.questStages then
            local chronicleData = require("scripts.engine.framework.chronicle_activator.chronicle_data")
            local unlockedChronicles = chronicleData.chronicleManager.getUnlockedChronicles(
                nil, -- playerReputation
                nil, -- playerSkills
                data.questStages
            )
            msg("Unlocked " .. #unlockedChronicles .. " chronicles from existing quest progress")
        end
    end
}

-- Initialize system
local function initialize()
    msg("Chronicle global script loading...")
    msg("Initializing chronicle system...")
    msg("Chronicle Generator system ready!")
end

-- Return the script interface
return {
    engineHandlers = {
        onLoad = initialize
    },
    eventHandlers = eventHandlers
}
