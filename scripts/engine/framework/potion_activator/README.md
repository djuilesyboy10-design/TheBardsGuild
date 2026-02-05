# Potion Activator Framework

## Overview
Part of the Universal Activator Framework - handles custom potion consumption effects using OpenMW's `I.ItemUsage` interface.

## 🎯 Purpose
Intercept potion usage events and trigger custom effects instead of (or in addition to) vanilla potion consumption. Perfect for teleportation potions, special effects, or custom mechanics.

## 📁 Files
- `potion_activator.lua` - Main usage handler (global script)
- `potion_activator_config.lua` - Potion configuration data
- `potion_activator_player.lua` - Player-side event handling

## 🚀 Quick Start

### 1. Add Your Potion
Edit `potion_activator_config.lua`:

```lua
local potionActivators = {
    -- Your custom potion
    ["your_potion_id"] = {
        event = "YourCustomEvent",
        destination = "your_destination",
        description = "Your potion description"
    }
}
```

### 2. Create Player Handler
In `potion_activator_player.lua`, add your event:

```lua
return {
    eventHandlers = {
        YourCustomEvent = function(data)
            -- Your custom logic here
            print("Custom potion effect triggered!")
        end
    }
}
```

### 3. Register Scripts
Add to your `.omwscripts` file:

```
GLOBAL: scripts/engine/framework/potion_activator/potion_activator.lua
PLAYER: scripts/engine/framework/potion_activator/potion_activator_player.lua
```

### 4. Test
- Reload Lua scripts
- Drag potion onto character model (not double-click)
- Check console for debug messages

## 🔧 Technical Details

### Interface Usage
Uses `I.ItemUsage.addHandlerForType(types.Potion, handler)` - the correct interface for inventory item usage.

**Important**: This works for dragging items onto the character model, not quick keys or AI usage.

### Event Flow
1. Player drags potion onto character
2. `potion_activator.lua` intercepts usage
3. Checks config for custom effects
4. Sends event to player script
5. Player script handles custom logic

### Return Values
- `return false` - Prevent default potion consumption
- `return true` - Allow default consumption (for non-custom potions)

## 📋 Configuration Options

### Basic Potion Entry
```lua
["potion_id"] = {
    event = "EventName",           -- Required: Event to send to player script
    destination = "dest_id",       -- Optional: For teleportation systems
    description = "Description"    -- Optional: For documentation
}
```

### Advanced Example
```lua
["jmcg_potion_unique1"] = {
    event = "HistCellPotionActivate",
    destination = "hist_cell_entrance",
    description = "Hist Cell teleportation potion"
}
```

## 🎯 Integration Examples

### Teleportation Potion
```lua
-- In player script
HistCellPotionActivate = function(data)
    require("openmw.core").sendGlobalEvent("UT_Travel", {
        network = "hist_cell",
        destination = data.activatorData.destination
    })
end
```

### Custom Effect Potion
```lua
-- In player script
CustomMagicPotion = function(data)
    -- Apply custom spell effect
    types.Actor.stats.attributes.magicka(self).base = 
        types.Actor.stats.attributes.magicka(self).base + 50
    
    -- Show message
    ui.showMessage("Magicka restored!")
end
```

### Multiple Choice Potion
```lua
-- In player script
ChoicePotion = function(data)
    -- Show choice menu
    choiceMenu.showInteractionChoice({
        choices = {
            {
                text = "Option 1",
                action = function() -- Do something end
            },
            {
                text = "Option 2", 
                action = function() -- Do something else end
            }
        }
    })
end
```

## 🐛 Troubleshooting

### Handler Not Called
- **Check**: Are you dragging the potion onto your character model?
- **Check**: Is the potion ID correct (case-sensitive)?
- **Check**: Are scripts registered in `.omwscripts`?

### No Custom Effect
- **Check**: Potion ID matches config exactly
- **Check**: Event handler exists in player script
- **Check**: Console for error messages

### Teleportation Not Working
- **Check**: Universal Travel system is loaded
- **Check**: Destination exists in `ut_destinations.lua`
- **Check**: Network and destination names are correct

## 📚 Best Practices

### Potion IDs
- Use lowercase IDs (OpenMW normalizes to lowercase)
- Test your potion ID in console: `player->getitemcount "potion_id"`

### Event Naming
- Use descriptive event names: `HistCellPotionActivate`
- Avoid conflicts with other mods

### Error Handling
```lua
-- Always validate potion objects
if not potion then
    print("[POTION_ACTIVATOR] Invalid potion object")
    return true
end

-- Check for player
local player = world.player or world.players[1]
if not player or actor ~= player then
    return true
end
```

### Debug Messages
Use consistent debug format:
```lua
print("[POTION_ACTIVATOR] Your message here")
```

## 🔍 Advanced Usage

### Conditional Effects
```lua
-- Check player conditions before applying effects
if types.Actor.stats.health(self).current < types.Actor.stats.health(self).base / 2 then
    -- Only heal if injured
    types.Actor.stats.health(self).current = types.Actor.stats.health(self).base
end
```

### Cooldown System
```lua
-- Add cooldown tracking
local lastUseTime = 0
local cooldown = 60 -- 60 seconds

CustomPotion = function(data)
    local currentTime = core.getGameTime()
    if currentTime - lastUseTime < cooldown then
        ui.showMessage("Potion on cooldown!")
        return
    end
    lastUseTime = currentTime
    
    -- Apply effect
end
```

### Integration with Other Systems
```lua
-- Check for other mods
if I.SkillFramework then
    I.SkillFramework.skillUsed("potion_crafting", {useType = 1, scale = 10})
end

if I.UniversalTravel then
    -- Use travel system
end
```

## 🎓 Learning Resources

### OpenMW Documentation
- **Item Usage Interface**: `I.ItemUsage.addHandlerForType()`
- **Event System**: `core.sendGlobalEvent()`
- **Types System**: `types.Potion`, `types.Actor`

### Related Systems
- **Universal Activator Framework**: For world object interactions
- **Universal Travel System**: For teleportation effects
- **Choice Menu System**: For player interaction UI

## 🚨 Important Notes

### Limitations
- **No Quick Keys**: Doesn't intercept quick key usage
- **No AI Usage**: Doesn't intercept AI potion consumption
- **No MWScript**: Doesn't intercept MWScript item usage

### Performance
- **Event-Driven**: Zero polling, instant response
- **Minimal Overhead**: Only runs when potions are used
- **Clean Architecture**: Follows established patterns

## 📖 Version History

### v1.0 - Current
- Uses `I.ItemUsage` interface (correct approach)
- Event-driven architecture
- Universal Travel integration
- Beginner-friendly configuration

### Previous Attempts
- ❌ `I.Activation.addHandlerForType(types.Potion)` - Wrong interface
- ❌ `engineHandlers.onUse` - Not supported in global scripts
- ❌ Polling approaches - Rejected for performance

---

**Status**: ✅ Working Version - Tested with Hist Cell potion teleportation

**For support**: Check console debug messages and ensure proper script registration.
