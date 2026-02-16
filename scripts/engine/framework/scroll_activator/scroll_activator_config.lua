-- Scroll Activator Configuration
-- Defines which scrolls trigger custom effects
-- Part of the Universal Activator Framework

local scrollActivators = {
    -- Endgame Scroll - Teleport to Dremora Citadel
    ["jmcg_endgame"] = {
        event = "EndgameScrollActivate",
        destination = "dremora_citadel",
        description = "Endgame scroll teleportation to Dremora Citadel"
    }
    
    -- Add more custom scrolls here
}

-- Get activator data for a specific scroll ID
local function getScrollActivator(scrollId)
    return scrollActivators[scrollId]
end

-- Get all configured activators (for debugging/inspection)
local function getAllScrollActivators()
    return scrollActivators
end

-- Check if a scroll has custom activation configured
local function hasScrollActivator(scrollId)
    return scrollActivators[scrollId] ~= nil
end

return {
    getScrollActivator = getScrollActivator,
    getAllScrollActivators = getAllScrollActivators,
    hasScrollActivator = hasScrollActivator
}
