local world = require('openmw.world')
local util = require('openmw.util')
local I = require('openmw.interfaces')
local types = require('openmw.types')

local function tp(cell, pos)
    for _, player in ipairs(world.players) do
        -- Explicitly using the full string to force interior cell loading
        player:teleport(cell, pos)
    end
end

I.Activation.addHandlerForType(types.Container, function(obj, actor)
    if obj.recordId == "test_lua_container_01" then
        actor:sendEvent("MyTravel_ShowMenuUI")
        return false
    end
end)

return {
    eventHandlers = {
        MyTravel_Propylon_Andasreth   = function() tp("Andasreth, Propylon Chamber",   util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Berandas    = function() tp("Berandas, Propylon Chamber",    util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Falasmaryon = function() tp("Falasmaryon, Propylon Chamber", util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Falensarano = function() tp("Falensarano, Propylon Chamber", util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Hlormaren   = function() tp("Hlormaren, Propylon Chamber",   util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Indoranyon  = function() tp("Indoranyon, Propylon Chamber",  util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Marandus    = function() tp("Marandus, Propylon Chamber",    util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Rotheran    = function() tp("Rotheran, Propylon Chamber",    util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Telasero    = function() tp("Telasero, Propylon Chamber",    util.vector3(4096, 4096, 160)) end,
        MyTravel_Propylon_Valenvaryon = function() tp("Valenvaryon, Propylon Chamber", util.vector3(4096, 4096, 160)) end,
    }
}