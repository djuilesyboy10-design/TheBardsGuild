# Universal Menu System

## What This Does
Provides **shared UI components and settings framework** for all mods in the Universal Framework. Key selection renderers, settings pages, and UI templates that other systems can reuse.

## Files
- `universal_key_renderer.lua` - MENU script for key binding UI
- `global_menu.lua` - GLOBAL placeholder (currently minimal)
- `universal_menu_quest_monitor.lua` - Quest monitoring integration

## For AI Prompting
```
Create OpenMW menu system with:
- Settings registration using I.Settings.registerGroup
- Key binding renderer using I.Settings.registerRenderer
- Event-driven settings changes (player → global via events)
- Storage using openmw.storage for persistence
```

## Key Pattern
```lua
I.Settings.registerRenderer('ModName/keySelection', function(value, set)
    -- Return UI layout for key binding
end)
```

## Registration
```
MENU: scripts/engine/framework/universal_menu/universal_key_renderer.lua
```
