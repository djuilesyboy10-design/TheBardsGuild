-- GLOBAL: scripts/engine/ballad_gate.lua
-- LOCKED VERSION — GLOBAL SAFE

local I = require("openmw.interfaces")

return {
    interfaceName = "BalladGate",

    interface = {
        isJiubBalladAvailable = function()
            local stage = I.Journal.getJournalIndex("JMCG_Ballad")
            return stage == 100
        end
    }
}