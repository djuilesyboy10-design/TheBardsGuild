-- GLOBAL: scripts/engine/ballad_gate.lua

local world = require("openmw.world")
local types = require("openmw.types")

return {
    interfaceName = "BalladGate",

    interface = {
        isJiubBalladAvailable = function()
            local player = world.players[1]
            if not player then return false end

            local stage = types.Player.getJournalIndex(player, "JMCG_Ballad")
            return stage == 100
        end
    }
}