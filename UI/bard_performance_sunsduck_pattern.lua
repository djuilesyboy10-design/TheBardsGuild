-- bard_performance_sunsduck_pattern.lua
-- Sunsduck-inspired dialogue integration

local self = require('openmw.self')
local ui = require('openmw.ui')
local types = require('openmw.types')

print(">>> BARD PERFORMANCE SUNSDUCK PATTERN INITIALIZED <<<")

-- Sunsduck-inspired Dialogue Integration
local sunsduckPattern = {
    -- Track dialogue state
    isInDialogue = false,
    currentDialogueTarget = nil,
    
    -- UI Mode Change Handler (Sunsduck pattern)
    onUiModeChanged = function(data)
        print("[Sunsduck Pattern] UI mode changed to:", data.newMode)
        
        if data.newMode == "Dialogue" then
            sunsduckPattern.isInDialogue = true
            print("[Sunsduck Pattern] Entered dialogue mode")
            
            -- Try to identify current dialogue target
            sunsduckPattern.identifyDialogueTarget()
            
        else
            sunsduckPattern.isInDialogue = false
            sunsduckPattern.currentDialogueTarget = nil
            print("[Sunsduck Pattern] Exited dialogue mode")
        end
    end,
    
    -- Identify current dialogue target
    identifyDialogueTarget = function()
        -- Look for nearby NPCs that could be dialogue targets
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
            sunsduckPattern.currentDialogueTarget = closestNPC
            print("[Sunsduck Pattern] Identified dialogue target:", closestNPC.recordId)
            
            -- Check if this is a publican and show our menu
            if _G.UniversalMenu and _G.UniversalMenu.isPublican(closestNPC) then
                print("[Sunsduck Pattern] Publican detected, showing menu...")
                -- Small delay to ensure dialogue is fully loaded
                async:new(100):callback(function()
                    _G.UniversalMenu.createMenu(closestNPC)
                end)
            end
        end
    end,
    
    -- Alternative: Add dialogue option via spell (Sunsduck dummy spell pattern)
    createPerformanceSpell = function()
        -- Create a dummy spell that triggers our menu
        if not types.Magic.records["bard_performance_menu"] then
            -- This would be added via ESP file
            print("[Sunsduck Pattern] Performance spell not found - needs ESP")
        end
    end,
    
    -- Check for performance spell (Sunsduck dummy spell pattern)
    checkForPerformanceSpell = function()
        if sunsduckPattern.isInDialogue then
            for _, spell in pairs(types.Actor.spells(self)) do
                if spell.id == "bard_performance_dummy" then
                    print("[Sunsduck Pattern] Performance dummy spell detected, showing menu...")
                    -- Remove the spell after detection
                    types.Actor.spells(self):remove("bard_performance_dummy")
                    
                    -- Show our universal menu
                    if sunsduckPattern.currentDialogueTarget then
                        _G.UniversalMenu.createMenu(sunsduckPattern.currentDialogueTarget)
                    else
                        -- Fallback: try to find nearest NPC
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
                        end
                    end
                    return true
                end
            end
        end
        return false
    end,
    
    -- Initialize the system
    initialize = function()
        -- Since we can't use Sunsduck's job system, create our own onFrame checker
        print("[Sunsduck Pattern] Creating custom onFrame checker...")
        
        -- Register for UI mode changes using OpenMW's built-in system
        local ui = require('openmw.ui')
        if ui.mode then
            ui.registerMode({
                name = 'BardPerformanceChecker',
                onModeChange = function(newMode, oldMode)
                    sunsduckPattern.onUiModeChanged({newMode = newMode, oldMode = oldMode})
                end
            })
            print("[Sunsduck Pattern] Registered for UI mode changes")
        else
            print("[Sunsduck Pattern] UI mode registration not available")
        end
        
        -- Create our own onFrame checker for dummy spell detection
        local lastCheckTime = 0
        local checkInterval = 0.5 -- Check every 0.5 seconds
        
        self:registerEvent('onFrame', function(dt)
            lastCheckTime = lastCheckTime + dt
            if lastCheckTime >= checkInterval then
                sunsduckPattern.checkForPerformanceSpell()
                lastCheckTime = 0
            end
        end)
        
        print("[Sunsduck Pattern] Custom onFrame checker registered")
    end
}

-- Initialize on load
sunsduckPattern.initialize()

-- Make available globally
_G.BardSunsduckPattern = sunsduckPattern

print("[Sunsduck Pattern] Sunsduck-inspired dialogue integration ready")

return {
    interfaceName = "BardSunsduckPattern",
    interface = sunsduckPattern
}
