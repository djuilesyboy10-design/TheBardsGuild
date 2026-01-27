# OpenMW Lua Scripting Guide

This guide covers Lua scripting for OpenMW, focusing on the patterns and APIs used in The Bards Guild mod.

## OpenMW Lua Overview

OpenMW 0.47+ introduces Lua scripting support, allowing for complex modding behaviors without dirty edits to the game files. Lua scripts run in a sandboxed environment with access to game data through specific APIs.

## Core Modules

### Essential Modules

```lua
-- Core OpenMW modules
local core = require('openmw.core')
local self = require('openmw.self')
local types = require('openmw.types')
local util = require('openmw.util')
local nearby = require('openmw.nearby')
local async = require('openmw.async')
local camera = require('openmw.camera')
local input = require('openmw.input')
local ui = require('openmw.ui')
local storage = require('openmw.storage')
local time = require('openmw.time')
local world = require('openmw.world')
local auxUtil = require('openmw_aux.util')
```

### Interfaces

```lua
-- Access to mod interfaces
local I = require("openmw.interfaces")

-- Skill Framework interface
local skillAPI = I.SkillFramework
```

## Script Structure

### Basic Script Template

```lua
---@diagnostic disable: undefined-global

-- Required modules
local types = require("openmw.types")
local self = require("openmw.self")
local I = require("openmw.interfaces")

-- Constants
local SCRIPT_NAME = "my_script"
local VERSION = 1.0

-- State variables
local lastUpdateTime = 0
local currentState = {}

-- Main functions
local function mainLogic()
    -- Your script logic here
end

-- Event handlers
local eventHandlers = {
    -- Custom events
}

-- Engine handlers
local engineHandlers = {
    onFrame = mainLogic,
    onLoad = function(data)
        -- Load saved state
        if data then
            currentState = data
        end
    end,
    onSave = function()
        -- Save state
        return currentState
    end,
}

-- Return script interface
return {
    eventHandlers = eventHandlers,
    engineHandlers = engineHandlers
}
```

## Engine Handlers

### onFrame
Called every frame. Use for continuous updates but be performance-conscious.

```lua
engineHandlers = {
    onFrame = function(dt)
        -- dt: delta time since last frame
        local currentTime = time.getGameTime()
        
        -- Throttle expensive operations
        if currentTime - lastUpdateTime > 1.0 then
            updateOncePerSecond()
            lastUpdateTime = currentTime
        end
    end
}
```

### onLoad/onSave
Handle persistent data storage.

```lua
engineHandlers = {
    onLoad = function(data)
        -- Restore saved state
        if data then
            playerGold = data.playerGold or 0
            questStage = data.questStage or 0
        end
    end,
    
    onSave = function()
        -- Save important state
        return {
            playerGold = playerGold,
            questStage = questStage
        }
    end
}
```

### onActivate
Called when activating objects.

```lua
engineHandlers = {
    onActivate = function(actor, target)
        if target.type == types.NPC and target.id == "my_npc" then
            -- Custom activation logic
            return true -- Prevent default activation
        end
        return false -- Allow default activation
    end
}
```

## Event System

### Custom Events
Scripts can send and receive custom events.

```lua
-- Send event
world.sendEvent("MyCustomEvent", {
    message = "Hello World",
    value = 42
})

-- Receive event
eventHandlers = {
    MyCustomEvent = function(data)
        print(data.message) -- "Hello World"
        print(data.value)   -- 42
    end
}
```

### Built-in Events
Common events from OpenMW:

```lua
eventHandlers = {
    -- Combat events
    Hit = function(data)
        -- data.attacker, data.defender, data.damage
    end,
    
    Death = function(data)
        -- data.victim
    end,
    
    -- Skill events
    SkillIncreased = function(data)
        -- data.skill, data.newLevel
    end,
    
    -- Magic events
    SpellCasted = function(data)
        -- data.caster, data.spell
    end
}
```

## Working with Game Objects

### Player Reference
```lua
local player = self -- In player scripts
local player = world.players[1] -- In global scripts

-- Player stats
local health = types.Actor.stats.health(player).current
local magicka = types.Actor.stats.magicka(player).current
local fatigue = types.Actor.stats.fatigue(player).current

-- Player position
local pos = player.position
local rot = player.rotation

-- Player inventory
local inventory = types.Actor.inventory(player)
local goldCount = inventory:countOf("gold_001")
```

### NPC Interaction
```lua
-- Find nearby NPCs
for _, npc in ipairs(nearby.npcs) do
    local distance = (npc.position - self.position):length()
    if distance < 500 then
        -- NPC is within 500 units
    end
end

-- Modify NPC stats
types.NPC.stats.skills.speechcraft(npc).base = 
    types.NPC.stats.skills.speechcraft(npc).base + 10
```

### Item Manipulation
```lua
-- Add item to inventory
types.Actor.inventory(self):add("gold_001", 100)

-- Remove item
types.Actor.inventory(self):remove("potion_health_01", 1)

-- Check for item
local hasItem = types.Actor.inventory(self):contains("weapon_longblade_01")
```

## UI and Messaging

### Message Boxes
```lua
ui.showMessage("Hello World")
ui.showMessage("Quest Complete!", "success")

-- More complex message
ui.showMessage({
    message = "Do you accept the quest?",
    buttons = {
        { text = "Yes", callback = acceptQuest },
        { text = "No", callback = declineQuest }
    }
})
```

### Custom UI
```lua
local myUI = ui.create({
    layer = "Windows",
    template = mwse.mcm.createTemplate,
    content = ui.content({
        type = ui.TEXT,
        text = "Hello UI",
        props = {
            textSize = 16,
            color = util.color.rgb(1, 1, 1)
        }
    })
})

myUI:show()
```

## Time and Timers

### Game Time
```lua
-- Get current game time
local gameTime = time.getGameTime()
local hour = time.hour(gameTime)
local day = time.day(gameTime)
local month = time.month(gameTime)

-- Time conversion
local realSeconds = time.toRealSeconds(gameTime)
local gameDaysPassed = time.getDaysPassed()
```

### Timers
```lua
-- One-shot timer
async:newUnscaledGameTimer(5.0, function()
    print("5 seconds later")
end)

-- Repeating timer
local timer = async:newUnscaledGameTimer(1.0, function()
    updateEverySecond()
end)
timer:run()
```

## Storage System

### Global Storage
```lua
-- Get global storage section
local storage = storage.globalSection("MyMod")

-- Save data
storage:set("playerLevel", 25)
storage:set("questData", { stage = 3, completed = false })

-- Load data
local level = storage:get("playerLevel", 1) -- Default to 1
local questData = storage:get("questData", {})
```

### Player Storage
```lua
-- Player-specific storage
local playerStorage = storage.playerSection(self, "MyMod")

playerStorage:set("personalFlag", true)
local flag = playerStorage:get("personalFlag", false)
```

## Localization

### Using l10n
```lua
local l10n = core.l10n('MyMod')

-- Get localized string
local message = l10n('my_message_key')

-- With parameters
local formatted = l10n('welcome_message', { name = "Player" })
```

## Best Practices

### Performance
1. **Throttle expensive operations** in onFrame
2. **Use async timers** instead of busy waiting
3. **Cache frequently accessed values**
4. **Avoid creating objects every frame**

### Error Handling
```lua
-- Always check for nil values
local target = nearby.activators[1]
if not target then return end

-- Use pcall for risky operations
local success, result = pcall(function()
    return riskyOperation()
end)
if not success then
    print("Error:", result)
end
```

### State Management
1. **Save only necessary data** in onSave
2. **Use version numbers** for save compatibility
3. **Handle missing data gracefully** in onLoad
4. **Keep state minimal** for performance

## Debugging

### Print Statements
```lua
print(string.format("[MyMod] Current value: %d", currentValue))
core.sendGlobalEvent("debug:print", { message = "Debug info" })
```

### Type Checking
```lua
-- Add type annotations for IDE support
---@param data table
---@return boolean
local function isValidData(data)
    return type(data) == "table" and data.value ~= nil
end
```

## Common Patterns

### Quest Progression
```lua
local function advanceQuest(stage)
    storage.globalSection("MyMod"):set("questStage", stage)
    
    if stage == 10 then
        ui.showMessage("Quest Complete!")
        world.sendEvent("quest:completed", { questId = "my_quest" })
    end
end
```

### Faction Relations
```lua
local function modifyFactionReaction(factionId, amount)
    local faction = world.getFactionRecord(factionId)
    if faction then
        -- Modify faction reaction (requires appropriate API)
        world.sendEvent("faction:reactionChanged", {
            faction = factionId,
            change = amount
        })
    end
end
```

### Skill Progression
```lua
local function grantSkillXP(skillId, amount)
    if I.SkillFramework then
        I.SkillFramework.skillUsed(skillId, { 
            useType = 1, 
            scale = amount 
        })
    end
end
```

## Integration with Other Mods

### Interface Checking
```lua
-- Check if another mod is available
if I.SomeOtherMod then
    I.SomeOtherMod.doSomething()
end

-- Register your own interface
I.MyMod = {
    version = "1.0",
    doSomething = function()
        -- Your function
    end
}
```

## Resources

- [OpenMW Lua Documentation](https://openmw.readthedocs.io/en/latest/reference/lua-scripting.html)
- [OpenMW API Reference](https://openmw.readthedocs.io/en/latest/reference/lua-scripting/api.html)
- [EmmyLua Annotations](https://emmylua.github.io/) for IDE support

This guide covers the essential patterns used in The Bards Guild mod. For specific implementation details, see the actual script files in the project.
