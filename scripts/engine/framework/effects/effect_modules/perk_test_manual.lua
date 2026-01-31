-- perk_test_manual.lua
-- Manual perk testing using existing systems

local I = require('openmw.interfaces')
local self = require('openmw.self')
local ui = require('openmw.ui')

local perkEffects = require("scripts.engine.framework.effects.effect_modules.perk_effects")

-- Check if we can trigger perk unlock through skill framework
local function checkSkillFramework()
    -- Try to get bard skill stat
    if I.SkillFramework and I.SkillFramework.getSkillStat then
        local bardStat = I.SkillFramework.getSkillStat('bard_performance')
        if bardStat then
            print("[MANUAL_TEST] Current bard skill level: " .. (bardStat.base or 0))
            
            -- Manually trigger perk check for current level
            perkEffects.checkPerkUnlock('bard_performance', bardStat.base or 0)
        else
            print("[MANUAL_TEST] Bard skill stat not found")
        end
    else
        print("[MANUAL_TEST] SkillFramework interface not available")
    end
end

-- Try to trigger through existing bard_perks.lua
local function triggerThroughBardPerks()
    print("[MANUAL_TEST] Testing through existing bard_perks.lua...")
    
    -- Simulate a skill level up event
    if I and I.SkillProgression and I.SkillProgression.skillUsed then
        print("[MANUAL_TEST] SkillProgression interface available")
        -- This might trigger the existing bard_perks system
    else
        print("[MANUAL_TEST] SkillProgression interface not available")
    end
end

-- Create a simple UI button for testing
local function createTestButton()
    ui.showMessage('[MANUAL_TEST] Perk test loaded! Try using bard skills or check console for debug messages.')
end

return {
    engineHandlers = {
        onLoad = function()
            print("[MANUAL_TEST] Perk test manual loaded!")
            createTestButton()
            checkSkillFramework()
        end,
        
        onUpdate = function()
            -- Check every 10 seconds for debugging
            if not lastCheck or (os.time() - lastCheck) > 10 then
                lastCheck = os.time()
                checkSkillFramework()
            end
        end
    }
}
