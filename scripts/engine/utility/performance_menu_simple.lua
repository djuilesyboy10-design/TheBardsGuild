-- performance_menu_simple.lua
-- Simple performance helper using proper OpenMW structure

local self = require('openmw.self')
local ui = require('openmw.ui')
local nearby = require('openmw.nearby')
local types = require('openmw.types')
local core = require('openmw.core')

print(">>> BARD PERFORMANCE MENU (SIMPLE) INITIALIZED <<<")

-- Performance type names
local performanceTypes = {
    [1] = "Brilliant",
    [2] = "Good", 
    [3] = "Mediocre",
    [4] = "Poor",
    [5] = "Disastrous"
}

-- Simple performance execution
local function executePerformance(performanceId)
    -- Get current location
    local location = "Unknown"
    if self.cell and self.cell.name then
        location = self.cell.name
    end
    
    -- Count audience using Bardcraft's context-independent pattern
    local audience = 0
    for _, actor in pairs(nearby.actors) do
        if actor.type == types.NPC then
            local distance = (actor.position - self.position):length()
            if distance <= 1000 then
                audience = audience + 1
            end
        end
    end
    
    -- Send performance event using Bardcraft's pattern
    core.sendGlobalEvent('BardPerformance', {
        performanceId = performanceId,
        location = location,
        audience = audience
    })
    
    -- Show notification
    local perfType = performanceTypes[performanceId] or "Unknown"
    ui.showMessage(string.format("Performing %s in %s for %d people!", perfType, location, audience))
    
    print(string.format("[Bard] Performance executed: %s in %s, Audience: %d", perfType, location, audience))
end

-- Quick performance (random)
local function quickPerform()
    local performanceId = math.random(1, 5)
    executePerformance(performanceId)
end

-- Specific performance
local function performSpecific(id)
    local num = tonumber(id)
    if not num or num < 1 or num > 5 then
        ui.showMessage("Performance ID must be 1-5!")
        return
    end
    executePerformance(num)
end

-- Show performance options
local function showOptions()
    ui.showMessage("Performance options: 1=Brilliant, 2=Good, 3=Mediocre, 4=Poor, 5=Disastrous")
    print("[Bard] Use performSpecific(1-5) to choose performance type")
end

-- Export functions for other scripts
local performanceHelper = {
    execute = executePerformance,
    quick = quickPerform,
    specific = performSpecific,
    showOptions = showOptions
}

-- Make available globally for console access
_G.performanceHelper = performanceHelper

print("[Bard] Performance helper functions available globally")

return {
    interfaceName = "PerformanceHelper",
    interface = performanceHelper
}
