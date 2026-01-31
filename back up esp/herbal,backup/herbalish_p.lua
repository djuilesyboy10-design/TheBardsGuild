local core = require('openmw.core')
local types = require('openmw.types')
local self = require('openmw.self')
local I = require('openmw.interfaces')
local ui = require('openmw.ui')
local okInput, input = pcall(require, 'openmw.input')
if not okInput then
    input = nil
end

local okAsync, async = pcall(require, 'openmw.async')
if not okAsync then
    async = nil
end

local API = I.SkillFramework

local SKILL_ID = "juilesy_herbalism"

print('[Herbalish] herbalish_p module loaded (top-level)')

local didInitDebug = false
local didEventDebug = false

-- Registration with skillGain
local function registerHerbalism()
    if not didInitDebug then
        didInitDebug = true
        print('[Herbalish] herbalish_p loaded')
    end

    if not API then
        print("[Herbalish] SkillFramework not found")
        return
    end

    if API.getSkillRecord and API.getSkillRecord(SKILL_ID) then
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

return {
    eventHandlers = {
        HerbalismHarvest = function(data)
            if not API then
                print('[Herbalish] HerbalismHarvest received but SkillFramework not found')
                return
            end

            local amount = (data and data.amount) or 0
            if amount <= 0 then
                return
            end

            local beforeStat = API.getSkillStat and API.getSkillStat(SKILL_ID) or nil
            local beforeBase = beforeStat and beforeStat.base or nil
            local beforeProgress = beforeStat and beforeStat.progress or nil

            API.skillUsed(SKILL_ID, { useType = 1, scale = amount })

            local afterStat = API.getSkillStat and API.getSkillStat(SKILL_ID) or nil
            local afterBase = afterStat and afterStat.base or nil
            local afterProgress = afterStat and afterStat.progress or nil

            didEventDebug = true
            print(string.format(
                '[Herbalish] HerbalismHarvest received: amount=%s | base %s->%s | progress %s->%s',
                tostring(amount),
                tostring(beforeBase),
                tostring(afterBase),
                tostring(beforeProgress),
                tostring(afterProgress)
            ))
        end,
        HerbalismHarvest_Global = function(data)
            print(string.format('[Herbalish] HerbalismHarvest_Global received: amount=%s recordId=%s', tostring(data and data.amount), tostring(data and data.recordId)))
        end
    },
    engineHandlers = {
        onInit = function()
            print('[Herbalish] herbalish_p onInit')
            registerHerbalism()
        end,
        onLoad = registerHerbalism
    }
}