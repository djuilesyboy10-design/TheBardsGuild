# Scroll Activator Framework

## 🎯 Overview
**Working scroll activator system** that triggers custom effects when scrolls are closed. Uses UI mode monitoring to detect when a book/scroll interface is closed, then triggers custom actions like teleportation.

## ✅ What It Does
- **Detects when books/scrolls are closed** (not when opened)
- **Checks if player has specific scroll** in inventory
- **Triggers custom effects** (teleportation, spells, etc.)
- **Integrates with Universal Travel** system
- **Zero polling overhead** - only runs when UI modes change

## 🚀 Quick Start for Modders

### 1. Add Your Scroll
Edit `scroll_activator_config.lua`:

```lua
local scrollActivators = {
    -- Your custom scroll (case-sensitive!)
    ["YourScrollID"] = {
        event = "YourCustomEvent",
        destination = "your_destination",
        description = "Your scroll description"
    }
}
```

### 2. Create Player Handler
In `scroll_activator_player.lua`, add your event:

```lua
return {
    eventHandlers = {
        YourCustomEvent = function(data)
            print("Custom scroll effect triggered!")
            -- Your custom logic here
        end
    }
}
```

### 3. Register Scripts
Add to your `.omwscripts` file:

```
GLOBAL: scripts/engine/framework/scroll_activator/scroll_activator.lua
PLAYER: scripts/engine/framework/scroll_activator/scroll_activator_player.lua
```

### 4. Test
- Reload Lua scripts
- Open and close your scroll
- Check console for debug messages

## 🔧 How It Works

### **Key Innovation: Book Close Detection**
Unlike potions (which trigger `I.ItemUsage`), books don't trigger item usage events. Instead, this system:

1. **Monitors UI mode changes** using `I.UI.getMode()`
2. **Detects "Interface" mode** when books are opened
3. **Detects transition back to `nil`** when books are closed
4. **Checks inventory** for the specific scroll
5. **Triggers custom effect** if scroll is found

### **Event Flow**
1. Player opens scroll → UI mode changes to "Interface"
2. Player closes scroll → UI mode changes to `nil`
3. System detects transition and checks inventory
4. If scroll found → triggers custom event
5. Player script handles custom logic

## 📋 Configuration

### **Basic Scroll Entry**
```lua
["YourScrollID"] = {
    event = "EventName",           -- Required: Event to send to player script
    destination = "dest_id",       -- Optional: For teleportation systems
    description = "Description"    -- Optional: For documentation
}
```

### **Working Example**
```lua
["JMCG_Endgame"] = {
    event = "EndgameScrollActivate",
    destination = "dremora_citadel",
    description = "Endgame scroll teleportation to Dremora Citadel"
}
```

## 🎯 Integration Examples

### **Teleportation Scroll**
```lua
EndgameScrollActivate = function(data)
    require("openmw.core").sendGlobalEvent("UT_Travel", {
        network = "endgame_scroll",
        destination = data.activatorData.destination
    })
    
    -- Show immersive message
    self:sendEvent("UT_ShowMessage", 
        "The scroll dissolves into light, pulling you toward your destination...")
end
```

### **Custom Effect Scroll**
```lua
MagicScrollActivate = function(data)
    -- Apply custom spell effect
    types.Actor.stats.attributes.magicka(self).base = 
        types.Actor.stats.attributes.magicka(self).base + 50
    
    ui.showMessage("Magicka restored!")
end
```

### **Choice Menu Scroll**
```lua
ChoiceScrollActivate = function(data)
    choiceMenu.showInteractionChoice({
        choices = {
            {
                text = "Teleport Home",
                action = function() 
                    require("openmw.core").sendGlobalEvent("UT_Travel", {
                        network = "home_scroll",
                        destination = "player_home"
                    })
                end
            },
            {
                text = "Cast Spell", 
                action = function() 
                    -- Cast your custom spell
                end
            }
        }
    })
end
```

## 🐛 Troubleshooting

### **Scroll Not Working**
- **Check**: Scroll ID matches config exactly (case-sensitive!)
- **Check**: Scripts are registered in `.omwscripts`
- **Check**: Console shows `[SCROLL_ACTIVATOR] Starting UI mode monitoring...`

### **No Teleportation**
- **Check**: Universal Travel system is loaded
- **Check**: Destination exists in `ut_destinations.lua`
- **Check**: Network and destination names are correct

### **Debug Messages**
Look for these in console:
- `[SCROLL_ACTIVATOR] Mode changed: Interface (was: nil)` - Book opened
- `[SCROLL_ACTIVATOR] Mode changed: nil (was: Interface)` - Book closed
- `[SCROLL_ACTIVATOR] Our scroll found in inventory, triggering teleport!` - Success!

## 📚 Best Practices

### **Scroll IDs**
- **Case-sensitive**: Use exact OpenMW record IDs
- **Test in console**: `player->getitemcount "YourScrollID"`
- **No spaces**: Use underscores or camelCase

### **Event Naming**
- **Descriptive**: `EndgameScrollActivate`, `HomeTeleportActivate`
- **Unique**: Avoid conflicts with other mods
- **Consistent**: Use `ScrollActivate` suffix

### **Debug Format**
```lua
print("[SCROLL_ACTIVATOR] Your message here")
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

### **Cooldown System**
```lua
local lastUseTime = 0
local cooldown = 60 -- 60 seconds

YourScrollActivate = function(data)
    local currentTime = core.getGameTime()
    if currentTime - lastUseTime < cooldown then
        ui.showMessage("Scroll on cooldown!")
        return
    end
    lastUseTime = currentTime
    
    -- Apply effect
end
```

### **Multi-Scroll Networks**
```lua
["home_scroll"] = {
    event = "HomeScrollActivate",
    destination = "player_home",
    network = "home_teleport"
},
["quest_scroll"] = {
    event = "QuestScrollActivate", 
    destination = "quest_location",
    network = "quest_teleport"
}
```

## 🚨 Important Notes

### **How It Differs from Potion Activator**
- **Potions**: Use `I.ItemUsage.addHandlerForType(types.Potion, ...)` - trigger on consumption
- **Scrolls**: Use UI mode monitoring - trigger on book close
- **Both**: Send events to player scripts for custom logic

### **Limitations**
- **Book reading only**: Doesn't work for other item types
- **UI mode dependency**: Relies on OpenMW's book interface behavior
- **Inventory check**: Must have scroll in inventory when book closes

### **Performance**
- **Event-driven**: Zero polling, instant response
- **Minimal overhead**: Only runs when UI modes change
- **Clean architecture**: Follows established patterns

## 📖 Version History

### **v1.0 - Current (Working Version)**
- ✅ Book close detection via UI mode monitoring
- ✅ Case-sensitive scroll ID handling
- ✅ Universal Travel integration
- ✅ Zero polling architecture
- ✅ Debug output for troubleshooting

---

**Status**: ✅ Working - Successfully teleports to Dremora Citadel**

**For support**: Check console debug messages and ensure proper script registration.

## 🔄 Quick Setup Guide

### **For New Modders**
1. **Copy the framework**: Copy the `scroll_activator` folder to your mod
2. **Edit config**: Add your scroll ID and event
3. **Add handler**: Create your custom event handler
4. **Register scripts**: Add to your `.omscripts`
5. **Test**: Open/close your scroll and check console

### **Integration Checklist**
- [ ] Scroll ID matches OpenMW record ID exactly
- [ ] Event handler exists in player script
- [ ] Scripts registered in `.omscripts`
- [ ] Debug messages appear in console
- [ ] Custom effect triggers when book closes

This framework provides a clean, reliable system for custom scroll effects that integrates seamlessly with existing Universal Travel and UI systems.
