-- Quest Monitor Configuration
-- Defines specific narrative triggers for quest stage updates
-- Part of the Universal Activator Framework

local questTriggers = {
    -- Example: The Bards Guild (Main Arc)
    ["the_bards_guild"] = {
        [10] = {
            event = "JMCG_GuildRecruitmentComplete",
            description = "Player has officially joined the Bards Guild"
        },
        [100] = {
            event = "JMCG_GuildFinalConvergence",
            description = "Main quest arc convergence initiated"
        }
    },
    
    -- Example: Saint Jiub's Quest
    ["jmcg_the_chroniclers_saint"] = {
        [50] = {
            event = "JMCG_JiubRedMountainBound",
            description = "Jiub departs for Red Mountain"
        }
    },
    
    -- Example: Hist Lore
    ["jmcg_hist_lore"] = {
        [30] = {
            event = "JMCG_HistDreamAwakened",
            description = "Player enters the Hist Dream state"
        }
    },
    
    -- JMCG_Final - Endgame Quest
    ["jmcg_final"] = {
        [50] = {
            event = "JMCG_FinalTeleportToArena",
            description = "Teleport player to The Gods Arena for final confrontation"
        }
    },
    
    -- JMCG_TheEnd - Post-game return
    ["jmcg_theend"] = {
        [10] = {
            event = "JMCG_ReturnToBardsGuild",
            description = "Return to The Bards Guild after final confrontation"
        },
        [20] = {
            event = "JMCG_TeleportToDremoraCitadel",
            description = "Teleport to Dremora Citadel for theend stage 20"
        },
        [100] = {
            event = "JMCG_GoodPathTeleportToBalmora",
            description = "Teleport to Balmora center after good path completion"
        }
    },
    ["jmcg_final"] = {
        [40] = {
            event = "JMCG_GoodPathTeleportToBalmora",
            description = "Teleport to Balmora center after final quest stage 40"
        },
        [50] = {
            event = "JMCG_FinalTeleportToArena",
            description = "Teleport player to The Gods Arena for final confrontation"
        }
    },
    ["jmcg_goodend"] = {
        [10] = {
            event = "JMCG_TeleportToSothaSilDome",
            description = "Teleport to Sotha Sil Dome after good end stage 10"
        },
        [30] = {
            event = "JMCG_ReturnToBardsGuild",
            description = "Return to Bards Guild after good end stage 30"
        },
        [50] = {
            event = "JMCG_TeleportToDremoraCitadel",
            description = "Teleport to Dremora Citadel for goodend stage 50"
        },
        [100] = {
            event = "JMCG_GoodPathTeleportToBalmora",
            description = "Teleport to Balmora center after good end completion"
        }
    },
    
    -- JMCG_Shane_Lore_2 - Orc questline
    ["jmcg_shane_lore_2"] = {
        [40] = {
            event = "JMCG_TeleportToMalacathsDomain",
            description = "Teleport to Malacath's Domain for Shane Lore stage 40"
        }
    }
}

-- Get trigger data for a specific quest and stage
local function getQuestTrigger(questId, stage)
    if questTriggers[questId] then
        return questTriggers[questId][stage]
    end
    return nil
end

return {
    getQuestTrigger = getQuestTrigger,
    getAllTriggers = function() return questTriggers end
}
