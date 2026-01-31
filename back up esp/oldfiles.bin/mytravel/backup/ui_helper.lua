local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local core = require("openmw.core")
local I = require("openmw.interfaces")
local types = require("openmw.types")
local self = require("openmw.self")
local storage = require("openmw.storage") -- Required for saving the cooldown

local root
local M = {}

-- Create or get a persistent storage section for this mod
local playerSettings = storage.playerSection("MyTravel_Settings")

local function close()
    if root then root:destroy(); root = nil end
    I.UI.setMode(nil)
end

function M.show()
    if root then return end
    
    -- Check Cooldown
    local currentTime = core.getGameTime() -- Current time in seconds
    local readyTime = playerSettings:get("Propylon_ReadyTime") or 0
    
    if currentTime < readyTime then
        local remainingSeconds = readyTime - currentTime
        local hours = math.floor(remainingSeconds / 3600)
        local minutes = math.floor((remainingSeconds % 3600) / 60)
        
        -- Show a simple error notification instead of opening the menu
        ui.showMessage(string.format("The network is recharging. Ready in %dh %dm.", hours, minutes))
        return 
    end

    I.UI.setMode("Interface", { windows = {} })
    local content = {}

    table.insert(content, {
        type = ui.TYPE.Text,
        props = { text = "PROPYLON NETWORK", textSize = 20, textColor = util.color.rgb(1, 1, 1) }
    })

    local locations = {
        { name = "Andasreth",   event = "MyTravel_Propylon_Andasreth",   quest = "JMCG_Tuning_master",  stage = 30 },
        { name = "Berandas",    event = "MyTravel_Propylon_Berandas",    quest = "JMCG_Tuning_master",  stage = 40 },
        { name = "Falasmaryon", event = "MyTravel_Propylon_Falasmaryon", quest = "JMCG_Tuning_master",  stage = 20 },
        { name = "Falensarano", event = "MyTravel_Propylon_Falensarano", quest = "JMCG_Tuning_master",  stage = 50 },
        { name = "Hlormaren",   event = "MyTravel_Propylon_Hlormaren",   quest = "JMCG_Tuning_master",  stage = 60 },
        { name = "Indoranyon",  event = "MyTravel_Propylon_Indoranyon",  quest = "JMCG_Tuning_master",  stage = 70 },
        { name = "Marandus",    event = "MyTravel_Propylon_Marandus",    quest = "JMCG_Tuning_master",  stage = 80 },
        { name = "Rotheran",    event = "MyTravel_Propylon_Rotheran",    quest = "JMCG_Tuning_master",  stage = 90 },
        { name = "Telasero",    event = "MyTravel_Propylon_Telasero",    quest = "JMCG_Tuning_master",  stage = 100 },
        { name = "Valenvaryon", event = "MyTravel_Propylon_Valenvaryon", quest = "JMCG_Tuning_master",  stage = 10 },
    }

    local playerQuests = types.Player.quests(self)

    for _, loc in ipairs(locations) do
        local qData = playerQuests[loc.quest]
        local currentStage = qData and qData.stage and tonumber(qData.stage) or 0
        
        if currentStage >= loc.stage then
            table.insert(content, {
                type = ui.TYPE.Container,
                content = ui.content({{ type = ui.TYPE.Text, props = { text = loc.name, textSize = 16, textColor = util.color.rgb(0.9, 0.9, 0.9) }}}),
                events = {
                    mouseClick = async:callback(function()
                        -- SET COOLDOWN ON USE (24 hours = 86400 seconds)
                        local cooldownDuration = 86400 
                        playerSettings:set("Propylon_ReadyTime", core.getGameTime() + cooldownDuration)
                        
                        core.sendGlobalEvent(loc.event)
                        close()
                    end)
                }
            })
        else
            table.insert(content, {
                type = ui.TYPE.Text,
                props = { text = loc.name .. " (Locked)", textSize = 16, textColor = util.color.rgb(0.4, 0.4, 0.4) }
            })
        end
    end

    table.insert(content, {
        type = ui.TYPE.Container,
        props = { paddingTop = 10 },
        content = ui.content({{ type = ui.TYPE.Text, props = { text = "[ CANCEL ]", textSize = 14, textColor = util.color.rgb(0.7, 0.7, 0.7) }}}),
        events = { mouseClick = async:callback(function() close() end) }
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