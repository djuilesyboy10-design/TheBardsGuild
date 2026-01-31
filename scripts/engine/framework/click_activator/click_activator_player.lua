-- Click Activator Player Script
-- Player-side component for universal click activation
-- Handles choice menu UI and vanilla dialogue triggering

local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local I = require("openmw.interfaces")

-- Import choice menu utilities
local choiceMenu = require("scripts.engine.framework.click_activator.choice_menu")

return {
    eventHandlers = {
        ShowInteractionChoice = function(e)
            print("[CLICK_ACTIVATOR_PLAYER] Showing interaction choice for: " .. tostring(e.npc))
            
            -- Show the choice menu with UI (available in player script)
            choiceMenu.showInteractionChoice(e.npc, e.class, e.activatorData, require("openmw.self"))
        end,
        
        TriggerVanillaDialogue = function(e)
            print("[CLICK_ACTIVATOR_PLAYER] Triggering vanilla dialogue for: " .. tostring(e.npc))
            
            -- For now, we'll just print a message
            -- In a full implementation, we'd need to find a way to trigger the vanilla dialogue
            -- This might require using OpenMW's built-in dialogue system or temporarily disabling our handler
            
            print("[CLICK_ACTIVATOR_PLAYER] Vanilla dialogue feature coming soon!")
            print("[CLICK_ACTIVATOR_PLAYER] For now, you can press the activate key again on the NPC")
        end
    }
}
