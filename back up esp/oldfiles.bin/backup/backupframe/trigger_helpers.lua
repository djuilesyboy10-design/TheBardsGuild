-- trigger_helpers.lua
-- Helper functions for universal trigger system
-- Part 2 of 3: Utility Functions

local world = require("openmw.world")

return {
    checkCellCondition = function(cellName)
        local player = world.players[1]
        if not player then return false end
        return player.cell.name == cellName
    end,
    
    checkSpellCondition = function(spellId)
        local player = world.players[1]
        if not player then return false end
        
        local types = require("openmw.types")
        for _, spell in ipairs(types.Actor.spells(player)) do
            if spell.id == spellId then
                return true
            end
        end
        return false
    end,
    
    fireTrigger = function(trigger)
        print("[TRIGGER] Firing:", trigger.name)
        local player = world.players[1]
        if player then
            player:sendEvent(trigger.event)
        end
        trigger.fired = true
    end
}
