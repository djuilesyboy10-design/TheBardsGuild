-- =============================================================================
-- UNIVERSAL REPUTATION SYSTEM - GLOBAL SCRIPT
-- =============================================================================
-- Event-driven reputation system that responds to player actions
-- =============================================================================

local core = require("openmw.core")
local types = require("openmw.types")
local world = require("openmw.world")
local storage = require("openmw.storage")

local MOD_ID = "UniversalReputation"

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

local function msg(message)
    print("[" .. MOD_ID .. "] " .. message)
end

-- =============================================================================
-- CONFIGURATION
-- =============================================================================

local CONFIG = {
    DEBUG = true,
    DECAY_RATE = 0.1,  -- Reputation slowly improves over time
    DECAY_INTERVAL = 3600,  -- Every hour of game time
}

-- =============================================================================
-- STATE MANAGEMENT
-- =============================================================================

local reputationData = {
    points = 0,
    level = "Neutral",
    lastDecayTime = 0,
    crimeCount = 0,
    heroicCount = 0,
    vanillaReputation = 0,
    completedQuests = {} -- Track quests internally
}

-- Weights for different reputation sources
local WEIGHTS = {
    VANILLA_MULTIPLIER = 0.5, -- How much vanilla reputation counts
    QUEST_MULTIPLIER = 2.0,   -- Default quest multiplier
    PATH_MULTIPLIER = 3.0     -- Major path choices are more impactful
}

-- Quest Alignments and Weights
-- Points are added to the criminal total (Negative = Heroic acts, Positive = Crimes)
local QUEST_ALIGNMENTS = {
    -- Core Choice Paths (Often triggered as separate quest completion IDs)
    jmcg_path_good = { points = -20, type = "Heroic" },
    jmcg_path_bad = { points = 30, type = "Criminal" },

    -- Heroic / Abolitionist Paths
    jmcg_twin_lamps_hymn = { points = -15, type = "Heroic" },
    jmcg_freedom = { points = -15, type = "Heroic" },
    jmcg_freedom2 = { points = -15, type = "Heroic" },
    jmcg_freedom3 = { points = -15, type = "Heroic" },
    jmcg_ballad = { points = -15, type = "Heroic" },
    jmcg_div_good = { points = -20, type = "Heroic" },
    jmcg_the_chroniclers_saint = { points = -20, type = "Heroic" },
    jmcg_guide = { points = -10, type = "Heroic" },
    jmcg_recruitment = { points = -10, type = "Honorable" },
    jmcg_the_family_ties = { points = -10, type = "Honorable" },

    -- Internal Choice Logic (Applied at specific stages)
    jmcg_orc_diplomacy = {
        stages = {
            [80] = { points = -20, type = "Heroic", reason = "truce_brokered" }, -- Choosing Truce
            [90] = { points = 35, type = "Criminal", reason = "slaughter_head" } -- Choosing Head as Proof
        }
    },
    jmcg_imperial_buisness = {
        stages = {
            [50] = { points = -15, type = "Heroic", reason = "freed_slave" }, -- Freed slave in Hla Oad
            [60] = { points = 25, type = "Criminal", reason = "delivered_slave" } -- Delivered slave to Tong
        }
    },
    jmcg_tavern_haload = {
        stages = {
            [50] = { points = -10, type = "Honorable", reason = "sheltered_vulnerable" },
            [60] = { points = 15, type = "Dishonorable", reason = "caution_over_commitment" }
        }
    },
    jmcg_daisy_lore = {
        stages = {
            [100] = { points = -20, type = "Heroic", reason = "freed_captives" }, -- Freeing hatchlings
            [110] = { points = 30, type = "Criminal", reason = "kept_vane_book" } -- Selling experimental recipes
        }
    },
    jmcg_aldruhn_seed = {
        stages = {
            [40] = { points = -10, type = "Honorable", reason = "seed_redemption" },
            [50] = { points = -15, type = "Heroic", reason = "seed_goodwill" },
            [60] = { points = 20, type = "Criminal", reason = "seed_subversive" }
        }
    },

    -- Criminal / Shadow Paths
    jmcg_tong_dirge = { points = 30, type = "Criminal" },
    jmcg_thieves_lore = { points = 25, type = "Criminal" },
    jmcg_fara = { points = 25, type = "Criminal" }, -- Shady cookbook/recipes
    jmcg_jack_lore = { points = 15, type = "Dishonorable" }, -- Political manipulation

    -- Mythic Paths (High Impact)
    jmcg_myth = { points = -30, type = "Legendary" },
    jmcg_div_myth = { points = -30, type = "Legendary" },
    jmcg_dragon = { points = -25, type = "Legendary" },
    jmcg_stack = { points = -25, type = "Legendary" },
    jmcg_web = { points = -25, type = "Legendary" },
    jmcg_ashsinger_echo = { points = -30, type = "Legendary" },
    jmcg_hist_lore = { points = -25, type = "Legendary" },
    jmcg_herm = { points = -25, type = "Legendary" },
    jmcg_lostbard = { points = -25, type = "Legendary" },
    jmcg_ally_lore = { points = -25, type = "Legendary" }, -- The Silent Archive
    jmcg_endgame = { points = -30, type = "Legendary" },    -- Northern Breeze
    jmcg_final = {
        stages = {
            [90] = { points = 50, type = "Criminal", reason = "joined_dagoth_ur" },
            [100] = { points = -60, type = "Legendary", reason = "reminded_friend" }
        }
    },

    -- Core Guild Progress (Mostly neutral/positive)
    jmcg_bards_guild = { points = -10, type = "Honorable" },
    jmcg_tuning_master = { points = -10, type = "Neutral" },
    jmcg_ablle = { points = -5, type = "Honorable" }, -- The Vibrating Earth
    jmcg_joseph_personal = { points = -5, type = "Neutral" },
    jmcg_joseph_lore = { points = -10, type = "Neutral" },
    jmcg_shane_lore = { points = -5, type = "Neutral" },
    jmcg_shane_lore_1 = { points = -5, type = "Neutral" },
    jmcg_shane_lore_2 = { points = -10, type = "Neutral" }
}

-- User settings
local settings = storage.globalSection("Settings" .. MOD_ID)

-- =============================================================================
-- REPUTATION SCORING
-- =============================================================================

local crimePoints = {
    pick_lock = -5,        -- Minor crime
    force_lock = -10,       -- Medium crime  
    magic_unlock = -7,       -- Magical crime
    theft = -15,            -- Major crime
    trespass = -3,          -- Minor violation
    murder = 30,            -- Serious crime
    assassination = 45      -- High-profile crime
}

local heroicPoints = {
    help_npc = 10,         -- Help someone
    complete_quest = 20,   -- Quest completion
    donate = 5,            -- Charity
    save_life = 25,        -- Heroic act
    clear_drug_den = 30,   -- Social service
    establish_network = 15 -- Organization building
}

-- =============================================================================
-- REPUTATION LEVELS
-- =============================================================================

local function calculateReputationLevel(points)
    -- For now, just use custom points without vanilla reputation integration
    -- TODO: Fix vanilla reputation access later
    
    local combinedScore = points

    if combinedScore >= 500 then 
        return "Broken"
    elseif combinedScore >= 250 then 
        return "Fading"
    elseif combinedScore >= 100 then 
        return "Distorted"
    elseif combinedScore >= 0 then 
        return "Tuning"
    elseif combinedScore >= -100 then 
        return "Resonant"
    elseif combinedScore >= -250 then 
        return "Anchor"
    else 
        return "Editor"
    end
end

-- =============================================================================
-- REPUTATION EFFECTS
-- =============================================================================

local reputationEffects = {
    Criminal = {
        bountyMultiplier = 1.5,    -- Higher bounties
        priceModifier = 1.3,        -- Shop prices higher
        serviceRefusal = 0.3,       -- 30% chance services refused
        factionStanding = -20,      -- Factions dislike you
        guardAggression = 1.2        -- Guards more hostile
    },
    Suspicious = {
        bountyMultiplier = 1.2,
        priceModifier = 1.1,
        serviceRefusal = 0.1,
        factionStanding = -10,
        guardAggression = 1.1
    },
    Dishonorable = {
        bountyMultiplier = 1.1,
        priceModifier = 1.05,
        serviceRefusal = 0.05,
        factionStanding = -5,
        guardAggression = 1.05
    },
    Neutral = {
        bountyMultiplier = 1.0,
        priceModifier = 1.0,
        serviceRefusal = 0.0,
        factionStanding = 0,
        guardAggression = 1.0
    },
    Honorable = {
        bountyMultiplier = 0.8,
        priceModifier = 0.9,
        serviceDiscount = 0.1,       -- 10% chance free services
        factionStanding = 10,
        guardAssistance = 0.2        -- Guards help you
    },
    Heroic = {
        bountyMultiplier = 0.5,
        priceModifier = 0.8,
        serviceDiscount = 0.2,       -- 20% chance free services
        factionStanding = 20,
        guardAssistance = 0.3
    },
    Legendary = {
        bountyMultiplier = 0.3,
        priceModifier = 0.7,
        serviceDiscount = 0.3,       -- 30% chance free services
        factionStanding = 30,
        guardAssistance = 0.5
    }
}

-- =============================================================================
-- QUEST MONITORING (Independent)
-- =============================================================================

local function checkQuestProgress()
    -- This polling function is now a fallback for initialization
    local player = world.players[1]
    if not player then return end

    local playerQuests = types.Player.quests(player)
    local questDatabase = require('scripts.jmcg_influence.quest_database')

    for questId, data in pairs(questDatabase) do
        local qId = questId:lower()
        local currentStage = 0
        for _, q in pairs(playerQuests) do
            if q.id:lower() == qId then
                currentStage = q.stage
                break
            end
        end

        local alignment = QUEST_ALIGNMENTS[qId]

        -- 1. Catch-up for stage-based choices
        if alignment and alignment.stages then
            for stage, stageReward in pairs(alignment.stages) do
                local rewardId = string.format("%s_stage_%d", qId, stage)
                if currentStage >= stage and not reputationData.completedQuests[rewardId] then
                    msg("Quest choice synced from journal: " .. rewardId)
                    reputationData.completedQuests[rewardId] = true
                    reputationData.points = reputationData.points + stageReward.points
                end
            end
        end

        -- 2. Catch-up for final completions
        local maxStage = data.maxIndex or 1
        if currentStage >= maxStage and not reputationData.completedQuests[qId] then
            msg("Quest completion synced from journal: " .. qId)
            reputationData.completedQuests[qId] = true
            
            -- Apply points for final completion
            if alignment and alignment.points then
                reputationData.points = reputationData.points + alignment.points
            elseif not (alignment and alignment.stages) then
                -- Default generic reward
                local basePoints = heroicPoints.complete_quest or 20
                reputationData.points = reputationData.points - (basePoints * WEIGHTS.QUEST_MULTIPLIER)
            end
        end
    end
    
    reputationData.level = calculateReputationLevel(reputationData.points)
end

-- =============================================================================
-- EVENT HANDLERS
-- =============================================================================

local function onQuestStageChanged(data)
    if not data or not data.questId then return end
    
    local questId = data.questId:lower()
    local stage = data.stage
    
    local questDatabase = require('scripts.jmcg_influence.quest_database')
    local questData = questDatabase[questId]
    
    if not questData then return end
    
    -- 1. Check for specific stage-based reputation rewards (Choices)
    local alignment = QUEST_ALIGNMENTS[questId]
    if alignment and alignment.stages and alignment.stages[stage] then
        local stageReward = alignment.stages[stage]
        local rewardId = string.format("%s_stage_%d", questId, stage)
        
        -- Only award once per stage
        if not reputationData.completedQuests[rewardId] then
            msg(string.format("Choice reward triggered: %s Stage %d (%+d points - %s)", 
                questId, stage, stageReward.points, stageReward.type))
            reputationData.completedQuests[rewardId] = true
            addReputationPoints(stageReward.points, stageReward.reason or "quest_choice")
        end
    end

    -- 2. Check for Quest Completion (Max Index)
    local maxStage = questData.maxIndex or 1
    if stage >= maxStage and not reputationData.completedQuests[questId] then
        msg("Quest completed detected via EVENT: " .. questId)
        reputationData.completedQuests[questId] = true
        
        -- Apply final completion reward if defined (and not stage-based only)
        if alignment and alignment.points then
            msg(string.format("Applying %s alignment for quest completion: %s (%+d points)", 
                alignment.type, questId, alignment.points))
            addReputationPoints(alignment.points, "quest_complete_" .. alignment.type:lower())
        elseif not (alignment and alignment.stages) then
            -- Default to Heroic completion for quests not explicitly in the alignment table
            onHeroicEvent({
                type = "complete_quest",
                questId = questId
            })
        end
    end
end

local function saveReputationData()
    if settings then
        settings:set("reputationData", {
            points = reputationData.points,
            level = reputationData.level,
            lastDecayTime = reputationData.lastDecayTime,
            crimeCount = reputationData.crimeCount,
            heroicCount = reputationData.heroicCount,
            completedQuests = reputationData.completedQuests
        })
        msg("Saved reputation data to storage")
    end
end

local function addReputationPoints(points, reason)
    reputationData.points = reputationData.points + points
    local oldLevel = reputationData.level
    reputationData.level = calculateReputationLevel(reputationData.points)
    
    -- Track counts
    if points > 0 then
        reputationData.crimeCount = reputationData.crimeCount + 1
    else
        reputationData.heroicCount = reputationData.heroicCount + 1
    end
    
    msg(string.format("Reputation %s: %+d points (%s) - Total: %d (%s)", 
        points < 0 and "increased" or "decreased", 
        points, 
        reason, 
        reputationData.points, 
        reputationData.level))
    
    -- Apply bounty for crimes (Positive points in this logic = bad)
    if points > 0 then
        applyBounty(points)
    end
    
    -- Notify level change
    if oldLevel ~= reputationData.level then
        msg("Reputation level changed: " .. oldLevel .. " → " .. reputationData.level)
        
        -- Send event to effects system
        core.sendGlobalEvent("Reputation_Changed", {
            level = reputationData.level,
            points = reputationData.points,
            oldLevel = oldLevel,
            crimeCount = reputationData.crimeCount,
            heroicCount = reputationData.heroicCount
        })
    end
    
    -- Always save on change
    saveReputationData()
end

local function applyBounty(crimePoints)
    local player = world.players[1]
    if not player then return end
    
    local bountyAmount = crimePoints * 2  -- 2 gold per crime point
    local currentBounty = types.NPC.stats.bounty(player).current or 0
    
    types.NPC.stats.bounty(player).current = currentBounty + bountyAmount
    
    msg("Bounty added: " .. bountyAmount .. " gold (Total: " .. (currentBounty + bountyAmount) .. ")")
end

local function applyReputationEffects(level)
    local effects = reputationEffects[level]
    if not effects then return end
    
    msg("Applying reputation effects for: " .. level)
    
    -- Store effects for other systems to read
    local player = world.players[1]
    if player then
        player:sendEvent("Reputation_EffectsApplied", {
            level = level,
            effects = effects
        })
    end
end

local function decayReputation()
    local currentTime = core.getGameTime()
    if currentTime - reputationData.lastDecayTime < CONFIG.DECAY_INTERVAL then
        return
    end
    
    reputationData.lastDecayTime = currentTime
    
    -- Slowly improve reputation for non-criminals
    if reputationData.level ~= "Criminal" and reputationData.points > -100 then
        local decayAmount = CONFIG.DECAY_RATE
        reputationData.points = reputationData.points - decayAmount
        reputationData.level = calculateReputationLevel(reputationData.points)
        
        msg("Reputation decayed: " .. decayAmount .. " points (Total: " .. reputationData.points .. ")")
    end
end

-- =============================================================================
-- EVENT HANDLERS
-- =============================================================================

local function onCrimeEvent(data)
    msg("DEBUG: Reputation_CrimeEvent received: " .. (data.type or "unknown"))
    if not data or not data.type then return end
    
    local points = crimePoints[data.type] or 5
    local reason = data.type
    
    if data.method then
        reason = reason .. " (" .. data.method .. ")"
    end
    
    addReputationPoints(points, reason)
end

local function onHeroicEvent(data)
    if not data or not data.type then return end
    
    local basePoints = heroicPoints[data.type] or 10
    local points = basePoints
    
    -- If it's a quest completion, apply the quest multiplier
    if data.type == "complete_quest" then
        points = points * WEIGHTS.QUEST_MULTIPLIER
    end
    
    local reason = data.type
    
    -- Subtract points for heroic acts (higher = worse in this system)
    addReputationPoints(-points, reason)
end

local function onGetReputation(data)
    local player = world.players[1]
    if player then
        player:sendEvent("Reputation_Response", {
            points = reputationData.points,
            level = reputationData.level,
            crimeCount = reputationData.crimeCount,
            heroicCount = reputationData.heroicCount
        })
    end
end

local function onBountyApplied(data)
    if not data or not data.method then return end
    
    -- Map Who Knocked methods to reputation crime types
    local methodToCrime = {
        force = "force_lock",
        pick = "pick_lock", 
        magic = "magic_lock"
    }
    
    local crimeType = methodToCrime[data.method] or "force_lock"
    local points = crimePoints[crimeType] or 10
    local reason = crimeType .. " (" .. data.method .. ")"
    
    addReputationPoints(points, reason)
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

local function initialize(savedData)
    msg("Initializing Universal Reputation System")
    
    -- Priority: 1. Data from onLoad (engine save), 2. Data from storage (global settings)
    local data = savedData or settings:get("reputationData")
    
    if data then
        msg("Debug: Loading reputation data, source: " .. (savedData and "Engine" or "Storage"))
        
        -- Handle ProtectedTable userdata (from storage)
        if type(data) == "userdata" then
            local success, extractedData = pcall(function()
                return {
                    points = data.points or 0,
                    level = data.level or "Neutral",
                    lastDecayTime = data.lastDecayTime or 0,
                    crimeCount = data.crimeCount or 0,
                    heroicCount = data.heroicCount or 0,
                    completedQuests = data.completedQuests or {}
                }
            end)
            
            if success and extractedData then
                data = extractedData
            else
                msg("Failed to extract data from ProtectedTable, starting fresh")
                data = nil
            end
        end
        
        if data then
            reputationData.points = data.points or 0
            reputationData.level = data.level or "Neutral"
            reputationData.lastDecayTime = data.lastDecayTime or 0
            reputationData.crimeCount = data.crimeCount or 0
            reputationData.heroicCount = data.heroicCount or 0
            reputationData.completedQuests = data.completedQuests or {}
            msg("Loaded reputation: " .. reputationData.points .. " points (" .. reputationData.level .. ")")
        end
    else
        msg("Starting with fresh reputation data")
    end
    
    -- Start decay timer
    local async = require("openmw.async")
    async:newUnsavableGameTimer(CONFIG.DECAY_INTERVAL, function()
        decayReputation()
        -- Schedule next decay
        async:newUnsavableGameTimer(CONFIG.DECAY_INTERVAL, arguments.callee)
    end)
    
    -- One-time sync for existing saves on load
    checkQuestProgress()
    
    msg("Universal Reputation System initialized")
end

-- =============================================================================
-- ENGINE HANDLERS
-- =============================================================================

return {
    engineHandlers = {
        onLoad = function(data)
            initialize(data and data.reputationData)
            msg("Universal Reputation System loaded")
        end,
        
        onSave = function()
            return {
                reputationData = reputationData
            }
        end
    },
    
    eventHandlers = {
        Reputation_CrimeEvent = onCrimeEvent,
        Reputation_HeroicEvent = onHeroicEvent,
        Reputation_GetReputation = onGetReputation,
        UA_BountyApplied = onBountyApplied,
        JMCG_QuestStageChanged = onQuestStageChanged,
        SpecialTitles_ShowMenu = function(data)
            -- Send event to MENU context to show titles UI
            print("[UniversalReputation] Opening Chronicle of Titles...")
        end
    }
}
