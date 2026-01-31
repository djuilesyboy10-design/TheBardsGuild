local TARGET_CELL = "Balmora, Lucky Lockup"
local EVENT_NAME  = "Bard_JiubBallad_Event"
-- Remove all requirements for testing

------------------------------------------------------------
-- GLOBAL STORAGE (key–value, NOT table)
------------------------------------------------------------
local storage = require('openmw.storage')
local globalData = storage.globalSection("Bard_JiubBallad")

------------------------------------------------------------
-- ENGINE HANDLER
------------------------------------------------------------
return {
    engineHandlers = {
        onFrame = function(dt)
            -- hard one-shot
            if globalData:get("fired") then return end

            local player = require('openmw.world').players[1]
            if not player then return end

            -- Remove quest requirements - trigger immediately
            local cell = player.cell
            if not cell or cell.name ~= TARGET_CELL then return end

            print("[BARD][CELL] Global Jiub Ballad trigger fired")

            player:sendEvent(EVENT_NAME)

            -- permanently disable
            globalData:set("fired", true)
        end
    }
}
