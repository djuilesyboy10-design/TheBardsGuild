-- bard_performance_global_detector.lua
-- Global script for dummy spell detection

print(">>> BARD PERFORMANCE GLOBAL DETECTOR INITIALIZED <<<")

-- Global Detection System
local globalDetector = {
    -- Track last check time
    lastCheckTime = 0,
    checkInterval = 0.5, -- Check every 0.5 seconds
    
    -- Check for dummy spell on player
    checkForPerformanceSpell = function()
        -- Use core.getActors() instead of nearby
        local nearby = require('openmw.nearby')
        local types = require('openmw.types')
        
        local players = nearby.getActorsByType(types.Player)
        if #players > 0 then
            local player = players[1]
            
            -- Check for dummy spell
            for _, spell in pairs(types.Actor.spells(player)) do
                if spell.id == "bard_performance_dummy" then
                    print("[Global Detector] Performance dummy spell detected, showing menu...")
                    
                    -- Remove the spell
                    types.Actor.spells(player):remove("bard_performance_dummy")
                    
                    -- Show the menu
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
                            print("[Global Detector] Menu shown for:", closestNPC.recordId)
                        else
                            print("[Global Detector] No NPC found for menu")
                        end
                    else
                        print("[Global Detector] UniversalMenu not available")
                    end
                    
                    return true
                end
            end
        end
        return false
    end,
    
    -- On frame handler
    onFrame = function(dt)
        globalDetector.lastCheckTime = globalDetector.lastCheckTime + dt
        if globalDetector.lastCheckTime >= globalDetector.checkInterval then
            globalDetector.checkForPerformanceSpell()
            globalDetector.lastCheckTime = 0
        end
    end,
    
    -- Debug function to manually check
    debugCheck = function()
        print("[Global Detector] Manual debug check...")
        local nearby = require('openmw.nearby')
        local types = require('openmw.types')
        
        local players = nearby.getActorsByType(types.Player)
        if #players > 0 then
            local player = players[1]
            print("[Global Detector] Found player:", player.recordId)
            
            -- Check for dummy spell
            local foundDummy = false
            for _, spell in pairs(types.Actor.spells(player)) do
                if spell.id == "bard_performance_dummy" then
                    print("[Global Detector] FOUND dummy spell!")
                    foundDummy = true
                end
            end
            
            if not foundDummy then
                print("[Global Detector] No dummy spell found")
                -- List all spells for debugging
                print("[Global Detector] Player spells:")
                for _, spell in pairs(types.Actor.spells(player)) do
                    print("  -", spell.id)
                end
            end
        else
            print("[Global Detector] No player found")
        end
    end
}

-- Make debug function globally available
_G.globalDetector = globalDetector

print("[Global Detector] System ready, checking every 0.5 seconds")

-- Register for onFrame events
return {
    eventHandlers = {
        onFrame = globalDetector.onFrame
    }
}
