# Universal Reputation System

## What This Does
**Reputation-based title system** that unlocks special player titles as reputation and quest progress increase. Similar to Chronicles but focused on titles/achievements.

## Files
- `reputation_global.lua` - GLOBAL script for reputation tracking
- `reputation_player.lua` - PLAYER script for UI and events
- `special_titles/` - Title unlock system with 45+ titles

## For AI Prompting
```
Create reputation system with:
- Track faction standing and quest completion
- Unlock titles at specific thresholds
- Display all titles (locked/unlocked) in UI
- Data file with title definitions and requirements
- Event-driven unlock checks
```

## Key Pattern
```lua
titleManager.checkRequirements(requirements, questProgress, reputation)
-- Returns true if player qualifies for title
```

## Registration
```
GLOBAL: scripts/engine/framework/universal_reputation/reputation_global.lua
PLAYER: scripts/engine/framework/universal_reputation/reputation_player.lua
PLAYER: scripts/engine/framework/universal_reputation/special_titles/special_titles_global.lua
PLAYER: scripts/engine/framework/universal_reputation/special_titles/special_titles_player.lua
```
