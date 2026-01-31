-- scripts/universal_travel/ut_destinations.lua
-- Universal Travel System - Central Destination Database
-- Supports multiple travel networks: Daedric, Propylon, Divine, etc.

return {
    -- Daedric Shrines Network (Test Case)
    daedric = {
        azura = {
            name = "Shrine of Azura",
            cell = "Shrine of Azura",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "The serene shrine to Azura, Dawn and Dusk"
        },
        boethiah = {
            name = "Shrine of Boethiah",
            cell = "Sunken Shrine of Boethiah",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "The sunken shrine to the Prince of Plots"
        },
        sheogorath = {
            name = "Ald Daedroth",
            cell = "Ald Daedroth",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "The mad prince's shrine of chaos"
        },
        molag_bal = {
            name = "Bal Ur",
            cell = "Bal Ur",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "The shrine to Molag Bal, King of Rape"
        },
        ald_sotha = {
            name = "Ald Sotha",
            cell = "Ald Sotha",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "Mehrunes Dagon's scenic island shrine"
        },
        -- Additional major shrines
        addadshashanammu = {
            name = "Addadshashanammu",
            cell = "Addadshashanammu",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "Sheogorath's island shrine"
        },
        maelkashishi = {
            name = "Maelkashishi",
            cell = "Maelkashishi",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "Sheogorath's western shrine"
        },
        yansirramus = {
            name = "Yansirramus",
            cell = "Yansirramus",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "Molag Bal's island shrine"
        },
        ashalmimilkala = {
            name = "Ashalmimilkala",
            cell = "Ashalmimilkala",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "Mehrunes Dagon's southwestern shrine"
        },
        assurnabitashpi = {
            name = "Assurnabitashpi",
            cell = "Assurnabitashpi",
            pos = {4096, 4096, 160},
            activator = "jmcg_01",
            description = "Mehrunes Dagon's western shrine"
        }
    },
    
    -- Propylon Network (For Migration)
    propylon = {
        andasreth = {
            name = "Andasreth",
            cell = "Andasreth, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_andasreth",
            requirements = { quest = "JMCG_Tuning_master", stage = 30 }
        },
        berandas = {
            name = "Berandas",
            cell = "Berandas, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_berandas",
            requirements = { quest = "JMCG_Tuning_master", stage = 40 }
        },
        falasmaryon = {
            name = "Falasmaryon",
            cell = "Falasmaryon, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_falasmaryon",
            requirements = { quest = "JMCG_Tuning_master", stage = 20 }
        },
        falensarano = {
            name = "Falensarano",
            cell = "Falensarano, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_falensarano",
            requirements = { quest = "JMCG_Tuning_master", stage = 50 }
        },
        hlormaren = {
            name = "Hlormaren",
            cell = "Hlormaren, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_hlormaren",
            requirements = { quest = "JMCG_Tuning_master", stage = 60 }
        },
        indoranyon = {
            name = "Indoranyon",
            cell = "Indoranyon, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_indoranyon",
            requirements = { quest = "JMCG_Tuning_master", stage = 70 }
        },
        marandus = {
            name = "Marandus",
            cell = "Marandus, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_marandus",
            requirements = { quest = "JMCG_Tuning_master", stage = 80 }
        },
        rotheran = {
            name = "Rotheran",
            cell = "Rotheran, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_rotheran",
            requirements = { quest = "JMCG_Tuning_master", stage = 90 }
        },
        telasero = {
            name = "Telasero",
            cell = "Telasero, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_telasero",
            requirements = { quest = "JMCG_Tuning_master", stage = 100 }
        },
        valenvaryon = {
            name = "Valenvaryon",
            cell = "Valenvaryon, Propylon Chamber",
            pos = {4096, 4096, 160},
            activator = "propylon_chamber_valenvaryon",
            requirements = { quest = "JMCG_Tuning_master", stage = 10 }
        }
    }
}
