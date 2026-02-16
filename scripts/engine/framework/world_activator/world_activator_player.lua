-- World Activator Player Handler
-- Handles custom world object effects on player side
-- Part of the Universal Activator Framework

local ui = require("openmw.ui")
local core = require("openmw.core")

return {
    eventHandlers = {
        JMCG_ResonancePillarActivate = function(data)
            print("[WORLD_ACTIVATOR_PLAYER] Activating Resonance Pillar")
            ui.showMessage("The pillar vibrates with a frequency that resonates in your marrow.")
            
            -- Trigger global resonance event
            core.sendGlobalEvent("JMCG_ResonanceShift", {
                source = data.object.recordId,
                magnitude = 5
            })
        end,
        
        JMCG_MarginAltarActivate = function(data)
            print("[WORLD_ACTIVATOR_PLAYER] Activating Margin Altar")
            ui.showMessage("The ink on the altar stains your very soul.")
            
            -- Open the Margin choice menu (if implemented)
            -- For now, just a debug print
            print("[WORLD_ACTIVATOR_PLAYER] Margin Altar choice menu coming soon")
        end
    }
}
