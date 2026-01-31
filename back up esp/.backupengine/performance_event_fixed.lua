-- performance_event_fixed.lua
-- Fixed event system that works in global context

local core = require('openmw.core')
local world = require('openmw.world')

print(">>> BARD PERFORMANCE EVENT SYSTEM INITIALIZED <<<")

-- Performance outcome mappings
local performanceOutcomes = {
    [1] = {
        name = "Brilliant Performance",
        xpBonus = 2.0,
        reputationBonus = 5,
        description = "The crowd is absolutely captivated by your performance!"
    },
    [2] = {
        name = "Good Performance", 
        xpBonus = 1.0,
        reputationBonus = 2,
        description = "The audience appreciates your performance."
    },
    [3] = {
        name = "Mediocre Performance",
        xpBonus = 0.5,
        reputationBonus = 0,
        description = "The performance was acceptable but not remarkable."
    },
    [4] = {
        name = "Poor Performance",
        xpBonus = 0.2,
        reputationBonus = -1,
        description = "The audience seems unimpressed by your performance."
    },
    [5] = {
        name = "Disastrous Performance",
        xpBonus = 0.1,
        reputationBonus = -3,
        description = "The performance did not go well at all."
    }
}

-- Last performance state
local lastPerformanceId = nil
local lastPerformanceTime = 0

-- Triggered by core.sendGlobalEvent('BardPerformance', ...)
local function onPerformanceEvent(data)
    if not data or not data.performanceId then return end
    
    local performanceId = data.performanceId
    local location = data.location or "Unknown"
    local audience = data.audience or 0
    
    local outcome = performanceOutcomes[performanceId]
    if not outcome then
        print("[Bard] Error: Invalid performance ID:", performanceId)
        return
    end
    
    -- Update state
    lastPerformanceId = performanceId
    lastPerformanceTime = world.getGameTime()
    
    -- Apply effects
    print(string.format("[Bard] %s in %s! XP: %.1fx, Rep: %+d", 
        outcome.name, location, outcome.xpBonus, outcome.reputationBonus))
    
    -- Send result to bard skill system
    world.sendEvent('BardPerformanceResult', {
        outcome = outcome,
        location = location,
        audience = audience,
        performanceId = performanceId
    })
    
    -- Update influence system if available
    if world.players[1] then
        world.players[1]:sendEvent('JMCG_BardInfluence_Update', {
            change = outcome.reputationBonus,
            source = "performance",
            location = location
        })
    end
end

-- Simple random number generator (1-5)
local function generatePerformanceOutcome()
    return math.random(1, 5)
end

-- Interface for external systems
return {
    eventHandlers = {
        BardPerformance = onPerformanceEvent
    },
    
    interfaceName = "BardPerformance",
    interface = {
        -- Generate random performance outcome
        generateOutcome = function()
            return generatePerformanceOutcome()
        end,
        
        -- Get last performance info
        getLastPerformance = function()
            return {
                id = lastPerformanceId,
                outcome = lastPerformanceId and performanceOutcomes[lastPerformanceId] or nil,
                time = lastPerformanceTime
            }
        end,
        
        -- Get all possible outcomes
        getOutcomes = function()
            return performanceOutcomes
        end
    }
}
