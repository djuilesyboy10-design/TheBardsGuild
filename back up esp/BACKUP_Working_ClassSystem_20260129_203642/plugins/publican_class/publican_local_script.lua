-- publican_local_script.lua
-- Local script for Publican NPCs - handles activation directly
-- Uses onActivated to show custom menu when player talks to Publican

local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local self = require("openmw.self")
local types = require("openmw.types")

-- Import the publican content data
local publicanContent = require("scripts.engine.plugins.publican_class.publican_content_data")

local root
local M = {}

-- Regional publican content based on location
local function getRegionalPublicanContent(cellName)
    local content = {}
    
    -- Balmora area content
    if string.find(string.lower(cellName), "balmora") then
        content = {
            greeting = "Welcome to the Lucky Lockup! I'm the publican here.",
            description = "What can I get for you today?"
        }
    -- Ald'ruhn area content
    elseif string.find(string.lower(cellName), "ald'ruhn") then
        content = {
            greeting = "Greetings, traveler. Welcome to our establishment.",
            description = "How may I serve you?"
        }
    -- Vivec area content
    elseif string.find(string.lower(cellName), "vivec") then
        content = {
            greeting = "Welcome to Vivec City. What brings you here?",
            description = "What services do you require?"
        }
    else
        content = {
            greeting = "Welcome, traveler.",
            description = "How can I help you?"
        }
    end
    
    return content
end

-- UI functions
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
                    textColor = util.color.rgb(0.9, 0.8, 0.6),
                }
            })
        end
    end
    -- Add click to continue text
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

-- Main function to show the publican interaction menu
local function showPublicanMenu()
    local player = require("openmw.world").players[1]
    if not player then return end

    local cellName = player.cell.name or "Unknown"
    local regionalContent = getRegionalPublicanContent(cellName)

    local content = {}
    
    -- Title
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = regionalContent.greeting,
            textSize = 32,
            textColor = util.color.rgb(0.9, 0.8, 0.6),
            align = ui.ALIGNMENT.Center,
            paddingBottom = 16
        }
    })
    
    -- Description
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = regionalContent.description,
            textSize = 24,
            textColor = util.color.rgb(0.85, 0.85, 0.85),
            align = ui.ALIGNMENT.Center,
            paddingBottom = 24
        }
    })
    
    -- Menu options
    local option_actions = {
        {
            text = "Tell me about local rumors",
            action = function()
                close()
                -- Get content from data table
                local content = publicanContent[1]
                showResult(content.content)
            end
        },
        {
            text = "What business opportunities are available?",
            action = function()
                close()
                -- Get content from data table
                local content = publicanContent[2]
                showResult(content.content)
            end
        },
        {
            text = "Tell me about your room services",
            action = function()
                close()
                -- Get content from data table
                local content = publicanContent[3]
                showResult(content.content)
            end
        },
        {
            text = "What entertainment do you have?",
            action = function()
                close()
                -- Get content from data table
                local content = publicanContent[4]
                showResult(content.content)
            end
        },
        {
            text = "Just chat for a while",
            action = function()
                close()
                -- Get content from data table
                local content = publicanContent[5]
                showResult(content.content)
            end
        }
    }

    -- Create menu buttons
    for _, option in ipairs(option_actions) do
        table.insert(content, {
            type = ui.TYPE.Container,
            props = {
                paddingBottom = 8
            },
            content = ui.content {
                {
                    type = ui.TYPE.Text,
                    props = {
                        text = option.text,
                        textSize = 26,
                        textColor = util.color.rgb(0.85, 0.85, 0.85),
                        align = ui.ALIGNMENT.Center,
                        padding = 12,
                        backgroundColor = util.color.rgba(0.2, 0.2, 0.2, 0.8),
                    },
                    events = {
                        mouseClick = async:callback(option.action)
                    }
                }
            }
        })
    end
    
    -- Exit option
    table.insert(content, {
        type = ui.TYPE.Container,
        props = {
            paddingTop = 16
        },
        content = ui.content {
            {
                type = ui.TYPE.Text,
                props = {
                    text = "Never mind",
                    textSize = 24,
                    textColor = util.color.rgb(0.6, 0.6, 0.6),
                    align = ui.ALIGNMENT.Center,
                    padding = 12,
                },
                events = {
                    mouseClick = async:callback(close)
                }
            }
        }
    })

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
            relativeSize = util.vector2(0.5, 0.6),
        },
        content = ui.content {
            {
                type = ui.TYPE.Flex,
                props = {
                    relativeSize = util.vector2(1, 1),
                    horizontal = false,
                    align = ui.ALIGNMENT.Center,
                    padding = 20,
                    backgroundColor = util.color.rgba(0.05, 0.05, 0.05, 0.92),
                },
                content = ui.content(content)
            }
        }
    }

    I.UI.setMode("Interface", { windows = {} })
end

-- Local script handlers
return {
    engineHandlers = {
        onActivated = function(actor)
            -- Check if the activator is the player
            if actor == require("openmw.world").players[1] then
                print("[PUBLICAN_LOCAL] Player activated Publican - showing menu")
                showPublicanMenu()
                return true  -- Prevent default activation
            end
            return false
        end
    }
}
