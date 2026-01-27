# Skill Framework API Documentation

The Skill Framework is a custom Lua-based system for adding new skills to OpenMW. This document provides a comprehensive reference for the API and usage patterns.

## Overview

The Skill Framework allows modders to:
- Register custom skills with full integration
- Define skill progression and XP gain
- Create skill books and training systems
- Add race and class modifiers
- Integrate with the stats window UI

## API Reference

### Core Module

```lua
local I = require("openmw.interfaces")
local API = I.SkillFramework
```

### Skill Registration

#### `API.registerSkill(skillId, skillProps)`

Registers a new custom skill.

**Parameters:**
- `skillId` (string): Unique identifier for the skill
- `skillProps` (table): Skill configuration properties

**Skill Properties:**
```lua
{
    name = "Skill Name",           -- Display name
    description = "Description",   -- Skill description
    icon = {                       -- Icon configuration
        fgr = "path/to/icon.dds"   -- Foreground texture
    },
    attribute = "strength",        -- Governing attribute
    specialization = API.SPECIALIZATION.Combat, -- Specialization
    startLevel = 5,                -- Starting level
    maxLevel = 100,                -- Maximum level
    skillGain = {                  -- XP gain multipliers
        [1] = 0.0,                 -- Use type 1 (numeric key)
    },
    statsWindowProps = {           -- UI placement
        subsection = API.STATS_WINDOW_SUBSECTIONS.Arts
    }
}
```

**Example:**
```lua
API.registerSkill("bard_performance", {
    name = "Lore Keeping",
    description = "Music, memory, persuasion, and myth...",
    icon = {
        fgr = "icons/bard/bard.dds",
    },
    attribute = "personality",
    specialization = API.SPECIALIZATION.Magic,
    startLevel = 5,
    maxLevel = 100,
    skillGain = {
        [1] = 0.0
    },
    statsWindowProps = {
        subsection = API.STATS_WINDOW_SUBSECTIONS.Arts 
    }
})
```

### Constants

#### Specializations
```lua
API.SPECIALIZATION.Combat    -- Combat skills
API.SPECIALIZATION.Magic     -- Magic skills  
API.SPECIALIZATION.Stealth   -- Stealth skills
```

#### Stats Window Subsections
```lua
API.STATS_WINDOW_SUBSECTIONS.Arts       -- Arts category
API.STATS_WINDOW_SUBSECTIONS.Combat     -- Combat category
API.STATS_WINDOW_SUBSECTIONS.Crafts     -- Crafts category
API.STATS_WINDOW_SUBSECTIONS.Language   -- Language category
API.STATS_WINDOW_SUBSECTIONS.Magic      -- Magic category
API.STATS_WINDOW_SUBSECTIONS.Misc       -- Misc category
API.STATS_WINDOW_SUBSECTIONS.Movement   -- Movement category
API.STATS_WINDOW_SUBSECTIONS.Nature     -- Nature category
API.STATS_WINDOW_SUBSECTIONS.Social     -- Social category
API.STATS_WINDOW_SUBSECTIONS.Theology   -- Theology category
```

### Skill Progression

#### `API.skillUsed(skillId, data)`

Called when a skill is used to grant XP.

**Parameters:**
- `skillId` (string): Skill identifier
- `data` (table): Usage data
  - `useType` (number): Type of usage (1-4)
  - `scale` (number): XP multiplier/scale

**Example:**
```lua
API.skillUsed("bard_performance", { 
    useType = 1, 
    scale = amount 
})
```

#### `API.getSkillStat(skillId)`

Retrieves skill statistics.

**Returns:**
- `stat` (table|nil): Skill stat object with properties:
  - `base` (number): Base skill level
  - `modified` (number): Modified skill level
  - `progress` (number): Progress to next level
  - `progressRequirement` (number): XP needed for next level

### Skill Books

#### `API.registerSkillBook(bookId, skillId, props)`

Registers a custom skill book.

**Parameters:**
- `bookId` (string): Book item ID
- `skillId` (string): Skill to increase
- `props` (table): Book properties

### Race and Class Modifiers

#### `API.addRaceModifier(skillId, raceId, amount)`

Adds a racial bonus to a skill.

#### `API.addClassModifier(skillId, classId, amount)`

Adds a class bonus to a skill.

## Implementation Patterns

### Basic Skill Structure

```lua
---@diagnostic disable: undefined-global
local types = require("openmw.types")
local self = require("openmw.self")
local I = require("openmw.interfaces")

---@type openmw.interfaces.SkillFramework
local API = I.SkillFramework

local SKILL_ID = "your_skill_id"

-- 1. SKILL REGISTRATION
API.registerSkill(SKILL_ID, {
    -- skill properties
})

-- 2. PASSIVE EFFECTS
local function applyPassives()
    local stat = API.getSkillStat(SKILL_ID)
    if not stat then return
    
    local level = stat.modified
    -- Apply passive bonuses based on level
end

-- 3. ENGINE HANDLERS
return {
    engineHandlers = {
        onFrame = applyPassives,
        onLoad = function(data)
            -- Load saved state
        end,
        onSave = function()
            -- Save state
            return {}
        end
    }
}
```

### XP Gain Patterns

#### Event-Based XP
```lua
return {
    eventHandlers = {
        YourEvent = function(data)
            if not API then return end
            
            local amount = (data and data.amount) or 0
            if amount <= 0 then return end
            
            API.skillUsed(SKILL_ID, { useType = 1, scale = amount })
        end
    }
}
```

#### Time-Based XP
```lua
local lastXPTime = 0

local function onFrame()
    local currentTime = getGameTime()
    if currentTime - lastXPTime > 3600 then -- 1 hour
        API.skillUsed(SKILL_ID, { useType = 1, scale = 1 })
        lastXPTime = currentTime
    end
end
```

## File Structure

Skills should be placed in `Lua/Skill/` directory:
```
Lua/
└── Skill/
    ├── bard_skill.lua
    ├── your_skill.lua
    └── another_skill.lua
```

## Best Practices

1. **Use numeric keys for skillGain**: Always use `[1] = 0.0` format
2. **Save state properly**: Implement onLoad/onSave for persistent data
3. **Check for API existence**: Always check `if not API then return end`
4. **Use type annotations**: Add EmmyLua type hints for better IDE support
5. **Handle edge cases**: Check for nil values and invalid states

## Integration Examples

### Passive Bonuses
```lua
local function applyBonuses()
    local stat = API.getSkillStat(SKILL_ID)
    if not stat then return end
    
    local level = stat.modified
    local bonus = math.floor(level / 10) -- 1 bonus per 10 levels
    
    -- Apply to vanilla skills
    types.NPC.stats.skills.speechcraft(self).modifier = 
        types.NPC.stats.skills.speechcraft(self).modifier + bonus
end
```

### Skill Progression
```lua
local function calculateProgress(level)
    -- Custom progression formula
    return level * 100 + math.pow(level, 1.5) * 10
end
```

## Troubleshooting

### Common Issues

1. **Skill not appearing**: Check skillId uniqueness and registration
2. **XP not gaining**: Verify skillUsed call and useType values
3. **UI placement**: Ensure subsection is valid
4. **Save corruption**: Implement proper onLoad/onSave handlers

### Debug Tips

```lua
-- Add debug prints
print(string.format("[Skill] %s: level=%d, progress=%.2f", 
    SKILL_ID, stat.modified, stat.progress))

-- Check API availability
if not API then
    print("[Skill] SkillFramework API not available")
    return
end
```

## Version Compatibility

- **API Version**: 2 (current)
- **OpenMW**: 0.47+
- **Lua**: 5.1 compatible

See the [bard_skill.lua](../Lua/Skill/bard_skill.lua) for a complete working example.
