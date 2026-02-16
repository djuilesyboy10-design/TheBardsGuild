-- Chronicle Player Script
-- Clean implementation using shared universal framework

local core = require("openmw.core")
local input = require("openmw.input")
local storage = require("openmw.storage")
local async = require("openmw.async")
local I = require("openmw.interfaces")
local ui = require("openmw.ui")
local util = require("openmw.util")

-- State management
local viewState = {
    selectedChronicle = nil,
    unlockedChronicles = {},
    menuWidget = nil,
    isOpen = false
}

-- Get settings storage group
local chronicleGroup = storage.playerSection("SettingsChronicle_Generator")

-- Subscribe to settings changes
chronicleGroup:subscribe(async:callback(function(_, key)
    local chronicleSettings = {
        enableChronicleSystem = chronicleGroup:get("enableChronicleSystem") ~= false,
        chronicleMenuKey = chronicleGroup:get("chronicleMenuKey") or 67  -- C key (consistent)
    }
    core.sendGlobalEvent("ChronicleGenerator_SettingsChanged", chronicleSettings)
end))

-- Initialize chronicle system
local function initialize()
    print("[CHRONICLE PLAYER] Initializing Chronicle Player UI system...")
    core.sendGlobalEvent("JMCG_RequestChronicleData", {})
end

-- Forward declaration
local showChronicleUI

-- Event handlers
local eventHandlers = {
    -- Receive chronicle data from global script
    JMCG_SetChronicleData = function(data)
        print("[CHRONICLE PLAYER] Received chronicle data")
        
        if data and data.unlockedPages then
            viewState.unlockedChronicles = data.unlockedPages
            print("[CHRONICLE PLAYER] Loaded " .. #data.unlockedPages .. " chronicles")
            
            -- Refresh UI if chronicle is currently open
            if viewState.isOpen and viewState.menuWidget then
                print("[CHRONICLE PLAYER] Refreshing chronicle UI with new data...")
                viewState.menuWidget:destroy()
                viewState.menuWidget = nil
                showChronicleUI()
            end
        end
    end,
    
    -- Show Chronicle UI
    JMCG_ShowChronicleUI = function(data)
        print("[CHRONICLE PLAYER] Showing Chronicle UI")
        
        if data and data.unlockedChronicles then
            viewState.unlockedChronicles = data.unlockedChronicles
        end
        
        showChronicleUI()
    end
}

-- Main UI function using shared universal UI components
showChronicleUI = function()
    print("[CHRONICLE PLAYER] Creating Chronicle UI using universal framework!")
    
    -- Import shared UI components
    local uiComponents = require('scripts.engine.framework.universal_menu.universal_ui_components')
    
    -- Create left panel with chronicles
    local leftContent = uiComponents.createLeftPanel(viewState.unlockedChronicles, function(index, chronicle)
        print("[CHRONICLE PLAYER] Selected chronicle: " .. chronicle.title)
        viewState.selectedChronicle = chronicle
        -- Destroy old UI and recreate (like Completionist)
        if viewState.menuWidget then 
            viewState.menuWidget:destroy()
            viewState.menuWidget = nil
        end
        showChronicleUI()
    end, viewState.selectedChronicle and function()
        for i, chronicle in ipairs(viewState.unlockedChronicles) do
            if chronicle.title == viewState.selectedChronicle.title then
                return i
            end
        end
        return nil
    end)
    
    -- Create right panel with selected chronicle content (empty until selected)
    local rightContent = uiComponents.createRightPanel(
        viewState.selectedChronicle and uiComponents.processTextContent(viewState.selectedChronicle.text) or ui.content({})
    )
    
    -- Create main layout following Completionist pattern
    local windowLayout = uiComponents.createMainLayout("", leftContent, rightContent)
    viewState.menuWidget = ui.create(windowLayout)
end

-- Toggle menu function following Completionist pattern
local function toggleMenu()
    if viewState.isOpen then
        if viewState.menuWidget then 
            viewState.menuWidget:destroy()
            viewState.menuWidget = nil
        end
        viewState.isOpen = false
        I.UI.removeMode('Interface')
    else
        -- Request fresh data from global script before showing UI
        print("[CHRONICLE PLAYER] Requesting fresh chronicle data...")
        core.sendGlobalEvent("JMCG_RequestChronicleData", {})
        showChronicleUI()
        viewState.isOpen = true
        I.UI.setMode('Interface', { windows = {} })
    end
end

-- Handle key presses
local function handleKeyPress(key)
    -- Check if system is enabled
    local enabled = chronicleGroup:get("enableChronicleSystem") ~= false
    if not enabled then
        return
    end
    
    -- Check for chronicle menu key
    local chronicleKey = chronicleGroup:get("chronicleMenuKey") or 67
    if key.code == chronicleKey then
        print("[CHRONICLE PLAYER] Chronicle key pressed")
        toggleMenu()
    end
    
    -- Check for ESC key to close UI (like Completionist)
    if key.code == 1 and viewState.isOpen then  -- ESC key
        toggleMenu()
    end
end

-- Send initial settings on startup
local function sendInitialSettings()
    local chronicleSettings = {
        enableChronicleSystem = chronicleGroup:get("enableChronicleSystem") ~= false,
        chronicleMenuKey = chronicleGroup:get("chronicleMenuKey") or 67  -- C key (consistent)
    }
    
    core.sendGlobalEvent("ChronicleGenerator_SettingsChanged", chronicleSettings)
end

-- Send settings immediately
sendInitialSettings()

-- Return the script interface
return {
    engineHandlers = {
        onKeyPress = function(key)
            handleKeyPress(key)
        end,
        onActive = initialize
    },
    eventHandlers = eventHandlers
}
