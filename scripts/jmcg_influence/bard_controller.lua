-- bard_controller.lua
-- Authoritative Bardic Influence state broadcaster
-- Uses quest updates to trigger UI sync (event-driven)

local I = require('openmw.interfaces')
local self = require('openmw.self')

----------------------------------------------------------------
-- Pull value from quest system
----------------------------------------------------------------
local function computeInfluence()
    if not I.JMCG_QuestData then
        return 0
    end
    return I.JMCG_QuestData.getMeterNumber() or 0
end

----------------------------------------------------------------
-- Broadcast (level-triggered, not edge-triggered)
----------------------------------------------------------------
local function broadcast()
    local value = computeInfluence()
    lastValue = value
    self:sendEvent("JMCG_BardInfluence_Update", value)
end

----------------------------------------------------------------
-- Engine hooks
----------------------------------------------------------------
return {
    engineHandlers = {

        onInit = function()
            broadcast() -- immediate sync
        end,

        onLoad = function()
            broadcast() -- load-order safe
        end,

        onQuestUpdate = function(questId, stage)
            -- Only broadcast if it's a Bard-related quest
            if questId and (questId:match("jmcg_") or questId:match("bard_")) then
                broadcast()
            end
        end,
    },

    interfaceName = "JMCG_BardInfluence",
    interface = {
        getCurrent = function()
            return lastValue or computeInfluence()
        end,
    }
}
