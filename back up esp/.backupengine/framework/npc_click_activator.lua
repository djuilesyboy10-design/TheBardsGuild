-- NPC Click Activator Framework
-- Handles click-based activation for NPCs
-- Replaces radius-based detection with direct player interaction

local Activation = require('openmw.interfaces').Activation
local types = require('openmw.types')
local world = require('openmw.world')

-- NPC Click Activation Handler
local function handleNPCClick(npc, actor)
    print("[NPC_CLICK_ACTIVATOR] handleNPCClick called")
    print("[NPC_CLICK_ACTIVATOR] NPC: " .. tostring(npc))
    print("[NPC_CLICK_ACTIVATOR] Actor: " .. tostring(actor))
    
    -- Only handle player activations
    if actor ~= world.players[1] then
        print("[NPC_CLICK_ACTIVATOR] Not player, returning true")
        return true -- Let other handlers process
    end
    
    -- Get NPC class
    local npcClass = types.NPC.record(npc).class
    print("[NPC_CLICK_ACTIVATOR] NPC Class: " .. tostring(npcClass))
    
    -- Handle merchant class activation
    if npcClass == "trader service" then
        print("[NPC_CLICK_ACTIVATOR] Found merchant, firing MerchantClassShowMenu event")
        -- Fire the existing merchant event - no changes to existing systems!
        actor:sendEvent("MerchantClassShowMenu", {
            npc = npc,
            class = npcClass
        })
        return false -- Skip default behavior
    end
    
    -- Let default behavior continue for other NPCs
    print("[NPC_CLICK_ACTIVATOR] Not merchant, returning true")
    return true
end

-- Register the NPC click handler
return {
    engineHandlers = {
        onActivate = function()
            print("[NPC_CLICK_ACTIVATOR] Registering NPC click handler")
            Activation.addHandlerForType(types.NPC, handleNPCClick)
        end
    }
}
