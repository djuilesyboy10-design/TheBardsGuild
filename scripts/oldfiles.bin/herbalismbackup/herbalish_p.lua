local core = require('openmw.core')
local types = require('openmw.types')
local self = require('openmw.self')
local I = require('openmw.interfaces')
local ui = require('openmw.ui')
local input = require('openmw.input')
local async = require('openmw.async')

local API = I.SkillFramework

local SKILL_ID = "juilesy_herbalism"

-- Registration with skillGain
local function registerHerbalism()
    if not API then
        print("[Herbalish] SkillFramework not found")
        return
    end

    API.registerSkill(SKILL_ID, {
        name = "Herbalism",
        description = "Governs successful plant harvesting and seed gathering.",
        icon = { fgr = "icons/bard/Herbal.dds" },
        attribute = "intelligence",
        specialization = API.SPECIALIZATION.Stealth,
        startLevel = 5,
        maxLevel = 100,
        statsWindowProps = { subsection = "Misc" },
        
        -- Critical: valid useType for skillUsed
        skillGain = {
            [1] = 1.0  -- useType = 1 now valid, multiplier 1.0 (adjust if needed)
        }
    })

    print("[Herbalish] Skill registered successfully")
end

-- Track last targeted flora to avoid spamming XP
local lastFloraTarget = nil

-- Poll current target in onFrame (safe in player script)
local function checkTarget()
    local target = types.Player.getTargetContainer(self)  -- valid in player script

    if target and target ~= lastFloraTarget then
        local id = target.recordId:lower()
        if id:find("^flora_") or id:find("^plant_") or id:find("^shroom_") or id:find("^ingred_") then
            -- Player is now targeting/opening a flora ? give XP
            local useAmount = 3.0  -- high test value - lower to 1.0-2.0 later
            API.skillUsed(SKILL_ID, { useType = 1, amount = useAmount })
            print("[Herbalish] Flora targeted/opened ? XP + " .. useAmount .. " | " .. id)

            ui.showMessage("Harvested " .. id .. "! (+XP)")
        end
        lastFloraTarget = target
    end
end

return {
    engineHandlers = {
        onInit = registerHerbalism,
        onLoad = registerHerbalism,
        onFrame = checkTarget  -- poll for target changes
    }
}