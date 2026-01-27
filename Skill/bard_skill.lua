---@diagnostic disable: undefined-global
local types = require("openmw.types")
local self = require("openmw.self")
local I = require("openmw.interfaces")

---@type openmw.interfaces.SkillFramework
local API = I.SkillFramework

local SKILL_ID = "bard_performance"

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
        [1] = 1.0  -- XP gain multiplier for bard activities
    },

    statsWindowProps = {
        subsection = API.STATS_WINDOW_SUBSECTIONS.Arts 
    }
})

------------------------------------------------------------
-- 2. PASSIVES (STABLE)
------------------------------------------------------------
local lastAppliedLevel = -1
local currentSpeechBonus = 0
local currentSneakBonus = 0
local currentMysticBonus = 0

local function applyBardPassives()
    local stat = API.getSkillStat(SKILL_ID)
    if not stat then return end

    local level = stat.modified
    if level == lastAppliedLevel then return end

    local bonus = 5
    local skills = types.NPC.stats.skills

    skills.speechcraft(self).modifier =
        skills.speechcraft(self).modifier - currentSpeechBonus + bonus
    currentSpeechBonus = bonus

    skills.sneak(self).modifier =
        skills.sneak(self).modifier - currentSneakBonus + bonus
    currentSneakBonus = bonus

    skills.mysticism(self).modifier =
        skills.mysticism(self).modifier - currentMysticBonus + bonus
    currentMysticBonus = bonus

    lastAppliedLevel = level
end

------------------------------------------------------------
-- 3. BARD XP EVENTS
------------------------------------------------------------

-- Manual XP gain for testing
local function grantBardXP(amount, reason)
    if not API then return end
    if amount <= 0 then return end
    
    API.skillUsed(SKILL_ID, { useType = 1, scale = amount })
    print(string.format("[Bard XP] Gained %d XP from %s", amount, reason))
end

------------------------------------------------------------
-- 4. ENGINE HANDLERS
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
                grantBardXP(math.floor(amount / 2), "herbalism knowledge")
            end
        end
    },
    engineHandlers = {
        onFrame = applyBardPassives,
        onLoad = function(data)
            currentSpeechBonus = 0
            currentSneakBonus = 0
            currentMysticBonus = 0
            lastAppliedLevel = (data and data.lastAppliedLevel) or -1
            applyBardPassives()
        end,
        onSave = function()
            return { lastAppliedLevel = lastAppliedLevel }
        end
    }
}
