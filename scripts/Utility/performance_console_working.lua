-- performance_console_working.lua
-- Console commands that actually work with OpenMW console

local I = require('openmw.interfaces')

print(">>> BARD PERFORMANCE CONSOLE SYSTEM INITIALIZED <<<")

-- Create interface for console access
local consoleInterface = {
    -- Test the entire system
    test = function()
        print("[Bard] Testing Performance System...")
        
        -- Test 1: Check performance event system (global interface access)
        local performanceAvailable = false
        -- Try multiple ways to access global interface
        local globalInterfaces = require('openmw.interfaces')
        
        -- Method 1: Direct interface access
        if globalInterfaces.BardPerformance then
            performanceAvailable = true
            print("[Bard] ✓ Performance interface available (direct)")
        -- Method 2: Through event handlers
        elseif globalInterfaces.BardPerformance and globalInterfaces.BardPerformance.generateOutcome then
            performanceAvailable = true
            print("[Bard] ✓ Performance interface available (event)")
        else
            print("[Bard] ✗ Performance interface not available")
            -- Debug: Show what performance-related interfaces exist
            print("[Bard] Available performance interfaces:")
            for name, value in pairs(globalInterfaces) do
                if string.find(string.lower(name), "performance") or 
                   string.find(string.lower(name), "bard") then
                    print(string.format("  - %s: %s", name, type(value)))
                end
            end
        end
        
        if performanceAvailable then
            -- Test the interface functions
            local perfInterface = globalInterfaces.BardPerformance
            if perfInterface.generateOutcome then
                local outcome = perfInterface.generateOutcome()
                print(string.format("[Bard] ✓ Generated outcome: %d", outcome))
            end
            
            if perfInterface.getOutcomes then
                local outcomes = perfInterface.getOutcomes()
                if outcomes and outcomes[1] then
                    print(string.format("[Bard] ✓ Outcome lookup successful: %s", outcomes[1].name))
                end
            end
        end
        
        -- Test 2: Check influence system
        local influenceAvailable = false
        -- Try multiple influence interface names
        if I.JMCG_Influence then
            influenceAvailable = true
            local currentInfluence = I.JMCG_Influence.getInfluence() or 0
            print(string.format("[Bard] ✓ Influence system available: %d%%", currentInfluence))
        elseif I.JMCG_BardInfluence then
            influenceAvailable = true
            print("[Bard] ✓ Bard Influence system available")
        else
            print("[Bard] ✗ Influence system not available")
            -- Debug: Show what influence-related interfaces exist
            print("[Bard] Available influence interfaces:")
            for name, value in pairs(I) do
                if string.find(string.lower(name), "influence") or 
                   string.find(string.lower(name), "jm_cg") then
                    print(string.format("  - %s: %s", name, type(value)))
                end
            end
        end
        
        -- Test 3: Check bard skill system
        local skillAvailable = false
        if I.SkillFramework then
            local bardStat = I.SkillFramework.getSkillStat("bard_performance")
            if bardStat then
                skillAvailable = true
                print(string.format("[Bard] ✓ Bard skill available: Level %d, Progress %.1f", 
                    bardStat.modified, bardStat.progress))
            else
                print("[Bard] ✗ Bard skill not registered")
            end
        else
            print("[Bard] ✗ SkillFramework not available")
        end
        
        -- Test 4: Check performance helper (interface access)
        local helperAvailable = false
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            helperAvailable = true
            print("[Bard] ✓ Performance helper available as interface")
        else
            print("[Bard] ✗ Performance helper not available as interface")
        end
        
        -- Summary
        print("[Bard] Core functionality test complete!")
        if performanceAvailable and influenceAvailable and skillAvailable and helperAvailable then
            print("[Bard] 🎉 ALL SYSTEMS GO! Performance system ready!")
        else
            print("[Bard] ⚠ Some systems not available - check logs")
        end
        
        return {
            performance = performanceAvailable,
            influence = influenceAvailable,
            skill = skillAvailable,
            helper = helperAvailable
        }
    end,
    
    -- Trigger a random performance
    perform = function()
        local performanceId = math.random(1, 5)
        
        -- Get current location
        local location = "Unknown"
        if self.cell and self.cell.name then
            location = self.cell.name
        end
        
        -- Count audience
        local audience = 0
        for _, npc in ipairs(self.nearby.npcs) do
            local distance = (npc.position - self.position):length()
            if distance <= 1000 then
                audience = audience + 1
            end
        end
        
        -- Send performance event
        self:sendGlobalEvent('BardPerformance', {
            performanceId = performanceId,
            location = location,
            audience = audience
        })
        
        print(string.format("[Bard] Performance triggered: ID %d, Location: %s, Audience: %d", 
            performanceId, location, audience))
    end,
    
    -- Trigger specific performance (1-5)
    performId = function(id)
        local num = tonumber(id)
        if not num or num < 1 or num > 5 then
            print("[Bard] Usage: performId(1-5)")
            return
        end
        
        -- Get current location
        local location = "Unknown"
        if self.cell and self.cell.name then
            location = self.cell.name
        end
        
        -- Count audience
        local audience = 0
        for _, npc in ipairs(self.nearby.npcs) do
            local distance = (npc.position - self.position):length()
            if distance <= 1000 then
                audience = audience + 1
            end
        end
        
        -- Send performance event
        self:sendGlobalEvent('BardPerformance', {
            performanceId = num,
            location = location,
            audience = audience
        })
        
        print(string.format("[Bard] Performance triggered: ID %d, Location: %s, Audience: %d", 
            num, location, audience))
    end,
    
    -- Test specific outcome
    testOutcome = function(id)
        local num = tonumber(id)
        if not num or num < 1 or num > 5 then
            print("[Bard] Usage: testOutcome(1-5)")
            return
        end
        
        if I.BardPerformance then
            local outcomes = I.BardPerformance.getOutcomes()
            local outcome = outcomes[num]
            if outcome then
                print(string.format("[Bard] Outcome %d: %s", num, outcome.name))
                print(string.format("[Bard] XP Bonus: %.1fx, Reputation: %+d", outcome.xpBonus, outcome.reputationBonus))
                print(string.format("[Bard] Description: %s", outcome.description))
            else
                print(string.format("[Bard] Invalid outcome ID: %d", num))
            end
        else
            print("[Bard] Performance system not available")
        end
    end,
    
    -- Show current bard skill status
    status = function()
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
    end,
    
    -- Show current influence
    influence = function()
        if I.JMCG_QuestData then
            local influence = I.JMCG_QuestData.getMeterNumber()
            print(string.format("[Bard] Bard Influence: %d%%", influence))
        else
            print("[Bard] Influence system not available")
        end
    end,
    
    -- Show performance outcomes table
    outcomes = function()
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
    end,
    
    -- Show performance menu
    menu = function()
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            interfaces.PerformanceHelper.showOptions()
        else
            print("[Bard] Performance helper not available - try reloadlua")
        end
    end,
    
    -- Quick performance (no menu)
    quick = function()
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            interfaces.PerformanceHelper.quick()
        else
            print("[Bard] Performance helper not available - try reloadlua")
        end
    end,
    
    -- Check menu status
    menuStatus = function()
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            print("[Bard] Simple system - no complex menu state")
        else
            print("[Bard] Performance helper not available - try reloadlua")
        end
    end,
    
    -- Specific performance
    performSpecific = function(id)
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            interfaces.PerformanceHelper.specific(id)
        else
            print("[Bard] Performance helper not available - try reloadlua")
        end
    end,
    
    -- Help command
    help = function()
        print("[Bard] Available Commands:")
        print("  test() - Run system test")
        print("  perform() - Trigger random performance")
        print("  performId(1-5) - Trigger specific performance")
        print("  performSpecific(1-5) - Specific performance (Bardcraft style)")
        print("  testOutcome(1-5) - Test outcome details")
        print("  status() - Show bard skill status")
        print("  influence() - Show current influence")
        print("  outcomes() - Show all performance outcomes")
        print("  menu() - Show performance options (Bardcraft style)")
        print("  quick() - Quick performance (no menu)")
        print("  menuStatus() - Check menu status")
        print("  testHelper() - Test helper directly")
        print("  help() - Show this help")
    end,
    
    -- Test helper directly
    testHelper = function()
        print("[Bard] Testing helper directly...")
        
        -- Try to access helper through interface
        local interfaces = require('openmw.interfaces')
        local helper = interfaces.PerformanceHelper
        
        if helper then
            print("[Bard] ✓ Helper found as interface!")
            print("[Bard] Functions available:")
            for name, func in pairs(helper) do
                print(string.format("  - %s: %s", name, type(func)))
            end
            
            -- Test showOptions
            if helper.showOptions then
                print("[Bard] Testing showOptions...")
                helper.showOptions()
            end
            
            return true
        else
            print("[Bard] ✗ Helper not found as interface")
            print("[Bard] Available interfaces:")
            local count = 0
            for name, value in pairs(interfaces) do
                if string.find(string.lower(name), "performance") or 
                   string.find(string.lower(name), "bard") or
                   string.find(string.lower(name), "helper") then
                    print(string.format("  - Interface %s: %s", name, type(value)))
                    count = count + 1
                end
            end
            print(string.format("[Bard] Found %d matching interfaces", count))
            
            return false
        end
    end
}

-- Register the interface for global access
return {
    interfaceName = "BardConsole",
    interface = consoleInterface
}
