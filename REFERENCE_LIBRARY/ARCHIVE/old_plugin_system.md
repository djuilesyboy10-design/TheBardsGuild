# NPC Plugin System - Quick Start Guide

## Overview
A modular, plug-and-play system for creating interactive NPC dialogue menus in OpenMW. Based on the successful Bard Class system, now expanded to support multiple NPC classes.

## 🚀 Quick Setup for New NPC Classes

### Method 1: Use Plugin Generator (Recommended)
```lua
local generator = require("plugin_generator")
generator.generate("SmithClass", "smith")
```

### Method 2: Manual 3-Step Process

#### Step 1: Generate Plugin Files
```lua
local generator = require("plugin_generator")
generator.generate("YourClass", "your_class")
```

#### Step 2: Add Event Listener
Add to `TheBardsGuild.omwscripts`:
```
PLAYER: scripts/engine/plugins/your_class/your_class_event_listener.lua
```

#### Step 3: Customize Content (Optional)
Edit generated `your_class_content_data.lua` to modify dialogue.

## 📁 File Structure

Each NPC plugin creates 5 files:
```
Lua/engine/plugins/your_class/
├── your_class_helper.lua          # Main UI and interaction logic
├── your_class_event_listener.lua   # Event handling
└── your_class_content_data.lua     # Dialogue content

scripts/engine/plugins/your_class/  # Duplicate for OpenMW compatibility
├── your_class_helper.lua
├── your_class_event_listener.lua
└── your_class_content_data.lua
```

## 🎯 Pre-Configured NPC Classes

The system already supports these NPC classes (no framework changes needed):

| Class Name | NPC Class in Game | Description |
|------------|-------------------|-------------|
| `BardClass` | `Bard` | Bards and musicians |
| `PublicanClass` | `Publican` | Tavern owners |
| `MerchantClass` | `trader service` | Shopkeepers and traders |
| `SmithClass` | `smith` | Blacksmiths and weapon sellers |
| `AlchemistClass` | `alchemist` | Potion makers |
| `EnchanterClass` | `enchanter` | Magic item services |
| `PublicanServiceClass` | `publican service` | Tavern service providers |

## ⚙️ System Components

### Framework Files (Already Configured)
- `universal_trigger.lua` - Main engine
- `trigger_config.lua` - NPC class definitions
- `trigger_helpers.lua` - Detection and firing logic

### Plugin Generator
- `plugin_generator.lua` - Automated plugin creation

### Configuration Files
- `TheBardsGuild.omwscripts` - Script registration

## 🛠️ Customization Guide

### Dialogue Content
Edit `your_class_content_data.lua`:
```lua
local yourClassContent = {
    [1] = {
        title = "Topic Title",
        content = [[
Your dialogue text here.
Multiple lines supported.
]]
    },
    -- Add more topics...
}
```

### UI Styling
Edit `your_class_helper.lua`:
- Text size: Change `textSize` values
- Colors: Modify `util.color.rgb()` values
- Box size: Adjust `relativeSize` values

### Menu Options
Edit the choices in `showChoiceMenu()` function:
```lua
local choices = {
    {
        text = "Your custom question",
        action = function()
            close()
            local content = yourClassContent[1]
            showResult(content.content)
        end
    },
    -- Add more options...
}
```

## 🔧 Troubleshooting

### Menu Not Appearing
1. Check if event listener is registered in `.omwscripts`
2. Verify NPC class name matches in-game class
3. Check console for "event listener loaded" message

### Wrong Display Format
1. Ensure `showResult()` function is called (not `showMessage()`)
2. Verify text size and formatting in helper file

### Trigger Not Firing
1. Check `trigger_config.lua` for correct NPC class
2. Verify player is within radius (default: 150 units)
3. Check console logs for trigger detection

## 📝 Plugin Generator API

### Basic Usage
```lua
local generator = require("plugin_generator")

-- Generate custom class
generator.generate("CustomClass", "custom")

-- Convenience methods
generator.generateMerchant()   -- Creates merchant_class
generator.generateSmith()      -- Creates smith_class
generator.generateAlchemist()  -- Creates alchemist_class
generator.generatePriest()     -- Creates priest_class
```

### What Generator Does
- ✅ Copies template files from bard_class
- ✅ Replaces all class names and references
- ✅ Updates require paths automatically
- ✅ Creates both Lua and scripts versions
- ✅ Maintains proper UI formatting

## 🎨 Best Practices

### Content Writing
- Keep dialogue topics focused and concise
- Use line breaks for readability
- Write in-character for each NPC class

### UI Design
- Use consistent text sizes (24 for main, 22 for prompts)
- Maintain golden color scheme for lore text
- Test on different screen resolutions

### Plugin Organization
- Use descriptive class names
- Keep content data separate from logic
- Document any special behaviors

## 🔄 Maintenance

### Adding New NPC Classes
1. Add to `trigger_config.lua` (if not pre-configured)
2. Add to `universal_trigger.lua` cell-based logic
3. Generate plugin files
4. Register event listener

### Updating Existing Plugins
- Edit content data for new dialogue
- Modify helper for UI changes
- Update event listener for new events

## 📊 System Features

### Automatic Features
- ✅ Cell-based trigger reset
- ✅ Radius-based NPC detection
- ✅ Proper UI layering
- ✅ Click-to-continue functionality
- ✅ Golden text formatting
- ✅ Responsive box sizing

### Safety Features
- ✅ No existing file modifications
- ✅ Isolated plugin structure
- ✅ Error-resistant loading
- ✅ Clean UI cleanup

## 🎯 Quick Examples

### Create a Blacksmith Plugin
```lua
generator.generate("SmithClass", "smith")
-- Add to omwscripts: PLAYER: scripts/engine/plugins/smith_class/smith_class_event_listener.lua
-- Done! Approach any smith NPC in-game
```

### Create an Alchemist Plugin  
```lua
generator.generate("AlchemistClass", "alchemist")
-- Add to omwscripts: PLAYER: scripts/engine/plugins/alchemist_class/alchemist_class_event_listener.lua
-- Done! Approach any alchemist NPC in-game
```

## 🏆 Success Metrics

When everything works correctly, you should see:
1. `[CLASS_NAME] event listener loaded!` in console
2. Trigger detection logs when approaching NPCs
3. Properly formatted dialogue boxes
4. Clean UI cleanup on click

## 📞 Support

For issues:
1. Check console logs first
2. Verify file structure matches template
3. Ensure all require paths are correct
4. Test with known working class (Merchant/Bard)

---

**Created by:** Plugin Generator System  
**Based on:** Bard Class Framework  
**Compatible with:** OpenMW Lua Engine  
**Last Updated:** Current Version
