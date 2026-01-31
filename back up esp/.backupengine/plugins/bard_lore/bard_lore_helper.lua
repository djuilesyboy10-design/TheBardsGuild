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

-- Import the bard content data
local bardContent = require("Lua.engine.plugins.bard_class.bard_content_data")

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
    local loreText = bardContent[1].content

    print("[BARDLORE] About to call showResult()")
    showResult(loreText)
    print("[BARDLORE] showResult() completed")
end

function M.showSong()
    print("[BARDLORE] showSong() function called")
    
    -- Remove the dummy spell
    local types = require("openmw.types")
    for _, spell in ipairs(types.Actor.spells(self)) do
        if spell.id == "bard_song_dummy" then
            types.Actor.spells(self):remove("bard_song_dummy")
            print("[BARDLORE] Song spell removed")
            break
        end
    end

    -- Show Song content
    local songText = bardContent[2].content

    print("[BARDLORE] About to call showResult() for song")
    showResult(songText)
    print("[BARDLORE] showResult() for song completed")
end

function M.showGossip()
    print("[BARDLORE] showGossip() function called")
    
    -- Remove the dummy spell
    local types = require("openmw.types")
    for _, spell in ipairs(types.Actor.spells(self)) do
        if spell.id == "bard_gossip_dummy" then
            types.Actor.spells(self):remove("bard_gossip_dummy")
            print("[BARDLORE] Gossip spell removed")
            break
        end
    end

    -- Show Gossip content
    local gossipText = bardContent[3].content

    print("[BARDLORE] About to call showResult() for gossip")
    showResult(gossipText)
    print("[BARDLORE] showResult() for gossip completed")
end

function M.showArt()
    print("[BARDLORE] showArt() function called")
    
    -- Remove the dummy spell
    local types = require("openmw.types")
    for _, spell in ipairs(types.Actor.spells(self)) do
        if spell.id == "bard_art_dummy" then
            types.Actor.spells(self):remove("bard_art_dummy")
            print("[BARDLORE] Art spell removed")
            break
        end
    end

    -- Show Art content
    local artText = bardContent[4].content

    print("[BARDLORE] About to call showResult() for art")
    showResult(artText)
    print("[BARDLORE] showResult() for art completed")
end

function M.showNevermind()
    print("[BARDLORE] showNevermind() function called")
    
    -- Remove the dummy spell
    local types = require("openmw.types")
    for _, spell in ipairs(types.Actor.spells(self)) do
        if spell.id == "bard_nevermind_dummy" then
            types.Actor.spells(self):remove("bard_nevermind_dummy")
            print("[BARDLORE] Nevermind spell removed")
            break
        end
    end

    -- Show Nevermind content
    local nevermindText = bardContent[5].content

    print("[BARDLORE] About to call showResult() for nevermind")
    showResult(nevermindText)
    print("[BARDLORE] showResult() for nevermind completed")
end

return M
