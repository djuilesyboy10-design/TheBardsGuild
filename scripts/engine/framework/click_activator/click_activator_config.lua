-- Click Activator Configuration
-- Defines which NPC classes trigger click interactions
-- Part of the Universal Activator Framework

local clickActivators = {
    -- Merchant Class - Trading and commerce interactions
    ["trader service"] = {
        event = "MerchantClassShowMenu",
        contentFile = "merchant_content_data",
        helperFile = "merchant_class_helper",
        description = "Merchant dialogue and trading interactions"
    },
    
    -- Bard Class - Music and performance interactions
    ["bard"] = {
        event = "BardClassShowMenu",
        contentFile = "bard_content_data",
        helperFile = "bard_class_helper",
        description = "Bard performances and musical interactions"
    },
    
    -- Publican Class - Inn services and interactions
    ["publican"] = {
        event = "PublicanClassShowMenu",
        contentFile = "publican_content_data",
        helperFile = "publican_class_helper",
        description = "Publican inn services and interactions"
    },
    
    -- Savant Class - Knowledge and lore interactions
    ["Savant"] = {
        event = "SavantClassShowMenu",
        contentFile = "savant_content_data",
        helperFile = "savant_class_helper",
        description = "Savant knowledge and lore interactions"
    },
    
    -- Pauper Class - Street wisdom and common folk interactions
    ["Pauper"] = {
        event = "PauperClassShowMenu",
        contentFile = "pauper_content_data",
        helperFile = "pauper_class_helper",
        description = "Pauper street wisdom and common interactions"
    },
    
    -- Alchemist Class - Potion and alchemy interactions
    ["alchemist"] = {
        event = "AlchemistClassShowMenu",
        contentFile = "alchemist_content_data",
        helperFile = "alchemist_class_helper",
        description = "Alchemist potion and alchemy interactions"
    },
    
    -- Smith Class - Weapon and armor crafting interactions
    ["smith"] = {
        event = "SmithClassShowMenu",
        contentFile = "smith_content_data",
        helperFile = "smith_class_helper",
        description = "Smith weapon and armor crafting interactions"
    },
    
    -- Noble Class - High society and political interactions
    ["noble"] = {
        event = "NobleClassShowMenu",
        contentFile = "noble_content_data",
        helperFile = "noble_class_helper",
        description = "Noble high society and political interactions"
    },
    
    -- Guard Class - Security and law enforcement interactions
    ["guard"] = {
        event = "GuardClassShowMenu",
        contentFile = "guard_content_data",
        helperFile = "guard_class_helper",
        description = "Guard security and law enforcement interactions"
    }
}

-- Get activator data for a specific NPC class
local function getActivatorData(npcClass)
    return clickActivators[npcClass]
end

-- Get all configured activators (for debugging/inspection)
local function getAllActivators()
    return clickActivators
end

-- Check if an NPC class has click activation configured
local function hasActivator(npcClass)
    return clickActivators[npcClass] ~= nil
end

return {
    getActivatorData = getActivatorData,
    getAllActivators = getAllActivators,
    hasActivator = hasActivator
}
