# NPC Class Plugins

## What This Does
The **Class Plugin System** adds **custom dialogue and interactions to specific NPC classes**. When you click on a merchant, bard, guard, or noble, they show unique content instead of just vanilla dialogue. Each class has its own personality, lore, and interaction style.

## Real World Use
- Merchants share rumors and local gossip before trading
- Bards tell stories and offer performance critiques
- Guards give directions or warnings based on reputation
- Nobles discuss politics and offer quests
- Each class feels unique and alive

## How It Works

```
Click Activator Detects NPC Class → Loads Plugin Helper → Shows Custom Dialogue
```

1. **Click Activator** checks the NPC's class (merchant, bard, etc.)
2. **Looks up plugin** in `click_activator_config.lua`
3. **Plugin Helper** handles the UI and content display
4. **Content Data** provides the actual dialogue text
5. **Player chooses** vanilla dialogue or custom interaction

## Folder Structure

Each class plugin lives in its own folder:

```
engine/plugins/
├── merchant_class/        # "trader service" NPCs
├── bard_class/           # Bard NPCs
├── guard_class/          # Guards and soldiers
├── publican_class/       # Innkeepers and tavern owners
├── noble_class/          # Nobles and important NPCs
├── smith_class/          # Blacksmiths
├── caravan_class/        # Caravaners and travelers
├── ballad/               # Special bard content (Saint Jiub)
├── bard_lore/            # Deep lore for bards
└── unique_dialogue/      # One-off special dialogues
```

## Each Plugin Contains

| File | Purpose |
|------|---------|
| `[class]_helper.lua` | UI functions, menu display, cleanup |
| `[class]_content_data.lua` | Dialogue text, lore, responses |
| `[class]_event_listener.lua` | Event handling (optional) |

## For ChatGPT/AI Prompting

**Copy this into your AI:**

```
I want to create an NPC class plugin for OpenMW that adds custom dialogue to a specific NPC type.

The system should:
- Detect NPC class when clicked (via Click Activator)
- Show choice menu: [Custom Dialogue] [Vanilla Dialogue] [Barter/Service]
- Display poetic formatted text with proper line breaks
- Include multiple dialogue options that chain together
- Return to vanilla dialogue seamlessly

Structure:
1. Helper file with showResult() function using ui.create()
2. Content data file with dialogue entries and requirements
3. Event listener for activation events
4. Registration in click_activator_config.lua

Use poetic formatting: break lines at natural pauses, use empty lines for stanza breaks.
Include action descriptions in italics like *The merchant leans forward*
```

## Example Plugin: Merchant Class

### Content Data (`merchant_content_data.lua`)
```lua
return {
    ["greeting_day"] = {
        text = [[
*The merchant notices your approach*

Ah, traveler! The morning markets bring fresh news.
Balmora's guards are on edge about smugglers on the roads.
Careful if you're heading north.

*They return to their wares*

Something I can help you find today?
        ]],
        conditions = { timeOfDay = "day" }
    },
    ["greeting_night"] = {
        text = "Evening business is slow... but I keep odd hours.",
        conditions = { timeOfDay = "night" }
    }
}
```

### Helper Functions
```lua
local function showResult(text)
    -- Parse text for poetic formatting
    local content = {}
    for line in string.gmatch(text, "([^\n]*)\n?") do
        if line == "" then
            -- Empty line = spacing
            table.insert(content, { type = ui.TYPE.Container, ... })
        else
            -- Text line
            table.insert(content, { type = ui.TYPE.Text, props = {...} })
        end
    end
    -- Create UI window
    ui.create({...})
end
```

## Integration with Click Activator

Register your plugin in `click_activator_config.lua`:

```lua
local activators = {
    ["trader service"] = { plugin = "merchant_class" },
    ["publican"] = { plugin = "publican_class" },
    ["bard"] = { plugin = "bard_class" },
    ["guard"] = { plugin = "guard_class" }
}
```

## Content Writing Tips

1. **Poetic Line Breaks**: Break sentences at natural speaking points
2. **Action Descriptions**: Use `*italics*` for physical movements
3. **Stanza Breaks**: Empty lines create pauses in speech
4. **Line Length**: Keep under 60 characters for readability
5. **Voice**: Each class should sound different (merchants=practical, bards=flowery)

## Example Content

**Merchant (Practical, Rumor-focused):**
```
The talk in Balmora is all about strange lights,
lights seen over Ghostgate in the dead of night.
The Temple's calling it an omen,
but the old folk... they remember the last time.
```

**Bard (Poetic, Metaphorical):**
```
*The bard strums a minor chord*

Songs are like shadows, friend.
They follow you even when you wish them gone.
This one follows the cliff racers...
and the saint who silenced their wings.
```

## Copy-Paste Template

Create a new plugin folder `engine/plugins/my_class/`:

1. **my_class_helper.lua** - Copy from merchant_class_helper.lua, change names
2. **my_class_content_data.lua** - Add your dialogue entries
3. **my_class_event_listener.lua** - Handle events (optional)
4. Register in `click_activator_config.lua`

## Class Generator Tool

There may be a bash script in `tools/` for generating new class plugins:
```bash
./tools/class_generator.sh my_class_name
```

This would create the folder structure and boilerplate files.

## Performance Notes
- Only loads when NPC of that class is clicked
- Content stored in separate files (clean organization)
- Event-driven (no background processing)
- UI cleaned up immediately after use

## Why This Approach?

Instead of modifying vanilla dialogue (which conflicts with other mods), this system:
- Adds content alongside vanilla (no conflicts)
- Player chooses vanilla or custom
- Each class feels unique and memorable
- Easy to extend with new classes
- Maintains Morrowind's core experience while enhancing it
