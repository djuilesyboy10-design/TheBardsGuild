-- trigger_config.lua
-- Configuration data for universal trigger system
-- Part 1 of 3: Data Table

return {
    triggers = {
        {
            name = "JiubBallad",
            type = "cell",
            cellName = "Balmora, Lucky Lockup",
            event = "Bard_JiubBallad_Event",
            fired = false
        },
        {
            name = "BardLore",
            type = "spell",
            spellId = "bard_performance_dummy",
            event = "BardLoreShowMenu",
            fired = false
        },
        {
            name = "BardClass",
            type = "npc_class",
            npcClass = "Bard",
            radius = 200,
            event = "BardClassShowMenu",
            fired = false
        }
    }
}
