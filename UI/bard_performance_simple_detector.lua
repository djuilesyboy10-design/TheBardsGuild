-- bard_performance_simple_detector.lua
-- Simple player-side detector for dummy spell

print(">>> BARD PERFORMANCE SIMPLE DETECTOR INITIALIZED <<<")

local simpleDetector = {
    -- Track last check time
    lastCheckTime = 0,
    checkInterval = 0.5, -- Check every 0.5 seconds
    
    -- Check for dummy spell on player
    checkForPerformanceSpell = function()
        local types = require('openmw.types')
        
        -- Check for dummy spell
        for _, spell in pairs(types.Actor.spells(self)) do
            if spell.id == "bard_performance_dummy" then
                print("[Simple Detector] Performance dummy spell detected, showing menu...")
                
                -- Remove the spell
                types.Actor.spells(self):remove("bard_performance_dummy")
                
                -- Show the menu directly
                if _G.UniversalMenu then
                    -- Find nearest NPC
                    local nearby = require('openmw.nearby')
                    local closestNPC = nil
                    local closestDistance = 1000
                    
                    for _, actor in pairs(nearby.actors) do
                        if actor.type == types.NPC then
                            local distance = (actor.position - self.position):length()
                            if distance < closestDistance then
                                closestDistance = distance
                                closestNPC = actor
                            end
                        end
                    end
                    
                    if closestNPC then
                        _G.UniversalMenu.createMenu(closestNPC)
                        print("[Simple Detector] Menu shown for:", closestNPC.recordId)
                    else
                        print("[Simple Detector] No NPC found for menu")
                    end
                else
                    print("[Simple Detector] UniversalMenu not available")
                end
                
                return true
            end
        end
        return false
    end,
    
    -- On frame handler
    onFrame = function(dt)
        simpleDetector.lastCheckTime = simpleDetector.lastCheckTime + dt
        if simpleDetector.lastCheckTime >= simpleDetector.checkInterval then
            simpleDetector.checkForPerformanceSpell()
            simpleDetector.lastCheckTime = 0
        end
    end
}

print("[Simple Detector] System ready, checking every 0.5 seconds")

-- Register for onFrame events
local lastCheckTime = 0
local checkInterval = 0.5

return {
    engineHandlers = {
        onFrame = function(dt)
            lastCheckTime = lastCheckTime + dt
            if lastCheckTime >= checkInterval then
                -- Get player object in engineHandlers context
                local nearby = require('openmw.nearby')
                local types = require('openmw.types')
                
                local players = nearby.getActorsByType(types.Player)
                if #players > 0 then
                    local player = players[1]
                    
                    -- Check for dummy spell
                    for _, spell in pairs(types.Actor.spells(player)) do
                        if spell.id == "bard_performance_dummy" then
                            print("[Simple Detector] Performance dummy spell detected, showing menu...")
                            
                            -- Remove the spell
                            types.Actor.spells(player):remove("bard_performance_dummy")
                            
                            -- Show the menu directly
                            if _G.UniversalMenu then
                                -- Find nearest NPC
                                local closestNPC = nil
                                local closestDistance = 1000
                                
                                for _, actor in pairs(nearby.actors) do
                                    if actor.type == types.NPC then
                                        local distance = (actor.position - player.position):length()
                                        if distance < closestDistance then
                                            closestDistance = distance
                                            closestNPC = actor
                                        end
                                    end
                                end
                                
                                if closestNPC then
                                    _G.UniversalMenu.createMenu(closestNPC)
                                    print("[Simple Detector] Menu shown for:", closestNPC.recordId)
                                else
                                    print("[Simple Detector] No NPC found for menu")
                                end
                            else
                                print("[Simple Detector] UniversalMenu not available")
                            end
                            
                            return true
                        end
                    end
                end
                
                lastCheckTime = 0
            end
        end
    }
}
