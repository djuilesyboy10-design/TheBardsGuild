-- World Activator Configuration
-- Defines which world objects trigger custom quest-related effects
-- Part of the Universal Activator Framework

local worldActivators = {
    -- Example: A strange resonance pillar
    ["jmcg_resonance_pillar"] = {
        event = "JMCG_ResonancePillarActivate",
        description = "A humming pillar of ancient Dwemer design"
    },
    
    -- Example: The Margin Altar
    ["jmcg_margin_altar"] = {
        event = "JMCG_MarginAltarActivate",
        description = "An altar bleeding ink and memories"
    }
}

-- Get activator data for a specific record ID
local function getWorldActivator(recordId)
    return worldActivators[recordId]
end

-- Get all configured activators
local function getAllWorldActivators()
    return worldActivators
end

-- Check if an object has custom activation configured
local function hasWorldActivator(recordId)
    return worldActivators[recordId] ~= nil
end

return {
    getWorldActivator = getWorldActivator,
    getAllWorldActivators = getAllWorldActivators,
    hasWorldActivator = hasWorldActivator
}
