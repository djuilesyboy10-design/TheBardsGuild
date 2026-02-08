-- Scroll Activator Player Handler
-- Handles UI monitoring and custom scroll effects
-- Part of the Universal Activator Framework

local I = require('openmw.interfaces')
local types = require('openmw.types')
local self = require('openmw.self')
local async = require('openmw.async')

-- Import configuration
local scrollConfig = require('scripts.engine.framework.scroll_activator.scroll_activator_config')

-- Track UI mode changes
local lastUiMode = nil
local monitoring = false

-- Check if UI mode changed and detect book closing
local function checkUiModeChange()
    local currentMode = I.UI.getMode()
    if currentMode ~= lastUiMode then
        print("[SCROLL_ACTIVATOR] Mode changed: " .. tostring(currentMode) .. " (was: " .. tostring(lastUiMode) .. ")")
        
        -- Debug: Show all possible modes we might see
        if currentMode then
            print("[SCROLL_ACTIVATOR] Current mode contains 'book': " .. tostring(string.find(currentMode:lower(), "book") ~= nil))
            print("[SCROLL_ACTIVATOR] Previous mode contains 'book': " .. tostring(lastUiMode and string.find(lastUiMode:lower(), "book") ~= nil))
        end
        
        -- Check if we're transitioning from book mode to something else
        if lastUiMode and (lastUiMode == "Book" or string.find(lastUiMode:lower() or "", "book") or lastUiMode == "Interface") then
            if currentMode ~= lastUiMode then
                print("[SCROLL_ACTIVATOR] Book closed, checking if it was our scroll...")
                
                -- Debug: Check inventory for our scroll
                local inventory = types.Actor.inventory(self)
                print("[SCROLL_ACTIVATOR] Checking inventory for JMCG_Endgame...")
                local scroll = inventory:find("JMCG_Endgame")
                print("[SCROLL_ACTIVATOR] Scroll found: " .. tostring(scroll ~= nil))
                
                if scroll then
                    print("[SCROLL_ACTIVATOR] Our scroll found in inventory, triggering teleport!")
                    
                    -- Get activator data
                    local activatorData = scrollConfig.getScrollActivator("JMCG_Endgame")
                    print("[SCROLL_ACTIVATOR] Activator data found: " .. tostring(activatorData ~= nil))
                    
                    if activatorData then
                        print("[SCROLL_ACTIVATOR] Sending UT_Travel event...")
                        -- Send travel event to Universal Travel system
                        require("openmw.core").sendGlobalEvent("UT_Travel", {
                            network = "endgame_scroll",
                            destination = activatorData.destination
                        })
                        
                        -- Show immersive message
                        self:sendEvent("UT_ShowMessage", 
                            "The last scroll from your native realm dissolves into light, pulling you toward the Dremora Citadel...")
                    else
                        print("[SCROLL_ACTIVATOR] ERROR: No activator data found!")
                    end
                else
                    print("[SCROLL_ACTIVATOR] Not our scroll, ignoring")
                end
            end
        end
        
        lastUiMode = currentMode
    end
    
    -- Continue monitoring
    if monitoring then
        async:newUnsavableGameTimer(0.1, checkUiModeChange)
    end
end

-- Start monitoring UI mode changes
local function startMonitoring()
    if not monitoring then
        monitoring = true
        lastUiMode = I.UI.getMode()
        print("[SCROLL_ACTIVATOR] Starting UI mode monitoring...")
        checkUiModeChange()
    end
end

-- Stop monitoring UI mode changes
local function stopMonitoring()
    monitoring = false
    print("[SCROLL_ACTIVATOR] Stopped UI mode monitoring")
end

return {
    eventHandlers = {
        -- Original scroll activation event (fallback)
        EndgameScrollActivate = function(data)
            print("[SCROLL_ACTIVATOR_PLAYER] === ENDGAME SCROLL ACTIVATE EVENT RECEIVED ===")
            print("[SCROLL_ACTIVATOR_PLAYER] Activating Endgame scroll effect")
            print("[SCROLL_ACTIVATOR_PLAYER] Data: " .. tostring(data))
            print("[SCROLL_ACTIVATOR_PLAYER] Activator data: " .. tostring(data and data.activatorData))
            
            -- Send travel event to Universal Travel system
            require("openmw.core").sendGlobalEvent("UT_Travel", {
                network = "endgame_scroll",
                destination = data.activatorData.destination
            })
            
            -- Show immersive message
            self:sendEvent("UT_ShowMessage", 
                "The last scroll from your native realm dissolves into light, pulling you toward the Dremora Citadel...")
        end
    },
    
    engineHandlers = {
        -- Start monitoring on load
        onLoad = function()
            startMonitoring()
        end
    }
}
