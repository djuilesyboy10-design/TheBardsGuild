-- bard_lore_helper.lua
-- Helper functions for BardLore system
-- Based on ballad_helper.lua but for Bard Lore content

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
                    textColor = util.color.rgb(0.9, 0.8, 0.6), -- Golden color for lore
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
                    mouseClick = async:callback(close)
                },
                content = ui.content(loreContent)
            }
        }
    }

    I.UI.setMode("Interface", { windows = {} })
end

function M.show()
    print("[BARDLORE] show() function called")
    
    -- Remove the dummy spell
    local types = require("openmw.types")
    for _, spell in ipairs(types.Actor.spells(self)) do
        if spell.id == "bard_performance_dummy" then
            types.Actor.spells(self):remove("bard_performance_dummy")
            print("[BARDLORE] Dummy spell removed")
            break
        end
    end

    -- Show Bard Lore content
    local loreText = [[
The ancient art of Bard Lore speaks of heroes long past,
Their songs and stories echoing through time.
Each verse a treasure, each melody a key,
To unlock the mysteries of history's grand design.

From tavern halls to castle courts so grand,
The bards weave tales across the land.
Their words carry power, their music brings peace,
A legacy that will never cease.
]]

    print("[BARDLORE] About to call showResult()")
    showResult(loreText)
    print("[BARDLORE] showResult() completed")
end

return M
