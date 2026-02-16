-- Universal UI Components
-- Shared left/right box layout for all framework systems
-- Based on proven Chronicle and Special Titles patterns

local ui = require('openmw.ui')
local util = require('openmw.util')
local async = require('openmw.async')
local I = require('openmw.interfaces')
local auxUi = require('openmw_aux.ui')

return {
    -- Create main left/right box layout
    createMainLayout = function(title, leftContent, rightContent)
        local width = 800
        local height = 600
        local leftWidth = width * 0.30
        local rightWidth = width * 0.70
        local headerHeight = 40
        
        -- No header - removed to fix hanging text issue
        
        -- Left panel
        local leftPanel = {
            type = ui.TYPE.Flex,
            props = { 
                horizontal = false,
                size = util.vector2(leftWidth, height - headerHeight - 20)
            },
            content = leftContent
        }
        
        -- Right panel
        local rightPanel = {
            type = ui.TYPE.Flex,
            props = { 
                horizontal = false,
                size = util.vector2(rightWidth, height - headerHeight - 20)
            },
            content = rightContent
        }
        
        -- Main container following Completionist pattern
        return {
            type = ui.TYPE.Container,
            layer = 'Windows',
            template = I.MWUI.templates.boxTransparentThick,
            props = {
                relativeSize = util.vector2(0.6, 0.4),
                relativePosition = util.vector2(0.5, 0.5),
                anchor = util.vector2(0.5, 0.5),
            },
            content = ui.content {
                {
                    type = ui.TYPE.Flex,
                    props = {
                        horizontal = true,
                        arrange = ui.ALIGNMENT.Start,
                    },
                    content = ui.content {
                        -- Left box with borders
                        {
                            type = ui.TYPE.Widget,
                            template = I.MWUI.templates.bordersThick,
                            props = {
                                size = util.vector2(leftWidth, height - 20)
                            },
                            content = leftContent
                        },
                        -- Right box with borders
                        {
                            type = ui.TYPE.Widget,
                            template = I.MWUI.templates.bordersThick,
                            props = {
                                size = util.vector2(rightWidth, height - 20)
                            },
                            content = rightContent
                        }
                    }
                }
            }
        }
    end,
    
    -- Create left panel with clickable items
    createLeftPanel = function(items, onSelectCallback, selectedItemIndex)
        local content = ui.content {
            -- Items list
            {
                type = ui.TYPE.Flex,
                props = { horizontal = false },
                content = ui.content {}
            }
        }
        
        -- Add items as clickable buttons
        for i, item in ipairs(items) do
            local textColor = util.color.rgb(0.8, 0.8, 0.8)
            if selectedItemIndex and i == selectedItemIndex then
                textColor = util.color.rgb(1.0, 1.0, 0.6) -- Highlight selected
            end
            
            table.insert(content[1].content, {
                type = ui.TYPE.Text,
                props = {
                    text = "• " .. item.title,
                    textSize = 14,
                    textColor = textColor,
                    paddingTop = 5,
                    paddingBottom = 5,
                    relativeSize = util.vector2(1, 0)
                },
                events = {
                    mouseClick = async:callback(function(e)
                        onSelectCallback(i, item)
                    end)
                }
            })
        end
        
        return content
    end,
    
    -- Create right panel with detailed content
    createRightPanel = function(content)
        return ui.content {
            -- Content with proper text processing
            {
                type = ui.TYPE.Flex,
                props = { horizontal = false },
                content = content
            }
        }
    end,
    
    -- Process text content with poetic formatting
    processTextContent = function(text)
        local content = ui.content {}
        
        for line in string.gmatch(text, "([^\n]*)\n?") do
            if line == "" then
                -- Empty line becomes spacing container
                table.insert(content, {
                    type = ui.TYPE.Container,
                    props = { paddingTop = 8 },
                    content = ui.content({})
                })
            else
                -- Text line with Completionist-style formatting
                table.insert(content, {
                    type = ui.TYPE.Text,
                    props = {
                        text = line,
                        textSize = 16, -- Completionist fontItem size
                        textColor = util.color.rgb(0.9, 0.8, 0.6), -- Golden color
                    }
                })
            end
        end
        
        return content
    end,
    
    -- Clean up UI following working pattern
    cleanupUI = function(widget)
        if widget then
            widget:destroy()
            widget = nil
        end
        I.UI.setMode(nil)
    end
}
