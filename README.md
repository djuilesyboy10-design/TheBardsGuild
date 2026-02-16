# Universal Framework - OpenMW Modding Foundation

A clean, professional framework for OpenMW modding with modular, independently functional systems. Each system is self-contained with its own README and can be used standalone or combined.

## What's Included

This repository contains **only the framework systems** - the building blocks for your mods. Each folder has its own detailed README explaining how to use it.

### Core Framework Systems

| System | Purpose | Location |
|--------|---------|----------|
| **Chronicle Activator** | Quest-based lore book system | `engine/framework/chronicle_activator/` |
| **Click Activator** | NPC interaction menus | `engine/framework/click_activator/` |
| **Dialogue System** | Dynamic NPC conversations | `engine/framework/dialogue/` |
| **NPC Schedule** | Time-based NPC routines | `engine/framework/npc_schedule/` |
| **Potion Activator** | Custom potion effects | `engine/framework/potion_activator/` |
| **Scroll Activator** | Book close detection for scrolls | `engine/framework/scroll_activator/` |
| **Spell Activator** | Spell cast detection | `engine/framework/spell_activator/` |
| **Universal Menu** | Shared UI components | `engine/framework/universal_menu/` |
| **Universal Reputation** | Title/reputation system | `engine/framework/universal_reputation/` |
| **Universal Travel** | Teleportation networks | `engine/framework/universal_travel/` |
| **Quest Monitor** | Quest stage tracking | `engine/framework/quest_monitor/` |
| **Object Management** | Object lifecycle handling | `engine/framework/object_management/` |
| **World Activator** | World event triggers | `engine/framework/world_activator/` |
| **Misc Activator** | Miscellaneous activators | `engine/framework/misc_activator/` |

### NPC Class Plugins

| Plugin | NPC Class | Location |
|--------|-------------|----------|
| **Bard Class** | Bard NPCs | `engine/plugins/bard_class/` |
| **Merchant Class** | Traders, publicans | `engine/plugins/merchant_class/` |
| **Guard Class** | Guards, soldiers | `engine/plugins/guard_class/` |
| **Noble Class** | Nobles, important NPCs | `engine/plugins/noble_class/` |
| **Smith Class** | Blacksmiths | `engine/plugins/smith_class/` |
| **Publican Class** | Innkeepers | `engine/plugins/publican_class/` |
| **Caravan Class** | Caravaners | `engine/plugins/caravan_class/` |
| **Ballad** | Special bard content | `engine/plugins/ballad/` |
| **Bard Lore** | Deep lore system | `engine/plugins/bard_lore/` |
| **Unique Dialogue** | One-off dialogues | `engine/plugins/unique_dialogue/` |
| **Perk Trigger** | Perk activation | `engine/plugins/perk_trigger/` |

### Utility Scripts

Debug and development tools in `engine/utility/` - not registered, for console use only.

## How to Use This Framework

### 1. Choose Your Systems

Each system is **independent**. Pick only what you need:
- Need NPC menus? Use **Click Activator**
- Need lore books? Use **Chronicle Activator**
- Need teleportation? Use **Universal Travel**

### 2. Read the README

Every system folder has a detailed README with:
- What it does
- How it works
- Installation (copy to your `.omwscripts`)
- Code examples for AI prompting
- Copy-paste templates

### 3. Register in .omwscripts

The `TheBardsGuild.omwscripts` file shows example registration. Copy the lines for systems you want into your own `.omwscripts`:

```
# Example - pick what you need:
GLOBAL: scripts/engine/framework/click_activator/click_activator.lua
PLAYER: scripts/engine/framework/click_activator/click_activator_player.lua
```

### 4. Customize

Each README has a **"Copy-Paste for Your Own Mod"** section with templates.

## Design Philosophy

- **Clean Separation** - Each system stands alone
- **README Everywhere** - Every folder documented
- **AI-Friendly** - Copy-paste prompts for ChatGPT/Claude
- **Event-Driven** - Zero polling, instant response
- **Vanilla Compatible** - Seamless integration
- **Gateway Opening** - Build foundations so others can create

## File Structure

```
scripts/
└── engine/
    ├── framework/          # Core systems (13 folders)
    │   ├── chronicle_activator/README.md
    │   ├── click_activator/README.md
    │   ├── dialogue/README.md
    │   ├── npc_schedule/README.md
    │   ├── potion_activator/README.md
    │   ├── scroll_activator/README.md
    │   ├── spell_activator/README.md
    │   ├── universal_menu/README.md
    │   ├── universal_reputation/README.md
    │   ├── universal_travel/README.md
    │   ├── quest_monitor/README.md
    │   ├── object_management/README.md
    │   └── world_activator/README.md
    ├── plugins/            # NPC class plugins (11 folders)
    │   ├── bard_class/README.md
    │   ├── merchant_class/README.md
    │   ├── guard_class/README.md
    │   ├── noble_class/README.md
    │   ├── smith_class/README.md
    │   ├── publican_class/README.md
    │   ├── caravan_class/README.md
    │   ├── ballad/README.md
    │   ├── bard_lore/README.md
    │   ├── unique_dialogue/README.md
    │   └── perk_trigger/README.md
    └── utility/README.md   # Debug tools
```

**Every folder has a README.** No guessing. No gatekeeping.

## Quick Start Example

Want to add NPC interaction menus to your mod?

1. **Read** `engine/framework/click_activator/README.md`
2. **Copy** the registration lines to your `.omwscripts`
3. **Edit** `click_activator_config.lua` to add your NPC class
4. **Create** your plugin in `engine/plugins/your_class/`
5. **Test** in-game

## Using with AI Assistants

Every README includes a **"For ChatGPT/AI Prompting"** section. Copy-paste these into your AI to get help building on the framework.

Example from Click Activator:
```
I want to create an NPC class plugin for OpenMW that adds custom dialogue...
[Full prompt with architecture details]
```

## Community License

This framework is free for all modders. Use it however you want - commercial or free, modified or unchanged. Simply give credit to the Universal Framework project.

No other restrictions. No gatekeeping. Just build amazing things.

## Gateway Status: ✅ OPEN

We've documented every system. Now it's your turn to create.

---

Professional OpenMW framework - elite architecture, accessible to everyone.

**24 README files** | **13 core systems** | **11 NPC plugins** | **Zero gatekeeping**
