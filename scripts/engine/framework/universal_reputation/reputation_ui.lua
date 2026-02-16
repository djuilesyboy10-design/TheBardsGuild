-- reputation_ui.lua
-- Isolated UI component for the Universal Reputation system
-- Displays reputation level in the corner of the screen

local ui = require('openmw.ui')
local util = require('openmw.util')

local reputationWidget = nil
local lastLevel = ""

-- Level colors for visual distinction
local levelColors = {
    Criminal = util.color.rgb(1, 0.2, 0.2),      -- Red
    Suspicious = util.color.rgb(1, 0.5, 0.2),    -- Orange
    Dishonorable = util.color.rgb(0.8, 0.6, 0.4), -- Brownish
    Neutral = util.color.rgb(0.9, 0.9, 0.9),     -- White/Gray
    Honorable = util.color.rgb(0.4, 0.8, 0.4),   -- Green
    Heroic = util.color.rgb(0.2, 0.8, 1),       -- Cyan
    Legendary = util.color.rgb(1, 0.8, 0.2)      -- Gold
}

local function drawReputationUI(level)
    if reputationWidget then 
        reputationWidget:destroy() 
    end

    local color = levelColors[level] or levelColors.Neutral

    reputationWidget = ui.create {
        layer = 'Notification',
        type = ui.TYPE.Widget,
        props = {
            -- Top left position, mirrored from Bard Ring (which is at 0.94, 0.06)
            relativePosition = util.vector2(0.06, 0.06),
            anchor = util.vector2(0.5, 0.5),
            size = util.vector2(150, 40),
        },
        content = ui.content({
            {
                type = ui.TYPE.Text,
                props = {
                    text = string.upper(level),
                    textSize = 18,
                    textColor = color,
                    relativePosition = util.vector2(0, 0.5),
                    anchor = util.vector2(0, 0.5),
                }
            },
            {
                type = ui.TYPE.Text,
                props = {
                    text = "REPUTATION",
                    textSize = 10,
                    textColor = util.color.rgb(0.7, 0.7, 0.7),
                    relativePosition = util.vector2(0, 0.8),
                    anchor = util.vector2(0, 0.5),
                }
            }
        })
    }
end

return {
    update = function(level)
        if level ~= lastLevel then
            drawReputationUI(level)
            lastLevel = level
        end
    end,
    destroy = function()
        if reputationWidget then
            reputationWidget:destroy()
            reputationWidget = nil
        end
    end
}
