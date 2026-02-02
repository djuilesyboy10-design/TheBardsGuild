-- =============================================================================
-- REPUTATION EFFECTS PLAYER
-- Player-side reputation effects display and notifications
-- Shows current reputation effects and handles notifications
-- =============================================================================

local core = require("openmw.core")
local self = require("openmw.self")
local ui = require("openmw.ui")
local MOD_ID = "ReputationEffectsPlayer"

-- S3 Framework Integration
local success, ScriptContext = pcall(function() return require('scripts.s3.scriptContext') end)
local success2, LogMessage = pcall(function() return require('scripts.s3.logmessage') end)
local success3, ProtectedTableModule = pcall(function() return require('scripts.s3.protectedTable') end)

-- Context detection and logging
local context = success and ScriptContext.get() or nil
local msg = core.getGMST or print
local debugLog = success2 and LogMessage or print

-- =============================================================================
-- CURRENT EFFECTS STATE
-- =============================================================================

local currentEffects = {}
local currentReputationLevel = "neutral"
local lastNotificationTime = 0
local notificationCooldown = 5.0 -- 5 seconds between notifications

-- Settings management
local settings = nil
if success3 and ProtectedTableModule and ProtectedTableModule.new then
    settings = ProtectedTableModule.new({
        name = "ReputationEffectsPlayer",
        global = false,
        debug = true,
        default = {
            enableNotifications = true,
            enableUI = true,
            notificationDuration = 3.0,
            showPriceChanges = true,
            showDialogueChanges = true,
            showGuardChanges = true,
            showFactionChanges = true,
            showTravelChanges = true
        }
    })
end

-- =============================================================================
-- UI NOTIFICATION SYSTEM
-- =============================================================================

local function showNotification(message, type, duration)
    if not settings or not settings.enableNotifications then return end
    
    local currentTime = core.getGameTime()
    if currentTime - lastNotificationTime < notificationCooldown then
        return -- Skip notification to avoid spam
    end
    
    lastNotificationTime = currentTime
    duration = duration or (settings.notificationDuration or 3.0)
    
    debugLog("Showing notification: " .. message)
    
    -- Create notification UI
    ui.showMessage({
        message = message,
        type = type or "info",
        duration = duration
    })
end

local function createEffectsSummary()
    if not currentEffects or not settings or not settings.enableUI then return end
    
    local summary = {}
    
    -- Price effects
    if settings.showPriceChanges and currentEffects.priceModifier then
        if currentEffects.priceModifier > 1.0 then
            table.insert(summary, "Shop prices: +" .. math.floor((currentEffects.priceModifier - 1.0) * 100) .. "%")
        elseif currentEffects.priceModifier < 1.0 then
            table.insert(summary, "Shop prices: -" .. math.floor((1.0 - currentEffects.priceModifier) * 100) .. "%")
        end
    end
    
    -- Service effects
    if currentEffects.serviceRefusal and currentEffects.serviceRefusal > 0 then
        table.insert(summary, "Service refusal: " .. math.floor(currentEffects.serviceRefusal * 100) .. "%")
    end
    
    if currentEffects.serviceDiscount and currentEffects.serviceDiscount > 0 then
        table.insert(summary, "Free services: " .. math.floor(currentEffects.serviceDiscount * 100) .. "%")
    end
    
    -- Guard effects
    if settings.showGuardChanges and currentEffects.guardAggression then
        if currentEffects.guardAggression > 1.0 then
            table.insert(summary, "Guards: More aggressive")
        elseif currentEffects.guardAggression < 1.0 then
            table.insert(summary, "Guards: More lenient")
        end
    end
    
    -- Faction effects
    if settings.showFactionChanges and currentEffects.factionStanding and currentEffects.factionStanding ~= 0 then
        local standing = currentEffects.factionStanding > 0 and "+" or ""
        table.insert(summary, "Faction standing: " .. standing .. currentEffects.factionStanding)
    end
    
    -- Special effects
    if currentEffects.travelBonus then
        table.insert(summary, "Travel bonuses")
    end
    
    if currentEffects.housingBonus then
        table.insert(summary, "Housing bonuses")
    end
    
    if currentEffects.specialServices then
        table.insert(summary, "Special services")
    end
    
    return #summary > 0 and table.concat(summary, " | ") or "No active effects"
end

-- =============================================================================
-- EFFECT HANDLERS
-- =============================================================================

local function onEffectsNotification(data)
    if not data or not data.message then return end
    
    showNotification(data.message, data.type or "info", data.duration)
end

local function onReputationEffectsUpdate(data)
    if not data or not data.effects then return end
    
    currentEffects = data.effects
    currentReputationLevel = data.reputationLevel or "neutral"
    
    debugLog("Updated reputation effects for level: " .. currentReputationLevel)
    
    -- Show summary notification
    local summary = createEffectsSummary()
    if summary then
        showNotification("Reputation effects updated: " .. summary, "info", 4.0)
    end
end

local function onReputationLevelChange(data)
    if not data or not data.level then return end
    
    local oldLevel = data.oldLevel or "unknown"
    local newLevel = data.level
    
    debugLog("Reputation level changed: " .. oldLevel .. " → " .. newLevel)
    
    -- Show level change notification
    local levelMessages = {
        criminal = "Criminal - You are feared and hated",
        suspicious = "Suspicious - People distrust you",
        dishonorable = "Dishonorable - Your actions are questionable",
        neutral = "Neutral - You have no notable reputation",
        honorable = "Honorable - You are respected",
        heroic = "Heroic - Your deeds are celebrated",
        legendary = "Legendary - Your name will be remembered"
    }
    
    local message = levelMessages[newLevel] or "Reputation level: " .. newLevel
    showNotification(message, "success", 5.0)
end

-- =============================================================================
-- CONSOLE COMMANDS
-- =============================================================================

local function showReputationEffects()
    if not currentEffects then
        print("No reputation effects currently active")
        return
    end
    
    print("=== Current Reputation Effects ===")
    print("Reputation Level: " .. (currentReputationLevel or "unknown"))
    print()
    
    for key, value in pairs(currentEffects) do
        if type(value) == "boolean" then
            print(key .. ": " .. (value and "Enabled" or "Disabled"))
        elseif type(value) == "number" then
            if key:find("Multiplier") or key:find("Modifier") then
                print(key .. ": " .. string.format("%.2f", value))
            else
                print(key .. ": " .. value)
            end
        end
    end
    
    print()
    print("Summary: " .. (createEffectsSummary() or "No effects"))
end

local function toggleNotifications()
    if not settings then return end
    
    settings.enableNotifications = not settings.enableNotifications
    local status = settings.enableNotifications and "enabled" or "disabled"
    print("Reputation effects notifications " .. status)
    showNotification("Reputation notifications " .. status, "info", 2.0)
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

-- Log initialization with context information
if success then
    msg("[ReputationEffectsPlayer] Reputation Effects Player loaded with S3 Framework support")
    if context then
        local contextNames = {
            [1] = "Local",
            [2] = "Global", 
            [3] = "Player",
            [4] = "Menu"
        }
        msg("[ReputationEffectsPlayer] Running in context: " .. (contextNames[context] or "Unknown"))
    end
else
    msg("[ReputationEffectsPlayer] Reputation Effects Player loaded (S3 Framework not available)")
end

if settings then
    msg("[ReputationEffectsPlayer] Settings management initialized")
    debugLog("[ReputationEffectsPlayer] Initialized with effects display system")
else
    msg("[ReputationEffectsPlayer] Settings management not available")
end

-- Register console commands
if core and core.registerConsoleCommand then
    core.registerConsoleCommand("rep_effects", showReputationEffects, "Show current reputation effects")
    core.registerConsoleCommand("rep_notify", toggleNotifications, "Toggle reputation effect notifications")
end

return {
    eventHandlers = {
        ReputationEffects_Notification = onEffectsNotification,
        ReputationEffects_Update = onReputationEffectsUpdate,
        Reputation_LevelChange = onReputationLevelChange
    }
}
