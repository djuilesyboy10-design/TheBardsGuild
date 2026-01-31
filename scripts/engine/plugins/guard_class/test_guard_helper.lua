-- test_guard_helper.lua
-- Minimal test helper matching merchant pattern exactly

local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local self = require("openmw.self")
local types = require("openmw.types")
local auxUi = require("openmw_aux.ui")

local root
local M = {}

-- Clean up any existing UI before showing new content
local function cleanupExistingUI()
    if root then
        auxUi.deepDestroy(root)
        root = nil
    end
    I.UI.setMode(nil)
end

-- Simple test content
local function showResult(text)
    if root then
        root:destroy()
        root = nil
    end

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
                    textSize = 28,
                    textColor = util.color.rgb(0.8, 0.8, 0.9),
                }
            })
        end
    end

    table.insert(loreContent, {
        type = ui.TYPE.Text,
        props = {
            text = "[ Click to continue ]",
            textSize = 26,
            textColor = util.color.rgb(0.5, 0.5, 0.5),
            paddingTop = 12,
        }
    })

    root = ui.create {
        layer = "Windows",
        type = ui.TYPE.Container,
        template = I.MWUI.templates.boxSolid,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.5, 0.5),
            relativeSize = util.vector2(0.6, 0.4),
        },
        content = ui.content {
            {
                type = ui.TYPE.Flex,
                props = {
                    relativeSize = util.vector2(1, 1),
                    horizontal = false,
                    align = ui.ALIGNMENT.Center,
                    padding = 16,
                    backgroundColor = util.color.rgba(0.05, 0.05, 0.05, 0.92),
                },
                events = {
                    mouseClick = async:callback(function()
                        if root then
                            root:destroy()
                            root = nil
                        end
                        I.UI.setMode(nil)
                    end)
                },
                content = ui.content(loreContent)
            }
        }
    }

    I.UI.setMode("Interface", { windows = {} })
end

local function close()
    if root then
        root:destroy()
        root = nil
    end
    I.UI.setMode(nil)
end

local function showChoiceMenu()
    cleanupExistingUI()
    I.UI.setMode("Interface", { windows = {} })

    local choices = {
        {
            text = "Test Guard Dialogue 1",
            action = function()
                close()
                showResult("This is a test guard dialogue.\n\nIf you can see this, the basic guard system is working!")
            end
        },
        {
            text = "Test Guard Dialogue 2", 
            action = function()
                close()
                showResult("Second test dialogue.\n\nThe helper system is functioning correctly.")
            end
        }
    }

    local content = {}
    
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = "What would you like to ask this guard?",
            textSize = 28,
            textColor = util.color.rgb(0.7, 0.8, 1.0),
        }
    })

    table.insert(content, {
        type = ui.TYPE.Container,
        props = { paddingTop = 16 },
        content = ui.content({})
    })

    for _, choice in ipairs(choices) do
        table.insert(content, {
            type = ui.TYPE.Container,
            content = ui.content({
                {
                    type = ui.TYPE.Text,
                    props = {
                        text = "• " .. choice.text,
                        textSize = 24,
                        textColor = util.color.rgb(0.85, 0.85, 0.85),
                    }
                }
            }),
            events = {
                mouseClick = async:callback(choice.action)
            }
        })

        table.insert(content, {
            type = ui.TYPE.Container,
            props = { paddingTop = 8 },
            content = ui.content({})
        })
    end

    root = ui.create {
        layer = "Windows",
        type = ui.TYPE.Container,
        template = I.MWUI.templates.boxSolid,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.0, 0.0),
            relativeSize = util.vector2(0.4, 0.4),
        },
        content = ui.content {
            {
                type = ui.TYPE.Flex,
                props = {
                    relativeSize = util.vector2(1, 1),
                    horizontal = false,
                    align = ui.ALIGNMENT.Center,
                    padding = 16,
                    backgroundColor = util.color.rgba(0.05, 0.05, 0.05, 0.92),
                },
                events = {
                    mouseClick = async:callback(close)
                },
                content = ui.content(content)
            }
        }
    }

    I.UI.setMode("Interface", { windows = {} })
end

function M.show()
    showChoiceMenu()
end

return M
