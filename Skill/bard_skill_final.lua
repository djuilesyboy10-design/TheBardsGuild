---@diagnostic disable: undefined-global
local types = require("openmw.types")
local self = require("openmw.self")
local nearby = require("openmw.nearby")
local I = require("openmw.interfaces")

---@type openmw.interfaces.SkillFramework
local API = I.SkillFramework

local SKILL_ID = "bard_performance"

------------------------------------------------------------
-- UTILITY FUNCTIONS (must be defined before use)
------------------------------------------------------------

local function generatePerformanceNarrative(quality, location)
    local narratives = {
        excellent = {
            tavern = "The tavern falls silent, mesmerized by your performance. Coins jingle in appreciation - your tale has touched their hearts.",
            cornerclub = "Even the Dunmer patrons pause to listen, captivated by your words. The cornerclub feels more alive with your music.",
            temple = "Your sacred performance resonates with the divines. The temple atmosphere becomes more serene with your devotion.",
            guild = "Fellow guild members gather around, impressed by your knowledge. Your performance earns you respect among your peers.",
            default = "The crowd is completely captivated by your performance. Your artistry has left a lasting impression."
        },
        good = {
            tavern = "The audience nods appreciatively at your performance. A few coins find their way to your collection plate.",
            cornerclub = "The cornerclub patrons enjoy your performance. The atmosphere feels more pleasant with your music.",
            temple = "Your performance is well-received in the temple. The priests nod in appreciation of your devotion.",
            guild = "Your guild members acknowledge your performance. You've earned some recognition for your skills.",
            default = "The audience enjoys your performance. You've made a positive impression on those listening."
        },
        poor = {
            tavern = "The crowd barely notices your performance. A few polite nods, but minds wander elsewhere.",
            cornerclub = "The cornerclub patrons are mostly indifferent to your performance. Perhaps this wasn't the right time.",
            temple = "Your performance doesn't quite capture the temple's attention. The priests seem preoccupied.",
            guild = "Your guild members seem unimpressed. Perhaps you need more practice before performing for them.",
            default = "The audience doesn't seem engaged with your performance. Maybe you need a different approach."
        }
    }
    
    local locationKey = location:lower()
    local locationType = "default"
    
    if locationKey:find("tavern") then locationType = "tavern"
    elseif locationKey:find("cornerclub") then locationType = "cornerclub"
    elseif locationKey:find("temple") then locationType = "temple"
    elseif locationKey:find("guild") then locationType = "guild"
    end
    
    local pool = narratives[quality] and narratives[quality][locationType] or narratives.good.default
    return pool or narratives.good.default
end

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
-- 2. ENHANCED PASSIVES WITH TIME/LOCATION AWARENESS
------------------------------------------------------------
local lastAppliedLevel = -1
local currentSpeechBonus = 0
local currentSneakBonus = 0
local currentMysticBonus = 0

-- Time-based bonus calculation
local function getTimeBasedBonus()
    local hour = 0 -- Placeholder - will be implemented properly
    return 1.0
end

-- Location-based bonus calculation
local function getLocationBonus()
    local cell = self.cell
    if not cell then return 1.0 end
    
    local cellName = cell.name:lower()
    
    -- Taverns are perfect for bards
    if cellName:find("tavern") or cellName:find("inn") then
        return 1.5
    -- Cornerclubs are social hubs
    elseif cellName:find("cornerclub") then
        return 1.3
    -- Temples appreciate sacred music
    elseif cellName:find("temple") then
        return 1.2
    -- Guild halls appreciate knowledge
    elseif cellName:find("guild") then
        return 1.1
    -- Neutral locations
    else
        return 1.0
    end
end

-- Audience size calculation
local function getAudienceCount()
    local count = 0
    local scanRadius = 1000 -- 10 units = approximately 1 meter
    
    for _, actor in pairs(nearby.actors) do
        if actor.type == types.NPC then
            local distance = (actor.position - self.position):length()
            if distance <= scanRadius then
                -- Count NPCs that can "hear" the performance
                count = count + 1
            end
        end
    end
    
    return count
end

-- Enhanced passive application
local function applyBardPassives()
    local stat = API.getSkillStat(SKILL_ID)
    if not stat then return end

    local level = stat.modified
    if level == lastAppliedLevel then return end

    -- Calculate bonuses with context
    local timeBonus = getTimeBasedBonus()
    local locationBonus = getLocationBonus()
    local audienceCount = getAudienceCount()
    local audienceBonus = math.min(math.floor(audienceCount / 5), 10) -- Max +10 from audience
    
    local baseBonus = math.floor(level / 10) -- 1 bonus per 10 levels
    local contextualBonus = math.floor(baseBonus * timeBonus * locationBonus) + audienceBonus
    
    local skills = types.NPC.stats.skills

    -- Apply speechcraft bonus
    skills.speechcraft(self).modifier =
        skills.speechcraft(self).modifier - currentSpeechBonus + contextualBonus
    currentSpeechBonus = contextualBonus

    -- Apply sneak bonus (bards need to be subtle)
    skills.sneak(self).modifier =
        skills.sneak(self).modifier - currentSneakBonus + contextualBonus
    currentSneakBonus = contextualBonus

    -- Apply mysticism bonus (magical performances)
    skills.mysticism(self).modifier =
        skills.mysticism(self).modifier - currentMysticBonus + contextualBonus
    currentMysticBonus = contextualBonus

    lastAppliedLevel = level
    
    -- Debug output
    print(string.format("[Bard] Passives updated - Level: %d, Time: %.1fx, Location: %.1fx, Audience: %d, Total Bonus: %d", 
        level, timeBonus, locationBonus, audienceCount, contextualBonus))
end

------------------------------------------------------------
-- 3. ENHANCED XP GAIN WITH CONTEXT
------------------------------------------------------------

-- Enhanced XP gain with contextual bonuses
local function grantBardXP(amount, reason, context)
    if not API then return end
    if amount <= 0 then return end
    
    -- Apply contextual multipliers
    local timeBonus = getTimeBasedBonus()
    local locationBonus = getLocationBonus()
    local audienceBonus = math.min(getAudienceCount() / 10, 2.0) -- Max 2x from audience
    
    local totalMultiplier = timeBonus * locationBonus * audienceBonus
    local finalAmount = math.floor(amount * totalMultiplier)
    
    API.skillUsed(SKILL_ID, { useType = 1, scale = finalAmount })
    
    print(string.format("[Bard XP] Gained %d XP from %s (Time: %.1fx, Location: %.1fx, Audience: %.1fx)", 
        finalAmount, reason, timeBonus, locationBonus, audienceBonus))
end

------------------------------------------------------------
-- 4. EVENT HANDLERS
------------------------------------------------------------
return {
    eventHandlers = {
        ---@param data table
        BardPerformance = function(data)
            local amount = (data and data.amount) or 1
            local quality = (data and data.quality) or "good"
            local location = (data and data.location) or "unknown"
            
            -- Different XP based on performance quality
            local qualityMultiplier = quality == "excellent" and 2.0 or
                                 quality == "good" and 1.0 or
                                 quality == "poor" and 0.5 or 1.0
            
            grantBardXP(amount * qualityMultiplier, "performance", {
                quality = quality,
                location = location
            })
            
            -- Show performance result using your ballad helper
            if data.showResult then
                local resultText = generatePerformanceNarrative(quality, location)
                require("scripts.engine.ballad_helper").showResult(resultText)
            end
        end,
        
        ---@param data table
        PersuasionSuccess = function(data)
            local amount = (data and data.amount) or 1
            local difficulty = (data and data.difficulty) or "normal"
            
            -- Persuasion gives more XP based on difficulty
            local difficultyMultiplier = difficulty == "hard" and 2.0 or
                                      difficulty == "normal" and 1.0 or
                                      difficulty == "easy" and 0.5 or 1.0
            
            grantBardXP(amount * difficultyMultiplier * 2, "persuasion", {
                difficulty = difficulty
            })
        end,
        
        ---@param data table
        TaleTold = function(data)
            local amount = (data and data.amount) or 1
            local listeners = (data and data.listeners) or 1
            local impact = (data and data.impact) or "minor"
            
            -- Tales scale with audience size and impact
            local audienceMultiplier = math.min(listeners / 3, 3.0) -- Max 3x from audience
            local impactMultiplier = impact == "major" and 2.0 or
                                 impact == "minor" and 1.0 or 1.0
            
            grantBardXP(amount * audienceMultiplier * impactMultiplier, "tale told", {
                listeners = listeners,
                impact = impact
            })
        end,
        
        ---@param data table
        SongComposed = function(data)
            local amount = (data and data.amount) or 3
            local complexity = (data and data.complexity) or "simple"
            
            -- Composition gives significant XP
            local complexityMultiplier = complexity == "masterpiece" and 3.0 or
                                      complexity == "complex" and 2.0 or
                                      complexity == "simple" and 1.0 or 1.0
            
            grantBardXP(amount * complexityMultiplier, "song composed", {
                complexity = complexity
            })
        end,
        
        ---@param data table
        LoreResearched = function(data)
            local amount = (data and data.amount) or 2
            local discovery = (data and data.discovery) or "minor"
            
            -- Research gives good XP for knowledge preservation
            local discoveryMultiplier = discovery == "major" and 2.0 or
                                       discovery == "minor" and 1.0 or 1.0
            
            grantBardXP(amount * discoveryMultiplier, "lore researched", {
                discovery = discovery
            })
        end,
        
        ---@param data HarvestData
        HerbalismHarvest = function(data)
            -- Bards find inspiration in nature
            local amount = (data and data.amount) or 0
            if amount <= 0 then return end
            
            -- 30% chance to find inspiration
            if math.random() < 0.3 then
                local inspirationAmount = math.floor(amount * 2)
                grantBardXP(inspirationAmount, "nature inspiration", {
                    source = "herbalism"
                })
            end
        end,
        
        ---@param data table
        BardPerformanceResult = function(data)
            -- Handle performance result from menu system
            if not data or not data.outcome then return end
            
            local outcome = data.outcome
            local location = data.location or "unknown"
            local audience = data.audience or 0
            local performanceId = data.performanceId or 1
            
            -- Apply XP bonus based on outcome
            local baseXP = 10 -- Base XP for any performance
            local finalXP = math.floor(baseXP * outcome.xpBonus)
            
            -- Apply contextual bonuses
            local timeBonus = getTimeBasedBonus()
            local locationBonus = getLocationBonus()
            local audienceBonus = math.min(audience / 10, 2.0)
            
            local totalMultiplier = timeBonus * locationBonus * audienceBonus
            local finalAmount = math.floor(finalXP * totalMultiplier)
            
            API.skillUsed(SKILL_ID, { useType = 1, scale = finalAmount })
            
            print(string.format("[Bard] Performance Result: %s | XP: %d | Bonuses: T%.1fx L%.1fx A%.1fx", 
                outcome.name, finalAmount, timeBonus, locationBonus, audienceBonus))
            
            -- Show performance narrative
            local resultText = string.format("%s\n\n%s\n\nLocation: %s\nAudience: %d people", 
                outcome.name, outcome.description, location, audience)
            require("scripts.engine.ballad_helper").showResult(resultText)
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
