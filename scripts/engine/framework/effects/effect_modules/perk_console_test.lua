-- perk_console_test.lua
-- Console test commands for perk system
-- Load this in console to test perks

local perkEffects = require("scripts.engine.framework.effects.effect_modules.perk_effects")

-- Make functions available for console testing
return {
    testMuseWhisper = function()
        print("[CONSOLE_TEST] Testing Muse's Whisper perk unlock...")
        perkEffects.checkPerkUnlock('bard_performance', 25)
    end,
    
    testEchoWeaver = function()
        print("[CONSOLE_TEST] Testing Echo Weaver perk unlock...")
        -- First unlock Muse's Whisper if not already unlocked
        local storage = require('openmw.storage')
        local playerPerks = storage.playerSection('BardPerks')
        local currentPerks = playerPerks:asTable() or {}
        if not currentPerks.muse_whisper then
            print("[CONSOLE_TEST] Unlocking Muse's Whisper first...")
            playerPerks:set('muse_whisper', true)
        end
        perkEffects.checkPerkUnlock('bard_performance', 50)
    end,
    
    testStoryShaper = function()
        print("[CONSOLE_TEST] Testing Story Shaper perk unlock...")
        -- First unlock prerequisites if not already unlocked
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
    end,
    
    showPerks = function()
        print("[CONSOLE_TEST] ========== CURRENT PERKS ==========")
        local storage = require('openmw.storage')
        local playerPerks = storage.playerSection('BardPerks')
        local currentPerks = playerPerks:asTable()
        if currentPerks and next(currentPerks) then
            for perkId, _ in pairs(currentPerks) do
                local perkEffectsData = require("scripts.engine.framework.effects.effect_data.perk_effects_data")
                local perkData = perkEffectsData.getPerkEffect(perkId)
                if perkData then
                    print("[CONSOLE_TEST] " .. perkData.name .. " (Level " .. perkData.level .. ")")
                end
            end
        else
            print("[CONSOLE_TEST] No perks unlocked yet.")
        end
        print("[CONSOLE_TEST] ======================================")
    end,
    
    resetPerks = function()
        print("[CONSOLE_TEST] Resetting all perks...")
        local storage = require('openmw.storage')
        local playerPerks = storage.playerSection('BardPerks')
        playerPerks:reset()
        print("[CONSOLE_TEST] All perks reset!")
    end
}
