# Chronicle Activator

## What This Does
The Chronicle Activator is a **quest-based lore book system**. As players complete quests, new lore pages unlock automatically. Think of it like a journal that writes itself based on your adventure progress.

## Real World Use
- Track player progress through major questlines
- Unlock lore pages when specific quest stages are reached
- Display unlocked chronicles in a custom UI (press C key by default)
- Perfect for RPGs where story discovery is part of the experience

## Files in This Folder

| File | Purpose |
|------|---------|
| `chronicle_global.lua` | GLOBAL script - listens for quest updates, calculates unlocked chronicles |
| `chronicle_player.lua` | PLAYER script - handles UI, key presses, displays the book |
| `chronicle_data.lua` | Data file - defines all chronicle entries and unlock requirements |
| `chronicle_settings.lua` | Settings file - key binding configuration |

## How It Works (Simple Version)

```
Quest Complete → Global Script Unlocks Chronicle → Player Can Read It
```

1. **Quest Monitor** detects when player reaches certain quest stages
2. **Global Script** receives this info and checks what chronicles should unlock
3. **Player Script** displays the UI when you press the key (C by default)
4. **Data File** contains all the lore text and quest requirements

## For ChatGPT/AI Prompting

**Copy this into your AI:**

```
I want to create a lore book system for OpenMW that unlocks pages as players complete quests.

The system should:
- Listen for quest stage updates from a quest monitor
- Check which lore entries should unlock based on progress
- Display unlocked entries in a book-style UI
- Use key press (C key) to open the book

Follow this pattern:
1. Global script receives quest stage events
2. Compare against data table with quest requirements
3. Send unlocked entries to player script
4. Player script displays them in a two-panel UI (list on left, content on right)

Use event-driven architecture (no polling). Storage for earned chronicles should use openmw.storage.
```

## Key Code Patterns

### Receiving Quest Updates (Global)
```lua
eventHandlers = {
    JMCG_QuestStageChanged = function(data)
        questStages[data.questId] = data.stage
        -- Check what chronicles unlock with this progress
    end
}
```

### Data Structure Example
```lua
local chronicleData = {
    questChronicles = {
        {
            id = "chronicle_bards_guild",
            title = "The Bard's Guild",
            text = "Your lore text here...",
            requirements = {
                questId = "JMCG_Bards_Guild",
                stage = 50
            }
        }
    }
}
```

### Displaying UI (Player)
```lua
-- Create left panel with list of unlocked chronicles
-- Create right panel with selected chronicle text
-- Use ui.create() with proper templates
```

## Integration Points

- **Quest Monitor**: Sends quest stage updates
- **Universal UI Components**: Uses shared UI framework for consistent look
- **Settings System**: Key binding configurable through OpenMW settings

## Registration in .omwscripts

```
GLOBAL: scripts/engine/framework/chronicle_activator/chronicle_global.lua
PLAYER: scripts/engine/framework/chronicle_activator/chronicle_player.lua
PLAYER: scripts/engine/framework/chronicle_activator/chronicle_settings.lua
```

## Copy-Paste for Your Own Mod

1. Copy all 4 files to your mod folder
2. Edit `chronicle_data.lua` with your quest IDs and lore text
3. Register the 3 main files in your `.omwscripts` file
4. Change the key binding in `chronicle_settings.lua` if desired

## Common Issues

| Problem | Solution |
|---------|----------|
| Chronicles not unlocking | Check quest IDs match exactly (case-sensitive) |
| UI not opening | Verify key binding in settings, check for conflicts |
| Empty book | Make sure player has completed quests listed in requirements |

## Performance Notes
- Zero polling - only responds to quest events
- Data stored in `openmw.storage` for persistence
- Minimal memory footprint (only stores unlocked entries)
