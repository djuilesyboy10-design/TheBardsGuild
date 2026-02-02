# Universal Framework - Professional OpenMW Modding

A clean, professional framework for OpenMW modding with modular, independently functional systems.

## 🎯 Featured Mods

### Who Knocked - Interactive Door System
**An intelligent door interaction mod that adds multiple approaches to locked doors.**

**Features:**
- **Advanced Lockpick System** - Force, Pick, Magic, and Master approaches
- **Dialogue-Based Entry** - Admire, Intimidate, and Bribe options  
- **Crime Integration** - Bounty system and reputation events
- **Professional UI** - Clean, color-coded interface

**Installation:**
```
GLOBAL: scripts/who_knocked/ua_global.lua
GLOBAL: scripts/who_knocked/ua_bounty_monitor.lua
PLAYER: scripts/who_knocked/ua_player.lua
PLAYER: scripts/who_knocked/ua_event_bridge.lua
PLAYER: scripts/who_knocked/dialogue_menu.lua
PLAYER: scripts/who_knocked/dialogue_data.lua
```

### Universal Framework
**Modular framework for click-based NPC interactions and extensible systems.**

**Components:**
- **Click Activator Framework** - Revolutionary NPC interaction system
- **Universal Trigger System** - Event-driven architecture
- **Effects Engine** - Modular perk and reputation systems
- **Class System Framework** - Extensible class-based gameplay

## 📁 File Structure

```
scripts/
├── who_knocked/           # Interactive door system
└── engine/                # Universal framework
    ├── framework/         # Core systems
    │   ├── click_activator/
    │   ├── effects/
    │   ├── universal_trigger/
    │   └── universal_menu/
    ├── dialogue/          # Dialogue management
    └── plugins/           # Extensible class systems
```

## 🚀 Installation

1. Copy the `scripts/` folder to your OpenMW data files
2. Add mod entries to your `.omwscripts` file
3. Enable in OpenMW launcher
4. Reload Lua in-game: `reloadlua`

## 🎯 Design Philosophy

- **Independent Mods** - Each mod works standalone
- **Professional Architecture** - Clean, maintainable code
- **Event-Driven** - No polling, instant response
- **Vanilla Compatible** - Seamless integration
- **Modular Design** - Use only what you need

## 📝 Requirements

- OpenMW 0.47 or later
- Lua scripting support enabled
- S3 Framework (optional, enhances functionality)

## 🏆 Elite Quality

Built with professional standards and attention to detail. This framework represents the cutting edge of OpenMW modding technology.

---

**Professional OpenMW modding framework - designed for elite modders, accessible to everyone.**
