-- perk_test_global.lua
-- Global test script for perk system
-- This creates global functions that can be called from console

local perkEffects = require("scripts.engine.framework.effects.effect_modules.perk_effects")

-- Create global test functions
_G.testMuseWhisper = function()
    print("[GLOBAL_TEST] Testing Muse's Whisper perk unlock...")
    perkEffects.checkPerkUnlock('bard_performance', 25)
end

_G.testEchoWeaver = function()
    print("[GLOBAL_TEST] Testing Echo Weaver perk unlock...")
    local storage = require('openmw.storage')
    local playerPerks = storage.playerSection('BardPerks')
    local currentPerks = playerPerks:asTable() or {}
    if not currentPerks.muse_whisper then
        print("[GLOBAL_TEST] Unlocking Muse's Whisper first...")
        playerPerks:set('muse_whisper', true)
    end
    perkEffects.checkPerkUnlock('bard_performance', 50)
end

_G.testStoryShaper = function()
    print("[GLOBAL_TEST] Testing Story Shaper perk unlock...")
    local storage = require('openmw.storage')
    local playerPerks = storage.playerSection('BardPerks')
    local currentPerks = playerPerks:asTable() or {}
    if not currentPerks.muse_whisper then
        playerPerks:set('muse_whisper', true)
    end
    if not currentPerks.echo_weaver then
        playerPerks:set('echo_weaver', true)
    end
    perkEffects.checkPerkUnlock('bard_performance', 75)
end

_G.showPerks = function()
    print("[GLOBAL_TEST] ========== CURRENT PERKS ==========")
    local storage = require('openmw.storage')
    local playerPerks = storage.playerSection('BardPerks')
    local currentPerks = playerPerks:asTable()
    if currentPerks and next(currentPerks) then
        for perkId, _ in pairs(currentPerks) do
            local perkEffectsData = require("scripts.engine.framework.effects.effect_data.perk_effects_data")
            local perkData = perkEffectsData.getPerkEffect(perkId)
            if perkData then
                print("[GLOBAL_TEST] " .. perkData.name .. " (Level " .. perkData.level .. ")")
            end
        end
    else
        print("[GLOBAL_TEST] No perks unlocked yet.")
    end
    print("[GLOBAL_TEST] ======================================")
end

_G.resetPerks = function()
    print("[GLOBAL_TEST] Resetting all perks...")
    local storage = require('openmw.storage')
    local playerPerks = storage.playerSection('BardPerks')
    playerPerks:reset()
    print("[GLOBAL_TEST] All perks reset!")
end

print("[GLOBAL_TEST] Perk test functions loaded! Use: testMuseWhisper(), showPerks(), resetPerks()")

return {
    -- Empty return - this script just sets up global functions
}
