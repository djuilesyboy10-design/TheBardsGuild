local I = require("openmw.interfaces")

local StatsWindow = I.StatsWindow
if not StatsWindow then
    -- In 2026, some UI overhauls might change this name, 
    -- so this check prevents the mod from crashing.
    print("[StatsWindow:Herbalism] StatsWindow interface not found")
    return {}
end

print("[StatsWindow:Herbalism] Registering Herbalism skill line")

StatsWindow.registerSkill({
    skillId = "gluby_herbalism", -- Matches the ID in your Skill Registration
    name = "Herbalism",
    icon = "icons/m/skill_alchemy.dds", -- Using Alchemy icon for the leaf/herb look
    subsection = StatsWindow.SUBSECTIONS.Misc, -- Places it under 'Misc' with Acrobatics/Mercantile
})

print("[StatsWindow:Herbalism] ? Herbalism line registered")

return {}