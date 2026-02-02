# Who Knocked - Interactive Door System

An OpenMW mod that adds skill-based options for locked doors.

## Features

### Advanced Lockpick System
- Force Lock - Strength-based approach
- Pick Lock - Security skill challenge  
- Magic Unlock - Alteration skill approach
- Master Attempt - Combined skills strategy

### Dialogue-Based Entry
- Admire - Use charm and personality
- Intimidate - Use threats and force
- Bribe - Use gold to gain entry

### Crime Integration
- Bounty system for failed attempts
- Sends reputation events for other mods

## Installation

1. Copy scripts/who_knocked/ folder to your mod's scripts/ directory
2. Add to your OMW scripts file:
```
GLOBAL: scripts/who_knocked/ua_global.lua
GLOBAL: scripts/who_knocked/ua_bounty_monitor.lua
PLAYER: scripts/who_knocked/ua_player.lua
PLAYER: scripts/who_knocked/ua_event_bridge.lua
PLAYER: scripts/who_knocked/dialogue_menu.lua
PLAYER: scripts/who_knocked/dialogue_data.lua
```
3. Reload Lua in-game: reloadlua
