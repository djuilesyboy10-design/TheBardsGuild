local core = require("openmw.core")

local function onCellChange(data)
    if not data or not data.cell or not data.cell.isExterior then
        return
    end

    -- lastRegion / lastWeatherId are your myth truth
    if not lastRegion or lastWeatherId == nil then
        return
    end

    local weatherRecord = weatherRecords[lastWeatherId]
    if not weatherRecord then
        return
    end

    core.weather.changeWeather(lastRegion, weatherRecord)
end

return {
    eventHandlers = {
        CellChanged = onCellChange
    }
}