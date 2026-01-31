-- weather_effects_data.lua
-- Universal Weather Effects Data Table
-- Users can easily add new weather effects here

local weatherEffects = {
    {
        id = "rain_ascadian",
        name = "Rain in Ascadian Isles",
        region = "Ascadian Isles Region", 
        weatherID = 4,  -- Rain
        duration = 3600,  -- 1 hour in seconds
        description = "Starts gentle rain in Ascadian Isles",
        userFriendly = "Makes it rain in the Ascadian Isles"
    },
    {
        id = "thunder_west_gash",
        name = "Thunderstorm in West Gash",
        region = "West Gash Region",
        weatherID = 5,  -- Thunderstorm  
        duration = 1800,  -- 30 minutes
        description = "Brings thunderstorm to West Gash",
        userFriendly = "Creates a thunderstorm in West Gash"
    },
    {
        id = "clear_balmora",
        name = "Clear skies over Balmora",
        region = "Balmora Region",
        weatherID = 0,  -- Clear
        duration = 7200,  -- 2 hours
        description = "Clears the skies over Balmora",
        userFriendly = "Makes the weather clear and sunny in Balmora"
    },
    {
        id = "fog_molag_mar",
        name = "Fog in Molag Mar",
        region = "Molag Mar Region",
        weatherID = 2,  -- Foggy
        duration = 2400,  -- 40 minutes
        description = "Brings mysterious fog to Molag Mar",
        userFriendly = "Creates thick fog around Molag Mar"
    },
    {
        id = "ashstorm_red_mountain",
        name = "Ashstorm near Red Mountain",
        region = "Red Mountain Region",
        weatherID = 6,  -- Ashstorm
        duration = 3000,  -- 50 minutes
        description = "Triggers an ashstorm from Red Mountain",
        userFriendly = "Causes a dangerous ashstorm from Red Mountain"
    }
}

return {
    weatherEffects = weatherEffects,
    
    -- Helper function for users to get weather effect by ID
    getEffect = function(effectId)
        for _, effect in ipairs(weatherEffects) do
            if effect.id == effectId then
                return effect
            end
        end
        return nil
    end,
    
    -- Helper function to list all available effects
    listEffects = function()
        local list = {}
        for _, effect in ipairs(weatherEffects) do
            table.insert(list, effect.id .. " - " .. effect.userFriendly)
        end
        return list
    end
}
