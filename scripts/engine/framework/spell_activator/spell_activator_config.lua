-- Spell Activator Configuration
-- Defines which spells trigger custom effects
-- Part of the Universal Activator Framework

local spellActivators = {
    -- Garden Spell - Teleport to The Lost Archive
    ["jmcg_garden"] = {
        event = "GardenSpellActivate",
        destination = "lost_archive",
        description = "Garden spell teleportation to The Lost Archive"
    }
    
    -- Add more custom spells here
}

-- Get activator data for a specific spell ID
local function getSpellActivator(spellId)
    return spellActivators[spellId]
end

-- Get all configured activators (for debugging/inspection)
local function getAllSpellActivators()
    return spellActivators
end

-- Check if a spell has custom activation configured
local function hasSpellActivator(spellId)
    return spellActivators[spellId] ~= nil
end

return {
    getSpellActivator = getSpellActivator,
    getAllSpellActivators = getAllSpellActivators,
    hasSpellActivator = hasSpellActivator
}
