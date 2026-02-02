-- scripts/universal_travel/ut_destinations.lua
-- Universal Travel System - Central Destination Database
-- Supports multiple travel networks: Daedric, Propylon, Divine, etc.

return {
    -- Daedric Shrines Network (Test Case)
    daedric = {
        azura = {
            name = "Shrine of Azura",
            cell = "Shrine of Azura",
            pos = {-368.251221, 4110.770996, 52.490837},
            activator = "jmcg_01",
            description = "The serene shrine to Azura, Dawn and Dusk"
        },
        boethiah = {
            name = "Shrine of Boethiah",
            cell = "Sunken Shrine of Boethiah",
            pos = {-65787.070312, -26484.052734, 3363.105225},
            activator = "jmcg_01",
            description = "The sunken shrine to the Prince of Plots"
        },
        sheogorath = {
            name = "Ald Daedroth",
            cell = "Ald Daedroth, Inner Shrine",
            pos = {3601.760254, 4553.038086, -31.000000},
            activator = "jmcg_01",
            description = "The mad prince's shrine of chaos"
        },
        molag_bal = {
            name = "Bal Ur",
            cell = "Bal Ur, Underground",
            pos = {-645.598022, 3342.898926, -1243.000000},
            activator = "jmcg_01",
            description = "The shrine to Molag Bal, King of Rape"
        },
        ald_sotha = {
            name = "Ald Sotha",
            cell = "Ald Sotha, Lower Level",
            pos = {4336.453125, 4994.451172, 13441.000000},
            activator = "jmcg_01",
            description = "Mehrunes Dagon's scenic island shrine"
        },
        -- Additional major shrines
        addadshashanammu = {
            name = "Addadshashanammu",
            cell = "Addadshashanammu, Shrine",
            pos = {3259.038818, 4813.018555, 13185.000000},
            activator = "jmcg_01",
            description = "Sheogorath's island shrine"
        },
        maelkashishi = {
            name = "Maelkashishi",
            cell = "Maelkashishi, Shrine",
            pos = {4368.021973, 2802.746582, 14481.000000},
            activator = "jmcg_01",
            description = "Sheogorath's western shrine"
        },
        yansirramus = {
            name = "Yansirramus",
            cell = "Yansirramus, Shrine",
            pos = {-508.415649, 2966.922119, -1022.999939},
            activator = "jmcg_01",
            description = "Molag Bal's island shrine"
        },
        ashalmimilkala = {
            name = "Ashalmimilkala",
            cell = "Ashalmimilkala, Shrine",
            pos = {1070.294556, -141.105011, -1007.000000},
            activator = "jmcg_01",
            description = "Mehrunes Dagon's southwestern shrine"
        },
        assurnabitashpi = {
            name = "Assurnabitashpi",
            cell = "Assurnabitashpi, Shrine",
            pos = {1288.477173, 4239.011719, -1663.000000},
            activator = "jmcg_01",
            description = "Mehrunes Dagon's western shrine"
        }
    },
    
    -- Propylon Network (For Migration)
    propylon = {
        andasreth = {
            name = "Andasreth",
            cell = "Andasreth, Propylon Chamber",
            pos = {-67.672050, 638.104797, -447.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 30 }
        },
        berandas = {
            name = "Berandas",
            cell = "Berandas, Propylon Chamber",
            pos = {-58.653496, 1027.871338, -703.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 40 }
        },
        falasmaryon = {
            name = "Falasmaryon",
            cell = "Falasmaryon, Propylon Chamber",
            pos = {-310.299683, 511.980042, -447.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 20 }
        },
        falensarano = {
            name = "Falensarano",
            cell = "Falensarano, Propylon Chamber",
            pos = {410.596008, 898.820007, -575.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 50 }
        },
        hlormaren = {
            name = "Hlormaren",
            cell = "Hlormaren, Propylon Chamber",
            pos = {4178.985840, 3183.155029, 12682.835938},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 60 }
        },
        indoranyon = {
            name = "Indoranyon",
            cell = "Indoranyon, Propylon Chamber",
            pos = {-116.962334, 757.755249, -447.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 70 }
        },
        marandus = {
            name = "Marandus",
            cell = "Marandus, Propylon Chamber",
            pos = {-329.099609, 899.064575, -447.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 80 }
        },
        rotheran = {
            name = "Rotheran",
            cell = "Rotheran, Propylon Chamber",
            pos = {-236.343887, 640.292236, -447.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 90 }
        },
        telasero = {
            name = "Telasero",
            cell = "Telasero, Propylon Chamber",
            pos = {-224.135269, 763.112000, -575.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 100 }
        },
        valenvaryon = {
            name = "Valenvaryon",
            cell = "Valenvaryon, Propylon Chamber",
            pos = {-323.190460, 800.596619, -575.000000},
            activator = "test_lua_container_01",
            requirements = { quest = "JMCG_Tuning_master", stage = 10 }
        }
    }
}
