local ui = require('openmw.ui')
local util = require('openmw.util')
local I = require('openmw.interfaces')

local hud

local function draw(progress)
    if hud then hud:destroy() end

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
                    anchor = util.vector2(0.5, 0.5)
                }
            },

            -- Bar background + fill
            {
                type = ui.TYPE.Widget,
                props = {
                    relativePosition = util.vector2(0.5, 0.5),
                    anchor = util.vector2(0.5, 0.5),
                    size = util.vector2(204, 14),
                    backgroundColor = util.color.rgb(0.1, 0.1, 0.1)
                },
                content = ui.content {{
                    type = ui.TYPE.Widget,
                    props = {
                        relativePosition = util.vector2(0, 0.5),
                        anchor = util.vector2(0, 0.5),
                        size = util.vector2(
                            math.max(1, 204 * (progress / 100)),
                            12
                        ),
                        backgroundColor = util.color.rgb(0.2, 0.4, 0.8)
                    }
                }}
            },

            -- Numeric display (RESTORED)
            {
                template = I.MWUI.templates.boxSolid,
                props = {
                    relativePosition = util.vector2(0.5, 0.8),
                    anchor = util.vector2(0.5, 0.5)
                },
                content = ui.content({
                    {
                        template = I.MWUI.templates.padding,
                        content = ui.content({
                            {
                                type = ui.TYPE.Text,
                                props = {
                                    text = string.format("%d / 100", progress),
                                    textColor = util.color.rgba(1, 1, 1, 1),
                                    textSize = 12
                                }
                            }
                        })
                    }
                })
            }
        }
    }
end

return {
    engineHandlers = {
        onUpdate = function()
            if I.JMCG_QuestData then
                draw(I.JMCG_QuestData.getMeterNumber() or 0)
            end
        end
    }
}



