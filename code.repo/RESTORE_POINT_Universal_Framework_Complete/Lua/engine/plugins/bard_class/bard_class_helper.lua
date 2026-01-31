-- bard_class_helper.lua
-- Helper functions for Bard Class NPC system
-- Interactive conversation system for Bard NPCs

local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local self = require("openmw.self")
local types = require("openmw.types")

local root
local M = {}

local function close()
    if root then
        root:destroy()
        root = nil
    end
    I.UI.setMode(nil)
end

local function showChoiceMenu()
    if root then
        root:destroy()
        root = nil
    end

    local choices = {
        {
            text = "Tell me about the local area",
            action = function()
                close()
                -- Grant the dummy spell for BardLore content
                types.Actor.spells(self):add("bard_performance_dummy")
                print("[BARD_CLASS] Bard lore spell granted")
                
                -- Show a brief message
                showMessage("The bard shares some fascinating local lore with you...")
            end
        },
        {
            text = "Do you know any songs?",
            action = function()
                close()
                showMessage("The bard hums a few bars of an ancient melody...")
            end
        },
        {
            text = "Never mind",
            action = close
        }
    }

    local content = {}
    
    -- Title
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = "What would you like to ask this bard?",
            textSize = 28,
            textColor = util.color.rgb(1.0, 0.85, 0.2), -- Golden color
        }
    })

    table.insert(content, {
        type = ui.TYPE.Container,
        props = { paddingTop = 16 },
        content = ui.content({})
    })

    -- Choices
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
            anchor = util.vector2(0.5, 0.5),
            relativeSize = util.vector2(0.5, 0.4),
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

local function showMessage(text)
    if root then
        root:destroy()
        root = nil
    end

    root = ui.create {
        layer = "Windows",
        type = ui.TYPE.Container,
        template = I.MWUI.templates.boxSolid,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.5, 0.5),
            relativeSize = util.vector2(0.4, 0.2),
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
                content = ui.content {
                    {
                        type = ui.TYPE.Text,
                        props = {
                            text = text,
                            textSize = 24,
                            textColor = util.color.rgb(0.85, 0.85, 0.85),
                            align = ui.ALIGNMENT.Center
                        }
                    },
                    {
                        type = ui.TYPE.Container,
                        props = { paddingTop = 12 },
                        content = ui.content({})
                    },
                    {
                        type = ui.TYPE.Text,
                        props = {
                            text = "[ Click to continue ]",
                            textSize = 18,
                            textColor = util.color.rgb(0.5, 0.5, 0.5),
                            align = ui.ALIGNMENT.Center
                        }
                    }
                }
            }
        }
    }

    I.UI.setMode("Interface", { windows = {} })
end

function M.show()
    print("[BARD_CLASS] Showing Bard interaction menu")
    showChoiceMenu()
end

return M
