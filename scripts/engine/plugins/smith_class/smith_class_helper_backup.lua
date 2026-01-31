-- smith_class_helper.lua
-- Helper functions for Smith Class NPC system
-- Interactive conversation system for Smith NPCs

local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local self = require("openmw.self")
local types = require("openmw.types")
local auxUi = require("openmw_aux.ui")  -- Add UI destruction utilities

-- Import the smith content data from separate file
local smithContent = require("scripts.engine.plugins.smith_class.smith_content_data")

local root
local M = {}

-- Clean up any existing UI before showing new content
local function cleanupExistingUI()
    if root then
        auxUi.deepDestroy(root)
        root = nil
    end
    -- Also ensure we're not in any other UI mode
    I.UI.setMode(nil)
end

local function close()
    if root then
        root:destroy()
        root = nil
    end
end

-- UI functions
local function showResult(text)
    -- Use proper UI cleanup
    cleanupExistingUI()

    local loreContent = {}

    for line in string.gmatch(text, "([^\n]*)\n?") do
        if line == "" then
            table.insert(loreContent, {
                type = ui.TYPE.Container,
                props = { paddingTop = 8 },
                content = ui.content({})
            })
        else
            table.insert(loreContent, {
                type = ui.TYPE.Text,
                props = {
                    text = line,
                    textSize = 18,
                    textColor = util.color.rgb(0.9, 0.9, 0.9),
                    textAlign = ui.ALIGNMENT.Start,
                    wrapText = true,
                }
            })
        end
    end

    -- Create the result window
    root = ui.create {
        layer = "Windows",
        type = ui.TYPE.Container,
        template = I.MWUI.templates.boxSolid,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.5, 0.5),
            relativeSize = util.vector2(0.7, 0.6),
        },
        content = ui.content {
            {
                type = ui.TYPE.Flex,
                props = {
                    relativeSize = util.vector2(1, 1),
                    horizontal = false,
                    align = ui.ALIGNMENT.Center,
                    padding = 24,
                    backgroundColor = util.color.rgba(0.05, 0.05, 0.05, 0.98),
                },
                content = ui.content(loreContent)
            }
        }
    }

    I.UI.setMode("Interface", { windows = {} })
end


local function showChoiceMenu()
    -- Use proper UI cleanup
    cleanupExistingUI()

    -- Additional safety check - ensure no other UI is showing
    I.UI.setMode("Interface", { windows = {} })

    local choices = {
        {
            text = "What materials do you work with?",
            action = function()
                close()
                local content = smithContent[2]
                showResult(content.content)
            end
        },
        {
            text = "Tell me about your finest weapons",
            action = function()
                close()
                local content = smithContent[1]
                showResult(content.content)
            end
        },
        {
            text = "Can you improve my equipment?",
            action = function()
                close()
                local content = smithContent[3]
                showResult(content.content)
            end
        },
        {
            text = "What's the secret to good smithing?",
            action = function()
                close()
                local content = smithContent[4]
                showResult(content.content)
            end
        },
        {
            text = "Any advice for an adventurer?",
            action = function()
                close()
                local content = smithContent[5]
                showResult(content.content)
            end
        }
    }

    local content = {}
    
    -- Title
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = "Smith Dialogue",
            textSize = 24,
            textColor = util.color.rgb(1.0, 0.85, 0.2),
            textAlign = ui.ALIGNMENT.Center,
        }
    })
    
    -- Spacer removed for cleaner look
    
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
                                textSize = 20,
                                textColor = util.color.rgb(0.9, 0.9, 0.9),
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

function M.show()
    showChoiceMenu()
end

return M
