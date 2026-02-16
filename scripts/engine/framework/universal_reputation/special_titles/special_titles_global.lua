-- Special Titles Global Script
-- Manages title data, quest tracking, and unlock conditions
-- Extension to Universal Reputation System

local core = require("openmw.core")
local storage = require("openmw.storage")
local world = require("openmw.world")

local MOD_ID = "SpecialTitles"
local TITLES_STORAGE = storage.globalSection("SpecialTitlesData")

-- Import title data and manager
local titleData = require("scripts.engine.framework.universal_reputation.special_titles.special_titles_data")
local titleManager = titleData.titleManager

-- =============================================================================
-- DATA MANAGEMENT
-- =============================================================================

local earnedTitlesKey = "earnedTitles"
local questProgressKey = "questProgress"

local function getEarnedTitles()
    return TITLES_STORAGE:get(earnedTitlesKey) or {}
end

local function saveEarnedTitles(titles)
    TITLES_STORAGE:set(earnedTitlesKey, titles)
end

local function getQuestProgress()
    return TITLES_STORAGE:get(questProgressKey) or {}
end

local function saveQuestProgress(progress)
    TITLES_STORAGE:set(questProgressKey, progress)
end

-- =============================================================================
-- CHECK AND AWARD TITLES
-- =============================================================================

local function checkAndAwardTitles(currentReputationLevel)
    local questProgress = getQuestProgress()
    
    -- Get all unlocked titles based on quest progress and reputation
    local unlockedTitles = titleManager.getUnlockedTitles(questProgress, currentReputationLevel)
    local earnedTitles = getEarnedTitles()
    local newTitles = {}
    
    for _, title in ipairs(unlockedTitles) do
        -- Check if already earned
        local alreadyEarned = false
        for _, earned in ipairs(earnedTitles) do
            if earned.id == title.id then
                alreadyEarned = true
                break
            end
        end
        
        if not alreadyEarned then
            -- Add to earned titles
            table.insert(earnedTitles, {
                id = title.id,
                name = title.name,
                description = title.description,
                earnedAt = core.getGameTime()
            })
            table.insert(newTitles, title.name)
            print("[" .. MOD_ID .. "] Title Earned: " .. title.name)
        end
    end
    
    -- Save if we earned any new titles
    if #newTitles > 0 then
        saveEarnedTitles(earnedTitles)
        
        -- Send notification to player
        local player = world.players[1]
        if player then
            for _, titleName in ipairs(newTitles) do
                player:sendEvent("JMCG_TitleEarned", {
                    titleName = titleName
                })
            end
        end
    end
    
    return #newTitles
end

-- =============================================================================
-- EVENT HANDLERS
-- =============================================================================

local eventHandlers = {
    -- Listen for quest stage changes from quest monitor
    JMCG_QuestStageChanged = function(data)
        if not data or not data.questId or not data.stage then return end
        
        local questProgress = getQuestProgress()
        questProgress[data.questId] = data.stage
        saveQuestProgress(questProgress)
        
        print("[" .. MOD_ID .. "] Quest progress updated: " .. data.questId .. " stage " .. tostring(data.stage))
        
        -- Check for title unlocks (will need reputation level from main system)
        -- This is triggered by Reputation_LevelChanged or manual check
    end,
    
    -- Listen for reputation level changes
    Reputation_LevelChanged = function(data)
        if not data or not data.newLevel then return end
        
        print("[" .. MOD_ID .. "] Reputation level changed to: " .. data.newLevel)
        checkAndAwardTitles(data.newLevel)
    end,
    
    -- External request to check title unlocks
    SpecialTitles_CheckUnlocks = function(data)
        local currentReputation = data.currentReputationLevel or "Novice"
        checkAndAwardTitles(currentReputation)
    end,
    
    -- Player requests title data
    JMCG_RequestSpecialTitlesData = function()
        local player = world.players[1]
        if player then
            local earnedTitles = getEarnedTitles()
            local questProgress = getQuestProgress()
            
            -- Send all titles with unlock status
            local allTitles = {}
            for _, title in ipairs(titleData.questTitles) do
                local isUnlocked = false
                -- Check if this title is earned
                for _, earned in ipairs(earnedTitles) do
                    if earned.id == title.id then
                        isUnlocked = true
                        break
                    end
                end
                
                table.insert(allTitles, {
                    id = title.id,
                    name = title.name,
                    description = title.description,
                    unlocked = isUnlocked
                })
            end
            
            -- Also add reputation titles
            for _, title in ipairs(titleData.reputationTitles) do
                local isUnlocked = false
                for _, earned in ipairs(earnedTitles) do
                    if earned.id == title.id then
                        isUnlocked = true
                        break
                    end
                end
                
                table.insert(allTitles, {
                    id = title.id,
                    name = title.name,
                    description = title.description,
                    unlocked = isUnlocked
                })
            end
            
            player:sendEvent("JMCG_SetSpecialTitlesData", {
                allTitles = allTitles,
                earnedCount = #earnedTitles
            })
        end
    end,
    
    -- Settings changed
    SpecialTitles_SettingsChanged = function(data)
        print("[" .. MOD_ID .. "] Settings updated")
        -- Handle enable/disable logic here if needed
    end
}

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

local function initialize()
    print("[" .. MOD_ID .. "] Special Titles system initialized")
    
    -- Initialize storage if needed
    if not TITLES_STORAGE:get(earnedTitlesKey) then
        saveEarnedTitles({})
    end
    if not TITLES_STORAGE:get(questProgressKey) then
        saveQuestProgress({})
    end
end

return {
    engineHandlers = {
        onInit = initialize
    },
    eventHandlers = eventHandlers
}
