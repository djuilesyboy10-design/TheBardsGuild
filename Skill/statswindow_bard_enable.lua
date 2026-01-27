local I = require("openmw.interfaces")

local StatsWindow = I.StatsWindow
if not StatsWindow then
    print("[StatsWindow:Bard] StatsWindow interface not found")
    return {}
end

print("[StatsWindow:Bard] Registering Bard skill line")

StatsWindow.registerSkill({
    skillId = "bard_performance",
    name = "Bard",
    icon = "icons/m/tx_skill_illusion.dds",
    subsection = StatsWindow.SUBSECTIONS.Magic,
})

print("[StatsWindow:Bard] ✓ Bard line registered")

return {}