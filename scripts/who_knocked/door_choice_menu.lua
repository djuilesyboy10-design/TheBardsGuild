-- Door Choice Menu for Knock-Knock Interactions
-- Provides choice between knock, lockpick, and cancel
-- Part of the Universal Activator Framework

local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local I = require("openmw.interfaces")
local auxUi = require("openmw_aux.ui")

local doorChoiceMenu = {}

-- Show the door interaction choice menu
function doorChoiceMenu.showDoorChoice(door, actor)
    local root
    
    -- Create menu choices
    local choices = {}
    
    -- Lockpick option
    table.insert(choices, {
        text = "[Lockpick]",
        color = util.color.rgb(0.7, 0.85, 1.0),  -- Light blue
        description = "Try to pick the lock with your skills",
        action = function()
            doorChoiceMenu.closeMenu(root)
            -- Send lockpick event back to player script
            actor:sendEvent("UA_ExecuteLockpick", {door = door})
        end
    })
    
    -- Dialogue option
    table.insert(choices, {
        text = "[Persuade]",
        color = util.color.rgb(0.85, 0.7, 1.0),  -- Light purple
        description = "Try to persuade them to open the door",
        action = function()
            doorChoiceMenu.closeMenu(root)
            -- Send dialogue event back to player script
            actor:sendEvent("UA_ExecuteDialogue", {door = door})
        end
    })
    
    -- Cancel option
    table.insert(choices, {
        text = "[Cancel]",
        color = util.color.rgb(0.7, 0.7, 0.7),  -- Light gray
        description = "Cancel interaction and walk away",
        action = function()
            doorChoiceMenu.closeMenu(root)
            -- Do nothing, just close the menu
        end
    })
    
    -- Build UI content
    local content = doorChoiceMenu.buildMenuContent(door, choices)
    
    -- Create the menu window
    root = ui.create {
        layer = "Windows",
        type = ui.TYPE.Container,
        template = I.MWUI.templates.boxSolid,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.5, 0.5),
            relativeSize = util.vector2(0.6, 0.4),  -- Smaller for door menu
        },
        content = ui.content {
            {
                type = ui.TYPE.Flex,
                props = {
                    relativeSize = util.vector2(1, 1),
                    horizontal = false,
                    align = ui.ALIGNMENT.Center,
                    padding = 24,
                    backgroundColor = util.color.rgba(0.0, 0.0, 0.0, 1.0),
                },
                content = ui.content(content)
            }
        }
    }
    
    I.UI.setMode("Interface", { windows = {} })
    
    return root
end

-- Build the menu content UI
function doorChoiceMenu.buildMenuContent(door, choices)
    local content = {}
    
    -- Title
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = "knock knock",
            textSize = 24,
            textColor = util.color.rgb(0.9, 0.8, 0.6),
            textAlign = ui.ALIGNMENT.Center,
            paddingBottom = 16,
        }
    })
    
    -- Choices
    for i, choice in ipairs(choices) do
        -- Choice button
        table.insert(content, {
            type = ui.TYPE.Container,
            props = {
                paddingTop = 8,
                paddingBottom = 8,
            },
            content = ui.content({
                {
                    type = ui.TYPE.Container,
                    template = I.MWUI.templates.pane,
                    props = {
                        relativeSize = util.vector2(1, 1),
                        padding = 16,
                    },
                    events = {
                        mouseClick = async:callback(choice.action)
                    },
                    content = ui.content({
                        {
                            type = ui.TYPE.Text,
                            props = {
                                text = choice.text,
                                textSize = 18,
                                textColor = choice.color or util.color.rgb(0.9, 0.9, 0.9),
                                textAlign = ui.ALIGNMENT.Center,
                            }
                        }
                    })
                }
            })
        })
        
        -- Spacer between choices
        if i < #choices then
            table.insert(content, {
                type = ui.TYPE.Container,
                props = { paddingTop = 12 },
                content = ui.content({})
            })
        end
    end
    
    return content
end

-- Close the menu
function doorChoiceMenu.closeMenu(root)
    if root then
        auxUi.deepDestroy(root)
        root = nil
    end
    I.UI.setMode(nil)
end

return doorChoiceMenu
