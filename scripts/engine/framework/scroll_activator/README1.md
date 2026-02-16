# Scroll Activator Framework - ItemUsage Implementation

## 🎯 Overview
**Working scroll activator system** that triggers custom effects when scrolls are used/activated. Uses OpenMW's `I.ItemUsage` interface to detect direct scroll usage, providing instant and reliable activation.

## ✅ What It Does
- **Detects when scrolls are used** (direct activation, not UI monitoring)
- **Filters for specific scroll IDs** to trigger custom effects
- **Triggers teleportation** via Universal Travel system
- **Shows immersive messages** to the player
- **Zero polling overhead** - event-driven architecture
- **Prevents normal scroll reading** when custom effect is triggered

## 🚀 Quick Start for Modders

### 1. Add Your Scroll
Edit `scroll_activator_config.lua`:

```lua
local scrollActivators = {
    -- Your custom scroll (lowercase, matching OpenMW record ID)
    ["your_scroll_id"] = {
        event = "YourCustomEvent",
        destination = "your_destination",
        description = "Your scroll description"
    }
}
```

### 2. Test Your Scroll
- Reload Lua scripts
- Use your scroll from inventory
- Check console for debug messages

### 3. Register Scripts
Add to your `.omwscripts` file:

```
GLOBAL: scripts/engine/framework/scroll_activator/scroll_activator.lua
PLAYER: scripts/engine/framework/scroll_activator/scroll_activator_player.lua
```

## 🔧 How It Works

### **Key Innovation: Direct Item Usage Detection**
Unlike the old UI monitoring approach, this system uses OpenMW's native `I.ItemUsage` interface:

1. **Registers handler** for `types.Book` (covers all books/scrolls)
2. **Detects scroll usage** when player activates it from inventory
3. **Filters by scroll ID** to find specific scrolls
4. **Triggers custom effect** immediately
5. **Returns false** to prevent normal scroll reading

### **Event Flow**
1. Player uses scroll from inventory → `I.ItemUsage` handler called
2. System checks if scroll ID matches configured scroll
3. If match → triggers custom effect (teleportation, etc.)
4. Returns `false` to prevent normal scroll reading
5. Shows immersive message and triggers teleport

### **Critical Implementation Details**
```lua
-- Register handler for ALL books/scrolls
I.ItemUsage.addHandlerForType(types.Book, function(scroll, actor)
    -- Filter for our specific scroll
    if scroll.recordId ~= "your_scroll_id" then
        return true -- Allow normal reading for other scrolls
    end
    
    -- Trigger custom effect
    -- ... your logic here
    
    return false -- Prevent normal scroll reading
end)
```

## 📋 Configuration

### **Basic Scroll Entry**
```lua
["your_scroll_id"] = {
    event = "EventName",           -- Optional: Event to send (not used in current implementation)
    destination = "dest_id",       -- Required: For teleportation systems
    description = "Description"    -- Optional: For documentation
}
```

### **Working Example**
```lua
["jmcg_endgame"] = {
    event = "EndgameScrollActivate",
    destination = "dremora_citadel", 
    description = "Endgame scroll teleportation to Dremora Citadel"
}
```

## 🎯 Integration Examples

### **Teleportation Scroll (Current Implementation)**
The system automatically handles teleportation when configured with a destination:

```lua
-- In scroll_activator.lua - automatic handling
if activatorData then
    -- Send travel event to Universal Travel system
    require("openmw.core").sendGlobalEvent("UT_Travel", {
        network = "endgame_scroll",
        destination = activatorData.destination
    })
    
    -- Show immersive message
    if actor.type == types.Actor.PLAYER then
        actor:sendEvent("UT_ShowMessage", 
            "The last scroll from your native realm dissolves into light, pulling you toward the Dremora Citadel...")
    end
    
    return false -- Prevent normal scroll usage
end
```

### **Custom Effect Scroll (Future Extension)**
To add custom effects, modify the handler in `scroll_activator.lua`:

```lua
if scroll.recordId == "magic_scroll" then
    -- Apply custom spell effect
    types.Actor.stats.attributes.magicka(actor).base = 
        types.Actor.stats.attributes.magicka(actor).base + 50
    
    ui.showMessage("Magicka restored!")
    return false
end
```

## 🐛 Troubleshooting

### **Scroll Not Working**
- **Check**: Scroll ID matches config exactly (lowercase!)
- **Check**: Scripts are registered in `.omwscripts`
- **Check**: Console shows `[SCROLL_ACTIVATOR] Universal scroll usage handler loaded`

### **No Teleportation**
- **Check**: Universal Travel system is loaded
- **Check**: Destination exists in `ut_destinations.lua`
- **Check**: Network and destination names are correct

### **Debug Messages**
Look for these in console:
- `[SCROLL_ACTIVATOR] === SCROLL HANDLER CALLED ===` - Handler triggered
- `[SCROLL_ACTIVATOR] Scroll used: your_scroll_id` - Scroll detected
- `[SCROLL_ACTIVATOR] Found activator data: true` - Config found
- `[SCROLL_ACTIVATOR] Custom content found for your_scroll_id, triggering teleport` - Success!

## 📚 Best Practices

### **Scroll IDs**
- **Lowercase**: OpenMW returns lowercase record IDs
- **Test in console**: `player->getitemcount "your_scroll_id"`
- **No spaces**: Use underscores instead

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
if types.Actor.stats.health(actor).current < types.Actor.stats.health(actor).base / 2 then
    -- Heal player
    types.Actor.stats.health(actor).current = types.Actor.stats.health(actor).base
end
```

### **Cooldown System**
```lua
local lastUseTime = {}
local cooldown = 60 -- 60 seconds

if scroll.recordId == "your_scroll_id" then
    local currentTime = core.getGameTime()
    if lastUseTime[scroll.recordId] and currentTime - lastUseTime[scroll.recordId] < cooldown then
        ui.showMessage("Scroll on cooldown!")
        return true -- Allow normal reading (or false to prevent)
    end
    lastUseTime[scroll.recordId] = currentTime
    
    -- Apply effect
end
```

### **Multi-Scroll Support**
```lua
["home_scroll"] = {
    destination = "player_home",
    description = "Teleport to player home"
},
["quest_scroll"] = {
    destination = "quest_location", 
    description = "Teleport to quest location"
}
```

## 🚨 Important Notes

### **How It Differs from Potion Activator**
- **Potions**: Use `I.ItemUsage.addHandlerForType(types.Potion, ...)` - trigger on consumption
- **Scrolls**: Use `I.ItemUsage.addHandlerForType(types.Book, ...)` - trigger on usage
- **Both**: Return `false` to prevent normal behavior, `true` to allow it

### **Advantages Over UI Monitoring**
- **Instant activation**: No UI mode delays
- **Reliable detection**: Direct item usage, not indirect UI changes
- **Cleaner code**: No complex UI state tracking
- **Better performance**: No continuous monitoring

### **Limitations**
- **Book type only**: Only works with `types.Book` items
- **Global script only**: Handler must be registered in global script context
- **ItemUsage dependency**: Requires OpenMW's ItemUsage interface

### **Performance**
- **Event-driven**: Zero polling, instant response
- **Minimal overhead**: Only runs when books are used
- **Clean architecture**: Follows established patterns

## 📖 Version History

### **v2.0 - Current (ItemUsage Implementation)**
- ✅ Direct scroll usage detection via `I.ItemUsage`
- ✅ Instant activation without UI monitoring
- ✅ Lowercase scroll ID handling
- ✅ Universal Travel integration
- ✅ Zero polling architecture
- ✅ Clean event-driven design

### **v1.0 - Previous (UI Monitoring)**
- ❌ Book close detection via UI mode monitoring
- ❌ Complex UI state tracking
- ❌ Delayed activation
- ❌ Case-sensitive scroll ID issues

---

**Status**: ✅ Working - Successfully teleports to Dremora Citadel on scroll usage**

**For support**: Check console debug messages and ensure proper script registration.

## 🔄 Quick Setup Guide

### **For New Modders**
1. **Copy the framework**: Copy the `scroll_activator` folder to your mod
2. **Edit config**: Add your scroll ID (lowercase) and destination
3. **Register scripts**: Add to your `.omwscripts` file
4. **Test**: Use your scroll from inventory and check console

### **Integration Checklist**
- [ ] Scroll ID matches OpenMW record ID (lowercase!)
- [ ] Scripts registered in `.omwscripts`
- [ ] Debug messages appear in console
- [ ] Custom effect triggers when scroll is used
- [ ] Normal scroll reading is prevented for custom scrolls

### **File Structure**
```
scroll_activator/
├── README1.md              # This documentation
├── scroll_activator.lua    # Global script with ItemUsage handler
├── scroll_activator_config.lua  # Configuration file
└── scroll_activator_player.lua  # Minimal player script
```

This framework provides a clean, reliable system for custom scroll effects that integrates seamlessly with existing Universal Travel and OpenMW systems.

## 🎯 Key Differences from Previous Version

| Feature | Old (UI Monitoring) | New (ItemUsage) |
|---------|-------------------|-----------------|
| **Detection Method** | UI mode changes | Direct item usage |
| **Activation Speed** | Delayed (on close) | Instant (on use) |
| **Reliability** | Complex, error-prone | Simple, reliable |
| **Code Complexity** | High (UI tracking) | Low (direct handler) |
| **Performance** | Continuous monitoring | Event-driven |
| **Scroll ID Case** | Case-sensitive issues | Lowercase consistent |

The new implementation is superior in every way - simpler, faster, more reliable, and easier to maintain.
