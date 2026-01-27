-- performance_simple.lua
-- Simple console commands that work directly in OpenMW console

local world = require('openmw.world')
local I = require('openmw.interfaces')

print(">>> BARD PERFORMANCE SIMPLE SYSTEM INITIALIZED <<<")

-- Global functions that can be called directly from console
_G.bardTest = function()
    print("[Bard] Testing Performance System...")
    
    -- Test 1: Check performance event system
    if I.BardPerformance then
        print("[Bard] ✓ Performance interface available")
        
        -- Test random number generation
        local outcome = I.BardPerformance.generateOutcome()
        print(string.format("[Bard] ✓ Generated outcome: %d", outcome))
        
        -- Test outcome lookup
        local outcomes = I.BardPerformance.getOutcomes()
        if outcomes[outcome] then
            print(string.format("[Bard] ✓ Outcome lookup successful: %s", outcomes[outcome].name))
        else
            print("[Bard] ✗ Outcome lookup failed")
        end
        
        -- Test last performance
        local lastPerf = I.BardPerformance.getLastPerformance()
        if lastPerf and lastPerf.outcome then
            print(string.format("[Bard] ✓ Last performance: %s", lastPerf.outcome.name))
        else
            print("[Bard] ✓ No previous performance (expected)")
        end
    else
        print("[Bard] ✗ Performance interface not available")
    end
    
    -- Test 2: Check influence system
    if I.JMCG_QuestData then
        local influence = I.JMCG_QuestData.getMeterNumber()
        print(string.format("[Bard] ✓ Influence system available: %d%%", influence))
    else
        print("[Bard] ! Influence system not available")
    end
    
    -- Test 3: Check bard skill system
    if I.SkillFramework then
        local bardStat = I.SkillFramework.getSkillStat("bard_performance")
        if bardStat then
            print(string.format("[Bard] ✓ Bard skill available: Level %d, Progress %.1f", 
                bardStat.modified, bardStat.progress))
        else
            print("[Bard] ! Bard skill not registered")
        end
    else
        print("[Bard] ✗ SkillFramework not available")
    end
    
    print("[Bard] Core functionality test complete!")
end

_G.bardPerform = function()
    local performanceId = math.random(1, 5)
    
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
    
    print(string.format("[Bard] Performance triggered: ID %d, Location: %s, Audience: %d", 
        performanceId, location, audience))
end

_G.bardPerformId = function(id)
    local num = tonumber(id)
    if not num or num < 1 or num > 5 then
        print("[Bard] Usage: bardPerformId(1-5)")
        return
    end
    
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
        performanceId = num,
        location = location,
        audience = audience
    })
    
    print(string.format("[Bard] Performance triggered: ID %d, Location: %s, Audience: %d", 
        num, location, audience))
end

_G.bardStatus = function()
    if I.SkillFramework then
        local bardStat = I.SkillFramework.getSkillStat("bard_performance")
        if bardStat then
            local req = I.SkillFramework.getSkillProgressRequirement("bard_performance") or 0
            print(string.format("[Bard] Skill Status: Level %d, Progress %.1f/%.1f", 
                bardStat.modified, bardStat.progress, req))
        else
            print("[Bard] Bard skill not registered")
        end
    else
        print("[Bard] SkillFramework not available")
    end
end

_G.bardInfluence = function()
    if I.JMCG_QuestData then
        local influence = I.JMCG_QuestData.getMeterNumber()
        print(string.format("[Bard] Bard Influence: %d%%", influence))
    else
        print("[Bard] Influence system not available")
    end
end

_G.bardOutcomes = function()
    if I.BardPerformance then
        local outcomes = I.BardPerformance.getOutcomes()
        print("[Bard] Performance Outcomes:")
        for id, outcome in pairs(outcomes) do
            print(string.format("  %d: %s (XP: %.1fx, Rep: %+d)", 
                id, outcome.name, outcome.xpBonus, outcome.reputationBonus))
        end
    else
        print("[Bard] Performance system not available")
    end
end

_G.bardHelp = function()
    print("[Bard] Available Commands:")
    print("  bardTest() - Run system test")
    print("  bardPerform() - Trigger random performance")
    print("  bardPerformId(1-5) - Trigger specific performance")
    print("  bardStatus() - Show bard skill status")
    print("  bardInfluence() - Show current influence")
    print("  bardOutcomes() - Show all performance outcomes")
    print("  bardHelp() - Show this help")
end

print("[Bard] Simple performance commands loaded!")
print("[Bard] Type 'bardHelp()' to see available commands")
