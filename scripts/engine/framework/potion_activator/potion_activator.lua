-- Potion Activator Framework
-- Handles custom potion consumption effects
-- Part of the Universal Activator Framework

local I = require('openmw.interfaces')
local types = require('openmw.types')
local world = require('openmw.world')

-- Import configuration
local potionConfig = require('scripts.engine.framework.potion_activator.potion_activator_config')

-- Universal Potion Usage Handler
I.ItemUsage.addHandlerForType(types.Potion, function(potion, actor)
    print("[POTION_ACTIVATOR] === POTION HANDLER CALLED ===")
    print("[POTION_ACTIVATOR] Potion used: " .. tostring(potion.recordId))
    print("[POTION_ACTIVATOR] Actor: " .. tostring(actor))
    print("[POTION_ACTIVATOR] Potion type: " .. tostring(potion.type))
    
    -- Safety check: ensure potion is valid
    if not potion then
        print("[POTION_ACTIVATOR] Invalid potion object, allowing default behavior")
        return true
    end
    
    -- Only handle player activations
    local player = world.player or world.players[1]
    if not player or actor ~= player then
        print("[POTION_ACTIVATOR] Not player activation, allowing default behavior")
        return true
    end
    
    -- Check if this potion has custom activation
    local activatorData = potionConfig.getPotionActivator(potion.recordId)
    print("[POTION_ACTIVATOR] Looking up activator data for: " .. tostring(potion.recordId))
    print("[POTION_ACTIVATOR] Found activator data: " .. tostring(activatorData ~= nil))
    
    if activatorData then
        print("[POTION_ACTIVATOR] Custom content found for " .. potion.recordId .. ", triggering custom effect")
        -- Send custom event to player script (UI available there)
        actor:sendEvent(activatorData.event, {
            potion = potion,
            actor = actor,
            activatorData = activatorData
        })
        -- Return false to prevent default consumption when we have custom content
        return false
    else
        print("[POTION_ACTIVATOR] No custom content for " .. potion.recordId .. ", allowing default consumption")
        -- Allow default potion consumption for potions without custom content
        return true
    end
end)

print("[POTION_ACTIVATOR] Universal potion usage handler loaded")

return {
    -- No engineHandlers needed - registration happens immediately
    -- This follows the click_activator pattern exactly
}
