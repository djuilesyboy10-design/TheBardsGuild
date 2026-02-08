# Spell Activator Framework

## 🎯 Overview
**Working spell activator system** that triggers custom effects when specific spells are cast. Uses active spell monitoring to detect when custom spells appear in the player's active spell list, then triggers custom actions like teleportation.

## ✅ What It Does
- **Detects when custom spells are cast** (instant detection)
- **Monitors player's active spells** efficiently
- **Triggers custom effects** (teleportation, buffs, etc.)
- **Integrates with Universal Travel** system
- **Built-in cooldown system** prevents spam

## 🚀 Quick Start for Modders

### 1. Add Your Spell
Edit `spell_activator_config.lua`:

```lua
local spellActivators = {
    -- Your custom spell (case-insensitive!)
    ["YourSpellID"] = {
        event = "YourCustomEvent",
        destination = "your_destination",
        description = "Your spell description"
    }
}
```

### 2. Create Player Handler
In `spell_activator_player.lua`, add your event:

```lua
return {
    eventHandlers = {
        YourCustomEvent = function(data)
            print("Custom spell effect triggered!")
            -- Your custom logic here
        end
    }
}
```

### 3. Register Scripts
Add to your `.omwscripts` file:

```
PLAYER: scripts/engine/framework/spell_activator/spell_activator.lua
PLAYER: scripts/engine/framework/spell_activator/spell_activator_player.lua
```

### 4. Test
- Reload Lua scripts
- Cast your custom spell
- Check console for debug messages

## 🔧 How It Works

### **Key Innovation: Active Spell Monitoring**
Unlike scroll activators (which use UI mode monitoring), this system:

1. **Monitors active spells** using `types.Actor.spells(self)`
2. **Detects spell count changes** for optimization
3. **Checks each spell** against custom configuration
4. **Applies cooldown system** to prevent spam
5. **Triggers custom event** when custom spell found

### **Event Flow**
1. Player casts custom spell → Spell appears in active list
2. System detects spell count change
3. Scans active spells for custom IDs
4. If custom spell found → triggers custom event
5. Player script handles custom logic
6. Applies cooldown to prevent re-triggering

### **Performance Optimizations**
- **Change Detection**: Only checks when spell count changes
- **Cooldown System**: 10-second default cooldown
- **Processed Tracking**: Avoids duplicate processing
- **Early Exit**: Stops after first custom spell found

## 📋 Configuration

### **Basic Spell Entry**
```lua
["YourSpellID"] = {
    event = "EventName",           -- Required: Event to send to player script
    destination = "dest_id",       -- Optional: For teleportation systems
    description = "Description"    -- Optional: For documentation
}
```

### **Working Example**
```lua
["jmcg_garden"] = {
    event = "GardenSpellActivate",
    destination = "lost_archive",
    description = "Garden spell teleportation to The Lost Archive"
}
```

## 🎯 Integration Examples

### **Teleportation Spell**
```lua
GardenSpellActivate = function(data)
    require("openmw.core").sendGlobalEvent("UT_Travel", {
        network = "garden_spell",
        destination = data.activatorData.destination
    })
    
    -- Show immersive message
    self:sendEvent("UT_ShowMessage", 
        "The spell dissolves reality around you, pulling you into The Lost Archive...")
end
```

### **Custom Effect Spell**
```lua
MagicSpellActivate = function(data)
    -- Apply custom spell effect
    types.Actor.stats.attributes.magicka(self).base = 
        types.Actor.stats.attributes.magicka(self).base + 50
    
    ui.showMessage("Magicka restored!")
end
```

### **Choice Menu Spell**
```lua
ChoiceSpellActivate = function(data)
    choiceMenu.showInteractionChoice({
        choices = {
            {
                text = "Teleport Home",
                action = function() 
                    require("openmw.core").sendGlobalEvent("UT_Travel", {
                        network = "home_spell",
                        destination = "player_home"
                    })
                end
            },
            {
                text = "Cast Buff", 
                action = function() 
                    -- Apply your custom buff
                end
            }
        }
    })
end
```

## 🐛 Troubleshooting

### **Spell Not Working**
- **Check**: Spell ID matches config (case-insensitive)
- **Check**: Scripts are registered in `.omwscripts`
- **Check**: Console shows debug messages when spell is cast

### **No Teleportation**
- **Check**: Universal Travel system is loaded
- **Check**: Destination exists in `ut_destinations.lua`
- **Check**: Network and destination names are correct

### **Debug Messages**
Look for these in console:
- `[SPELL_ACTIVATOR] Custom spell detected: your_spell_id` - Success!
- `[SPELL_ACTIVATOR_PLAYER] Activating YourEvent` - Event received

### **Performance Issues**
- **Check**: Cooldown system working (10-second default)
- **Check**: Only checking when spell count changes
- **Check**: No infinite loops in event handlers

## 📚 Best Practices

### **Spell IDs**
- **Case-insensitive**: Framework normalizes to lowercase
- **Test in console**: `player->getspellcount "YourSpellID"`
- **No spaces**: Use underscores or camelCase

### **Event Naming**
- **Descriptive**: `GardenSpellActivate`, `HomeTeleportActivate`
- **Unique**: Avoid conflicts with other mods
- **Consistent**: Use `SpellActivate` suffix

### **Cooldown Management**
```lua
-- Adjust cooldown in spell_activator.lua if needed
if currentTime - processedSpells[spellId] < 5 then -- 5 second cooldown
    goto continue
end
```

### **Debug Format**
```lua
print("[SPELL_ACTIVATOR] Your message here")
```

## 🔍 Advanced Features

### **Conditional Effects**
```lua
-- Only work if player meets conditions
if types.Actor.stats.health(self).current < types.Actor.stats.health(self).base / 2 then
    -- Heal player
    types.Actor.stats.health(self).current = types.Actor.stats.health(self).base
end
```

### **Custom Cooldowns**
```lua
-- Modify cooldown per spell in config
["your_spell_id"] = {
    event = "YourEvent",
    cooldown = 30, -- 30 second cooldown
    destination = "your_destination"
}
```

### **Multi-Spell Networks**
```lua
["home_spell"] = {
    event = "HomeSpellActivate",
    destination = "player_home",
    network = "home_teleport"
},
["quest_spell"] = {
    event = "QuestSpellActivate", 
    destination = "quest_location",
    network = "quest_teleport"
}
```

## 🚨 Important Notes

### **How It Differs from Scroll Activator**
- **Spells**: Use active spell monitoring - trigger on cast
- **Scrolls**: Use UI mode monitoring - trigger on book close
- **Both**: Send events to player scripts for custom logic

### **Limitations**
- **Player only**: Only monitors player's spells, not NPC spells
- **Active spells**: Detects spells in player's active spell list
- **Cooldown**: Built-in cooldown prevents rapid re-triggering

### **Performance**
- **Optimized checking**: Only when spell count changes
- **Cooldown system**: Prevents spam processing
- **Clean architecture**: Follows established patterns

## 📖 Version History

### **v1.0 - Current (Working Version)**
- ✅ Active spell monitoring with optimization
- ✅ Case-insensitive spell ID handling
- ✅ Universal Travel integration
- ✅ Built-in cooldown system
- ✅ Debug output for troubleshooting

---

**Status**: ✅ Working - Successfully teleports to The Lost Archive**

**For support**: Check console debug messages and ensure proper script registration.

## 🔄 Quick Setup Guide

### **For New Modders**
1. **Copy the framework**: Copy the `spell_activator` folder to your mod
2. **Edit config**: Add your spell ID and event
3. **Add handler**: Create your custom event handler
4. **Register scripts**: Add to your `.omscripts`
5. **Test**: Cast your spell and check console

### **Integration Checklist**
- [ ] Spell ID matches OpenMW spell ID (case-insensitive)
- [ ] Event handler exists in player script
- [ ] Scripts registered in `.omscripts`
- [ ] Debug messages appear when spell is cast
- [ ] Custom effect triggers immediately

### **Performance Tips**
- Framework automatically optimizes checking
- Built-in cooldown prevents spam
- Only processes one spell per update cycle
- Change detection minimizes unnecessary checks

This framework provides a clean, reliable system for custom spell effects that integrates seamlessly with existing Universal Travel and UI systems while maintaining optimal performance.
