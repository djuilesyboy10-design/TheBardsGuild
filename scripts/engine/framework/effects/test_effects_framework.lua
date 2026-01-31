-- test_effects_framework.lua
-- Test script for the Universal Effects Framework
-- Run this in console to test the weather effects system

local effectsEngine = require("scripts.engine.framework.effects.universal_effects_engine")
local weatherEffects = require("scripts.engine.framework.effects.effect_modules.weather_effects")

-- Test functions for console use
return {
    testWeatherEffects = function()
        print("🌦️ Testing Weather Effects Framework...")
        print("=" .. string.rep("=", 50))
        
        -- Test 1: List available effects
        weatherEffects.listAvailableEffects()
        print("")
        
        -- Test 2: Test weather system
        local weatherTest = weatherEffects.testWeatherSystem()
        print("")
        
        -- Test 3: Test effects engine
        local engineTest = effectsEngine.testEffectsEngine()
        print("")
        
        -- Test 4: Test specific weather effect
        print("Testing specific weather effect...")
        local effect = {
            type = "weather",
            data = {
                effectId = "rain_ascadian"
            }
        }
        local specificTest = effectsEngine.processEffect(effect)
        print("")
        
        print("=" .. string.rep("=", 50))
        if weatherTest and engineTest and specificTest then
            print("🎉 ALL TESTS PASSED! Weather Effects Framework is working!")
        else
            print("❌ Some tests failed. Check the logs above.")
        end
        
        return weatherTest and engineTest and specificTest
    end,
    
    testEffect = function(effectId)
        print("Testing weather effect: " .. effectId)
        local effect = {
            type = "weather",
            data = {
                effectId = effectId
            }
        }
        return effectsEngine.processEffect(effect)
    end,
    
    listEffects = function()
        weatherEffects.listAvailableEffects()
    end
}
