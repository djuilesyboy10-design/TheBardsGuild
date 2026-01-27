local core = require('openmw.core')
local world = require('openmw.world')

-- v0.50 Weather Record Map
local weatherRecords = {
    [0] = core.weather.records.Clear,
    [1] = core.weather.records.Cloudy,
    [2] = core.weather.records.Foggy,
    [3] = core.weather.records.Overcast,
    [4] = core.weather.records.Rain,
    [5] = core.weather.records.Thunderstorm,
    [6] = core.weather.records.Ashstorm,
    [7] = core.weather.records.Blight,
    [8] = core.weather.records.Snow,
    [9] = core.weather.records.Blizzard,
}

local activeMythWeather = nil

local function onApplyEffect(data)
    if data and data.weatherEvent then
        activeMythWeather = {
            record = weatherRecords[data.weatherEvent.weatherID]
        }
        -- Initial force attempt
        print(">>> Myth Weather Active")
    end
end

local function onUpdate(dt)
    if activeMythWeather then
        -- In v0.50 Global scripts, use world.players (a table)
        for _, player in ipairs(world.players) do
            local cell = player.cell
            
            -- Ensure we only force weather in exterior-capable cells
            if cell.isExterior or cell:hasTag("QuasiExterior") then
                local region = cell.region
                if region then
                    -- Force the weather for the player's specific region ID (string)
                    -- 'true' ensures an instant lock that overrides regional defaults
                    core.weather.changeWeather(region, activeMythWeather.record, true)
                end
            end
        end
    end
end

return {
    eventHandlers = {
        ApplyBardicEffect = onApplyEffect,
    },
    engineHandlers = {
        onUpdate = onUpdate,
    }
}