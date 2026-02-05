-- Potion Activator Configuration
-- Defines which potions trigger custom effects
-- Part of the Universal Activator Framework

local potionActivators = {
    -- Hist Cell Potion - Teleport to Hist memory chamber
    ["jmcg_potion_unique1"] = {
        event = "HistCellPotionActivate",
        destination = "hist_cell_entrance",
        description = "Hist Cell teleportation potion"
    }
    
    -- Add more custom potions here
}

-- Get activator data for a specific potion ID
local function getPotionActivator(potionId)
    return potionActivators[potionId]
end

-- Get all configured activators (for debugging/inspection)
local function getAllPotionActivators()
    return potionActivators
end

-- Check if a potion has custom activation configured
local function hasPotionActivator(potionId)
    return potionActivators[potionId] ~= nil
end

return {
    getPotionActivator = getPotionActivator,
    getAllPotionActivators = getAllPotionActivators,
    hasPotionActivator = hasPotionActivator
}
