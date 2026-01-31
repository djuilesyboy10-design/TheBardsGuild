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
    
    checkNPCClassCondition = function(npcClass, radius)
        local types = require("openmw.types")
        local player = world.players[1]
        
        if not player then 
            print("[NPC_CLASS] No player found")
            return false, nil 
        end
        
        radius = radius or 200 -- Default 200 units
        
        print("[NPC_CLASS] Checking for", npcClass, "within", radius, "units")
        print("[NPC_CLASS] Player position:", player.position)
        
        local actorCount = 0
        for _, actor in pairs(world.activeActors) do
            actorCount = actorCount + 1
            if actor.type == types.NPC then
                local distance = (actor.position - player.position):length()
                
                -- Try to get NPC class from record
                local className = nil
                local record = types.NPC.record(actor.recordId)
                
                if record and record.class then
                    className = record.class
                elseif actor.recordId then
                    className = actor.recordId
                end
                
                print("[NPC_CLASS] Found NPC:", actor.recordId, "Class:", className, "Distance:", distance)
                
                if distance <= radius then
                    if className and (className == npcClass or string.find(string.lower(className), string.lower(npcClass))) then
                        print("[NPC_CLASS] FOUND MATCH!", className, "within", radius, "units")
                        return true, actor
                    end
                end
            end
        end
        
        print("[NPC_CLASS] Checked", actorCount, "actors, no", npcClass, "found")
        return false, nil
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
