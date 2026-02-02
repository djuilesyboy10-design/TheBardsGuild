-- =============================================================================
-- REPUTATION EFFECTS SYSTEM
-- S3 Framework-powered reputation-based effects and modifiers
-- Handles dynamic gameplay changes based on player reputation
-- =============================================================================

local core = require("openmw.core")
local world = require("openmw.world")
local types = require("openmw.types")
local MOD_ID = "ReputationEffects"

-- S3 Framework Integration
local success, ScriptContext = pcall(function() return require('scripts.s3.scriptContext') end)
local success2, LogMessage = pcall(function() return require('scripts.s3.logmessage') end)
local success3, ProtectedTableModule = pcall(function() return require('scripts.s3.protectedTable') end)

-- Context detection and logging
local context = success and ScriptContext.get() or nil
local msg = core.getGMST or print
local debugLog = success2 and LogMessage or print

-- =============================================================================
-- REPUTATION EFFECTS CONFIGURATION
-- =============================================================================

local reputationEffects = {
    criminal = {
        bountyMultiplier = 1.5,        -- 50% higher bounties
        priceModifier = 1.3,          -- 30% higher shop prices
        serviceRefusal = 0.4,         -- 40% chance services refused
        factionStanding = -25,        -- Major faction penalty
        guardAggression = 1.4,         -- 40% more aggressive guards
        dialogueHostility = 0.6,       -- 60% chance hostile dialogue
        travelRestrictions = true,     -- Cannot use certain travel services
        housingRestrictions = true     -- Cannot buy certain houses
    },
    
    suspicious = {
        bountyMultiplier = 1.2,
        priceModifier = 1.1,
        serviceRefusal = 0.15,
        factionStanding = -10,
        guardAggression = 1.1,
        dialogueHostility = 0.2,
        travelRestrictions = false,
        housingRestrictions = false
    },
    
    dishonorable = {
        bountyMultiplier = 1.1,
        priceModifier = 1.05,
        serviceRefusal = 0.05,
        factionStanding = -5,
        guardAggression = 1.0,
        dialogueHostility = 0.1,
        travelRestrictions = false,
        housingRestrictions = false
    },
    
    neutral = {
        bountyMultiplier = 1.0,
        priceModifier = 1.0,
        serviceRefusal = 0.0,
        factionStanding = 0,
        guardAggression = 1.0,
        dialogueHostility = 0.0,
        travelRestrictions = false,
        housingRestrictions = false
    },
    
    honorable = {
        bountyMultiplier = 0.8,         -- 20% lower bounties
        priceModifier = 0.9,          -- 10% discount
        serviceRefusal = 0.0,
        factionStanding = 15,         -- Faction bonus
        guardAggression = 0.8,        -- Guards more lenient
        dialogueHostility = 0.0,
        serviceDiscount = 0.1,         -- 10% chance free services
        travelBonus = true            -- Faster/cheaper travel
    },
    
    heroic = {
        bountyMultiplier = 0.6,        -- 40% lower bounties
        priceModifier = 0.8,          -- 20% discount
        serviceRefusal = 0.0,
        factionStanding = 25,
        guardAggression = 0.6,        -- Guards very helpful
        dialogueHostility = 0.0,
        serviceDiscount = 0.2,        -- 20% chance free services
        travelBonus = true,
        housingBonus = true            -- Access to better housing
    },
    
    legendary = {
        bountyMultiplier = 0.5,        -- 50% lower bounties
        priceModifier = 0.7,          -- 30% discount
        serviceRefusal = 0.0,
        factionStanding = 40,
        guardAggression = 0.5,        -- Guards protective
        dialogueHostility = 0.0,
        serviceDiscount = 0.3,        -- 30% chance free services
        travelBonus = true,
        housingBonus = true,
        specialServices = true        -- Access to unique services
    }
}

-- =============================================================================
-- ACTIVE EFFECTS TRACKING
-- =============================================================================

local activeEffects = {}
local currentReputationLevel = "neutral"

-- Settings management
local settings = nil
if success3 and ProtectedTableModule and ProtectedTableModule.new then
    settings = ProtectedTableModule.new({
        name = "ReputationEffects",
        global = true,
        debug = true,
        default = {
            enableEffects = true,
            enablePriceModifiers = true,
            enableDialogueEffects = true,
            enableGuardEffects = true,
            enableFactionEffects = true,
            enableTravelEffects = true,
            effectsUpdateInterval = 5.0, -- Update every 5 seconds
            notificationsEnabled = true
        }
    })
end

-- =============================================================================
-- EFFECT APPLICATION FUNCTIONS
-- =============================================================================

local function applyPriceModifiers(effects)
    if not settings or not settings.enablePriceModifiers then return end
    
    debugLog("Applying price modifiers: " .. effects.priceModifier)
    
    -- This would integrate with shop systems
    -- For now, we'll just log the effect
    if settings.notificationsEnabled then
        local player = world.players[1]
        if player then
            local message = effects.priceModifier > 1.0 and 
                "Shop prices increased by " .. math.floor((effects.priceModifier - 1.0) * 100) .. "%" or
                "Shop prices decreased by " .. math.floor((1.0 - effects.priceModifier) * 100) .. "%"
            
            player:sendEvent("ReputationEffects_Notification", {
                type = "price",
                message = message,
                modifier = effects.priceModifier
            })
        end
    end
end

local function applyDialogueEffects(effects)
    if not settings or not settings.enableDialogueEffects then return end
    
    debugLog("Applying dialogue effects: hostility chance " .. (effects.dialogueHostility * 100) .. "%")
    
    -- This would integrate with dialogue systems
    -- Send effect to dialogue manager
    core.sendGlobalEvent("UniqueDialogue_UpdateEffects", {
        hostilityChance = effects.dialogueHostility,
        reputationLevel = currentReputationLevel
    })
end

local function applyFactionEffects(effects)
    if not settings or not settings.enableFactionEffects then return end
    
    debugLog("Applying faction effects: " .. effects.factionStanding .. " standing")
    
    -- This would integrate with faction systems
    core.sendGlobalEvent("Faction_UpdateReputationBonus", {
        bonus = effects.factionStanding,
        reputationLevel = currentReputationLevel
    })
end

local function applyGuardEffects(effects)
    if not settings or not settings.enableGuardEffects then return end
    
    debugLog("Applying guard effects: aggression multiplier " .. effects.guardAggression)
    
    -- This would integrate with guard AI systems
    core.sendGlobalEvent("GuardAI_UpdateReputationEffects", {
        aggressionMultiplier = effects.guardAggression,
        reputationLevel = currentReputationLevel
    })
end

local function applyTravelEffects(effects)
    if not settings or not settings.enableTravelEffects then return end
    
    debugLog("Applying travel effects: " .. (effects.travelBonus and "bonus enabled" or "no bonus"))
    
    -- This would integrate with travel systems
    core.sendGlobalEvent("TravelSystem_UpdateReputationEffects", {
        hasBonus = effects.travelBonus or false,
        reputationLevel = currentReputationLevel
    })
end

-- =============================================================================
-- MAIN EFFECTS MANAGER
-- =============================================================================

local function applyReputationEffects(reputationLevel)
    if not settings or not settings.enableEffects then return end
    
    local effects = reputationEffects[reputationLevel] or reputationEffects.neutral
    
    debugLog("Applying reputation effects for level: " .. reputationLevel)
    
    -- Apply all effect types
    applyPriceModifiers(effects)
    applyDialogueEffects(effects)
    applyFactionEffects(effects)
    applyGuardEffects(effects)
    applyTravelEffects(effects)
    
    -- Store current effects
    activeEffects = effects
    currentReputationLevel = reputationLevel
    
    debugLog("Reputation effects applied successfully")
end

local function removeReputationEffects()
    debugLog("Removing all reputation effects")
    
    -- Reset all systems to neutral
    local neutralEffects = reputationEffects.neutral
    applyPriceModifiers(neutralEffects)
    applyDialogueEffects(neutralEffects)
    applyFactionEffects(neutralEffects)
    applyGuardEffects(neutralEffects)
    applyTravelEffects(neutralEffects)
    
    activeEffects = {}
    currentReputationLevel = "neutral"
end

-- =============================================================================
-- EVENT HANDLERS
-- =============================================================================

local function onReputationChanged(data)
    if not data or not data.level then return end
    
    debugLog("Reputation changed to: " .. data.level .. " (" .. data.points .. " points)")
    
    -- Apply new effects
    applyReputationEffects(data.level)
end

local function onReputationReset()
    debugLog("Reputation reset - removing effects")
    removeReputationEffects()
end

local function onSettingsChanged(data)
    if not data then return end
    
    debugLog("Reputation effects settings changed")
    
    -- Reapply effects with new settings
    if currentReputationLevel ~= "neutral" then
        applyReputationEffects(currentReputationLevel)
    end
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

-- Log initialization with context information
if success then
    msg("[ReputationEffects] Reputation Effects System loaded with S3 Framework support")
    if context then
        local contextNames = {
            [1] = "Local",
            [2] = "Global", 
            [3] = "Player",
            [4] = "Menu"
        }
        msg("[ReputationEffects] Running in context: " .. (contextNames[context] or "Unknown"))
    end
else
    msg("[ReputationEffects] Reputation Effects System loaded (S3 Framework not available)")
end

if settings then
    msg("[ReputationEffects] Settings management initialized")
    debugLog("[ReputationEffects] Initialized with dynamic effects system")
else
    msg("[ReputationEffects] Settings management not available")
end

return {
    eventHandlers = {
        Reputation_Changed = onReputationChanged,
        Reputation_Reset = onReputationReset,
        ReputationEffects_SettingsChanged = onSettingsChanged
    }
}
