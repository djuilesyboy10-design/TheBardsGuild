-- perk_test_trigger.lua
-- In-game trigger for perk testing
-- Press a key or use an item to trigger perk tests

local I = require('openmw.interfaces')
local self = require('openmw.self')
local ui = require('openmw.ui')

local perkEffects = require("scripts.engine.framework.effects.effect_modules.perk_effects")

-- Create a simple spell that triggers perk test
local function createTestSpell()
    -- This would be better if we could add spells dynamically
    -- For now, we'll use a key press approach
end

-- Key press handler for testing
local function onKeyPress(key)
    if key == "F9" then
        print("[KEY_TEST] Testing Muse's Whisper perk unlock...")
        perkEffects.checkPerkUnlock('bard_performance', 25)
    elseif key == "F10" then
        print("[KEY_TEST] Showing current perks...")
        local storage = require('openmw.storage')
        local playerPerks = storage.playerSection('BardPerks')
        local currentPerks = playerPerks:asTable()
        if currentPerks and next(currentPerks) then
            for perkId, _ in pairs(currentPerks) do
                local perkEffectsData = require("scripts.engine.framework.effects.effect_data.perk_effects_data")
                local perkData = perkEffectsData.getPerkEffect(perkId)
                if perkData then
                    ui.showMessage(perkData.name .. " (Level " .. perkData.level .. ")")
                end
            end
        else
            ui.showMessage("No perks unlocked yet.")
        end
    elseif key == "F11" then
        print("[KEY_TEST] Resetting all perks...")
        local storage = require('openmw.storage')
        local playerPerks = storage.playerSection('BardPerks')
        playerPerks:reset()
        ui.showMessage("All perks reset!")
    end
end

-- Alternative: Use a spell that already exists
local function checkForTestSpell()
    -- Check if player has a specific spell and trigger perk test
    local types = require('openmw.types')
    local spells = types.Actor.spells(self)
    
    for _, spell in ipairs(spells) do
        if spell.id == "bard_performance_dummy" then
            print("[SPELL_TEST] Bard spell detected, triggering perk test...")
            perkEffects.checkPerkUnlock('bard_performance', 25)
            break
        end
    end
end

return {
    engineHandlers = {
        -- Check for test spell every few seconds
        onUpdate = function()
            -- Only check every 5 seconds
            if not lastCheck or (os.time() - lastCheck) > 5 then
                lastCheck = os.time()
                checkForTestSpell()
            end
        end
    }
}
