# Universal Trigger Framework - Modular Content System

## 🎭 Overview

The Universal Trigger Framework is a revolutionary modular content system that allows easy creation of interactive content through a simple, plug-and-play architecture. No more hardcoded triggers - just configure and go! While initially designed for bard-related content, this framework can handle any type of interactive mod content.

## 🚀 Quick Start

### For Players:
1. Install the mod as usual
2. Enter "Balmora, Lucky Lockup" to trigger sample content
3. Use the "bard_performance_dummy" spell to trigger another sample
4. Experience the modular content system!

### For Modders:
1. Add new triggers to `Lua/engine/framework/trigger_config.lua`
2. Create plugin folders in `Lua/engine/plugins/`
3. Follow the plugin template structure
4. Your content automatically integrates with the universal system!

## 📁 Framework Structure

```
📁 Lua/engine/
├── 📁 framework/           # Universal trigger system (DO NOT MODIFY)
│   ├── universal_trigger.lua    # Main engine
│   ├── trigger_helpers.lua      # Helper functions
│   └── trigger_config.lua       # Trigger configurations
├── 📁 plugins/            # Your content goes here
│   ├── 📁 sample_content/      # Sample cell-based content
│   └── 📁 another_sample/      # Sample spell-based content
└── [core systems]       # Essential ballad systems
```

## 🎯 Creating New Content

### Step 1: Add Trigger Configuration

Edit `Lua/engine/framework/trigger_config.lua`:

```lua
return {
    triggers = {
        -- Existing triggers...
        {
            name = "YourContent",
            type = "cell", -- or "spell", "npc", "item"
            cellName = "Your Cell Name", -- for cell triggers
            spellId = "your_spell_id", -- for spell triggers
            event = "YourContentShowMenu",
            fired = false
        }
    }
}
```

### Step 2: Create Plugin Folder

```
📁 Lua/engine/plugins/your_content/
├── your_content_event_listener.lua
└── your_content_helper.lua
```

### Step 3: Event Listener Template

Create `your_content_event_listener.lua`:

```lua
return {
    eventHandlers = {
        YourContentShowMenu = function()
            print("[YOUR_CONTENT] Event received")
            require("scripts.engine.plugins.your_content.your_content_helper").show()
        end
    }
}
```

### Step 4: Helper Template

Create `your_content_helper.lua`:

```lua
local ui = require("openmw.ui")
local util = require("openmw.util")
local async = require("openmw.async")
local I = require("openmw.interfaces")

local root
local M = {}

local function close()
    if root then
        root:destroy()
        root = nil
    end
    I.UI.setMode(nil)
end

function M.show()
    -- Your content display logic here
    -- Use the professional UI template from other plugins
    
    root = ui.create {
        layer = "Windows",
        type = ui.TYPE.Container,
        template = I.MWUI.templates.boxSolid,
        props = {
            relativePosition = util.vector2(0.5, 0.5),
            anchor = util.vector2(0.5, 0.5),
            relativeSize = util.vector2(0.6, 0.4),
        },
        content = ui.content {
            {
                type = ui.TYPE.Flex,
                props = {
                    relativeSize = util.vector2(1, 1),
                    horizontal = false,
                    align = ui.ALIGNMENT.Center,
                    padding = 16,
                    backgroundColor = util.color.rgba(0.05, 0.05, 0.05, 0.92),
                },
                events = {
                    mouseClick = async:callback(close)
                },
                content = ui.content(yourContent)
            }
        }
    }

    I.UI.setMode("Interface", { windows = {} })
end

return M
```

### Step 5: Register Plugin

Add to `TheBardsGuild.omwscripts`:

```
PLAYER: scripts/engine/plugins/your_content/your_content_event_listener.lua
```

## 🔧 Trigger Types

### Cell Triggers
```lua
{
    name = "CellTrigger",
    type = "cell",
    cellName = "Balmora, Council Club",
    event = "CellTriggerEvent",
    fired = false
}
```

### Spell Triggers
```lua
{
    name = "SpellTrigger",
    type = "spell",
    spellId = "your_spell_id",
    event = "SpellTriggerEvent",
    fired = false
}
```

### NPC Triggers (Coming Soon)
```lua
{
    name = "NPCTrigger",
    type = "npc",
    npcClass = "Bard",
    event = "NPCTriggerEvent",
    fired = false
}
```

## 🎨 UI Guidelines

All plugins should use the professional UI template:

- ✅ Use `I.MWUI.templates.boxSolid` for borders
- ✅ Use nested Container + Flex structure
- ✅ Set `relativeSize = util.vector2(0.6, 0.4)` for proper sizing
- ✅ Use consistent colors and text sizes
- ✅ Include click-to-close functionality

## 🌟 Examples

### Sample Cell-Based Plugin
- Location: `Lua/engine/plugins/sample_content/`
- Trigger: Cell-based (Balmora, Lucky Lockup)
- Content: Interactive choices

### Sample Spell-Based Plugin
- Location: `Lua/engine/plugins/another_sample/`
- Trigger: Spell-based (bard_performance_dummy)
- Content: Information display

## 🔍 Troubleshooting

### Common Issues:

1. **Trigger not firing**: Check trigger_config.lua for correct spelling
2. **UI not showing**: Verify require() paths are correct
3. **Template errors**: Ensure Container + Flex structure is used
4. **Event not received**: Check omwscripts registration

### Debug Tips:

- Use `print()` statements for debugging
- Test triggers one at a time
- Check console for error messages
- Verify file paths in require() statements

## 🚀 Advanced Features

### Weather Effects Integration
The framework automatically integrates with the weather effect system. Certain choices can trigger weather changes.

### Sound Effects
Add sound effects to your content for enhanced immersion.

### Custom Conditions
Extend `trigger_helpers.lua` to add custom condition types.

## 📚 API Reference

### Framework Functions
- `helpers.checkCellCondition(cellName)` - Check if player is in cell
- `helpers.checkSpellCondition(spellId)` - Check if player has spell
- `helpers.fireTrigger(trigger)` - Fire trigger event

### UI Components
- `I.MWUI.templates.boxSolid` - Professional bordered container
- `ui.TYPE.Container` - Main container type
- `ui.TYPE.Flex` - Flexible layout container
- `ui.TYPE.Text` - Text display component

## 🤝 Contributing

1. Follow the plugin template structure
2. Use consistent naming conventions
3. Test your content thoroughly
4. Document your trigger types
5. Share your plugins with the community!

## 📜 License

This framework is open source. Feel free to use it in your own mods and create plugins for the community.

---

**Universal Trigger Framework - Making interactive content creation simple and modular! 🎭✨**
