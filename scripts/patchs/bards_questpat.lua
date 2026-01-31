local self = require('openmw.self')

-- =============================================================================
-- STANDALONE QUEST PATCH: Bards Quests & Lore
-- =============================================================================

local MyPatchQuests = {
    {
        id = "JMCG_Thieves_Lore",
        name = "The Undercover Act: 2",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "7 stages. Quest index 100."
    },
    {
        id = "JMCG_Ablle",
        name = "The Vibrating Earth",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "4 stages. Quest index 100."
    },
    {
        id = "JMCG_AshSinger_Echo",
        name = "The Ash Singers Echo",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "6 stages. Quest index 60."
    },
    {
        id = "JMCG_Ballad",
        name = "St Jiubs Ballad",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "3 stages. Quest index 100."
    },
    {
        id = "JMCG_Daisy_Lore",
        name = "The Silent Melody",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "9 stages. Quest index 110."
    },
    {
        id = "JMCG_Guide",
        name = "The AshLander Guide",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "1 stage. Quest index 10."
    },
    {
        id = "JMCG_Hist_Lore",
        name = "The Memory of Sap",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "7 stages. Quest index 100."
    },
    {
        id = "JMCG_Imperial_Buisness",
        name = "The Undercover Act: 1",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "8 stages. Quest index 115."
    },
    {
        id = "JMCG_Orc_Diplomacy",
        name = "Orc Diplomacy",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "5 stages. Quest index 100."
    },
    {
        id = "JMCG_Path_Bad",
        name = "Slaving all day",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "1 stage. Quest index 10."
    },
    {
        id = "JMCG_Path_Good",
        name = "The Abolitionist",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "1 stage. Quest index 10."
    },
    {
        id = "JMCG_Recruitment",
        name = "Recruitment Drive",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "12 stages. Quest index 100."
    },
    {
        id = "JMCG_Shane_Lore",
        name = "The Pig Children",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "4 stages. Quest index 100."
    },
    {
        id = "JMCG_Shane_Lore_1",
        name = "Orc True Nature?",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "4 stages. Quest index 100."
    },
    {
        id = "JMCG_Shane_Lore_2",
        name = "Nature of Honor",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "5 stages. Quest index 60."
    },
    {
        id = "JMCG_The_Chroniclers_Saint",
        name = "The War of the Skies",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "9 stages."
    },
    {
        id = "JMCG_The_Family_Ties",
        name = "Family Ties",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "3 stages. Quest index 100."
    },
    {
        id = "JMCG_Tong_Dirge",
        name = "The Shadow’s Duet",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "5 stages. Quest index 100."
    },
    {
        id = "JMCG_Twin_Lamps_Hymn",
        name = "Songs of Freedom",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "5 stages. Quest index 100."
    },
    {
        id = "The Bard's Guild",
        name = "The New Bards Guild",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "6 stages. Quest index 130."
    },
    {
        id = "JMCG_Tuning_Master",
        name = "The Devils Tuning Fork",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "10 stages. Quest index 100."
    },
    {
        id = "JMCG_Taver_HalOad",
        name = "Sweet Little Lies, Tell Me",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "4 stages. No complete rumor set up."
    },
    {
        id = "Jmcg_Joseph_lore",
        name = "Crossed Chords",
        category = "Bards Lore",
        subcategory = "Bards Quests",
        text = "5 stages. Quest index 100."
    },
}

-- =============================================================================
-- REGISTRATION LOGIC
-- =============================================================================
local hasSent = false

return {
    engineHandlers = {
        onUpdate = function(dt)
            if not hasSent then
                self:sendEvent("Completionist_RegisterPack", MyPatchQuests)
                print("[Completionist Patch] Bards Lore quests registered successfully.")
                hasSent = true
            end
        end
    }
}