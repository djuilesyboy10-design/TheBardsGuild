-- Bardic UI Helper
-- Owns creation, update, and lifetime of the Bardic Influence HUD
-- No gameplay logic lives here

local ui = require('openmw.ui')
local util = require('openmw.util')

local M = {}

----------------------------------------------------------------
-- Internal state
----------------------------------------------------------------
local hud = nil
local barFill = nil
local valueText = nil
local isVisible = false

----------------------------------------------------------------
-- Visual constants
----------------------------------------------------------------
local BAR_WIDTH = 204
local BAR_HEIGHT = 12
local MAX_VALUE = 100

----------------------------------------------------------------
-- Internal: create UI once
----------------------------------------------------------------
local function createUI()
    if hud then return end

    hud = ui.create {
        layer = 'Notification',
        type = ui.TYPE.Widget,
        props = {
            relativePosition = util.vector2(0.5, 1.0),
            anchor = util.vector2(0.5, 1.0),
            size = util.vector2(240, 80),
        },
        content = ui.content {

            -- Title
            {
                type = ui.TYPE.Text,
                props = {
                    text = "BARDIC INFLUENCE",
                    textSize = 14,
                    textColor = util.color.rgb(0.8, 0.7, 0.4),
                    relativePosition = util.vector2(0.5, 0.2),
                    anchor = util.vector2(0.5, 0.5),
                },
            },

            -- Bar background
            {
                type = ui.TYPE.Widget,
                props = {
                    relativePosition = util.vector2(0.5, 0.5),
                    anchor = util.vector2(0.5, 0.5),
                    size = util.vector2(BAR_WIDTH, BAR_HEIGHT + 2),
                    backgroundColor = util.color.rgb(0.1, 0.1, 0.1),
                },
                content = ui.content {

                    -- Bar fill (correct relative scaling)
                    {
                        type = ui.TYPE.Widget,
                        props = {
                            relativePosition = util.vector2(0, 0.5),
                            anchor = util.vector2(0, 0.5),

                            -- Width scales via relativeSize
                            relativeSize = util.vector2(0, 1),
                            size = util.vector2(0, BAR_HEIGHT),

                            backgroundColor = util.color.rgb(0.2, 0.4, 0.8),
                        },
                        onCreated = function(widget)
                            barFill = widget
                        end,
                    },

                },
            },

            -- Numeric value text
            {
                type = ui.TYPE.Text,
                props = {
                    text = "0 / 100",
                    textSize = 12,
                    textColor = util.color.rgb(0.9, 0.9, 0.9),
                    relativePosition = util.vector2(0.5, 0.8),
                    anchor = util.vector2(0.5, 0.5),
                },
                onCreated = function(widget)
                    valueText = widget
                end,
            },

        },
    }

    isVisible = true
end

----------------------------------------------------------------
-- Public API
----------------------------------------------------------------

function M.init()
    createUI()
end

function M.setProgress(value)
    if not hud then return end
    if not barFill or not valueText then return end

    local clamped = math.max(0, math.min(value or 0, MAX_VALUE))

    barFill.props.relativeSize = util.vector2(
        clamped / MAX_VALUE,
        1
    )

    valueText.props.text = string.format("%d / %d", clamped, MAX_VALUE)

    hud:update()
end

function M.show()
    if not hud then createUI() end
    if isVisible then return end

    hud.props.alpha = 1.0
    hud:update()
    isVisible = true
end

function M.hide()
    if not hud or not isVisible then return end

    hud.props.alpha = 0.0
    hud:update()
    isVisible = false
end

function M.destroy()
    if hud then
        hud:destroy()
        hud = nil
        barFill = nil
        valueText = nil
        isVisible = false
    end
end

return M