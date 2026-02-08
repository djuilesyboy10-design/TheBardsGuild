-- Spell Activator Player Handler
-- Handles custom spell effects on player side
-- Part of the Universal Activator Framework

return {
    eventHandlers = {
        GardenSpellActivate = function(data)
            print("[SPELL_ACTIVATOR_PLAYER] Activating Garden spell effect")
            
            -- Send travel event to Universal Travel system
            require("openmw.core").sendGlobalEvent("UT_Travel", {
                network = "garden_spell",
                destination = data.activatorData.destination
            })
            
            -- Show immersive message
            require("openmw.world").players[1]:sendEvent("UT_ShowMessage", 
                "The Garden spell dissolves reality around you, pulling you into The Lost Archive...")
        end
    }
}
