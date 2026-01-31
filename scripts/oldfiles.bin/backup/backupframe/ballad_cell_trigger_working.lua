-- GLOBAL: scripts/engine/ballad_cell_trigger.lua

local world = require("openmw.world")

local TARGET_CELL = "Balmora, Lucky Lockup"
local firedInCell = false

return {
    engineHandlers = {
        onUpdate = function()
            local player = world.players[1]
            if not player then return end

            local cell = player.cell
            if not cell then return end

            if cell.name ~= TARGET_CELL then
                firedInCell = false
                return
            end

            if firedInCell then return end

            print("[BARD][CELL] Entered Lucky Lockup, firing Jiub Ballad event")

            -- ✅ MATCH TRAVEL SYSTEM
            player:sendEvent("Bard_JiubBallad_Event")

            firedInCell = true
        end
    }
}
