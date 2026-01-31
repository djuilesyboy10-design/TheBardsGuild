# SkillFramework - Core System Analysis

## 🎯 Overview
SkillFramework is a comprehensive custom skill system for OpenMW that allows modders to add new skills with full integration into the vanilla game systems.

## 📁 Architecture

### Core Files Structure
```
SkillFramework/
├── api.lua           # Main API interface
├── actor.lua         # Actor-specific functionality  
├── global.lua        # Global script management
├── types.lua         # Type definitions
├── config/           # Configuration settings
├── settings/         # User preferences
└── util/             # Utility functions
```

### Load Order
1. **global.lua** - Initializes global systems
2. **actor.lua** - Handles player/NPC skill data
3. **api.lua** - Exposes public interface
4. **types.lua** - Defines data structures

## 🔍 Core Patterns

### 1. Interface Pattern
```lua
-- Clean API exposure
I.SkillFramework = {
    registerSkill = function(skillId, props) end,
    skillUsed = function(skillId, data) end,
    getSkillStat = function(skillId) end,
    -- ... other methods
}
```

### 2. Skill Registration Pattern
```lua
API.registerSkill(skillId, {
    name = "Skill Name",
    description = "Description",
    icon = { fgr = "path/icon.dds" },
    attribute = "strength",
    specialization = API.SPECIALIZATION.Combat,
    startLevel = 5,
    maxLevel = 100,
    skillGain = { [1] = 1.0 },
    statsWindowProps = {
        subsection = API.STATS_WINDOW_SUBSECTIONS.Arts
    }
})
```

### 3. Data Management Pattern
```lua
-- Centralized skill data storage
local customSkills = {}
local skillStats = {}

-- Per-actor skill tracking
local function getActorSkills(actor)
    if not actorSkills[actor] then
        actorSkills[actor] = {}
    end
    return actorSkills[actor]
end
```

### 4. Event System Pattern
```lua
-- XP gain events
API.skillUsed(SKILL_ID, { 
    useType = 1, 
    scale = amount 
})

-- Progression tracking
local function updateSkillProgress(actor, skillId, amount)
    -- Calculate progress, handle level ups
end
```

## 🔗 Integration Points

### With Vanilla Systems
- **Stats Window** - Custom skill display
- **Level Up System** - Skill progression
- **Attribute Modifiers** - Governing attributes
- **Save System** - Persistent skill data

### With Other Mods
- **StatsWindow** mod integration
- **Character sheet** enhancements
- **Progression calculators**

## 💡 Key Innovations

### 1. Modular Skill System
- **Clean registration** - Easy to add new skills
- **Standardized interface** - Consistent behavior
- **Extensible architecture** - Room for growth

### 2. Progression Flexibility
```lua
-- Custom progression formulas
skillGain = {
    [1] = 1.0,    -- Base multiplier
    [2] = 0.5,    -- Secondary multiplier
    -- Can be extended
}
```

### 3. Save Compatibility
```lua
-- Clean save/load handling
engineHandlers = {
    onLoad = function(data)
        -- Restore skill state
    end,
    onSave = function()
        -- Save only necessary data
    end
}
```

### 4. Performance Optimization
```lua
-- Efficient updates
local function updateSkills(actor)
    -- Batch updates
    -- Throttled calculations
end
```

## 📚 Technical Deep Dive

### Skill Data Structure
```lua
skillStat = {
    base = 5,              -- Base skill level
    modified = 5,         -- Current level (with bonuses)
    progress = 0.0,       -- Progress to next level
    progressRequirement = 100.0  -- XP needed for next level
}
```

### XP Calculation Formula
```lua
-- Standard progression (likely)
local function calculateProgressRequirement(level)
    return level * 100 + math.pow(level, 1.5) * 10
end
```

### Integration with Stats Window
```lua
-- How skills appear in character sheet
statsWindowProps = {
    subsection = API.STATS_WINDOW_SUBSECTIONS.Arts,
    -- Custom display properties
}
```

## 🎯 Your Bard Skill Integration

### How Your Skill Uses Framework
```lua
-- 1. Registration (✅ Done)
API.registerSkill("bard_performance", {
    -- Skill properties
})

-- 2. XP Gain (✅ Fixed)
API.skillUsed(SKILL_ID, { 
    useType = 1, 
    scale = amount 
})

-- 3. Progress Tracking (✅ Working)
local stat = API.getSkillStat(SKILL_ID)
```

### Advanced Integration Ideas
```lua
-- 1. Dynamic Progression
local function calculateBardProgress(activityType, amount)
    local multiplier = 1.0
    if activityType == "persuasion" then
        multiplier = 2.0  -- Persuasion gives more XP
    elseif activityType == "performance" then
        multiplier = 1.5
    end
    return amount * multiplier
end

-- 2. Skill Synergies
local function applySkillSynergies()
    local bardLevel = API.getSkillStat(SKILL_ID).modified
    local speechBonus = math.floor(bardLevel / 10)
    
    -- Apply to vanilla speechcraft
    types.NPC.stats.skills.speechcraft(self).modifier = 
        types.NPC.stats.skills.speechcraft(self).modifier + speechBonus
end

-- 3. Specialized Progression
local function specializedProgression(skillLevel)
    -- Bard skills progress differently
    if skillLevel < 20 then
        return skillLevel * 50  -- Faster early progression
    else
        return skillLevel * 150 + math.pow(skillLevel, 2)  -- Slower later
    end
end
```

## 🔧 Framework Extension Ideas

### 1. Skill Dependencies
```lua
-- Skills that require other skills
API.registerSkill("advanced_bard", {
    dependencies = { "bard_performance", minLevel = 50 },
    -- Other properties
})
```

### 2. Skill Trees
```lua
-- Branching skill progression
skillTree = {
    bard_performance = {
        lore_keeping = { requiredLevel = 25 },
        persuasion_mastery = { requiredLevel = 30 },
        musical_theory = { requiredLevel = 20 }
    }
}
```

### 3. Dynamic Skill Properties
```lua
-- Skills that change based on context
local function updateSkillProperties(context)
    if context.isInTavern then
        -- Bard skills are more effective
    end
end
```

## 🚀 Advanced Usage Patterns

### 1. Multi-Skill Systems
```lua
-- Skills that work together
local function calculateCombinedBonus()
    local bardLevel = API.getSkillStat("bard_performance").modified
    local speechLevel = types.NPC.stats.skills.speechcraft(self).base
    
    return math.floor((bardLevel + speechLevel) / 20)
end
```

### 2. Contextual XP
```lua
-- Different XP based on situation
local function getContextualXP(activity, context)
    local baseXP = activity.baseXP
    
    if context.location == "tavern" then
        baseXP = baseXP * 1.5  -- Tavern bonus
    end
    
    if context.audienceSize > 5 then
        baseXP = baseXP * 1.2  -- Audience bonus
    end
    
    return baseXP
end
```

### 3. Skill Specializations
```lua
-- Different bard specializations
local specializations = {
    storyteller = { bonus: "persuasion", modifier: 1.5 },
    musician = { bonus: "performance", modifier: 1.3 },
    scholar = { bonus: "lore", modifier: 1.4 }
}
```

## 🎓 Lessons for Your Mod

### ✅ Strengths to Leverage
1. **Clean API design** - Easy to extend and maintain
2. **Modular architecture** - Components work independently
3. **Save compatibility** - Robust data persistence
4. **Performance focus** - Efficient updates and calculations

### 🎯 Optimization Opportunities
1. **Batch skill updates** - Update multiple skills at once
2. **Context-aware progression** - XP based on situation
3. **Skill synergies** - Skills that enhance each other
4. **Dynamic balancing** - Adjust progression based on gameplay

### 🔮 Future Possibilities
1. **Skill trees** - Branching progression paths
2. **Skill dependencies** - Prerequisites for advanced skills
3. **Specialization system** - Focus on different bard aspects
4. **Master/apprentice system** - Teach skills to NPCs

## 📝 Personal Notes

### Key Insights
1. **Framework is well-designed** - Clean separation of concerns
2. **Extensible architecture** - Room for growth and customization
3. **Performance-conscious** - Designed for real-time gameplay
4. **Integration-friendly** - Works well with other mods

### Questions for Further Study
1. How does it handle skill conflicts between mods?
2. What's the maximum number of skills it can handle?
3. How does it calculate progression curves?
4. Can skills affect world state, not just player stats?

---

## 🚀 Next Steps

1. **Study the source code** in detail
2. **Experiment with extensions** - Add new features
3. **Document your discoveries** in PERSONAL_NOTES
4. **Build advanced systems** using the framework as base

This framework is the foundation of your entire bard system - master it, and you can build anything! 🎓✨
