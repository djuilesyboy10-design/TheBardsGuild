-- Scroll Activator Framework
-- Handles custom scroll usage effects
-- Part of the Universal Activator Framework

local I = require('openmw.interfaces')
local types = require('openmw.types')
local world = require('openmw.world')

-- Import configuration
local scrollConfig = require('scripts.engine.framework.scroll_activator.scroll_activator_config')

-- Universal Scroll Usage Handler
I.ItemUsage.addHandlerForType(types.Book, function(scroll, actor)
    print("[SCROLL_ACTIVATOR] === SCROLL HANDLER CALLED ===")
    print("[SCROLL_ACTIVATOR] Scroll used: " .. tostring(scroll.recordId))
    print("[SCROLL_ACTIVATOR] Actor: " .. tostring(actor))
    print("[SCROLL_ACTIVATOR] Scroll type: " .. tostring(scroll.type))
    
    -- Safety check: ensure scroll is valid
    if not scroll then
        print("[SCROLL_ACTIVATOR] Invalid scroll object, allowing default behavior")
        return true
    end
    
    -- Only handle player activations
    local player = world.player or world.players[1]
    if not player or actor ~= player then
        print("[SCROLL_ACTIVATOR] Not player activation, allowing default behavior")
        return true
    end
    
    -- Check if this is our specific scroll
    if scroll.recordId ~= "jmcg_endgame" then
        print("[SCROLL_ACTIVATOR] Not our target scroll (" .. scroll.recordId .. "), allowing default behavior")
        return true
    end
    
    -- Get activator data
    local activatorData = scrollConfig.getScrollActivator("jmcg_endgame")
    print("[SCROLL_ACTIVATOR] Looking up activator data for: jmcg_endgame")
    print("[SCROLL_ACTIVATOR] Found activator data: " .. tostring(activatorData ~= nil))
    
    if activatorData then
        print("[SCROLL_ACTIVATOR] Custom content found for jmcg_endgame, triggering teleport")
        -- Send travel event to Universal Travel system
        require("openmw.core").sendGlobalEvent("UT_Travel", {
            network = "endgame_scroll",
            destination = activatorData.destination
        })
        
        -- Show immersive message to the actor who used the scroll
        if actor.type == types.Actor.PLAYER then
            actor:sendEvent("UT_ShowMessage", 
                "The last scroll from your native realm dissolves into light, pulling you toward the Dremora Citadel...")
        end
        
        -- Return false to prevent normal scroll usage
        return false
    else
        print("[SCROLL_ACTIVATOR] No activator data found for jmcg_endgame, allowing default behavior")
        return true
    end
end)

print("[SCROLL_ACTIVATOR] Universal scroll usage handler loaded")

return {
    -- No engineHandlers needed - registration happens immediately
    -- This follows the potion_activator pattern exactly
}
