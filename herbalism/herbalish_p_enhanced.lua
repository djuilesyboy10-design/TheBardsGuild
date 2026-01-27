local core = require('openmw.core')
local types = require('openmw.types')
local self = require('openmw.self')
local world = require('openmw.world')
local I = require('openmw.interfaces')
local ui = require('openmw.ui')
local okInput, input = pcall(require, 'openmw.input')
if not okInput then
    input = nil
end

local okAsync, async = pcall(require, 'openmw.async')
if not okAsync then
    async = nil
end

local API = I.SkillFramework

local SKILL_ID = "juilesy_herbalism"

print('[Herbalish] Enhanced herbalish_p module loaded (top-level)')

local didInitDebug = false
local didEventDebug = false

-- Enhanced seasonal and time-based modifiers
local function getSeasonalBonus()
    local month = math.floor((world.getGameTime() / (3600 * 24 * 30)) % 12) + 1
    
    -- Spring (1-3): +20% for new growth
    if month >= 1 and month <= 3 then return 1.2 end
    -- Summer (4-6): +30% for abundant plants
    if month >= 4 and month <= 6 then return 1.3 end
    -- Autumn (7-9): +40% for harvest season
    if month >= 7 and month <= 9 then return 1.4 end
    -- Winter (10-12): +10% for rare finds
    if month >= 10 or month <= 12 then return 1.1 end
    
    return 1.0
end

-- Time-based harvesting (bards are more attuned to nature at certain times)
local function getTimeBasedBonus()
    local hour = world.getGameTime() / 3600 % 24
    
    -- Early morning (5-7): Bards feel nature's awakening
    if hour >= 5 and hour < 7 then return 1.3 end
    -- Midday (11-13): Peak harvesting time
    if hour >= 11 and hour < 13 then return 1.2 end
    -- Evening (17-19): Nature's beauty inspires
    if hour >= 17 and hour < 19 then return 1.2 end
    -- Night (21-23): Rare night-blooming plants
    if hour >= 21 and hour < 23 then return 1.5 end
    
    return 1.0
end

-- Location-based bonuses
local function getLocationBonus()
    local cell = self.cell
    if not cell then return 1.0 end
    
    local cellName = cell.name:lower()
    
    -- Forests and natural areas
    if cellName:find("forest") or cellName:find("woods") or cellName:find("grove") then
        return 1.5
    -- Swamps and marshes
    elseif cellName:find("swamp") or cellName:find("marsh") or cellName:find("bog") then
        return 1.3
    -- Mountains and highlands
    elseif cellName:find("mountain") or cellName:find("highland") then
        return 1.2
    -- Farms and plantations
    elseif cellName:find("farm") or cellName:find("plantation") then
        return 1.4
    -- Dungeons and caves (rare finds)
    elseif cellName:find("cave") or cellName:find("dungeon") or cellName:find("mine") then
        return 1.6
    end
    
    return 1.0
end

-- Enhanced registration with better description
local function registerHerbalism()
    if not didInitDebug then
        didInitDebug = true
        print('[Herbalish] Enhanced herbalish_p loaded')
    end

    if not API then
        print("[Herbalish] SkillFramework not found")
        return
    end

    if API.getSkillRecord and API.getSkillRecord(SKILL_ID) then
        return
    end

    API.registerSkill(SKILL_ID, {
        name = "Herbalism",
        description = "The ancient art of gathering and understanding plants. Bards find inspiration in nature's wisdom, while herbalists seek the healing properties of Morrowind's flora. Skill increases with successful harvesting and seasonal awareness.",
        icon = { fgr = "icons/bard/Herbal.dds" },
        attribute = "intelligence",
        specialization = API.SPECIALIZATION.Stealth,
        startLevel = 5,
        maxLevel = 100,
        statsWindowProps = { subsection = "Nature" },
        
        skillGain = {
            [1] = 1.0
        }
    })

    print("[Herbalish] Enhanced skill registered successfully")
end

-- Enhanced XP calculation with multiple factors
local function calculateEnhancedXP(baseAmount, recordId)
    local seasonalBonus = getSeasonalBonus()
    local timeBonus = getTimeBasedBonus()
    local locationBonus = getLocationBonus()
    
    -- Plant rarity based on record ID
    local rarityBonus = 1.0
    local recordIdLower = recordId:lower()
    
    -- Rare plants give more XP
    if recordIdLower:find("trama") or recordIdLower:find("shroom") then
        rarityBonus = 1.5
    elseif recordIdLower:find("com_") or recordIdLower:find("ingred_") then
        rarityBonus = 1.3
    end
    
    local totalMultiplier = seasonalBonus * timeBonus * locationBonus * rarityBonus
    local finalAmount = math.floor(baseAmount * totalMultiplier)
    
    return finalAmount, {
        seasonal = seasonalBonus,
        time = timeBonus,
        location = locationBonus,
        rarity = rarityBonus
    }
end

return {
    eventHandlers = {
        HerbalismHarvest = function(data)
            if not API then
                print('[Herbalish] HerbalismHarvest received but SkillFramework not found')
                return
            end

            local amount = (data and data.amount) or 0
            if amount <= 0 then
                return
            end

            local recordId = (data and data.recordId) or "unknown"
            local finalAmount, bonuses = calculateEnhancedXP(amount, recordId)

            local beforeStat = API.getSkillStat and API.getSkillStat(SKILL_ID) or nil
            local beforeBase = beforeStat and beforeStat.base or nil
            local beforeProgress = beforeStat and beforeStat.progress or nil

            API.skillUsed(SKILL_ID, { useType = 1, scale = finalAmount })

            local afterStat = API.getSkillStat and API.getSkillStat(SKILL_ID) or nil
            local afterBase = afterStat and afterStat.base or nil
            local afterProgress = afterStat and afterStat.progress or nil

            didEventDebug = true
            print(string.format(
                '[Herbalish] Enhanced harvest: %s | XP: %d | Bonuses: S%.1f T%.1f L%.1f R%.1f | base %s->%s | progress %s->%s',
                recordId, finalAmount,
                bonuses.seasonal, bonuses.time, bonuses.location, bonuses.rarity,
                tostring(beforeBase), tostring(afterBase),
                tostring(beforeProgress), tostring(afterProgress)
            ))
            
            -- Bard inspiration chance (30% base, higher with rare plants)
            local inspirationChance = 0.3
            if bonuses.rarity > 1.2 then
                inspirationChance = math.min(0.5, 0.3 + (bonuses.rarity - 1.0) * 0.2)
            end
            
            if math.random() < inspirationChance then
                local inspirationAmount = math.floor(finalAmount * 2)
                -- Send inspiration to bard skill
                world.sendEvent("Bard_NatureInspiration", {
                    amount = inspirationAmount,
                    source = recordId,
                    context = "herbalism"
                })
                
                print(string.format('[Herbalism] Bard inspiration! +%d XP from %s', inspirationAmount, recordId))
            end
        end,
        
        HerbalismHarvest_Global = function(data)
            print(string.format('[Herbalish] Enhanced harvest (global): %s | XP: %d', 
                tostring(data and data.recordId), 
                math.floor((data and data.amount or 0) * getSeasonalBonus() * getTimeBasedBonus() * getLocationBonus())
            ))
        end,
        
        -- Bard inspiration event handler
        Bard_NatureInspiration = function(data)
            if not API then return end
            
            local amount = (data and data.amount) or 0
            if amount <= 0 then return end
            
            local source = (data and data.source) or "nature"
            local context = (data and data.context) or "unknown"
            
            API.skillUsed("bard_performance", { useType = 1, scale = amount })
            
            print(string.format('[Bard] Nature inspiration received: +%d XP from %s (%s)', amount, source, context))
        end
    },
    
    engineHandlers = {
        onInit = function()
            print('[Herbalish] Enhanced herbalish_p onInit')
            registerHerbalism()
        end,
        onLoad = registerHerbalism
    }
}
