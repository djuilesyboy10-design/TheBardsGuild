-- performance_test_fixed.lua
-- Fixed test system to verify core functionality without UI

local world = require('openmw.world')
local I = require('openmw.interfaces')

print(">>> BARD PERFORMANCE TEST SYSTEM INITIALIZED <<<")

-- Test function to verify all systems work
local function testPerformanceSystem()
    print("[TEST] Testing Bard Performance System...")
    
    -- Test 1: Check performance event system
    if I.BardPerformance then
        print("[TEST] ✓ Performance interface available")
        
        -- Test random number generation
        local outcome = I.BardPerformance.generateOutcome()
        print(string.format("[TEST] ✓ Generated outcome: %d", outcome))
        
        -- Test outcome lookup
        local outcomes = I.BardPerformance.getOutcomes()
        if outcomes[outcome] then
            print(string.format("[TEST] ✓ Outcome lookup successful: %s", outcomes[outcome].name))
        else
            print("[TEST] ✗ Outcome lookup failed")
        end
        
        -- Test last performance
        local lastPerf = I.BardPerformance.getLastPerformance()
        if lastPerf and lastPerf.outcome then
            print(string.format("[TEST] ✓ Last performance: %s", lastPerf.outcome.name))
        else
            print("[TEST] ✓ No previous performance (expected)")
        end
    else
        print("[TEST] ✗ Performance interface not available")
    end
    
    -- Test 2: Check influence system
    if I.JMCG_QuestData then
        local influence = I.JMCG_QuestData.getMeterNumber()
        print(string.format("[TEST] ✓ Influence system available: %d%%", influence))
    else
        print("[TEST] ! Influence system not available")
    end
    
    -- Test 3: Check bard skill system
    if I.SkillFramework then
        local bardStat = I.SkillFramework.getSkillStat("bard_performance")
        if bardStat then
            print(string.format("[TEST] ✓ Bard skill available: Level %d, Progress %.1f", 
                bardStat.modified, bardStat.progress))
        else
            print("[TEST] ! Bard skill not registered")
        end
    else
        print("[TEST] ✗ SkillFramework not available")
    end
    
    print("[TEST] Core functionality test complete!")
end

-- Manual performance trigger (for testing without UI)
local function triggerManualPerformance(performanceId)
    performanceId = performanceId or math.random(1, 5)
    
    -- Get current location
    local location = "Unknown"
    if self.cell and self.cell.name then
        location = self.cell.name
    end
    
    -- Count audience
    local audience = 0
    for _, npc in ipairs(world.nearby.npcs) do
        local distance = (npc.position - self.position):length()
        if distance <= 1000 then
            audience = audience + 1
        end
    end
    
    -- Send performance event
    world.sendGlobalEvent('BardPerformance', {
        performanceId = performanceId,
        location = location,
        audience = audience
    })
    
    print(string.format("[TEST] Manual performance triggered: ID %d, Location: %s, Audience: %d", 
        performanceId, location, audience))
end

-- Console command interface
local testCommands = {
    -- Run full test suite
    testSystem = function()
        testPerformanceSystem()
    end,
    
    -- Trigger manual performance
    triggerPerformance = function(id)
        triggerManualPerformance(id)
    end,
    
    -- Trigger random performance
    triggerRandom = function()
        triggerManualPerformance(math.random(1, 5))
    end,
    
    -- Test specific outcome
    testOutcome = function(outcomeId)
        if I.BardPerformance then
            local outcomes = I.BardPerformance.getOutcomes()
            local outcome = outcomes[outcomeId]
            if outcome then
                print(string.format("[TEST] Outcome %d: %s", outcomeId, outcome.name))
                print(string.format("[TEST] XP Bonus: %.1fx, Reputation: %+d", outcome.xpBonus, outcome.reputationBonus))
                print(string.format("[TEST] Description: %s", outcome.description))
            else
                print(string.format("[TEST] Invalid outcome ID: %d", outcomeId))
            end
        else
            print("[TEST] Performance interface not available")
        end
    end
}

-- Register the interface
return {
    interfaceName = "BardPerformanceTest",
    interface = testCommands
}
