-- perk_trigger_event_listener.lua
-- Event listener for Universal Perk System
-- Part of the universal trigger framework

return {
    eventHandlers = {
        SkillLevelUp = function(e)
            if e.skillId == 'bard_performance' then
                print("[PERK_TRIGGER] Bard skill level up detected: " .. e.newLevel)
                require("scripts.engine.framework.effects.effect_modules.perk_effects").checkPerkUnlock(e.skillId, e.newLevel)
            end
        end,
        
        -- Future universal triggers (framework ready)
        ConversationComplete = function(e)
            print("[PERK_TRIGGER] Conversation completed: " .. e.topicId)
            require("scripts.engine.framework.effects.effect_modules.perk_effects").checkConversationPerk(e.npcId, e.topicId)
        end,
        
        QuestStageComplete = function(e)
            print("[PERK_TRIGGER] Quest stage completed: " .. e.questId)
            require("scripts.engine.framework.effects.effect_modules.perk_effects").checkQuestPerk(e.questId, e.stage)
        end
    }
}
