local I = require('openmw.interfaces')
local API = I.SkillFramework

local SKILL_ID = "juilesy_herbalism"

local function registerHerbalism()
    if not API then
        print("[Herbalish] SkillFramework missing - cannot register")
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
        statsWindowProps = { subsection = "Misc" }
    })

    print("[Herbalish] Skill registered")
end

return {
    engineHandlers = {
        onInit = registerHerbalism,
        onLoad = registerHerbalism
    }
}