-- Special Titles Player Script
-- Clean implementation using shared universal framework
-- Tracks earned titles that unlock reality editing abilities

local core = require("openmw.core")
local input = require("openmw.input")
local storage = require("openmw.storage")
local async = require("openmw.async")
local I = require("openmw.interfaces")
local ui = require("openmw.ui")
local util = require("openmw.util")

-- State management
local viewState = {
    selectedTitle = nil,
    allTitles = {},  -- All titles with unlock status
    earnedCount = 0,
    menuWidget = nil,
    isOpen = false
}

-- Get settings storage group
local titlesGroup = storage.playerSection("SettingsSpecialTitles")

-- Subscribe to settings changes
titlesGroup:subscribe(async:callback(function(_, key)
    local titlesSettings = {
        enableTitlesSystem = titlesGroup:get("enableTitlesSystem") ~= false,
        titlesMenuKey = titlesGroup:get("titlesMenuKey") or 79  -- O key
    }
    core.sendGlobalEvent("SpecialTitles_SettingsChanged", titlesSettings)
end))

-- Initialize special titles system
local function initialize()
    print("[SPECIAL TITLES PLAYER] Initializing Special Titles UI system...")
    core.sendGlobalEvent("JMCG_RequestSpecialTitlesData", {})
end

-- Forward declaration
local showSpecialTitlesUI

-- Event handlers
local eventHandlers = {
    -- Receive title data from global script
    JMCG_SetSpecialTitlesData = function(data)
        print("[SPECIAL TITLES PLAYER] Received titles data")
        
        if data and data.allTitles then
            viewState.allTitles = data.allTitles
            viewState.earnedCount = data.earnedCount or 0
            print("[SPECIAL TITLES PLAYER] Loaded " .. #data.allTitles .. " titles (" .. viewState.earnedCount .. " unlocked)")
            
            -- Refresh UI if titles menu is currently open
            if viewState.isOpen and viewState.menuWidget then
                print("[SPECIAL TITLES PLAYER] Refreshing titles UI with new data...")
                viewState.menuWidget:destroy()
                viewState.menuWidget = nil
                showSpecialTitlesUI()
            end
        end
    end,
    
    -- Show Special Titles UI
    JMCG_ShowSpecialTitlesUI = function(data)
        print("[SPECIAL TITLES PLAYER] Showing Special Titles UI")
        
        if data and data.allTitles then
            viewState.allTitles = data.allTitles
            viewState.earnedCount = data.earnedCount or 0
        end
        
        showSpecialTitlesUI()
    end
}

-- Main UI function using shared universal UI components
showSpecialTitlesUI = function()
    print("[SPECIAL TITLES PLAYER] Creating Special Titles UI using universal framework!")
    
    -- Import shared UI components
    local uiComponents = require('scripts.engine.framework.universal_menu.universal_ui_components')
    local async = require('openmw.async')
    
    -- Build left panel content manually to handle locked/unlocked states
    local leftContent = ui.content {
        {
            type = ui.TYPE.Flex,
            props = { horizontal = false },
            content = ui.content {}
        }
    }
    
    -- Add all titles with visual distinction for locked ones
    for i, title in ipairs(viewState.allTitles) do
        local isUnlocked = title.unlocked
        local displayName = isUnlocked and ("• " .. title.name) or "• [Locked]"
        local textColor = isUnlocked and util.color.rgb(0.8, 0.8, 0.8) or util.color.rgb(0.4, 0.4, 0.4) -- Gray for locked
        
        -- Highlight selected if unlocked
        if isUnlocked and viewState.selectedTitle and viewState.selectedTitle.id == title.id then
            textColor = util.color.rgb(1.0, 1.0, 0.6) -- Yellow highlight
        end
        
        local titleEntry = {
            type = ui.TYPE.Text,
            props = {
                text = displayName,
                textSize = 14,
                textColor = textColor,
                paddingTop = 5,
                paddingBottom = 5,
                relativeSize = util.vector2(1, 0)
            }
        }
        
        -- Only add click handler for unlocked titles
        if isUnlocked then
            titleEntry.events = {
                mouseClick = async:callback(function(e)
                    print("[SPECIAL TITLES PLAYER] Selected title: " .. title.name)
                    viewState.selectedTitle = title
                    -- Destroy old UI and recreate
                    if viewState.menuWidget then 
                        viewState.menuWidget:destroy()
                        viewState.menuWidget = nil
                    end
                    showSpecialTitlesUI()
                end)
            }
        end
        
        table.insert(leftContent[1].content, titleEntry)
    end
    
    -- Create right panel with selected title content
    local rightContentText = ""
    if viewState.selectedTitle then
        if viewState.selectedTitle.unlocked then
            rightContentText = viewState.selectedTitle.description
        else
            rightContentText = "[Complete the required quest to unlock this title]"
        end
    else
        rightContentText = "Select a title from the left to view its description.\n\nUnlocked: " .. viewState.earnedCount .. "/" .. #viewState.allTitles
    end
    
    local rightContent = uiComponents.createRightPanel(
        uiComponents.processTextContent(rightContentText)
    )
    
    -- Create main layout
    local windowLayout = uiComponents.createMainLayout("Chronicle of Titles", leftContent, rightContent)
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
        print("[SPECIAL TITLES PLAYER] Requesting fresh titles data...")
        core.sendGlobalEvent("JMCG_RequestSpecialTitlesData", {})
        showSpecialTitlesUI()
        viewState.isOpen = true
        I.UI.setMode('Interface', { windows = {} })
    end
end

-- Handle key presses
local function handleKeyPress(key)
    -- Check if system is enabled
    local enabled = titlesGroup:get("enableTitlesSystem") ~= false
    if not enabled then
        return
    end
    
    -- Check for titles menu key
    local titlesKey = titlesGroup:get("titlesMenuKey") or 80  -- P key
    if key.code == titlesKey then
        print("[SPECIAL TITLES PLAYER] Titles key pressed")
        toggleMenu()
    end
    
    -- Check for ESC key to close UI (like Completionist)
    if key.code == 1 and viewState.isOpen then  -- ESC key
        toggleMenu()
    end
end

-- Send initial settings on startup
local function sendInitialSettings()
    local titlesSettings = {
        enableTitlesSystem = titlesGroup:get("enableTitlesSystem") ~= false,
        titlesMenuKey = titlesGroup:get("titlesMenuKey") or 80  -- P key
    }
    
    core.sendGlobalEvent("SpecialTitles_SettingsChanged", titlesSettings)
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
