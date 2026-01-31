-- reputation_effects.lua
-- Universal Reputation Effects Module
-- Handles all reputation-related effects for the dialogue system

local reputationEffectsData = require("scripts.engine.framework.effects.effect_data.reputation_effects_data")
local types = require("openmw.types")

-- Apply reputation effect to player
local function applyReputationEffect(effectData)
    -- Extract effectId from the data structure
    local effectId = effectData.effectId
    if not effectId then
        print("[REPUTATION_EFFECTS] Error: No effectId provided in effect data")
        return false
    end
    
    local effect = reputationEffectsData.getEffect(effectId)
    
    if not effect then
        print("[REPUTATION_EFFECTS] Error: Reputation effect '" .. effectId .. "' not found!")
        return false
    end
    
    -- Get the player
    local player = require("openmw.self")
    if not player then
        print("[REPUTATION_EFFECTS] Error: Player not found!")
        return false
    end
    
    -- Apply reputation change using correct OpenMW API
    local currentRep = types.NPC.getFactionReputation(player, effect.faction) or 0
    local newRep = currentRep + effect.amount
    
    -- Set the new reputation using the correct API
    types.NPC.setFactionReputation(player, effect.faction, newRep)
    
    print("[REPUTATION_EFFECTS] Applied reputation effect: " .. effect.name)
    print("[REPUTATION_EFFECTS] Faction: " .. effect.faction .. " | Change: " .. effect.amount .. " | New: " .. newRep)
    
    -- Optional: Store effect for duration tracking (future enhancement)
    M.currentEffect = {
        id = effect.id,
        faction = effect.faction,
        startTime = os.time(),
        duration = effect.duration,
        originalRep = currentRep
    }
    
    return true
end

-- Get current active reputation effect
-- Get current active effect
local function getCurrentEffect()
    return currentEffect
end

-- Check if a reputation effect is available
local function isEffectAvailable(effectId)
    return reputationEffectsData.getEffect(effectId) ~= nil
end

-- List all available reputation effects for debugging
local function listAvailableEffects()
    local effects = reputationEffectsData.listEffects()
    print("[REPUTATION_EFFECTS] Available effects:")
    for _, effect in ipairs(effects) do
        print("  " .. effect)
    end
end

-- Test function to verify reputation system is working
local function testReputationSystem()
    print("[REPUTATION_EFFECTS] Testing reputation system...")
    
    -- Test with a simple reputation effect
    local testResult = applyReputationEffect({effectId = "imperial_favor"})
    
    if testResult then
        print("[REPUTATION_EFFECTS] ✅ Reputation system test PASSED")
        return true
    else
        print("[REPUTATION_EFFECTS] ❌ Reputation system test FAILED")
        return false
    end
end

-- Get current reputation for a faction
local function getCurrentReputation(factionName)
    local player = require("openmw.self")
    if not player then
        return nil
    end
    
    return types.NPC.getFactionReputation(player, factionName)
end

return {
    eventHandlers = {
        -- Event handlers for reputation effects
    },
    engineHandlers = {
        -- Engine handlers if needed
    },
    interfaceName = "ReputationEffects",
    interface = {
        applyReputationEffect = applyReputationEffect,
        getCurrentReputation = getCurrentReputation,
        getCurrentEffect = getCurrentEffect,
        isEffectAvailable = isEffectAvailable,
        listAvailableEffects = listAvailableEffects,
        testReputationSystem = testReputationSystem
    }
}
