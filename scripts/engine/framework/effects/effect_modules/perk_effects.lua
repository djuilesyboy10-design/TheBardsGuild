-- perk_effects.lua
-- Universal Perk Effects Module
-- Handles perk unlocking and effect dispatch

local perkEffectsData = require("scripts.engine.framework.effects.effect_data.perk_effects_data")
local universalEffectsEngine = require("scripts.engine.framework.effects.universal_effects_engine")
local storage = require('openmw.storage')

-- Register our effect handlers with the Universal Effects Engine
universalEffectsEngine.registerEffectHandler('dialogue', applyDialogueEffect)
universalEffectsEngine.registerEffectHandler('storage', applyStorageEffect)

-- Player storage for unlocked perks (save-specific with temporary lifetime)
local playerPerks = storage.playerSection('BardPerks')
playerPerks:setLifeTime(storage.LIFE_TIME.Temporary)

local function checkPerkUnlock(skillId, newLevel)
    print("[PERK_EFFECTS] Checking perk unlock for " .. skillId .. " level " .. newLevel)
    
    -- Get current unlocked perks
    local currentPerks = playerPerks:asTable() or {}
    
    -- Get available perks for this level
    local availablePerks = perkEffectsData.getAvailablePerks(newLevel, currentPerks)
    
    for _, perk in ipairs(availablePerks) do
        print("[PERK_EFFECTS] Unlocking perk: " .. perk.name)
        
        -- Mark perk as unlocked
        playerPerks:set(perk.id, true)
        currentPerks[perk.id] = true
        
        -- Show unlock message
        require("openmw.ui").showMessage("Perk Unlocked: " .. perk.name .. " - " .. perk.description)
        
        -- Dispatch all effects for this perk
        for _, effect in ipairs(perk.effects) do
            print("[PERK_EFFECTS] Dispatching effect: " .. effect.type .. " -> " .. (effect.data and effect.data.effectId or "no effectId"))
            universalEffectsEngine.processEffect(effect)
        end
    end
end

-- Future trigger functions (framework ready)
local function checkConversationPerk(npcId, topicId)
    print("[PERK_EFFECTS] Checking conversation-based perk unlock for " .. npcId .. " topic: " .. topicId)
    -- Future implementation for conversation-triggered perks
end

local function checkQuestPerk(questId, stage)
    print("[PERK_EFFECTS] Checking quest-based perk unlock for " .. questId .. " stage: " .. stage)
    -- Future implementation for quest-triggered perks
end

-- Apply dialogue effect (for perk system)
local function applyDialogueEffect(effectData)
    local effectId = effectData.effectId
    print("[PERK_EFFECTS] Applying dialogue effect: " .. effectId)
    
    if effectId == 'hidden_dialogue_unlock' then
        -- Set flag for hidden dialogue access
        local playerPerks = storage.playerSection('BardPerks')
        playerPerks:set('hasMuseWhisper', true)
        print("[PERK_EFFECTS] Hidden dialogue paths unlocked!")
        return true
    elseif effectId == 'conversation_memory_access' then
        -- Enable conversation memory system
        local playerPerks = storage.playerSection('BardPerks')
        playerPerks:set('hasEchoWeaver', true)
        print("[PERK_EFFECTS] Conversation memory access enabled!")
        return true
    elseif effectId == 'reality_warping_options' then
        -- Enable reality warping dialogue
        local playerPerks = storage.playerSection('BardPerks')
        playerPerks:set('hasStoryShaper', true)
        print("[PERK_EFFECTS] Reality warping dialogue options enabled!")
        return true
    end
    
    print("[PERK_EFFECTS] Unknown dialogue effect: " .. effectId)
    return false
end

-- Apply storage effect (for perk system)
local function applyStorageEffect(effectData)
    local effectId = effectData.effectId
    print("[PERK_EFFECTS] Applying storage effect: " .. effectId)
    
    if effectId == 'conversation_logging_enable' then
        -- Enable conversation logging
        local conversationLog = storage.globalSection('BardConversationLog')
        conversationLog:set('loggingEnabled', true)
        print("[PERK_EFFECTS] Conversation logging enabled!")
        return true
    end
    
    print("[PERK_EFFECTS] Unknown storage effect: " .. effectId)
    return false
end

-- Console test function to unlock perks instantly
local function testPerkUnlock(skillId, level)
    print("[PERK_EFFECTS] ========== PERK TEST ==========")
    print("[PERK_EFFECTS] Testing perk unlock for " .. skillId .. " at level " .. level)
    
    -- Simulate skill level up
    checkPerkUnlock(skillId, level)
    
    print("[PERK_EFFECTS] Test complete! Check your unlocked perks.")
    print("[PERK_EFFECTS] ===================================")
end

-- Console function to test specific perk
local function testMuseWhisper()
    print("[PERK_EFFECTS] Testing Muse's Whisper perk unlock...")
    testPerkUnlock('bard_performance', 25)
end

-- Console function to test Echo Weaver
local function testEchoWeaver()
    print("[PERK_EFFECTS] Testing Echo Weaver perk unlock...")
    -- First unlock Muse's Whisper if not already unlocked
    local currentPerks = playerPerks:asTable() or {}
    if not currentPerks.muse_whisper then
        print("[PERK_EFFECTS] Unlocking Muse's Whisper first...")
        playerPerks:set('muse_whisper', true)
    end
    testPerkUnlock('bard_performance', 50)
end

-- Console function to test Story Shaper
local function testStoryShaper()
    print("[PERK_EFFECTS] Testing Story Shaper perk unlock...")
    -- First unlock prerequisites if not already unlocked
    local currentPerks = playerPerks:asTable() or {}
    if not currentPerks.muse_whisper then
        playerPerks:set('muse_whisper', true)
    end
    if not currentPerks.echo_weaver then
        playerPerks:set('echo_weaver', true)
    end
    testPerkUnlock('bard_performance', 75)
end

-- Console function to reset all perks
local function resetPerks()
    print("[PERK_EFFECTS] Resetting all perks...")
    playerPerks:reset()
    print("[PERK_EFFECTS] All perks reset!")
end

-- Console function to show current perks
local function showPerks()
    print("[PERK_EFFECTS] ========== CURRENT PERKS ==========")
    local currentPerks = playerPerks:asTable()
    if currentPerks and next(currentPerks) then
        for perkId, _ in pairs(currentPerks) do
            local perkData = perkEffectsData.getPerkEffect(perkId)
            if perkData then
                print("[PERK_EFFECTS] " .. perkData.name .. " (Level " .. perkData.level .. ")")
            end
        end
    else
        print("[PERK_EFFECTS] No perks unlocked yet.")
    end
    print("[PERK_EFFECTS] ======================================")
end

local function debugPerkSystem()
    print("[PERK_EFFECTS] ========== PERK SYSTEM DEBUG ==========")
    print("[PERK_EFFECTS] Perk effects module loaded successfully")
    
    -- Test data loading
    local allPerks = perkEffectsData.listAllPerkEffects()
    print("[PERK_EFFECTS] Available perks: " .. #allPerks)
    
    -- Test storage
    local currentPerks = playerPerks:asTable()
    print("[PERK_EFFECTS] Current unlocked perks: " .. (currentPerks and table.concat(currentPerks, ", ") or "none"))
    
    print("[PERK_EFFECTS] ===========================================")
end

-- Initialize debug info
debugPerkSystem()

return {
    eventHandlers = {
        -- Event handlers for perk system
    },
    engineHandlers = {
        -- Engine handlers if needed
    },
    interfaceName = "PerkEffects",
    interface = {
        checkPerkUnlock = checkPerkUnlock,
        checkConversationPerk = checkConversationPerk,
        checkQuestPerk = checkQuestPerk,
        applyDialogueEffect = applyDialogueEffect,
        applyStorageEffect = applyStorageEffect,
        debugPerkSystem = debugPerkSystem
    },
    -- Direct exports for console testing
    checkPerkUnlock = checkPerkUnlock,
    checkConversationPerk = checkConversationPerk,
    checkQuestPerk = checkQuestPerk,
    applyDialogueEffect = applyDialogueEffect,
    applyStorageEffect = applyStorageEffect,
    debugPerkSystem = debugPerkSystem
}
