-- performance_menu_helper.lua
-- Simple performance menu helper (no interface registration)

local ui = require('openmw.ui')

print(">>> BARD PERFORMANCE MENU HELPER INITIALIZED <<<")

-- Menu state
local menuActive = false
local pendingPerformance = nil

-- Get player context
local function getPlayerContext()
    return require('openmw.self')
end

-- Simple messagebox for performance confirmation
local function showPerformanceMenu()
    if menuActive then
        print("[Bard] Menu already active")
        return
    end
    
    local self = getPlayerContext()
    
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
    
    -- Store pending performance data
    pendingPerformance = {
        location = location,
        audience = audience,
        performanceId = math.random(1, 5)
    }
    
    menuActive = true
    
    -- Create simple messagebox
    ui.showMessage({
        message = string.format("Perform in %s?\n\nAudience: %d people\n\nChoose your performance type:", 
            location, audience),
        buttons = {
            {
                text = "Brilliant",
                callback = function()
                    executePerformance(1)
                end
            },
            {
                text = "Good", 
                callback = function()
                    executePerformance(2)
                end
            },
            {
                text = "Mediocre",
                callback = function()
                    executePerformance(3)
                end
            },
            {
                text = "Poor",
                callback = function()
                    executePerformance(4)
                end
            },
            {
                text = "Cancel",
                callback = function()
                    cancelPerformance()
                end
            }
        }
    })
    
    print(string.format("[Bard] Performance menu shown: %s, Audience: %d", location, audience))
end

-- Execute the performance
local function executePerformance(performanceId)
    if not pendingPerformance then
        print("[Bard] Error: No pending performance")
        return
    end
    
    local self = getPlayerContext()
    
    -- Update the performance ID
    pendingPerformance.performanceId = performanceId
    
    -- Send performance event
    self:sendGlobalEvent('BardPerformance', {
        performanceId = pendingPerformance.performanceId,
        location = pendingPerformance.location,
        audience = pendingPerformance.audience
    })
    
    print(string.format("[Bard] Performance executed: ID %d, Location: %s, Audience: %d", 
        pendingPerformance.performanceId, pendingPerformance.location, pendingPerformance.audience))
    
    -- Clean up
    cleanupMenu()
end

-- Cancel the performance
local function cancelPerformance()
    print("[Bard] Performance cancelled")
    cleanupMenu()
end

-- Clean up menu state
local function cleanupMenu()
    menuActive = false
    pendingPerformance = nil
end

-- Quick performance (no menu)
local function quickPerform()
    local self = getPlayerContext()
    
    local location = "Unknown"
    if self.cell and self.cell.name then
        location = self.cell.name
    end
    
    local audience = 0
    for _, npc in ipairs(self.nearby.npcs) do
        local distance = (npc.position - self.position):length()
        if distance <= 1000 then
            audience = audience + 1
        end
    end
    
    local performanceId = math.random(1, 5)
    
    self:sendGlobalEvent('BardPerformance', {
        performanceId = performanceId,
        location = location,
        audience = audience
    })
    
    print(string.format("[Bard] Quick performance: ID %d, Location: %s, Audience: %d", 
        performanceId, location, audience))
end

-- Check if menu is active
local function isMenuActive()
    return menuActive
end

-- Export functions for console system
return {
    show = showPerformanceMenu,
    quickPerform = quickPerform,
    isActive = isMenuActive
}
