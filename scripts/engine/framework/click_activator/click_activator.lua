-- Universal Click Activator
-- Handles click-based activation for NPCs
-- Replaces range-based detection with direct player interaction
-- Part of the Universal Activator Framework

local I = require('openmw.interfaces')
local types = require('openmw.types')
local world = require('openmw.world')

-- Import configuration only (UI not available in global script)
local clickConfig = require('scripts.engine.framework.click_activator.click_activator_config')

-- Universal NPC Click Activation Handler
I.Activation.addHandlerForType(types.NPC, function(npc, actor)
    -- Safety check: ensure npc is valid
    if not npc then
        print("[CLICK_ACTIVATOR] Invalid NPC object, allowing default behavior")
        return true
    end
    
    print("[CLICK_ACTIVATOR] NPC clicked: " .. tostring(npc.recordId))
    
    -- Only handle player activations
    local player = world.player or world.players[1]
    if not player or actor ~= player then
        print("[CLICK_ACTIVATOR] Not player activation, allowing default behavior")
        return true
    end
    
    -- Get NPC class with safety check
    local npcRecord = types.NPC.record(npc)
    if not npcRecord then
        print("[CLICK_ACTIVATOR] Cannot get NPC record, allowing default behavior")
        return true
    end
    
    local npcClass = npcRecord.class
    print("[CLICK_ACTIVATOR] NPC Class: " .. tostring(npcClass))
    
    -- DEBUG: Log faction and rank information
    if npcRecord.faction then
        print("[CLICK_ACTIVATOR] NPC Faction: " .. tostring(npcRecord.faction))
    end
    if npcRecord.rank then
        print("[CLICK_ACTIVATOR] NPC Rank: " .. tostring(npcRecord.rank))
    end
    if npcRecord.race then
        print("[CLICK_ACTIVATOR] NPC Race: " .. tostring(npcRecord.race))
    end
    
    -- Check if this NPC class has click activation configured
    local activatorData = clickConfig.getActivatorData(npcClass)
    
        
    -- Only show choice menu if this NPC has custom content
    if activatorData then
        print("[CLICK_ACTIVATOR] Custom content found for " .. npcClass .. ", showing choice menu")
        -- Send choice menu event to player script (UI available there)
        actor:sendEvent("ShowInteractionChoice", {
            npc = npc,
            class = npcClass,
            activatorData = activatorData
        })
        -- Return false to prevent default behavior when we have custom content
        return false
    else
        print("[CLICK_ACTIVATOR] No custom content for " .. npcClass .. ", allowing vanilla dialogue")
        -- Allow vanilla dialogue for NPCs without custom content
        return true
    end
end)

print("[CLICK_ACTIVATOR] Universal click activator loaded")

return {
    -- No engineHandlers needed - registration happens immediately
    -- This is more efficient and follows the herbalism pattern
}
