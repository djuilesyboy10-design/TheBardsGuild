-- universal_effects_engine.lua
-- Core Universal Effects Engine
-- Processes and executes all effect types for the dialogue system

local weatherEffects = require("scripts.engine.framework.effects.effect_modules.weather_effects")
local reputationEffects = require("scripts.engine.framework.effects.effect_modules.reputation_effects")

local M = {}

-- Effect type handlers
local effectHandlers = {
    weather = weatherEffects.applyWeatherEffect,
    reputation = reputationEffects.applyReputationEffect,
    dialogue = nil, -- Will be registered dynamically
    storage = nil, -- Will be registered dynamically
    -- Future effect types will be added here
    -- audio = audioEffects.applyAudioEffect,
    -- ai = aiEffects.applyAIEffect,
}

-- Process a single effect
function M.processEffect(effect)
    if not effect or not effect.type then
        print("[EFFECTS_ENGINE] Error: Invalid effect data")
        return false
    end
    
    local handler = effectHandlers[effect.type]
    if not handler then
        print("[EFFECTS_ENGINE] Error: No handler for effect type '" .. effect.type .. "'")
        return false
    end
    
    -- Execute the effect
    local success = handler(effect)
    
    if success then
        print("[EFFECTS_ENGINE] ✅ Processed " .. effect.type .. " effect")
    else
        print("[EFFECTS_ENGINE] ❌ Failed to process " .. effect.type .. " effect")
    end
    
    return success
end

-- Register effect handlers dynamically
function M.registerEffectHandler(effectType, handler)
    effectHandlers[effectType] = handler
    print("[EFFECTS_ENGINE] Registered handler for effect type: " .. effectType)
end

-- Process multiple effects (for dialogue choices with multiple effects)
function M.processEffects(effects)
    if not effects or type(effects) ~= "table" then
        print("[EFFECTS_ENGINE] Error: Invalid effects array")
        return false
    end
    
    local successCount = 0
    local totalCount = #effects
    
    print("[EFFECTS_ENGINE] Processing " .. totalCount .. " effects...")
    
    for i, effect in ipairs(effects) do
        if M.processEffect(effect) then
            successCount = successCount + 1
        end
    end
    
    print("[EFFECTS_ENGINE] Completed: " .. successCount .. "/" .. totalCount .. " effects successful")
    return successCount == totalCount
end

-- Legacy function for backward compatibility with existing dialogue format
-- This handles the old format: {weatherEvent = {regionName, weatherID}}
function M.processLegacyEffect(legacyEffect)
    if not legacyEffect or not legacyEffect.weatherEvent then
        print("[EFFECTS_ENGINE] Error: Invalid legacy effect format")
        return false
    end
    
    local weatherEvent = legacyEffect.weatherEvent
    local effect = {
        type = "weather",
        data = {
            region = weatherEvent.regionName,
            weatherID = weatherEvent.weatherID
        }
    }
    
    return M.processEffect(effect)
end

-- Test the effects engine
function M.testEffectsEngine()
    print("[EFFECTS_ENGINE] Testing Universal Effects Engine...")
    
    -- Test weather effect
    local testEffect = {
        type = "weather",
        data = {
            effectId = "clear_balmora"
        }
    }
    
    local result = M.processEffect(testEffect)
    
    if result then
        print("[EFFECTS_ENGINE] ✅ Effects Engine test PASSED")
        return true
    else
        print("[EFFECTS_ENGINE] ❌ Effects Engine test FAILED")
        return false
    end
end

-- List available effect types
function M.listEffectTypes()
    local types = {}
    for effectType, _ in pairs(effectHandlers) do
        table.insert(types, effectType)
    end
    return types
end

return M
