local core = require('openmw.core')

-- Mapping for v0.50 Weather Records
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

-- Myth state storage
local lastRegion = nil
local lastWeatherId = nil

print(">>> BARD WEATHER SYSTEM INITIALIZED <<<")

-- Triggered by core.sendGlobalEvent('ApplyBardicEffect', ...)
local function onApplyEffect(data)
    if not data or not data.weatherEvent then return end

    local regionName = data.weatherEvent.regionName
    local weatherId  = data.weatherEvent.weatherID
    local record     = weatherRecords[weatherId]

    if not regionName or not record then 
        print("[BARD] Error: Invalid Region or Weather ID")
        return 
    end

    -- Update state
    lastRegion = regionName
    lastWeatherId = weatherId

    -- Force the weather in the target region immediately
    core.weather.changeWeather(regionName, record, true)
    print("[BARD] Myth weather asserted in:", regionName)
end

-- Engine hook to re-assert weather when player crosses cell/region boundaries
local function onCellChange()
    if lastRegion and lastWeatherId ~= nil then
        local record = weatherRecords[lastWeatherId]
        if record then
            -- Re-force the weather instantly to prevent regional defaults from taking over
            core.weather.changeWeather(lastRegion, record, true)
        end
    end
end

return {
    eventHandlers = {
        ApplyBardicEffect = onApplyEffect,
        onCellChange = onCellChange, -- Built-in v0.50 Global Engine Hook
    }
}