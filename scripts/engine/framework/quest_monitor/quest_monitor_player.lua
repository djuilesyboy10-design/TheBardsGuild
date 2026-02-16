-- Quest Monitor Player Script
-- Tracks quest stage changes and notifies the global engine
-- Essential for "Reality Control" narrative events

local core = require('openmw.core')

return {
    engineHandlers = {
        onQuestUpdate = function(questId, stage)
            local qId = questId:lower()
            print("[QUEST_MONITOR_PLAYER] Quest updated: " .. qId .. " to stage " .. tostring(stage))
            
            core.sendGlobalEvent("JMCG_QuestStageChanged", {
                questId = qId,
                stage = stage
            })
        end
    },
    eventHandlers = {
        JMCG_FinalTeleportToArena = function(data)
            print("[QUEST_MONITOR_PLAYER] Firing teleport to The Gods Arena via Universal Travel")
            
            -- Use Universal Travel system for teleport
            core.sendGlobalEvent("UT_Travel", {
                network = "gods_arena",
                destination = "final_arena"
            })
        end,
        
        JMCG_ReturnToBardsGuild = function(data)
            print("[QUEST_MONITOR_PLAYER] Firing teleport to Bards Guild via Universal Travel")
            
            -- Use Universal Travel system for teleport
            core.sendGlobalEvent("UT_Travel", {
                network = "bards_guild",
                destination = "guild_hall"
            })
        end,
        
        JMCG_GoodPathTeleportToBalmora = function(data)
            print("[QUEST_MONITOR_PLAYER] Firing teleport to Balmora center via Universal Travel")
            
            -- Use Universal Travel system for teleport
            core.sendGlobalEvent("UT_Travel", {
                network = "bards_guild",
                destination = "balmora_center"
            })
        end,
        
        JMCG_TeleportToDremoraCitadel = function(data)
            print("[QUEST_MONITOR_PLAYER] Firing teleport to Dremora Citadel via Universal Travel")
            
            -- Use Universal Travel system for teleport
            core.sendGlobalEvent("UT_Travel", {
                network = "endgame_scroll",
                destination = "dremora_citadel"
            })
        end,
        
        JMCG_TeleportToSothaSilDome = function(data)
            print("[QUEST_MONITOR_PLAYER] Firing teleport to Sotha Sil Dome via Universal Travel")
            
            -- Use Universal Travel system for teleport
            core.sendGlobalEvent("UT_Travel", {
                network = "bards_guild",
                destination = "sotha_sil_dome"
            })
        end,
        
        JMCG_TeleportToMalacathsDomain = function(data)
            print("[QUEST_MONITOR_PLAYER] Firing teleport to Malacath's Domain via Universal Travel")
            
            -- Use Universal Travel system for teleport
            core.sendGlobalEvent("UT_Travel", {
                network = "bards_guild",
                destination = "malacaths_domain"
            })
        end
    }
}
