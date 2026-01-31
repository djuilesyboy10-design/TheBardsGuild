-- scripts/mytravel/teleport_executor.lua
local world = require("openmw.world")

local function onExecuteTeleport(data)
    print(">>> GLOBAL RECEIVED ID:", data and data.id)

    if not data or not data.id then
        print(">>> ERROR: No teleport ID received")
        return
    end

    for _, player in ipairs(world.players) do
        -- TEMP TEST: always Balmora
        player:teleport("Balmora, Guild of Mages")
    end
end

return {
    eventHandlers = {
        MyTravel_ExecuteTeleport = onExecuteTeleport
    }
}
