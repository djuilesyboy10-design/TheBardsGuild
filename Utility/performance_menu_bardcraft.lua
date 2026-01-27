-- performance_menu_bardcraft.lua
-- Bardcraft-style simple performance helper

local self = require('openmw.self')
local ui = require('openmw.ui')

print(">>> BARD PERFORMANCE MENU (BARDCRAFT STYLE) INITIALIZED <<<")

-- Simple performance execution (Bardcraft pattern)
local function executePerformance(performanceId)
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
    
    -- Performance type names
    local performanceTypes = {
        [1] = "Brilliant",
        [2] = "Good", 
        [3] = "Mediocre",
        [4] = "Poor",
        [5] = "Disastrous"
    }
    
    -- Send performance event
    self:sendGlobalEvent('BardPerformance', {
        performanceId = performanceId,
        location = location,
        audience = audience
    })
    
    -- Show notification (Bardcraft style)
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

-- Show performance options (simple notification)
local function showOptions()
    ui.showMessage("Performance options: 1=Brilliant, 2=Good, 3=Mediocre, 4=Poor, 5=Disastrous")
    print("[Bard] Use performSpecific(1-5) to choose performance type")
end

-- Export functions (Bardcraft pattern)
return {
    execute = executePerformance,
    quick = quickPerform,
    specific = performSpecific,
    showOptions = showOptions
}
