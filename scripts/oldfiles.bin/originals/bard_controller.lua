-- bard_controller.lua
-- Authoritative Bardic Influence state broadcaster
-- Uses a heartbeat to guarantee UI sync

local I = require('openmw.interfaces')
local self = require('openmw.self')

local HEARTBEAT_INTERVAL = 0.2 -- seconds (safe + cheap)

local lastValue = nil
local timer = 0

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

        onUpdate = function(dt)
            timer = timer + dt
            if timer >= HEARTBEAT_INTERVAL then
                timer = 0
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