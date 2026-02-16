-- Misc Activator Configuration
-- Defines which miscellaneous items trigger custom effects
-- Part of the Universal Activator Framework

local miscActivators = {
    -- Example: The Devil's Tuning Fork
    ["jmcg_fork"] = {
        event = "JMCG_TuningForkActivate",
        description = "Activates the Propylon resonance network"
    },
    
    -- Example: Bone Flute (Pied Piper arc)
    ["jmcg_bone_flute"] = {
        event = "JMCG_PiedPiperActivate",
        description = "Triggers a temporal stutter effect"
    }
}

-- Get activator data for a specific misc item ID
local function getMiscActivator(itemId)
    return miscActivators[itemId]
end

-- Get all configured activators
local function getAllMiscActivators()
    return miscActivators
end

-- Check if an item has custom activation configured
local function hasMiscActivator(itemId)
    return miscActivators[itemId] ~= nil
end

return {
    getMiscActivator = getMiscActivator,
    getAllMiscActivators = getAllMiscActivators,
    hasMiscActivator = hasMiscActivator
}
