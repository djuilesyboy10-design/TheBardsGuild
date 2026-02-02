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
    heroicCount = 0
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
    trespass = -3           -- Minor violation
}

local heroicPoints = {
    help_npc = 10,         -- Help someone
    complete_quest = 20,   -- Quest completion
    donate = 5,            -- Charity
    save_life = 25         -- Heroic act
}

-- =============================================================================
-- REPUTATION LEVELS
-- =============================================================================

local function calculateReputationLevel(points)
    if points >= 100 then 
        return "Criminal"
    elseif points >= 50 then 
        return "Suspicious"
    elseif points >= 20 then 
        return "Dishonorable"
    elseif points >= 0 then 
        return "Neutral"
    elseif points >= -20 then 
        return "Honorable"
    elseif points >= -50 then 
        return "Heroic"
    else 
        return "Legendary"
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
-- UTILITY FUNCTIONS
-- =============================================================================

local function msg(message)
    if CONFIG.DEBUG then
        print("[" .. MOD_ID .. "] " .. message)
    end
end

local function addReputationPoints(points, reason)
    reputationData.points = reputationData.points + points
    local oldLevel = reputationData.level
    reputationData.level = calculateReputationLevel(reputationData.points)
    
    -- Track counts
    if points > 0 then
        reputationData.heroicCount = reputationData.heroicCount + 1
    else
        reputationData.crimeCount = reputationData.crimeCount + 1
    end
    
    msg(string.format("Reputation %s: %+d points (%s) - Total: %d (%s)", 
        points > 0 and "increased" or "decreased", 
        points, 
        reason, 
        reputationData.points, 
        reputationData.level))
    
    -- Apply bounty for crimes
    if points < 0 then
        applyBounty(math.abs(points))
    end
    
    -- Notify level change
    if oldLevel ~= reputationData.level then
        msg("Reputation level changed: " .. oldLevel .. " → " .. reputationData.level)
        
        -- Save reputation data
        if settings then
            settings:set("reputationData", {
                points = reputationData.points,
                level = reputationData.level,
                lastDecayTime = reputationData.lastDecayTime,
                crimeCount = reputationData.crimeCount,
                heroicCount = reputationData.heroicCount
            })
            msg("Debug: Saved reputation data to storage")
        end
        
        -- Send event to effects system
        core.sendGlobalEvent("Reputation_Changed", {
            level = reputationData.level,
            points = reputationData.points,
            oldLevel = oldLevel,
            crimeCount = reputationData.crimeCount,
            heroicCount = reputationData.heroicCount
        })
    end
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
    
    local points = heroicPoints[data.type] or 10
    local reason = data.type
    
    addReputationPoints(points, reason)
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

local function initialize()
    msg("Initializing Universal Reputation System")
    
    -- Load saved data
    local savedData = settings:get("reputationData")
    msg("Debug: savedData type: " .. type(savedData))
    
    -- Handle ProtectedTable userdata
    if savedData and type(savedData) == "userdata" then
        msg("Debug: Converting ProtectedTable userdata to table")
        -- Try to extract data from ProtectedTable
        local success, extractedData = pcall(function()
            return {
                points = savedData.points or 0,
                level = savedData.level or "Neutral",
                lastDecayTime = savedData.lastDecayTime or 0,
                crimeCount = savedData.crimeCount or 0,
                heroicCount = savedData.heroicCount or 0
            }
        end)
        
        if success and extractedData then
            reputationData.points = extractedData.points
            reputationData.level = extractedData.level
            reputationData.lastDecayTime = extractedData.lastDecayTime
            reputationData.crimeCount = extractedData.crimeCount
            reputationData.heroicCount = extractedData.heroicCount
            msg("Loaded saved reputation: " .. reputationData.points .. " points (" .. reputationData.level .. ")")
        else
            msg("Failed to extract data from ProtectedTable, starting fresh")
        end
    elseif savedData and type(savedData) == "table" then
        -- Copy values from saved data to our table
        reputationData.points = savedData.points or 0
        reputationData.level = savedData.level or "Neutral"
        reputationData.lastDecayTime = savedData.lastDecayTime or 0
        reputationData.crimeCount = savedData.crimeCount or 0
        reputationData.heroicCount = savedData.heroicCount or 0
        msg("Loaded saved reputation: " .. reputationData.points .. " points (" .. reputationData.level .. ")")
    else
        msg("Starting with fresh reputation data")
    end
    
    -- Start decay timer
    local time = require("openmw_aux.time")
    time.runRepeatedly(decayReputation, CONFIG.DECAY_INTERVAL, {type = time.SimulationTime})
    
    msg("Universal Reputation System initialized")
end

-- =============================================================================
-- ENGINE HANDLERS
-- =============================================================================

return {
    engineHandlers = {
        onLoad = function()
            initialize()
            msg("Universal Reputation System loaded")
        end,
        
        onSave = function()
            -- Temporarily disable saving to avoid serialization issues
            -- TODO: Fix serialization later
            return {}
        end
    },
    
    eventHandlers = {
        Reputation_CrimeEvent = onCrimeEvent,
        Reputation_HeroicEvent = onHeroicEvent,
        Reputation_GetReputation = onGetReputation,
        UA_BountyApplied = onBountyApplied
    }
}
