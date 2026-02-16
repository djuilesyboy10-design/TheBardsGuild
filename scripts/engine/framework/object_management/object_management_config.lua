return {
    -- Add your object groups here
    -- Example Group:
    -- my_custom_group = {
    --     questId = "my_quest_id",
    --     stage = 10,
    --     objects = {
    --         {
    --             recordId = "my_object_id",
    --             cell = "My Cell Name",
    --             conditions = { type = "disable" }
    --         }
    --     }
    -- }
    
    -- JMCG_theend completion - remove house door and static items
    theend_cleanup = {
        questId = "jmcg_theend",
        stage = 20,
        objects = {
            { recordId = "JMCG_B1", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B2", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B3", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B4", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B5", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B6", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B7", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B9", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B10", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B11", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
        }
    },
    
    -- JMCG_goodend completion - also removes same items
    goodend_cleanup = {
        questId = "jmcg_goodend",
        stage = 50,
        objects = {
            { recordId = "JMCG_B1", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B2", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B3", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B4", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B5", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B6", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B7", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B9", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B10", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
            { recordId = "JMCG_B11", cell = "Balmora (-3, -3)", conditions = { type = "disable" } },
        }
    }
}
