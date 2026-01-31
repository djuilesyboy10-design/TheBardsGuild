local I = require("openmw.interfaces")

local SkillAPI = I.SkillFramework
local StatsWindow = I.StatsWindow

-- Ensure SkillFramework and UI are ready
if not SkillAPI then
    print("[HerbalismStats] SkillFramework not found")
    return {}
end

if not StatsWindow then
    print("[HerbalismStats] StatsWindow interface not found")
    return {}
end

local skillId = "gluby_herbalism"

print("==========================================")
print("HERBALISM STATS WINDOW: Registering line")
print("==========================================")

-- Register the line in the character sheet
StatsWindow.registerSkill({
    skillId = skillId,
    name = "Herbalism",
    icon = "icons/m/skill_alchemy.dds", -- Classic alchemy icon for the UI
    subsection = StatsWindow.SUBSECTIONS.Misc,
})

-- Update function to refresh the UI number
local function updateHerbalismStat()
    -- Uses the modified skill value (including buffs/debuffs)
    local stat = SkillAPI.getSkillStat(skillId)
    local value = stat and stat.modified or 0
    StatsWindow.updateSkill(skillId, value)
end

-- Initialize the display
updateHerbalismStat()

-- Bind the live update so it changes the moment you harvest
SkillAPI.onSkillChanged(skillId, updateHerbalismStat)

print("HERBALISM STATS WINDOW: ? Live update bound")

return {}