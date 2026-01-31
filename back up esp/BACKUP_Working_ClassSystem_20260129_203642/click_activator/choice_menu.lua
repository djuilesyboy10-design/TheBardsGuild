-- Universal Choice Menu for NPC Interactions
-- Provides choice between custom content and vanilla dialogue
-- Part of the Universal Activator Framework

local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local I = require("openmw.interfaces")
local auxUi = require("openmw_aux.ui")  -- Add UI destruction utilities

local choiceMenu = {}

-- Clean up any existing UI elements
local function cleanupExistingUI()
    -- Destroy any existing merchant UI elements
    local merchantHelper = require("scripts.engine.plugins.merchant_class.merchant_class_helper")
    if merchantHelper.root then
        auxUi.deepDestroy(merchantHelper.root)
        merchantHelper.root = nil
    end
end

-- Show the interaction choice menu
function choiceMenu.showInteractionChoice(npc, npcClass, activatorData, actor)
    local root
    
    -- Clean up any existing UI elements first
    cleanupExistingUI()
    
    -- Determine if this NPC class has custom content
    local hasCustomContent = activatorData ~= nil
    
    -- Create menu choices
    local choices = {}
    
    -- Add custom content option if available
    if hasCustomContent then
        table.insert(choices, {
            text = "[TheBardsGuild] Custom " .. npcClass .. " Interaction",
            description = "Experience TheBardsGuild custom narrative content",
            action = function()
                choiceMenu.closeMenu(root)
                -- Fire the correct class-specific event with NPC data
                actor:sendEvent(activatorData.event, {npc = npc})
            end
        })
    end
    
    -- Always add vanilla dialogue option
    table.insert(choices, {
        text = "[Morrowind] Talk & Persuade",
        description = "Use standard dialogue with persuasion options",
        action = function()
            choiceMenu.closeMenu(root)
            -- Use a frame callback to ensure proper UI state transition
            async:newUnsavableGameTimer(0, function()
                I.UI.addMode('Dialogue', {target = npc})
            end)
        end
    })
    
    -- Add barter option for merchants, publicans, and smiths
    if npcClass == "trader service" or npcClass == "publican" or npcClass == "smith" then
        table.insert(choices, {
            text = "[Morrowind] Barter",
            description = "Open merchant barter interface",
            action = function()
                choiceMenu.closeMenu(root)
                -- Use a frame callback to ensure proper UI state transition
                async:newUnsavableGameTimer(0, function()
                    I.UI.addMode('Barter', {target = npc})
                end)
            end
        })
    end
    
    -- Always add exit option
    table.insert(choices, {
        text = "[Exit]",
        description = "Cancel interaction",
        action = function()
            choiceMenu.closeMenu(root)
            -- Do nothing, just close the menu
        end
    })
    
    -- Build UI content
    local content = choiceMenu.buildMenuContent(npc, npcClass, choices)
    
    -- Create the menu window
    root = ui.create {
        layer = "Windows",
        type = ui.TYPE.Container,
        template = I.MWUI.templates.boxSolid,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.5, 0.5),
            relativeSize = util.vector2(0.6, 0.5),  -- Slightly larger for better readability
        },
        content = ui.content {
            {
                type = ui.TYPE.Flex,
                props = {
                    relativeSize = util.vector2(1, 1),
                    horizontal = false,
                    align = ui.ALIGNMENT.Center,
                    padding = 24,  -- More padding
                    backgroundColor = util.color.rgba(0.0, 0.0, 0.0, 1.0),  -- Pure black background
                },
                content = ui.content(content)
            }
        }
    }
    
    I.UI.setMode("Interface", { windows = {} })
    
    return root
end

-- Build the menu content UI
function choiceMenu.buildMenuContent(npc, npcClass, choices)
    local content = {}
    
    -- Title
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = "",  -- Made title invisible
            textSize = 1,  -- Minimal size
            textColor = util.color.rgb(0.05, 0.05, 0.05),  -- Same as background
            textAlign = ui.ALIGNMENT.Center,
        }
    })
    
    -- NPC name and class (clean format)
    local npcName = "NPC"
    if npc.recordId then
        npcName = tostring(npc.recordId):match("([^%)]+)$") or "NPC"
        npcName = npcName:gsub('"', ""):gsub("^%s+", ""):gsub("%s+$", "")
    end
    
    table.insert(content, {
        type = ui.TYPE.Text,
        props = {
            text = "",  -- Made NPC description text invisible
            textSize = 1,  -- Minimal size
            textColor = util.color.rgb(0.05, 0.05, 0.05),  -- Same as background
            textAlign = ui.ALIGNMENT.Center,
            paddingTop = 1,  -- Minimal padding
        }
    })
    
    -- Spacer removed for cleaner look
    
    -- Choices
    for i, choice in ipairs(choices) do
        -- Choice button
        table.insert(content, {
            type = ui.TYPE.Container,
            props = {
                paddingTop = 8,
                paddingBottom = 8,
            },
            content = ui.content({
                {
                    type = ui.TYPE.Container,
                    template = I.MWUI.templates.pane,
                    props = {
                        relativeSize = util.vector2(1, 1),
                        padding = 16,
                    },
                    events = {
                        mouseClick = async:callback(choice.action)
                    },
                    content = ui.content({
                        {
                            type = ui.TYPE.Text,
                            props = {
                                text = choice.text,
                                textSize = 20,
                                textColor = util.color.rgb(0.9, 0.9, 0.9),
                                textAlign = ui.ALIGNMENT.Center,
                            }
                        }
                    })
                }
            })
        })
        
        -- Spacer between choices
        if i < #choices then
            table.insert(content, {
                type = ui.TYPE.Container,
                props = { paddingTop = 12 },
                content = ui.content({})
            })
        end
    end
    
    return content
end

-- Close the menu
function choiceMenu.closeMenu(root)
    if root then
        auxUi.deepDestroy(root)
        root = nil
    end
    I.UI.setMode(nil)
end

return choiceMenu
