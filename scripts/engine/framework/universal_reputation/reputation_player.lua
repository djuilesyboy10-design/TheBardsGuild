-- =============================================================================
-- UNIVERSAL REPUTATION SYSTEM - PLAYER SCRIPT
-- =============================================================================
-- Bridges Global reputation logic to the Player HUD and handles testing
-- =============================================================================

local core = require("openmw.core")
local ui = require("openmw.ui")
local self = require("openmw.self")
local reputationUI = require("scripts.engine.framework.universal_reputation.reputation_ui")

local MOD_ID = "UniversalReputation"

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

local function msg(message)
    print("[" .. MOD_ID .. " Player] " .. message)
end

-- Request status from global
local function requestReputationUpdate()
    core.sendGlobalEvent("Reputation_GetReputation")
end

-- =============================================================================
-- EVENT HANDLERS
-- =============================================================================

local function onReputationResponse(data)
    if not data or not data.level then return end
    
    -- Update the dedicated HUD
    reputationUI.update(data.level)
    
    -- Log for developer visibility
    msg(string.format("Reputation Sync: %s (%d points)", data.level, data.points or 0))
end

-- =============================================================================
-- CONSOLE TESTING COMMANDS
-- =============================================================================

-- Accessible via: luap showReputationStatus()
_G.showReputationStatus = requestReputationUpdate

-- =============================================================================
-- ENGINE HANDLERS
-- =============================================================================

return {
    engineHandlers = {
        onLoad = function()
            msg("Player Component Initialized")
            requestReputationUpdate()
        end,
        
        onConsoleCommand = function(cmd)
            if cmd == "rep_status" then
                requestReputationUpdate()
                return true
            end
            return false
        end
    },
    
    eventHandlers = {
        Reputation_Response = onReputationResponse
    }
}
