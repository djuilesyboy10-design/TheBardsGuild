-- Potion Activator Player Handler
-- Handles custom potion effects on player side
-- Part of the Universal Activator Framework

return {
    eventHandlers = {
        HistCellPotionActivate = function(data)
            print("[POTION_ACTIVATOR_PLAYER] Activating Hist Cell potion effect")
            
            -- Send travel event to Universal Travel system
            require("openmw.core").sendGlobalEvent("UT_Travel", {
                network = "hist_cell",
                destination = data.activatorData.destination
            })
            
            -- Show immersive message
            require("openmw.world").players[1]:sendEvent("UT_ShowMessage", 
                "Your consciousness joins the Hist's collective memory...")
        end
    }
}
