-- universal_trigger.lua
-- Main engine for universal trigger system
-- Part 3 of 3: Engine System

local config = require("scripts.engine.framework.trigger_config")
local helpers = require("scripts.engine.framework.trigger_helpers")

return {
    engineHandlers = {
        onUpdate = function()
            for _, trigger in ipairs(config.triggers) do
                if not trigger.fired then
                    local conditionMet = false
                    
                    if trigger.type == "cell" then
                        conditionMet = helpers.checkCellCondition(trigger.cellName)
                    elseif trigger.type == "spell" then
                        conditionMet = helpers.checkSpellCondition(trigger.spellId)
                    elseif trigger.type == "npc_class" then
                        conditionMet, trigger.detectedNPC = helpers.checkNPCClassCondition(trigger.npcClass, trigger.radius)
                    else
                        print("[TRIGGER] Unknown trigger type:", trigger.type)
                    end
                    
                    if conditionMet then
                        helpers.fireTrigger(trigger)
                    end
                end
            end
        end
    }
}
