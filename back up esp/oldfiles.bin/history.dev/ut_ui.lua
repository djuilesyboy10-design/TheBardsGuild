-- scripts/universal_travel/ut_ui.lua
-- Universal Travel System - UI Component
-- Works for any travel network

local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local types = require("openmw.types")
local self = require("openmw.self")
local storage = require("openmw.storage")
local destinations = require("scripts.universal_travel.ut_destinations")

local root
local M = {}

-- Network-specific settings
local networkSettings = {
    daedric = {
        title = "DAEDRIC NETWORK",
        cooldown = 43200, -- 12 hours
        storageKey = "Daedric_ReadyTime",
        color = {0.8, 0.2, 0.8} -- Purple theme
    },
    propylon = {
        title = "PROPYLON NETWORK", 
        cooldown = 86400, -- 24 hours
        storageKey = "Propylon_ReadyTime",
        color = {0.2, 0.8, 0.2} -- Green theme
    }
}

local function close()
    if root then root:destroy(); root = nil end
    I.UI.setMode(nil)
end

local function checkRequirements(requirements)
    if not requirements then return true end
    
    if requirements.quest and requirements.stage then
        local playerQuests = types.Player.quests(self)
        local qData = playerQuests[requirements.quest]
        local currentStage = qData and qData.stage and tonumber(qData.stage) or 0
        return currentStage >= requirements.stage
    end
    
    return true
end

function M.showMenu(network)
    if root then return end
    
    local networkData = destinations[network]
    local settings = networkSettings[network] or networkSettings.daedric
    
    if not networkData then
        ui.showMessage("Invalid travel network: " .. network)
        return
    end
    
    -- Check cooldown
    local playerSettings = storage.playerSection("UT_Settings")
    playerSettings:setLifeTime(storage.LIFE_TIME.Temporary) -- Save-specific storage
    local currentTime = core.getGameTime()
    local readyTime = playerSettings:get(settings.storageKey) or 0
    
    if currentTime < readyTime then
        local remainingSeconds = readyTime - currentTime
        local hours = math.floor(remainingSeconds / 3600)
        local minutes = math.floor((remainingSeconds % 3600) / 60)
        ui.showMessage(string.format("The %s is recharging. Ready in %dh %dm.", 
            settings.title:lower(), hours, minutes))
        return 
    end

    I.UI.setMode("Interface", { windows = {} })
    local content = {}

    -- Title
    table.insert(content, {
        type = ui.TYPE.Text,
        props = { 
            text = settings.title, 
            textSize = 20, 
            textColor = util.color.rgb(settings.color[1], settings.color[2], settings.color[3]) 
        }
    })

    -- Destinations
    for destId, destInfo in pairs(networkData) do
        local canTravel = checkRequirements(destInfo.requirements)
        
        if canTravel then
            table.insert(content, {
                type = ui.TYPE.Container,
                content = ui.content({
                    { 
                        type = ui.TYPE.Text, 
                        props = { 
                            text = destInfo.name, 
                            textSize = 16, 
                            textColor = util.color.rgb(0.9, 0.9, 0.9) 
                        }
                    }
                }),
                props = { paddingTop = 2, paddingBottom = 2 },
                events = {
                    mouseClick = async:callback(function()
                        -- Set cooldown
                        playerSettings:set(settings.storageKey, core.getGameTime() + settings.cooldown)
                        
                        -- Send travel event
                        core.sendGlobalEvent("UT_Travel", {
                            network = network,
                            destination = destId
                        })
                        close()
                    end)
                }
            })
        else
            table.insert(content, {
                type = ui.TYPE.Text,
                props = { 
                    text = destInfo.name .. " (Locked)", 
                    textSize = 16, 
                    textColor = util.color.rgb(0.4, 0.4, 0.4) 
                }
            })
        end
    end

    -- Cancel button
    table.insert(content, {
        type = ui.TYPE.Container,
        props = { paddingTop = 10 },
        content = ui.content({
            { 
                type = ui.TYPE.Text, 
                props = { 
                    text = "[ CANCEL ]", 
                    textSize = 14, 
                    textColor = util.color.rgb(0.7, 0.7, 0.7) 
                }
            }
        }),
        events = { 
            mouseClick = async:callback(function() close() end) 
        }
    })

    root = ui.create {
        layer = "Windows",
        type = ui.TYPE.Flex,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.5, 0.5),
            horizontal = false,
            align = ui.ALIGNMENT.Center,
            padding = 15,
            backgroundColor = util.color.rgba(0.05, 0.05, 0.05, 0.9),
        },
        content = ui.content(content)
    }
end

return M
