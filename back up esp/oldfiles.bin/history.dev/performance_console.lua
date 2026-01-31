-- performance_console.lua
-- Simple console commands for testing performance functionality

local world = require('openmw.world')
local I = require('openmw.interfaces')

print(">>> BARD PERFORMANCE CONSOLE COMMANDS INITIALIZED <<<")

-- Simple console interface
return {
    interfaceName = "BardConsole",
    interface = {
        -- Test the entire system
        test = function()
            if I.BardPerformanceTest then
                I.BardPerformanceTest.testSystem()
            else
                print("[Bard] Test system not available")
            end
        end,
        
        -- Trigger a random performance
        perform = function()
            if I.BardPerformanceTest then
                I.BardPerformanceTest.triggerRandom()
            else
                print("[Bard] Performance system not available")
            end
        end,
        
        -- Trigger specific performance (1-5)
        performId = function(id)
            local num = tonumber(id)
            if not num or num < 1 or num > 5 then
                print("[Bard] Usage: performId(1-5)")
                return
            end
            
            if I.BardPerformanceTest then
                I.BardPerformanceTest.triggerPerformance(num)
            else
                print("[Bard] Performance system not available")
            end
        end,
        
        -- Test specific outcome
        testOutcome = function(id)
            local num = tonumber(id)
            if not num or num < 1 or num > 5 then
                print("[Bard] Usage: testOutcome(1-5)")
                return
            end
            
            if I.BardPerformanceTest then
                I.BardPerformanceTest.testOutcome(num)
            else
                print("[Bard] Test system not available")
            end
        end,
        
        -- Show current bard skill status
        status = function()
            if I.SkillFramework then
                local bardStat = I.SkillFramework.getSkillStat("bard_performance")
                if bardStat then
                    print(string.format("[Bard] Skill Status: Level %d, Progress %.1f/%.1f", 
                        bardStat.modified, bardStat.progress, 
                        I.SkillFramework.getSkillProgressRequirement("bard_performance") or 0))
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
        
        -- Help command
        help = function()
            print("[Bard] Available Commands:")
            print("  test() - Run system test")
            print("  perform() - Trigger random performance")
            print("  performId(1-5) - Trigger specific performance")
            print("  testOutcome(1-5) - Test outcome details")
            print("  status() - Show bard skill status")
            print("  influence() - Show current influence")
            print("  outcomes() - Show all performance outcomes")
            print("  help() - Show this help")
        end
    }
}
