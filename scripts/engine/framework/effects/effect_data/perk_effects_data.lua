-- perk_effects_data.lua
-- Universal Perk Effects Data
-- Defines perk-effect combinations for the Universal Effects Framework

local perkEffects = {
    -- Level 25 - The Muse's Whisper
    muse_whisper = {
        level = 25,
        skillId = 'bard_performance',
        name = "The Muse's Whisper",
        description = "Channel Hermaeus Mora's gift - hear the true intent behind words and unlock hidden dialogue paths",
        effects = {
            {
                type = 'dialogue',
                data = {effectId = 'hidden_dialogue_unlock'},
                description = 'Hidden dialogue paths become available with NPCs'
            },
            {
                type = 'reputation',
                data = {effectId = 'hermaeus_blessing'},
                description = 'Subtle reputation boost with those who sense your insight'
            }
        },
        hidden = true, -- Only revealed when unlocked
        requirements = {
            skill = 'bard_performance',
            level = 25
        }
    },
    
    -- Level 50 - The Echo Weaver
    echo_weaver = {
        level = 50,
        skillId = 'bard_performance',
        name = "The Echo Weaver",
        description = "Walk through the halls of spoken words - access conversations from the past and weave them into present influence",
        effects = {
            {
                type = 'dialogue',
                data = {effectId = 'conversation_memory_access'},
                description = 'Reference past conversations to gain trust and information'
            },
            {
                type = 'reputation',
                data = {effectId = 'echo_credibility_bonus'},
                description = 'NPCs remember your previous encounters more clearly'
            },
            {
                type = 'storage',
                data = {effectId = 'conversation_logging_enable'},
                description = 'Begin recording all conversations for future reference'
            }
        },
        hidden = true,
        requirements = {
            skill = 'bard_performance',
            level = 50,
            perk = 'muse_whisper' -- Requires previous perk
        }
    },
    
    -- Level 75 - The Story Shaper
    story_shaper = {
        level = 75,
        skillId = 'bard_performance',
        name = "The Story Shaper",
        description = "Sing new possibilities into existence - your performances literally reshape reality and quest outcomes",
        effects = {
            {
                type = 'dialogue',
                data = {effectId = 'reality_warping_options'},
                description = 'Unique dialogue options appear that can alter quest outcomes'
            },
            {
                type = 'weather',
                data = {effectId = 'story_influenced_weather'},
                description = 'The environment responds to the emotional tone of your performances'
            },
            {
                type = 'schedule',
                data = {effectId = 'narrative_schedule_shifts'},
                description = 'NPC schedules may change based on the stories you tell'
            },
            {
                type = 'reputation',
                data = {effectId = 'reality_shaper_fame'},
                description = 'Your reputation as a reality weaver spreads across Vvardenfell'
            }
        },
        hidden = true,
        requirements = {
            skill = 'bard_performance',
            level = 75,
            perk = 'echo_weaver' -- Requires previous perk
        }
    }
}

-- Get perk effect data by ID
local function getPerkEffect(perkId)
    print("[PERK_DATA] Getting perk effect for: " .. tostring(perkId))
    local perk = perkEffects[perkId]
    if perk then
        print("[PERK_DATA] Found perk: " .. perk.name .. " at level " .. perk.level)
    else
        print("[PERK_DATA] ERROR: Perk not found: " .. tostring(perkId))
    end
    return perk
end

-- Get all available perks for a skill level
local function getAvailablePerks(skillLevel, currentPerks)
    print("[PERK_DATA] Checking available perks for skill level " .. skillLevel)
    print("[PERK_DATA] Current perks: " .. (currentPerks and table.concat(currentPerks, ", ") or "none"))
    
    local available = {}
    
    for perkId, perkData in pairs(perkEffects) do
        -- Check if perk is already obtained
        if currentPerks and currentPerks[perkId] then
            print("[PERK_DATA] Skipping already obtained perk: " .. perkId)
            goto continue
        end
        
        -- Check skill level requirement
        if skillLevel >= perkData.level then
            print("[PERK_DATA] Level requirement met for " .. perkId .. " (need " .. perkData.level .. ", have " .. skillLevel .. ")")
            
            -- Check prerequisite perks
            local prereqMet = true
            if perkData.requirements.perk then
                prereqMet = currentPerks and currentPerks[perkData.requirements.perk] == true
                print("[PERK_DATA] Prerequisite check for " .. perkId .. ": " .. tostring(prereqMet))
            end
            
            if prereqMet then
                table.insert(available, {
                    id = perkId,
                    name = perkData.name,
                    description = perkData.description,
                    effects = perkData.effects,
                    level = perkData.level
                })
                print("[PERK_DATA] Available perk added: " .. perkData.name)
            end
        else
            print("[PERK_DATA] Level requirement NOT met for " .. perkId .. " (need " .. perkData.level .. ", have " .. skillLevel .. ")")
        end
        
        ::continue::
    end
    
    print("[PERK_DATA] Total available perks: " .. #available)
    return available
end

-- Get all perk effects (for debugging/modding reference)
local function listAllPerkEffects()
    print("[PERK_DATA] Listing all perk effects...")
    local list = {}
    for perkId, perkData in pairs(perkEffects) do
        table.insert(list, perkId)
        print("[PERK_DATA] Registered perk: " .. perkId .. " - " .. perkData.name)
    end
    print("[PERK_DATA] Total perks registered: " .. #list)
    return list
end

-- Debug function to test perk loading
local function debugPerkSystem()
    print("[PERK_DATA] ========== PERK SYSTEM DEBUG ==========")
    print("[PERK_DATA] Perk data file loaded successfully")
    print("[PERK_DATA] Registered perks:")
    
    for perkId, perkData in pairs(perkEffects) do
        print("[PERK_DATA]   - " .. perkId .. " (Level " .. perkData.level .. "): " .. perkData.name)
        print("[PERK_DATA]     Effects: " .. #perkData.effects .. " total")
        for i, effect in ipairs(perkData.effects) do
            print("[PERK_DATA]       " .. i .. ". " .. effect.type .. " -> " .. (effect.data and effect.data.effectId or "no effectId"))
        end
    end
    print("[PERK_DATA] ===========================================")
end

-- Initialize debug info
debugPerkSystem()

return {
    getPerkEffect = getPerkEffect,
    getAvailablePerks = getAvailablePerks,
    listAllPerkEffects = listAllPerkEffects,
    debugPerkSystem = debugPerkSystem
}
