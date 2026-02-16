# Spell Activator Framework

## 🎯 Overview
**Working spell activator system** that triggers custom effects when spells are cast. Uses OpenMW's `I.ItemUsage` interface to detect direct spell casting, providing instant and reliable activation for teleportation and other custom effects.

## ✅ What It Does
- **Detects when spells are cast** (direct activation, not spell learning)
- **Filters for specific spell IDs** to trigger custom effects
- **Triggers teleportation** via Universal Travel system
- **Shows immersive messages** to the player
- **Zero polling overhead** - event-driven architecture
- **Prevents normal spell casting** when custom effect is triggered

## 🚀 Quick Start for Modders

### 1. Add Your Spell
Edit `spell_activator_config.lua`:

```lua
local spellActivators = {
    -- Your custom spell (lowercase, matching OpenMW record ID)
    ["your_spell_id"] = {
        network = "spell_teleport",
        destination = "your_destination",
        message = "Your custom teleportation message...",
        description = "Your spell description"
    }
}
```

### 2. Test Your Spell
- Reload Lua scripts
- Cast your spell from spell menu or hotkey
- Check console for debug messages

### 3. Register Scripts
Add to your `.omwscripts` file:

```
GLOBAL: scripts/engine/framework/spell_activator/spell_activator.lua
PLAYER: scripts/engine/framework/spell_activator/spell_activator_player.lua
```

## 🔧 How It Works

### **Key Innovation: Direct Spell Usage Detection**
This system uses OpenMW's native `I.ItemUsage` interface for spells:

1. **Registers handler** for `types.Spell` (covers all spells)
2. **Detects spell casting** when player casts any spell
3. **Filters by spell ID** to find specific spells
4. **Triggers custom effect** immediately
5. **Returns false** to prevent normal spell casting

### **Event Flow**
1. Player casts spell → `I.ItemUsage` handler called
2. System checks if spell ID matches configured spell
3. If match → triggers custom effect (teleportation, etc.)
4. Returns `false` to prevent normal spell casting
5. Shows immersive message and triggers teleport

### **Critical Implementation Details**
```lua
-- Register handler for ALL spells
I.ItemUsage.addHandlerForType(types.Spell, function(spell, actor)
    -- Filter for our specific spell
    if spell.recordId ~= "your_spell_id" then
        return true -- Allow normal casting for other spells
    end
    
    -- Trigger custom effect
    -- ... your logic here
    
    return false -- Prevent normal spell casting
end)
```

## 📋 Configuration

### **Basic Spell Entry**
```lua
["your_spell_id"] = {
    network = "spell_teleport",        -- Optional: Network for UT system
    destination = "dest_id",           -- Required: For teleportation systems
    message = "Custom message...",     -- Optional: Immersive message
    description = "Description"        -- Optional: For documentation
}
```

### **Working Example**
```lua
["jmcg_teleport_balmora"] = {
    network = "spell_teleport",
    destination = "balmora",
    message = "The teleportation spell shimmers around you, and the world dissolves into a kaleidoscope of colors. You feel yourself pulled through the ether, reappearing in the familiar streets of Balmora...",
    description = "Teleportation spell to Balmora"
}
```

## 🎯 Integration Examples

### **Teleportation Spell (Current Implementation)**
The system automatically handles teleportation when configured with a destination:

```lua
-- In spell_activator.lua - automatic handling
if activatorData then
    -- Send travel event to Universal Travel system
    require("openmw.core").sendGlobalEvent("UT_Travel", {
        network = activatorData.network or "spell_teleport",
        destination = activatorData.destination
    })
    
    -- Show immersive message
    if actor.type == types.Actor.PLAYER then
        actor:sendEvent("UT_ShowMessage", 
            activatorData.message or "The spell's magic envelops you, pulling you through space and time...")
    end
    
    return false -- Prevent normal spell casting
end
```

### **Custom Effect Spell (Future Extension)**
To add custom effects, modify the handler in `spell_activator.lua`:

```lua
if spell.recordId == "magic_boost_spell" then
    -- Apply custom magic boost
    types.Actor.stats.attributes.magicka(actor).base = 
        types.Actor.stats.attributes.magicka(actor).base + 100
    
    ui.showMessage("Magicka greatly increased!")
    return false
end
```

### **Combat Spell with Effects**
```lua
if spell.recordId == "fire_nova_spell" then
    -- Create fire damage area effect
    -- This would require additional combat system integration
    -- For now, just show message and prevent normal casting
    ui.showMessage("Fire nova erupts around you!")
    return false
end
```

## 🐛 Troubleshooting

### **Spell Not Working**
- **Check**: Spell ID matches config exactly (lowercase!)
- **Check**: Scripts are registered in `.omwscripts`
- **Check**: Console shows `[SPELL_ACTIVATOR] Universal spell usage handler loaded`

### **No Teleportation**
- **Check**: Universal Travel system is loaded
- **Check**: Destination exists in `ut_destinations.lua`
- **Check**: Network and destination names are correct

### **Debug Messages**
Look for these in console:
- `[SPELL_ACTIVATOR] === SPELL HANDLER CALLED ===` - Handler triggered
- `[SPELL_ACTIVATOR] Spell cast: your_spell_id` - Spell detected
- `[SPELL_ACTIVATOR] Found activator data: true` - Config found
- `[SPELL_ACTIVATOR] Custom content found for your_spell_id, triggering teleport` - Success!

## 📚 Best Practices

### **Spell IDs**
- **Lowercase**: OpenMW returns lowercase record IDs
- **Test in console**: `player->getspell "your_spell_id"` (if available)
- **No spaces**: Use underscores instead

### **Message Writing**
- **Immersive**: Describe the magical experience
- **Location-specific**: Mention the destination
- **Length**: Keep messages reasonable for display

### **Network Naming**
- **Descriptive**: `spell_teleport`, `combat_spell`, `utility_spell`
- **Unique**: Avoid conflicts with other mods
- **Consistent**: Use `spell` prefix for spell networks

## 🔍 Advanced Features

### **Conditional Effects**
```lua
-- Only work if player meets conditions
if types.Actor.stats.health(actor).current < types.Actor.stats.health(actor).base / 2 then
    -- Heal player with spell
    types.Actor.stats.health(actor).current = types.Actor.stats.health(actor).base
    ui.showMessage("The spell's healing magic restores you!")
    return false
end
```

### **Cooldown System**
```lua
local lastUseTime = {}
local cooldown = 300 -- 5 minutes in game time

if spell.recordId == "your_spell_id" then
    local currentTime = core.getGameTime()
    if lastUseTime[spell.recordId] and currentTime - lastUseTime[spell.recordId] < cooldown then
        ui.showMessage("Spell on cooldown!")
        return true -- Allow normal casting (or false to prevent)
    end
    lastUseTime[spell.recordId] = currentTime
    
    -- Apply effect
end
```

### **Multi-Spell Support**
```lua
["teleport_balmora"] = {
    network = "spell_teleport",
    destination = "balmora",
    message = "The spell pulls you toward Balmora..."
},
["teleport_vivec"] = {
    network = "spell_teleport", 
    destination = "vivec",
    message = "The spell pulls you toward Vivec City..."
}
```

### **Dynamic Spell Configuration**
```lua
-- In spell_activator_config.lua
local function setTargetSpell(spellId)
    targetSpell = spellId
end

-- Use this to dynamically change which spell is active
spellConfig.setTargetSpell("new_spell_id")
```

## 🚨 Important Notes

### **How It Differs from Other Activators**
- **Potions**: Use `I.ItemUsage.addHandlerForType(types.Potion, ...)` - trigger on consumption
- **Scrolls**: Use `I.ItemUsage.addHandlerForType(types.Book, ...)` - trigger on usage
- **Spells**: Use `I.ItemUsage.addHandlerForType(types.Spell, ...)` - trigger on casting
- **All**: Return `false` to prevent normal behavior, `true` to allow it

### **Advantages Over Spell Learning Detection**
- **Instant activation**: No need to learn spells first
- **Reliable detection**: Direct spell casting, not indirect spell book usage
- **Cleaner code**: No complex spell tracking
- **Better performance**: Event-driven only when spells are cast

### **Limitations**
- **Spell type only**: Only works with `types.Spell` items
- **Global script only**: Handler must be registered in global script context
- **ItemUsage dependency**: Requires OpenMW's ItemUsage interface
- **No spell creation**: Cannot create new spells, only intercept existing ones

### **Performance**
- **Event-driven**: Zero polling, instant response
- **Minimal overhead**: Only runs when spells are cast
- **Clean architecture**: Follows established patterns

## 📖 Version History

### **v1.0 - Current (ItemUsage Implementation)**
- ✅ Direct spell casting detection via `I.ItemUsage`
- ✅ Instant activation without spell learning
- ✅ Lowercase spell ID handling
- ✅ Universal Travel integration
- ✅ Zero polling architecture
- ✅ Clean event-driven design

---

**Status**: ✅ Working - Ready for spell implementation

**For support**: Check console debug messages and ensure proper script registration.

## 🔄 Quick Setup Guide

### **For New Modders**
1. **Copy the framework**: Copy the `spell_activator` folder to your mod
2. **Edit config**: Add your spell ID (lowercase) and destination
3. **Register scripts**: Add to your `.omwscripts` file
4. **Test**: Cast your spell and check console

### **Integration Checklist**
- [ ] Spell ID matches OpenMW record ID (lowercase!)
- [ ] Scripts registered in `.omwscripts`
- [ ] Debug messages appear in console
- [ ] Custom effect triggers when spell is cast
- [ ] Normal spell casting is prevented for custom spells

### **File Structure**
```
spell_activator/
├── README.md                  # This documentation
├── spell_activator.lua        # Global script with ItemUsage handler
├── spell_activator_config.lua # Configuration file
└── spell_activator_player.lua # Minimal player script
```

This framework provides a clean, reliable system for custom spell effects that integrates seamlessly with existing Universal Travel and OpenMW systems.

## 🎯 Comparison with Other Activators

| Activator Type | Detection Method | Use Case | Return Value |
|----------------|------------------|----------|--------------|
| **Potion** | `types.Potion` + ItemUsage | Consumption effects | `false` to prevent drinking |
| **Scroll** | `types.Book` + ItemUsage | Reading/usage effects | `false` to prevent reading |
| **Spell** | `types.Spell` + ItemUsage | Casting effects | `false` to prevent casting |

All three activators follow the same pattern but use different OpenMW types, making the framework consistent and easy to understand.
