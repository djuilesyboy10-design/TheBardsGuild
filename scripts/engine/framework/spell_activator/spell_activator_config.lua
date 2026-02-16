-- Spell Activator Configuration
-- Defines which spells trigger custom effects
-- Part of the Universal Activator Framework

local spellActivators = {
    -- Garden Teleport Spell - Uses existing UT destination
    ["JMCG_Garden"] = {
        network = "garden_spell",
        destination = "lost_archive",
        message = "The garden spell's magic surrounds you with the scent of blooming flowers. The world shimmers and dissolves, revealing a hidden sanctuary of perfect tranquility...",
        description = "Teleportation spell to the Bard's Guild garden"
    },
    
    -- Add more custom spells here
}

-- Target spell ID for easy reference
local targetSpell = "JMCG_Garden"

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

-- Get the target spell ID
local function getTargetSpell()
    return targetSpell
end

-- Set the target spell ID (for dynamic configuration)
local function setTargetSpell(spellId)
    targetSpell = spellId
end

return {
    getSpellActivator = getSpellActivator,
    getAllSpellActivators = getAllSpellActivators,
    hasSpellActivator = hasSpellActivator,
    getTargetSpell = getTargetSpell,
    setTargetSpell = setTargetSpell
}
