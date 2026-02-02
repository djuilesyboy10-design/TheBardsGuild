-- reputation_effects_data.lua
-- Universal Reputation Effects Data Table
-- Users can easily add new reputation effects here

local reputationEffects = {
    {
        id = "imperial_favor",
        name = "Imperial Favor",
        faction = "Imperial Legion",
        amount = 10,
        duration = 3600,  -- 1 hour in seconds
        description = "Gain favor with the Imperial faction",
        userFriendly = "Increases Imperial Legion reputation by +10"
    },
    {
        id = "temple_blessing",
        name = "Temple Blessing",
        faction = "Temple",
        amount = 15,
        duration = 7200,  -- 2 hours
        description = "Receive blessing from the Temple",
        userFriendly = "Increases Temple reputation by +15"
    },
    {
        id = "hlaalu_anger",
        name = "Hlaalu Anger",
        faction = "Great House Hlaalu",
        amount = -5,
        duration = 1800,  -- 30 minutes
        description = "Offend House Hlaalu",
        userFriendly = "Decreases Hlaalu reputation by -5"
    },
    {
        id = "fighter_guild_respect",
        name = "Fighter Guild Respect",
        faction = "Fighters Guild",
        amount = 8,
        duration = 3600,  -- 1 hour
        description = "Earn respect from Fighters Guild",
        userFriendly = "Increases Fighters Guild reputation by +8"
    },
    {
        id = "thieves_guild_trust",
        name = "Thieves Guild Trust",
        faction = "Thieves Guild",
        amount = 12,
        duration = 5400,  -- 1.5 hours
        description = "Gain trust with Thieves Guild",
        userFriendly = "Increases Thieves Guild reputation by +12"
    },
    {
        id = "hlaalu_favor",
        name = "Hlaalu Favor",
        faction = "Great House Hlaalu",
        amount = 8,
        duration = 7200,  -- 2 hours
        description = "Gain favor with House Hlaalu",
        userFriendly = "Increases House Hlaalu reputation by +8"
    }
}

return {
    reputationEffects = reputationEffects,
    
    -- Helper function for users to get reputation effect by ID
    getEffect = function(effectId)
        for _, effect in ipairs(reputationEffects) do
            if effect.id == effectId then
                return effect
            end
        end
        return nil
    end,
    
    -- Helper function to list all available effects
    listEffects = function()
        local list = {}
        for _, effect in ipairs(reputationEffects) do
            table.insert(list, effect.id .. " - " .. effect.userFriendly)
        end
        return list
    end
}
