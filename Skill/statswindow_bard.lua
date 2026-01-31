local I = require("openmw.interfaces")

local SkillAPI = I.SkillFramework
local StatsWindow = I.StatsWindow

if not SkillAPI then
    print("[BardStats] SkillFramework not found")
    return {}
end

if not StatsWindow then
    print("[BardStats] StatsWindow interface not found")
    return {}
end

local skillId = "bard_performance"

print("==========================================")
print("BARD STATS WINDOW: Registering line")
print("==========================================")

StatsWindow.registerSkill({
    skillId = skillId,
    name = "Bard",
    icon = "icons/m/tx_skill_illusion.dds",
    subsection = StatsWindow.SUBSECTIONS.Magic,
})

local function updateBardStat()
    local value = SkillAPI.getSkillValue(skillId) or 0
    StatsWindow.updateSkill(skillId, value)
end

updateBardStat()

SkillAPI.onSkillChanged(skillId, updateBardStat)

print("BARD STATS WINDOW: ✓ Live update bound")

return {}