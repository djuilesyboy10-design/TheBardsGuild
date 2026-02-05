local self = require("openmw.self")

-- =============================================================================
-- STANDALONE QUEST PATCH: Bards Quests & Lore
-- =============================================================================

local MyPatchQuests = {
    {
        id = "JMCG_Thieves_Lore",
        name = "The Undercover Act: 2",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "7 stages. Quest index 100."
    },
    {
        id = "JMCG_Ablle",
        name = "The Vibrating Earth",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "4 stages. Quest index 100."
    },
    {
        id = "JMCG_AshSinger_Echo",
        name = "The Ash Singers Echo",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "6 stages. Quest index 60."
    },
    {
        id = "JMCG_Ballad",
        name = "St Jiubs Ballad",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "3 stages. Quest index 100."
    },
    {
        id = "JMCG_Daisy_Lore",
        name = "The Silent Melody",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "9 stages. Quest index 110."
    },
    {
        id = "JMCG_Guide",
        name = "The AshLander Guide",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "1 stage. Quest index 10."
    },
    {
        id = "JMCG_Hist_Lore",
        name = "The Memory of Sap",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "7 stages. Quest index 100."
    },
    {
        id = "JMCG_Imperial_Buisness",
        name = "The Undercover Act: 1",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "5 stages. Quest index 100."
    },
    {
        id = "The Bards Guild",
        name = "The New Bards Guild",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "6 stages. Quest index 130."
    },
    {
        id = "JMCG_Tuning_Master",
        name = "The Devils Tuning Fork",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "10 stages. Quest index 100."
    },
    {
        id = "JMCG_Taver_HalOad",
        name = "Sweet Little Lies, Tell Me",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "4 stages. No complete rumor set up."
    },
    {
        id = "Jmcg_Joseph_lore",
        name = "Crossed Chords",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "5 stages. Quest index 100."
    },
    -- Additional quests from UI data
    {
        id = "JMCG_Orc_Diplomacy",
        name = "Orc Diplomacy",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 100."
    },
    {
        id = "JMCG_Path_Bad",
        name = "Slaving all day",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "1 stage. Quest index 10."
    },
    {
        id = "JMCG_Path_Good",
        name = "The Abolitionist",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "1 stage. Quest index 10."
    },
    {
        id = "JMCG_Recruitment",
        name = "Recruitment Drive",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 100."
    },
    {
        id = "JMCG_Shane_Lore",
        name = "The Pig Children",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 100."
    },
    {
        id = "JMCG_Shane_Lore_1",
        name = "Orc true nature?",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 100."
    },
    {
        id = "JMCG_Shane_Lore_2",
        name = "Gaze of Malacath",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 60."
    },
    {
        id = "JMCG_The_Chroniclers_Saint",
        name = "The War of the Sky's",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 90."
    },
    {
        id = "JMCG_The_Family_Ties",
        name = "Family Ties",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 100."
    },
    {
        id = "JMCG_Tong_Dirge",
        name = "The Shadow's Duet",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 100."
    },
    {
        id = "JMCG_Twin_Lamps_Hymn",
        name = "Song's of Freedom",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 100."
    },
    {
        id = "JMCG_Joseph_Personal",
        name = "Joseph's Past",
        category = "Factions | The Bards Guild",
        subcategory = "Bards Quests",
        text = "Multiple stages. Quest index 100."
    }
}

-- =============================================================================
-- REGISTRATION LOGIC
-- =============================================================================
local hasSent = false

return {
    engineHandlers = {
        onUpdate = function(dt)
            if not hasSent then
                print("[Completionist Patch] Bards Lore quests registered successfully.")
                self:sendEvent("Completionist_RegisterPack", MyPatchQuests)
                hasSent = true
            end
        end
    }
}
