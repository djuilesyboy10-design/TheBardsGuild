local TARGET_CELL = "Sadrith Mora, Dirty Muriel's Cornerclub"
local EVENT_NAME  = "Bard_JiubBallad_Event"
local REQUIRED_QUEST = "JMCG_Fara"
local REQUIRED_STAGE = 10

------------------------------------------------------------
-- GLOBAL STORAGE (key–value, NOT table)
------------------------------------------------------------
local globalData = storage.globalSection("Bard_JiubBallad")

------------------------------------------------------------
-- ENGINE HANDLER
------------------------------------------------------------
return {
    engineHandlers = {
        onUpdate = function()
            -- hard one-shot
            if globalData:get("fired") then return end

            local player = world.players[1]
            if not player then return end

            -- Quest stage check
            local questStage = core.getQuestStage(REQUIRED_QUEST)
            if questStage < REQUIRED_STAGE then return end

            local cell = player.cell
            if not cell or cell.name ~= TARGET_CELL then return end

            print("[BARD][CELL] Global Jiub Ballad trigger fired")

            player:sendEvent(EVENT_NAME)

            -- permanently disable
            globalData:set("fired", true)
        end
    }
}