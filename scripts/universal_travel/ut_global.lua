-- scripts/universal_travel/ut_global.lua
-- Universal Travel System - Global Handler
-- Single script to handle ALL travel networks

local world = require('openmw.world')
local util = require('openmw.util')
local I = require('openmw.interfaces')
local types = require('openmw.types')
local destinations = require('scripts.universal_travel.ut_destinations')

local function teleportToDestination(network, destinationId)
    local dest = destinations[network] and destinations[network][destinationId]
    if not dest then
        print("UT Error: Invalid destination", network, destinationId)
        return false
    end
    
    for _, player in ipairs(world.players) do
        player:teleport(dest.cell, util.vector3(dest.pos[1], dest.pos[2], dest.pos[3]))
    end
    return true
end

-- Universal activation handler for all travel networks
I.Activation.addHandlerForType(types.Activator, function(obj, actor)
    -- Check all networks for matching activator
    for networkName, networkData in pairs(destinations) do
        for destId, destInfo in pairs(networkData) do
            if obj.recordId == destInfo.activator then
                actor:sendEvent("UT_ShowMenu", networkName)
                return false
            end
        end
    end
    
    return true
end)

-- Universal activation handler for Container-type travel networks (Propylon)
I.Activation.addHandlerForType(types.Container, function(obj, actor)
    -- Check all networks for matching activator
    for networkName, networkData in pairs(destinations) do
        for destId, destInfo in pairs(networkData) do
            if obj.recordId == destInfo.activator then
                actor:sendEvent("UT_ShowMenu", networkName)
                return false
            end
        end
    end
    
    return true
end)

return {
    eventHandlers = {
        -- Universal travel handler
        UT_Travel = function(data)
            if data.network and data.destination then
                teleportToDestination(data.network, data.destination)
            end
        end,
        
        -- Effect system integration
        UT_EffectTravel = function(data)
            -- For framework effect system integration
            if data.network and data.destination then
                teleportToDestination(data.network, data.destination)
            end
        end
    }
}
