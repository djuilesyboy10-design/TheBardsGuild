-- weather_effects.lua
-- Universal Weather Effects Module
-- Handles all weather-related effects for the dialogue system

local core = require('openmw.core')
local weatherEffectsData = require("scripts.engine.framework.effects.effect_data.weather_effects_data")

local M = {}

-- Weather mapping from your ballad system
local weatherRecords = {
    [0] = core.weather.records.Clear,
    [1] = core.weather.records.Cloudy,
    [2] = core.weather.records.Foggy,
    [3] = core.weather.records.Overcast,
    [4] = core.weather.records.Rain,
    [5] = core.weather.records.Thunderstorm,
    [6] = core.weather.records.Ashstorm,
    [7] = core.weather.records.Blight,
    [8] = core.weather.records.Snow,
    [9] = core.weather.records.Blizzard,
}

-- Apply weather effect to a specific region
function M.applyWeatherEffect(effectId)
    local effect = weatherEffectsData.getEffect(effectId)
    
    if not effect then
        print("[WEATHER_EFFECTS] Error: Weather effect '" .. effectId .. "' not found!")
        return false
    end
    
    -- Get the weather record
    local weatherRecord = weatherRecords[effect.weatherID]
    if not weatherRecord then
        print("[WEATHER_EFFECTS] Error: Invalid weather ID " .. effect.weatherID)
        return false
    end
    
    -- Apply the weather change
    local success = core.weather.setWeather(effect.region, weatherRecord)
    
    if success then
        print("[WEATHER_EFFECTS] Applied weather effect: " .. effect.name)
        print("[WEATHER_EFFECTS] Region: " .. effect.region .. " | Weather: " .. effect.weatherID)
        
        -- Optional: Store effect for duration tracking (future enhancement)
        M.currentEffect = {
            id = effect.id,
            region = effect.region,
            startTime = os.time(),
            duration = effect.duration
        }
        
        return true
    else
        print("[WEATHER_EFFECTS] Failed to apply weather effect: " .. effect.name)
        return false
    end
end

-- Get current active weather effect
function M.getCurrentEffect()
    return M.currentEffect
end

-- Check if a weather effect is available
function M.isEffectAvailable(effectId)
    return weatherEffectsData.getEffect(effectId) ~= nil
end

-- List all available weather effects for debugging
function M.listAvailableEffects()
    local effects = weatherEffectsData.listEffects()
    print("[WEATHER_EFFECTS] Available effects:")
    for _, effect in ipairs(effects) do
        print("  " .. effect)
    end
end

-- Test function to verify weather system is working
function M.testWeatherSystem()
    print("[WEATHER_EFFECTS] Testing weather system...")
    
    -- Test with a simple clear weather effect
    local testResult = M.applyWeatherEffect("clear_balmora")
    
    if testResult then
        print("[WEATHER_EFFECTS] ✅ Weather system test PASSED")
        return true
    else
        print("[WEATHER_EFFECTS] ❌ Weather system test FAILED")
        return false
    end
end

return M
