-- Misc Activator Framework
-- Handles custom usage effects for miscellaneous items
-- Part of the Universal Activator Framework

local I = require('openmw.interfaces')
local types = require('openmw.types')
local world = require('openmw.world')

-- Import configuration
local miscConfig = require('scripts.engine.framework.misc_activator.misc_activator_config')

-- Universal Misc Item Usage Handler
I.ItemUsage.addHandlerForType(types.Miscellaneous, function(item, actor)
    -- Safety check: ensure item is valid
    if not item then
        return true
    end
    
    -- Only handle player activations
    local player = world.player or world.players[1]
    if not player or actor ~= player then
        return true
    end
    
    -- Check if this item has custom activation
    local activatorData = miscConfig.getMiscActivator(item.recordId)
    
    if activatorData then
        print("[MISC_ACTIVATOR] Custom content found for " .. item.recordId .. ", triggering custom effect")
        -- Send custom event to player script
        actor:sendEvent(activatorData.event, {
            item = item,
            actor = actor,
            activatorData = activatorData
        })
        -- Return false to prevent default behavior (like 'cannot use this item')
        return false
    else
        -- Allow default behavior for items without custom content
        return true
    end
end)

print("[MISC_ACTIVATOR] Universal misc item usage handler loaded")

return {}
