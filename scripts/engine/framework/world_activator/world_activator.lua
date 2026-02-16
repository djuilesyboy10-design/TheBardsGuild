-- World Activator Framework
-- Handles custom activation for world objects (altars, pillars, etc.)
-- Part of the Universal Activator Framework

local I = require('openmw.interfaces')
local types = require('openmw.types')
local world = require('openmw.world')

-- Import configuration
local worldConfig = require('scripts.engine.framework.world_activator.world_activator_config')

-- Universal World Object Activation Handler
I.Activation.addHandlerForType(types.Activator, function(obj, actor)
    -- Safety check
    if not obj then return true end
    
    -- Only handle player activations
    local player = world.player or world.players[1]
    if not player or actor ~= player then
        return true
    end
    
    -- Check if this object has custom activation
    local activatorData = worldConfig.getWorldActivator(obj.recordId)
    
    if activatorData then
        print("[WORLD_ACTIVATOR] Custom content found for " .. obj.recordId)
        -- Send custom event to player script
        actor:sendEvent(activatorData.event, {
            object = obj,
            activatorData = activatorData
        })
        -- Return false to prevent default behavior
        return false
    end
    
    -- Allow default behavior
    return true
end)

print("[WORLD_ACTIVATOR] Universal world object activator loaded")

return {}
