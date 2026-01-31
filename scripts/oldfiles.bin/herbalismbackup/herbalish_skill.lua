local I = require("openmw.interfaces")

local SkillAPI = I.SkillFramework

-- Very careful StatsWindow check
local StatsWindow = I.StatsWindow

if not SkillAPI then
    print("[Herbalish:Stats] ERROR: SkillFramework interface missing")
    return {}
end

if not StatsWindow then
    print("[Herbalish:Stats] ERROR: I.StatsWindow is nil ? Stats Window Extender not loaded or not enabled")
    return {}
end

print("[Herbalish:Stats] StatsWindow interface found!")

-- Check if registerSkill exists
if type(StatsWindow.registerSkill) ~= "function" then
    print("[Herbalish:Stats] ERROR: StatsWindow.registerSkill is not a function (type = " .. type(StatsWindow.registerSkill) .. ")")
    -- Fallback: try to use SkillFramework's built-in UI props only
    print("[Herbalish:Stats] Falling back to SkillFramework statsWindowProps only")
    return {}
end

local skillId = "gluby_herbalism"

print("[Herbalish:Stats] Registering skill ? " .. skillId)

StatsWindow.registerSkill({
    skillId    = skillId,
    name       = "Herbalism",
    icon       = { fgr = "icons/m/skill_alchemy.dds" },
    subsection = "Misc"   -- string literal
})

local function updateDisplay()
    local value = SkillAPI.getSkillValue(skillId) or 0
    StatsWindow.updateSkill(skillId, value)
end

updateDisplay()
SkillAPI.onSkillChanged(skillId, updateDisplay)

print("[Herbalish:Stats] UI integration bound (if no crash above)")

return {}