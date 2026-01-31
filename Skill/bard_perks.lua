local I = require('openmw.interfaces')
local types = require('openmw.types')
local self = require('openmw.self')
local ui = require('openmw.ui')

local SKILL_ID = 'bard_performance'
local lastKnownLevel = -1

local perkLevels = {
    25, 50, 75
}

local function checkForPerk(level)
    if level == 25 then
        ui.showMessage('Perk Unlocked: Silver Tongue - +10 to Speechcraft and Persuasion attempts')
        -- Apply passive bonus
        local speechcraft = types.NPC.stats.skills.speechcraft(self)
        speechcraft.base = speechcraft.base + 10
    elseif level == 50 then
        ui.showMessage('Perk Unlocked: Memory Weaver - Rumor quests now reveal extra details')
        -- Could set a global flag or send event to other systems
        if I and I.SkillProgression and I.SkillProgression.skillUsed then
            I.SkillProgression.skillUsed('speechcraft', { skillGain = 0.1 })
        end
    elseif level == 75 then
        ui.showMessage('Perk Unlocked: Chronicler\'s Insight - Unique dialogue options appear in major quests')
        -- Could set a global flag or send event to dialogue systems
        if I and I.SkillProgression and I.SkillProgression.skillUsed then
            I.SkillProgression.skillUsed('mysticism', { skillGain = 0.1 })
        end
    end
end

local function onSkillLevelUp(skillId, source, options)
    if skillId ~= SKILL_ID then return end
    
    local stat = I.SkillFramework and I.SkillFramework.getSkillStat(SKILL_ID)
    if not stat then return end
    
    local currentLevel = stat.base
    
    if currentLevel > lastKnownLevel then
        for _, level in ipairs(perkLevels) do
            if currentLevel >= level and lastKnownLevel < level then
                checkForPerk(level)
            end
        end
        lastKnownLevel = currentLevel
    end
end

return {
    eventHandlers = {
        skillLevelUp = onSkillLevelUp
    },
    engineHandlers = {
        onLoad = function(data)
            lastKnownLevel = (data and data.lastKnownLevel) or -1
        end,
        onSave = function()
            return { lastKnownLevel = lastKnownLevel }
        end
    }
}
