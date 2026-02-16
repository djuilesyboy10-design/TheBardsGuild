-- Misc Activator Player Handler
-- Handles custom misc item effects on player side
-- Part of the Universal Activator Framework

return {
    eventHandlers = {
        JMCG_TuningForkActivate = function(data)
            print("[MISC_ACTIVATOR_PLAYER] Activating Devil's Tuning Fork")
            
            -- Send event to Universal Travel system
            require("openmw.core").sendGlobalEvent("UT_Travel_Menu", {
                item = data.item,
                activatorData = data.activatorData
            })
        end,
        
        JMCG_PiedPiperActivate = function(data)
            print("[MISC_ACTIVATOR_PLAYER] Activating Pied Piper Bone Flute")
            
            -- Immersive message
            require("openmw.ui").showMessage("The bone flute emits a discordant note that makes the air shimmer...")
            
            -- Trigger temporal effect event
            require("openmw.core").sendGlobalEvent("JMCG_TemporalStutter", {
                intensity = 1.0
            })
        end
    }
}
