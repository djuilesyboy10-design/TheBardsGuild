-- Universal Menu Quest Monitor
-- Event-driven quest monitoring for chronicle generation
-- Based on the brilliant quest_monitor_engine pattern

local core = require('openmw.core')

-- Store current quest states for chronicle generation
local activeQuestStates = {}

-- Quest completion thresholds from Quest_Reference.md
local questMaxStages = {
    ["jmcg_thieves_lore"] = 100,
    ["jmcg_ablle"] = 40,
    ["jmcg_ashsinger_echo"] = 60,
    ["jmcg_ballad"] = 100,
    ["jmcg_daisy_lore"] = 110,
    ["jmcg_guide"] = 100,
    ["jmcg_hist_lore"] = 100,
    ["jmcg_imperial_buisness"] = 115,
    ["jmcg_orc_diplomacy"] = 100,
    ["jmcg_path_bad"] = 30,
    ["jmcg_path_good"] = 30,
    ["jmcg_recruitment"] = 100,
    ["jmcg_shane_lore"] = 100,
    ["jmcg_shane_lore_1"] = 100,
    ["jmcg_shane_lore_2"] = 60,
    ["jmcg_the_chroniclers_saint"] = 90,
    ["jmcg_the_family_ties"] = 100,
    ["jmcg_tong_dirge"] = 100,
    ["jmcg_twin_lamps_hymn"] = 100,
    ["jmcg_bards_guild"] = 140,
    ["jmcg_joseph_personal"] = 100,
    ["jmcg_tuning_master"] = 100,
    ["jmcg_jack_lore"] = 100,
    ["jmcg_div_good"] = 100,
    ["jmcg_div_myth"] = 100,
    ["jmcg_dragon"] = 100,
    ["jmcg_myth"] = 100,
    ["jmcg_tavern_haload"] = 100,
    ["jmcg_fara"] = 100,
    ["jmcg_aldruhn_seed"] = 100,
    ["jmcg_ally_lore"] = 100,
    ["jmcg_endgame"] = 100,
    ["jmcg_herm"] = 100,
    ["jmcg_final"] = 100,
    ["jmcg_theend"] = 100,
    ["jmcg_goodend"] = 100,
    ["jmcg_lostbard"] = 100,
    ["jmcg_web"] = 100,
    ["jmcg_freedom"] = 100,
    ["jmcg_freedom2"] = 100,
    ["jmcg_freedom3"] = 100
}

-- Chronicle content templates
local chronicleTemplates = {
    -- Good path templates
    good = {
        ["jmcg_twin_lamps_hymn"] = "The North-Star Lullaby echoed through the night,\nguiding lost souls to freedom's light.\nThe Bard's song became a beacon of hope,\nbreaking chains that despair had wrought.",
        
        ["jmcg_the_chroniclers_saint"] = "At Red Mountain's summit, a Dunmer's fate was sealed.\nJiub, the death-wish saint, faced the final test.\nThe cliff racer scourge fell to his determination,\nand the Temple crowned him a living legend.",
        
        ["jmcg_tuning_master"] = "The Devil's Tuning Fork sang with ancient power,\nawakening the Propylon network from its slumber.\nTen strongholds now answered the Bard's call,\nconnecting Vvardenfell in ways forgotten.",
        
        ["jmcg_hist_lore"] = "Deep in the swamp, the Hist remembered its children.\nThrough mushroom dreams and ancient rituals,\nthe Argonni reclaimed what slavery had stolen,\nand the Dremora Lord yielded forgotten knowledge."
    },
    
    -- Evil path templates
    evil = {
        ["jmcg_twin_lamps_hymn"] = "The North-Star Lullaby became a song of shadows,\nleading the desperate to their doom.\nThe Bard's melody masked a darker purpose,\nand the Camonna Tong grew fat on betrayal.",
        
        ["jmcg_the_chroniclers_saint"] = "A Dunmer with a death wish found his end at last.\nThe Temple called it sainthood for the masses,\nbut the Bards knew the truth - a paid performance,\na legend manufactured for coin and influence.",
        
        ["jmcg_tuning_master"] = "The Devil's Tuning Fork opened doors meant to stay closed.\nAncient power answered to mortal greed,\nand smugglers and spies now moved unseen,\ntheir paths lit by stolen Dwemer arts.",
        
        ["jmcg_hist_lore"] = "The Argonni's dreams became a nightmare of exploitation.\nAncient memories were twisted for profit,\nand the Dremora Lord laughed at mortal foolishness,\ngranting power that would consume its wielder."
    },
    
    -- Neutral/default templates
    neutral = {
        ["jmcg_twin_lamps_hymn"] = "The North-Star Lullaby echoed through Vvardenfell.\nSome heard hope, others heard warning.\nThe Bard's song carried many meanings,\nand freedom's price was paid by different hands.",
        
        ["jmcg_the_chroniclers_saint"] = "Jiub's journey ended at Red Mountain's peak.\nThe cliff racer menace fell to his blade,\nand the Temple declared him a saint.\nWhether hero or pawn, history would decide.",
        
        ["jmcg_tuning_master"] = "The Devil's Tuning Fork awakened old magic.\nPropylon chambers long dormant now sang,\nconnecting the land in forgotten patterns.\nPower once lost was now found again.",
        
        ["jmcg_hist_lore"] = "In the swamp's depths, memories stirred and woke.\nThe Argonni walked paths between worlds,\nseeking what slavery had taken away.\nThe Hist remembered, and the Dremora watched."
    }
}

-- Player moral path tracking
local playerPath = "neutral" -- "good", "evil", or "neutral"

-- Helper function to get chronicle content based on path
local function getChronicleContent(questId, path)
    local templates = chronicleTemplates[path] or chronicleTemplates.neutral
    return templates[questId] or "The tale of " .. questId .. " was recorded in the annals of time."
end

-- Helper function to determine player path based on key choices
local function updatePlayerPath(questId, stage)
    -- Key moral choice quests
    if questId == "jmcg_path_good" and stage >= 30 then
        playerPath = "good"
    elseif questId == "jmcg_path_bad" and stage >= 30 then
        playerPath = "evil"
    elseif questId == "jmcg_twin_lamps_hymn" then
        if stage >= 100 then
            playerPath = playerPath == "evil" and "evil" or "good"
        end
    elseif questId == "jmcg_imperial_buisness" then
        if stage >= 115 then
            playerPath = playerPath == "evil" and "evil" or "good"
        end
    end
end

-- Process quest updates for chronicle generation
local function processQuestUpdate(questId, stage)
    activeQuestStates[questId] = stage
    
    -- Update player path based on moral choices
    updatePlayerPath(questId, stage)
    
    -- Check if quest is completed
    local maxStage = questMaxStages[questId]
    if maxStage and stage >= maxStage then
        print("[UNIVERSAL_MENU_QUEST_MONITOR] Quest completed: " .. questId .. " at stage " .. tostring(stage))
        
        -- Generate chronicle content
        local chronicleContent = getChronicleContent(questId, playerPath)
        
        -- Send chronicle entry to chronicle system
        core.sendGlobalEvent("UniversalMenu_ChronicleEntry", {
            questId = questId,
            stage = stage,
            content = chronicleContent,
            playerPath = playerPath,
            timestamp = core.getGameTime()
        })
    end
end

-- Event handlers following quest_monitor_engine pattern
local eventHandlers = {
    JMCG_QuestStarted = function(data)
        print("[UNIVERSAL_MENU_QUEST_MONITOR] New quest detected: " .. data.questId .. " at stage " .. tostring(data.stage))
        processQuestUpdate(data.questId, data.stage)
    end,
    
    JMCG_QuestStageChanged = function(data)
        print("[UNIVERSAL_MENU_QUEST_MONITOR] Quest advanced: " .. data.questId .. " to stage " .. tostring(data.stage))
        processQuestUpdate(data.questId, data.stage)
    end
}

-- Return the script interface
return {
    eventHandlers = eventHandlers,
    -- Engine handlers for saving/loading if state needs to persist globally
}
