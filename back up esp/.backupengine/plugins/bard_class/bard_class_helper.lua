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
local auxUi = require("openmw_aux.ui")  -- Add UI destruction utilities

-- Import the bard content data from separate file
local bardContent = require("scripts.engine.plugins.bard_class.bard_content_data")

local root
local M = {}

-- Clean up any existing UI before showing new content
local function cleanupExistingUI()
    if root then
        auxUi.deepDestroy(root)
        root = nil
    end
    -- Also ensure we're not in any other UI mode
    I.UI.setMode(nil)
end

-- Regional bard content based on location
local function getRegionalBardContent(cellName)
    local content = {}
    
    -- Balmora area content
    if string.find(string.lower(cellName), "balmora") then
        content = [[
Ah, Balmora! The city of canals and commerce.

*The bard clears their throat and begins to sing:*

"In Balmora's heart where waters flow,
The Hlaalu dance and gold coins grow.
From Council Club to Lucky Lockup's door,
The traders seek their fortunes more.

But listen close, I'll tell you true,
Beneath the silt-streaked sky so blue,
There's secrets whispered on the breeze,
Of ancient times and forgotten keys."

*A knowing smile plays on the bard's lips.*

"This city has seen more than merchants, friend. Every canal holds a story, every corner a memory of when the dwarves walked these lands...]]
    
    -- Ald'ruhn area content
    elseif string.find(string.lower(cellName), "ald'ruhn") then
        content = [[
Ald'ruhn! The shell-city of Red Mountain's shadow.

*The bard's voice drops to a mysterious whisper:*

"Within the great shell, ancient and deep,
Where Red Mountain's secrets sleep.
The Redoran stand with honor proud,
Their voices echo, clear and loud.

But older still than stone and shell,
Are tales the ash-storms cannot tell.
Of heroes fallen, kings of old,
And stories worth more than gold."

*The bard glances toward the distant mountain.*

"The wind here carries voices from the past... if you know how to listen...]]
    
    -- Default content for other locations
    else
        content = [[
*The bard looks around thoughtfully, then begins:*

"Every place has its own rhythm, its own song.
This land of Morrowind breathes with ancient magic,
Where the past and present dance like lovers in the twilight.

I could sing of heroes long forgotten,
Of dragons' wings and dwarven might,
Of love lost in the ash-storm's fury,
And hope that blooms like ghost-flowers in the night."

*The bard's eyes sparkle with mischief.*

"But the best stories are the ones we live ourselves, aren't they?]]
    end
    
    return content
end

-- Dynamic gossip system
local function getLocalGossip()
    local gossipOptions = {
        [[
*The bard leans in, voice dropping to a conspiratorial whisper:*

"Have you heard the news? They say a strange light was seen over Ghostgate last night. The Temple is calling it an omen, but the old folk... they remember the last time such lights appeared.

And speaking of strange things, a caravan from the west arrived without half its merchants. They claim bandits, but I saw fear in their eyes that no simple thief could cause..."

*The bard pauses dramatically.*

"But the strangest tale? They say someone has been asking questions about the old bardic colleges. The ones that haven't been used since the War of the First Council...]],
        
        [[
*The bard strums a thoughtful chord on their instrument:*

"Trade's been odd lately. The Hlaalu are tightening their purse strings, and even the Telvanni have been seen in Balmora more often than usual.

And there's talk of a new song being sung in the ashlands - one that makes the kwama foragers nervous. Some say it's just superstition, but others... others remember the last time the land sang back."

*The bard's expression grows serious.*

"Keep your wits about you, friend. Morrowind is stirring, and not all who stir are friendly...]],
        
        [[
*The bard grins, tapping their instrument knowingly:*

"You know what's really interesting? The bards' guild has been quiet lately. Too quiet. Usually we're the first to hear when something big is about to happen.

But the songs I've been hearing in my dreams... they speak of a stranger who will change the very way stories are told in Morrowind. Someone who understands the true power of words."

*The bard winks at you.*

"Maybe that someone is you, eh? Or maybe I've just been drinking too much mazte...]]
    }
    
    -- Return a random gossip
    local index = math.random(#gossipOptions)
    return gossipOptions[index]
end

local function showResult(text)
    print("[BARD_CLASS] showResult called with: " .. tostring(text))
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

local function showChoiceMenu()
    -- Use proper UI cleanup
    cleanupExistingUI()

    -- Additional safety check - ensure no other UI is showing
    I.UI.setMode("Interface", { windows = {} })

    local choices = {
        {
            text = "Tell me about the local area and its stories",
            action = function()
                close()
                -- Grant the dummy spell for BardLore content
                types.Actor.spells(self):add("bard_performance_dummy")
                
                -- Get content from data table
                local content = bardContent[1]
                showResult(content.content)
            end
        },
        {
            text = "Share a song or poem with me",
            action = function()
                close()
                
                -- Get content from data table
                local content = bardContent[2]
                showResult(content.content)
            end
        },
        {
            text = "What's the latest news and gossip?",
            action = function()
                close()
                
                -- Get content from data table
                local content = bardContent[3]
                showResult(content.content)
            end
        },
        {
            text = "Teach me about the art of barding",
            action = function()
                close()
                
                -- Get content from data table
                local content = bardContent[4]
                showResult(content.content)
            end
        },
        {
            text = "Never mind",
            action = function()
                close()
                
                -- Get content from data table
                local content = bardContent[5]
                showResult(content.content)
            end
        }
    }

    local content = {}
    
    -- Title
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = "What would you like to ask this traveling bard?",
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
            anchor = util.vector2(0.0, 0.0),
            relativeSize = util.vector2(0.4, 0.4),
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

function M.show()
    showChoiceMenu()
end

return M
