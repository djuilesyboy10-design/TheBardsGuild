local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local self = require("openmw.self")
local types = require("openmw.types")

-- ✅ CORRECT CONTENT LOAD
local JiubData = require("scripts.engine.jiub_jiub_authorship")

local root
local M = {}

local function close()
    if root then
        root:destroy()
        root = nil
    end
    I.UI.setMode(nil)
end

-- 🔁 SHOW RESULT VERSE (POEM PRESENTATION, CLICK ANYWHERE TO CLOSE)
local function showResult(text)
    if root then
        root:destroy()
        root = nil
    end

    local verseContent = {}

    for line in string.gmatch(text, "([^\n]*)\n?") do
        if line == "" then
            table.insert(verseContent, {
                type = ui.TYPE.Container,
                props = { paddingTop = 8 },
                content = ui.content({})
            })
        else
            table.insert(verseContent, {
                type = ui.TYPE.Text,
                props = {
                    text = line,
                    textSize = 32,
                    textColor = util.color.rgb(0.7, 0.7, 0.7), -- 🔘 GREY for Result
                }
            })
        end
    end

    table.insert(verseContent, {
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
                    mouseClick = async:callback(close)
                },
                content = ui.content(verseContent)
            }
        }
    }

    I.UI.setMode("Interface", { windows = {} })
end

function M.show()
    if root then return end

    print("[BARD][UI] Opening Ballad UI")
    I.UI.setMode("Interface", { windows = {} })

    local entry = JiubData.JIUB_SAINTING
    local content = {}

    -- 🔹 CONTEXT (YELLOW)
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = entry.context,
            textSize = 28,
            textColor = util.color.rgb(1.0, 0.85, 0.2), -- 🟡 YELLOW for Context
        }
    })

    table.insert(content, {
        type = ui.TYPE.Container,
        props = { paddingTop = 10 },
        content = ui.content({})
    })

    -- 🔹 QUESTION
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = entry.question,
            textSize = 28,
            textColor = util.color.rgb(0.85, 0.85, 0.85),
        }
    })

    table.insert(content, {
        type = ui.TYPE.Container,
        props = { paddingTop = 8 },
        content = ui.content({})
    })

    -- 🔹 ANSWERS (RED)
    for _, option in ipairs(entry.options) do
        table.insert(content, {
            type = ui.TYPE.Container,
            content = ui.content({
                {
                    type = ui.TYPE.Text,
                    props = {
                        text = option.label,
                        textSize = 24,
                        textColor = util.color.rgb(0.9, 0.3, 0.3), -- 🔴 RED for Answers
                    }
                }
            }),
            events = {
                mouseClick = async:callback(function()
                    print("[BARD][CHOICE]\t", option.key)
                    showResult(option.result)
                    
                    -- Set quest stage to 100 to complete the ballad
                    local player = require("openmw.self")
                    if player and player.type == require("openmw.types").Player then
                        player:sendEvent("Journal", {topic = "JMCG_Ballad", stage = 100})
                        print("[BARD][QUEST] Set JMCG_Ballad to stage 100")
                    end
                end)
            }
        })

        table.insert(content, {
            type = ui.TYPE.Container,
            props = { paddingTop = 4 },
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
                    mouseClick = async:callback(close)
                },
                content = ui.content(content)
            }
        }
    }
end

return M
