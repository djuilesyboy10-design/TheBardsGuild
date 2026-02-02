-- door_lock_effects_data.lua
-- Data definitions for door lock effects

local M = {}

-- Door lock effects
local effects = {
    night_lock_houses = {
        id = "night_lock_houses",
        name = "Night Lock - Houses",
        description = "Locks residential doors at night (10 PM to 8 AM)",
        lockTime = {
            start = 22,  -- 10 PM
            end = 8      -- 8 AM
        },
        doorTypes = {
            "'s house",
            "'s home", 
            "house",
            "dwelling",
            "apartment"
        },
        lockLevel = 30,
        showMessage = true,
        lockMessage = "The door locks automatically as night falls.",
        unlockMessage = "The door unlocks automatically as morning arrives."
    },
    
    night_lock_shops = {
        id = "night_lock_shops", 
        name = "Night Lock - Shops",
        description = "Locks private shops at night (8 PM to 9 AM)",
        lockTime = {
            start = 20,  -- 8 PM (shops close earlier)
            end = 9      -- 9 AM (shops open later)
        },
        doorTypes = {
            "'s shop",
            "'s store",
            "shop",
            "store"
        },
        lockLevel = 40,
        showMessage = true,
        lockMessage = "The shop door is locked for the night.",
        unlockMessage = "The shop door opens for business."
    },
    
    night_lock_inn_rooms = {
        id = "night_lock_inn_rooms",
        name = "Night Lock - Inn Rooms", 
        description = "Locks private inn rooms at night",
        lockTime = {
            start = 22,  -- 10 PM
            end = 7      -- 7 AM (early checkout)
        },
        doorTypes = {
            "room",
            "chamber",
            "quarters"
        },
        cellPatterns = {
            "inn",
            "tavern"
        },
        lockLevel = 25,
        showMessage = true,
        lockMessage = "The room door is locked for the night.",
        unlockMessage = "The room door unlocks for the morning."
    },
    
    guild_doors_never_lock = {
        id = "guild_doors_never_lock",
        name = "Guild Doors - Never Lock",
        description = "Ensures guild and public doors remain accessible 24/7",
        lockTime = {
            start = 22,
            end = 8
        },
        doorTypes = {
            "guild",
            "guildhall", 
            "temple",
            "palace",
            "public"
        },
        lockLevel = 0,  -- Never lock
        showMessage = false
    },
    
    tavern_main_areas = {
        id = "tavern_main_areas",
        name = "Tavern Main Areas - Never Lock", 
        description = "Keeps main tavern areas accessible",
        lockTime = {
            start = 22,
            end = 8
        },
        doorTypes = {
            "tavern",
            "inn"
        },
        lockLevel = 0,  -- Never lock main areas
        showMessage = false
    },
    
    -- Special case overrides
    balmora_special_cases = {
        id = "balmora_special_cases",
        name = "Balmora Special Cases",
        description = "Special door handling for Balmora",
        lockTime = {
            start = 22,
            end = 8
        },
        specificDoors = {
            "balmora_tavern_door",
            "balmora_mages_guild",
            "balmora_fighters_guild"
        },
        lockLevel = 0,  -- Keep these unlocked
        showMessage = false
    }
}

-- Get effect by ID
function M.getEffect(effectId)
    return effects[effectId]
end

-- List all available effects
function M.listEffects()
    local effectList = {}
    for id, effect in pairs(effects) do
        table.insert(effectList, id)
    end
    return effectList
end

-- Get effects by lock time
function M.getEffectsByLockTime(hour)
    local applicableEffects = {}
    for id, effect in pairs(effects) do
        if hour >= effect.lockTime.start or hour < effect.lockTime.end then
            table.insert(applicableEffects, effect)
        end
    end
    return applicableEffects
end

-- Get all locking effects (those that actually lock doors)
function M.getLockingEffects()
    local lockingEffects = {}
    for id, effect in pairs(effects) do
        if effect.lockLevel > 0 then
            table.insert(lockingEffects, effect)
        end
    end
    return lockingEffects
end

-- Get all unlocking effects (those that ensure doors stay unlocked)
function M.getUnlockingEffects()
    local unlockingEffects = {}
    for id, effect in pairs(effects) do
        if effect.lockLevel == 0 then
            table.insert(unlockingEffects, effect)
        end
    end
    return unlockingEffects
end

return M
