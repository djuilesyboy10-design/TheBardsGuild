---@diagnostic disable: undefined-global
local types = require("openmw.types")
local self = require("openmw.self")
local I = require("openmw.interfaces")

---@type openmw.interfaces.SkillFramework
local API = I.SkillFramework

local SKILL_ID = "bard_performance"

------------------------------------------------------------
-- UTILITY FUNCTIONS (must be defined before use)
------------------------------------------------------------

------------------------------------------------------------
-- 1. SKILL REGISTRATION
------------------------------------------------------------

API.registerSkill(SKILL_ID, {
    name = "Lore Keeping",
    description = "Music, memory, persuasion, and myth; these are the threads used to weave the tapestry of existence. Through the mastery of every craft, the artisan ensures that no truth is forgotten and no beauty remains unspoken.",

    icon = {
        fgr = "icons/bard/bard.dds",
    },

    attribute = "personality",
    specialization = API.SPECIALIZATION.Magic,
    startLevel = 5,
    maxLevel = 100,

    skillGain = {
        [1] = 0.0  -- XP gain multiplier for bard activities
    },

    statsWindowProps = {
        subsection = API.STATS_WINDOW_SUBSECTIONS.Arts 
    }
})



------------------------------------------------------------
-- 2. TIERED PASSIVE BONUS SYSTEM
------------------------------------------------------------
local lastAppliedLevel = -1
local currentSpeechBonus = 0
local currentSneakBonus = 0
local currentMysticBonus = 0
local currentIllusionBonus = 0
local currentAcrobaticsBonus = 0

-- Enhanced passive application with tiered scaling
local function applyBardPassives()
    local stat = API.getSkillStat(SKILL_ID)
    if not stat then return end

    local level = stat.modified
    if level == lastAppliedLevel then return end

    -- Tiered scaling with +5 increments every 25 levels (from bard_skill.lua)
    local bonus = level < 25 and 5 or
                  level < 50 and 10 or
                  level < 75 and 15 or 20
    
    print("[BARD_PASSIVES] Applying tiered bonus: " .. bonus .. " (at level " .. level .. ")")
    local skills = types.NPC.stats.skills

    print("[BARD_PASSIVES] Applying speechcraft bonus...")
    skills.speechcraft(self).modifier =
        skills.speechcraft(self).modifier - currentSpeechBonus + bonus
    currentSpeechBonus = bonus
    print("[BARD_PASSIVES] Speechcraft modifier now: " .. skills.speechcraft(self).modifier)

    print("[BARD_PASSIVES] Applying sneak bonus...")
    skills.sneak(self).modifier =
        skills.sneak(self).modifier - currentSneakBonus + bonus
    currentSneakBonus = bonus
    print("[BARD_PASSIVES] Sneak modifier now: " .. skills.sneak(self).modifier)

    print("[BARD_PASSIVES] Applying mysticism bonus...")
    skills.mysticism(self).modifier =
        skills.mysticism(self).modifier - currentMysticBonus + bonus
    currentMysticBonus = bonus
    print("[BARD_PASSIVES] Mysticism modifier now: " .. skills.mysticism(self).modifier)

    -- Add the missing skills from bard_skill.lua
    print("[BARD_PASSIVES] Applying illusion bonus...")
    skills.illusion(self).modifier =
        skills.illusion(self).modifier - currentIllusionBonus + bonus
    currentIllusionBonus = bonus
    print("[BARD_PASSIVES] Illusion modifier now: " .. skills.illusion(self).modifier)

    print("[BARD_PASSIVES] Applying acrobatics bonus...")
    skills.acrobatics(self).modifier =
        skills.acrobatics(self).modifier - currentAcrobaticsBonus + bonus
    currentAcrobaticsBonus = bonus
    print("[BARD_PASSIVES] Acrobatics modifier now: " .. skills.acrobatics(self).modifier)

    lastAppliedLevel = level
    print("[BARD_PASSIVES] Passives applied successfully!")
end

-- Register level-up event handler for instant passive updates (from bard_skill.lua)
API.addSkillLevelUpHandler(function(skillId, source, options)
    if skillId == SKILL_ID then
        print("[BARD_PASSIVES] Bard skill leveled up! Applying passives...")
        applyBardPassives()
    end
end)

-- Simple XP gain function (contextual features removed for performance)
local function grantBardXP(amount, reason)
    if not API then return end
    if amount <= 0 then return end
    
    API.skillUsed(SKILL_ID, { useType = 1, scale = amount })


    print(string.format("[Bard XP] Gained %d XP from %s", amount, reason))
end

------------------------------------------------------------
-- 4. EVENT HANDLERS
------------------------------------------------------------
return {
    eventHandlers = {
        ---@param data table
        BardPerformance = function(data)
            local amount = (data and data.amount) or 1
            grantBardXP(amount, "performance")
        end,
        
        ---@param data table
        PersuasionSuccess = function(data)
            local amount = (data and data.amount) or 1
            grantBardXP(amount * 2, "persuasion")
        end,
        
        ---@param data table
        TaleTold = function(data)
            local amount = (data and data.amount) or 1
            grantBardXP(amount, "tale told")
        end,
        
        ---@param data table
        SongComposed = function(data)
            local amount = (data and data.amount) or 3
            grantBardXP(amount, "song composed")
        end,
        
        ---@param data table
        LoreResearched = function(data)
            local amount = (data and data.amount) or 2
            grantBardXP(amount, "lore researched")
        end,
        
        -- Keep herbalism for now as a fallback
        ---@param data HarvestData
        HerbalismHarvest = function(data)
            local amount = (data and data.amount) or 0
            if amount > 0 then
                -- Reduced XP: 25% of harvest amount (no minimum to prevent abuse)
                local xpGain = amount * 0.25
                if xpGain >= 0.1 then  -- Only grant if meaningful XP
                    grantBardXP(xpGain, "herbalism knowledge")
                end
            end
        end,
        
        ---@param data table
        AlchemyCrafted = function(data)
            local amount = (data and data.amount) or 1
            grantBardXP(amount, "alchemy knowledge")
        end
    },
    
    engineHandlers = {`n        onFrame = applyBardPassives,
        onLoad = function(data)
            currentSpeechBonus = 0
            currentSneakBonus = 0
            currentMysticBonus = 0
            currentIllusionBonus = 0
            currentAcrobaticsBonus = 0
            lastAppliedLevel = (data and data.lastAppliedLevel) or -1
            -- Apply passives on load to ensure they're active
            applyBardPassives()
        end,
        onSave = function()
            return { lastAppliedLevel = lastAppliedLevel }
        end
    }
}
