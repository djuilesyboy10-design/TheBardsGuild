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
        }
    }
}
