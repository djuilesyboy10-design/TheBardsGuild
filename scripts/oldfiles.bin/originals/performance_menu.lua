-- performance_menu.lua
-- Simple menu-driven performance system based on your influence UI patterns

local ui = require('openmw.ui')
local util = require('openmw.util')
local world = require('openmw.world')
local I = require('openmw.interfaces')

local hud
local MENU_WIDTH = 300
local MENU_HEIGHT = 200

local function showPerformanceMenu()
    -- Close existing menu
    if hud then hud:destroy() end
    
    hud = ui.create {
        layer = 'Windows',
        type = ui.TYPE.Widget,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.5, 0.5),
            size = util.vector2(MENU_WIDTH, MENU_HEIGHT),
        },
        content = ui.content({
            -- Background
            {
                type = ui.TYPE.Widget,
                props = {
                    size = util.vector2(MENU_WIDTH, MENU_HEIGHT),
                    backgroundColor = util.color.rgb(0.1, 0.1, 0.1)
                }
            },
            
            -- Title
            {
                type = ui.TYPE.Text,
                props = {
                    text = "BARD PERFORMANCE",
                    textSize = 18,
                    textColor = util.color.rgb(0.8, 0.7, 0.4),
                    relativePosition = util.vector2(0.5, 0.1),
                    anchor = util.vector2(0.5, 0.5)
                }
            },
            
            -- Performance buttons
            {
                type = ui.TYPE.Widget,
                props = {
                    relativePosition = util.vector2(0.5, 0.4),
                    anchor = util.vector2(0.5, 0.5),
                    size = util.vector2(MENU_WIDTH - 40, 120)
                },
                content = ui.content({
                    -- Brilliant Performance button
                    {
                        type = ui.TYPE.Text,
                        props = {
                            text = "1. Brilliant Performance",
                            textSize = 14,
                            textColor = util.color.rgb(0.2, 0.8, 0.2),
                            relativePosition = util.vector2(0.5, 0.1),
                            anchor = util.vector2(0.5, 0.5)
                        },
                        events = {
                            mouseClick = function()
                                performAction(1)
                            end
                        }
                    },
                    
                    -- Good Performance button
                    {
                        type = ui.TYPE.Text,
                        props = {
                            text = "2. Good Performance",
                            textSize = 14,
                            textColor = util.color.rgb(0.8, 0.8, 0.2),
                            relativePosition = util.vector2(0.5, 0.3),
                            anchor = util.vector2(0.5, 0.5)
                        },
                        events = {
                            mouseClick = function()
                                performAction(2)
                            end
                        }
                    },
                    
                    -- Mediocre Performance button
                    {
                        type = ui.TYPE.Text,
                        props = {
                            text = "3. Mediocre Performance",
                            textSize = 14,
                            textColor = util.color.rgb(0.8, 0.8, 0.8),
                            relativePosition = util.vector2(0.5, 0.5),
                            anchor = util.vector2(0.5, 0.5)
                        },
                        events = {
                            mouseClick = function()
                                performAction(3)
                            end
                        }
                    },
                    
                    -- Poor Performance button
                    {
                        type = ui.TYPE.Text,
                        props = {
                            text = "4. Poor Performance",
                            textSize = 14,
                            textColor = util.color.rgb(0.8, 0.4, 0.4),
                            relativePosition = util.vector2(0.5, 0.7),
                            anchor = util.vector2(0.5, 0.5)
                        },
                        events = {
                            mouseClick = function()
                                performAction(4)
                            end
                        }
                    },
                    
                    -- Disastrous Performance button
                    {
                        type = ui.TYPE.Text,
                        props = {
                            text = "5. Disastrous Performance",
                            textSize = 14,
                            textColor = util.color.rgb(0.8, 0.2, 0.2),
                            relativePosition = util.vector2(0.5, 0.9),
                            anchor = util.vector2(0.5, 0.5)
                        },
                        events = {
                            mouseClick = function()
                                performAction(5)
                            end
                        }
                    }
                })
            },
            
            -- Close button
            {
                type = ui.TYPE.Text,
                props = {
                    text = "Press ESC to close",
                    textSize = 12,
                    textColor = util.color.rgb(0.5, 0.5, 0.5),
                    relativePosition = util.vector2(0.5, 0.95),
                    anchor = util.vector2(0.5, 0.5)
                }
            }
        })
    }
    
    -- Handle ESC key to close
    ui.setKeyFocus(hud)
    hud:registerKey('escape', function()
        if hud then hud:destroy() end
    end)
end

-- Perform the selected action
local function performAction(performanceId)
    -- Get current location
    local location = "Unknown"
    if self.cell and self.cell.name then
        location = self.cell.name
    end
    
    -- Count audience
    local audience = 0
    for _, npc in ipairs(world.nearby.npcs) do
        local distance = (npc.position - self.position):length()
        if distance <= 1000 then -- Within hearing range
            audience = audience + 1
        end
    end
    
    -- Send performance event
    world.sendGlobalEvent('BardPerformance', {
        performanceId = performanceId,
        location = location,
        audience = audience
    })
    
    -- Close menu
    if hud then hud:destroy() end
    
    print(string.format("[Bard] Performance initiated: ID %d, Location: %s, Audience: %d", 
        performanceId, location, audience))
end

-- Interface to show the menu
return {
    interfaceName = "BardPerformanceMenu",
    interface = {
        showMenu = function()
            showPerformanceMenu()
        end,
        
        closeMenu = function()
            if hud then hud:destroy() end
        end
    }
}
