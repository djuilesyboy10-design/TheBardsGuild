-- =============================================================================
-- UNIVERSAL REPUTATION SYSTEM - PLAYER SCRIPT
-- =============================================================================
-- Player-side UI and testing interface for reputation system
-- =============================================================================

local core = require("openmw.core")
local ui = require("openmw.ui")
local self = require("openmw.self")

local MOD_ID = "UniversalReputation"

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

local function msg(message)
    print("[" .. MOD_ID .. " Player] " .. message)
end

-- Make this function globally accessible for console/Lua mode
local function showReputationStatus()
    -- Request current reputation from global script
    core.sendGlobalEvent("Reputation_GetReputation")
end

-- =============================================================================
-- EVENT HANDLERS
-- =============================================================================

local function onReputationResponse(data)
    if not data then return end
    
    -- Show reputation status
    local message = string.format(
        "Reputation: %s\nPoints: %d\nCrimes: %d\nHeroic Acts: %d",
        data.level,
        data.points,
        data.crimeCount,
        data.heroicCount
    )
    
    ui.showMessage(message)
    msg("Reputation status: " .. data.level .. " (" .. data.points .. " points)")
end

local function onReputationEffectsApplied(data)
    if not data then return end
    
    ui.showMessage("Reputation effects applied: " .. data.level)
    msg("Reputation effects applied for: " .. data.level)
end

-- =============================================================================
-- CONSOLE COMMANDS FOR TESTING
-- =============================================================================

-- Create global functions for console testing
rep_status = function()
    showReputationStatus()
end

rep_test_crime = function(crimeType)
    core.sendGlobalEvent("Reputation_CrimeEvent", {
        type = crimeType or "force_lock",
        method = "test"
    })
    ui.showMessage("Test crime committed: " .. (crimeType or "force_lock"))
end

rep_test_heroic = function(actionType)
    core.sendGlobalEvent("Reputation_HeroicEvent", {
        type = actionTypes or "help_npc"
    })
    ui.showMessage("Test heroic action: " .. (actionType or "help_npc"))
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

local function initialize()
    msg("Initializing Universal Reputation Player Component")
    
    -- Show initial status
    showReputationStatus()
    
    msg("Universal Reputation Player Component initialized")
    msg("Commands: rep_status, rep_test_crime(type), rep_test_heroic(action)")
end

-- =============================================================================
-- ENGINE HANDLERS
-- =============================================================================

-- Register global functions for console/Lua mode access
_G.showReputationStatus = showReputationStatus

return {
    engineHandlers = {
        onLoad = function()
            initialize()
            msg("Universal Reputation Player Component loaded")
        end,
        
        onConsoleCommand = function(cmd)
            if cmd == "rep_status" then
                showReputationStatus()
                return true
            elseif cmd == "rep_test_crime" then
                -- This would need parameters, for now just show usage
                msg("Usage: rep_test_crime(type) - Available types: force_lock, pick_lock, theft")
                return true
            elseif cmd == "rep_test_heroic" then
                msg("Usage: rep_test_heroic(action) - Available actions: rescue, donation, help")
                return true
            end
            return false
        end
    },
    
    eventHandlers = {
        Reputation_Response = onReputationResponse,
        Reputation_EffectsApplied = onReputationEffectsApplied
    }
}
