---@diagnostic disable: undefined-global
local I = require("openmw.interfaces")

-- Simple test script to trigger bard XP events
-- Use this in console or bind to a key for testing

local function testBardXP()
    if not I.SkillFramework then
        print("SkillFramework not available")
        return
    end
    
    -- Test different bard activities
    world.sendEvent("BardPerformance", { amount = 1 })
    world.sendEvent("PersuasionSuccess", { amount = 1 })
    world.sendEvent("TaleTold", { amount = 1 })
    world.sendEvent("SongComposed", { amount = 3 })
    world.sendEvent("LoreResearched", { amount = 2 })
    
    print("[Bard Test] Sent test XP events")
end

-- You can call this from console with:
-- require('scripts.Lua.Skill.bard_test').testBardXP()

return {
    testBardXP = testBardXP
}
