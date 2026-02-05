# Universal Framework - Professional OpenMW Modding

A clean, professional framework for OpenMW modding with modular, independently functional systems. Built for our own mod development and released to help the community create amazing content more easily.

## Featured Mods

### Who Knocked - Interactive Door System
An intelligent door interaction mod that adds multiple approaches to locked doors.

**Features:**
- Advanced Lockpick System - Force, Pick, Magic, and Master approaches
- Dialogue-Based Entry - Admire, Intimidate, and Bribe options  
- Crime Integration - Bounty system and reputation events
- Professional UI - Clean, color-coded interface

**Installation:**
```
GLOBAL: scripts/who_knocked/ua_global.lua
GLOBAL: scripts/who_knocked/ua_bounty_monitor.lua
PLAYER: scripts/who_knocked/ua_player.lua
PLAYER: scripts/who_knocked/ua_event_bridge.lua
PLAYER: scripts/who_knocked/dialogue_menu.lua
PLAYER: scripts/who_knocked/dialogue_data.lua
```

### Potion Activator Framework
Advanced potion consumption system for custom effects and teleportation.

**Features:**
- Event-driven potion interception using I.ItemUsage interface
- Custom potion effects without vanilla consumption
- Universal Travel integration for teleportation potions
- Beginner-friendly configuration system
- Professional documentation and examples

**Installation:**
```
GLOBAL: scripts/engine/framework/potion_activator/potion_activator.lua
PLAYER: scripts/engine/framework/potion_activator/potion_activator_player.lua
```

**Configuration:** Edit `potion_activator_config.lua` to add custom potions.

### Herbalism (Beta Release)
Advanced plant gathering and alchemy system demonstrating cross-mod skill communication.

**Features:**
- Plant gathering and identification system
- Cross-mod skill integration with Bard's Lore
- Alchemy enhancement framework
- Dependency management example

**Requirements:**
- Skill Framework (required)
- Stat Window Mod (required)
- S3 Framework (required)
- Universal Framework (included)

**Note:** This is a beta release showing how skills from different mods can communicate and enhance each other through our event system.

### Skill Framework
Advanced skill system implementation demonstrating cross-mod communication bridges.

**Features:**
- Bard's Lore skill system with perks
- Skill-to-skill communication protocols
- Integration points for external mods
- Professional skill progression mechanics

**Requirements:**
- Stat Window Mod (required for skill display)
- S3 Framework (required for skill communication)
- Universal Framework (included)

**Use Case:** Perfect example of how to bridge your mod's skills with other mods in the ecosystem.

### JMCG Influence
Quest progression tracking system with adaptable UI pipeline.

**Features:**
- Quest state management
- Progress tracking interface
- Adaptable UI components
- Event-driven updates

**Note:** This serves as an example of our UI pipeline that can be adapted for any quest system or progression tracking needs.

## Universal Framework Modules

### Core Systems

**Click Activator Framework**
Revolutionary NPC interaction system that replaces range-based detection with direct player clicks. Provides clean, intuitive NPC interaction for any mod type.

**Potion Activator Framework**
Event-driven potion consumption system for custom effects and teleportation.

**Universal Trigger System**
Event-driven activation framework for any game object. Allows modders to create custom triggers and responses without polling or complex detection systems.

**Universal Effects Engine**
Modular effect processing system supporting weather, reputation, dialogue, and storage effects. Easily extensible for custom effect types.

**Universal Reputation System**
Event-driven reputation system with automatic decay, level progression, and faction-specific tracking. Responds dynamically to player actions across all mods.

**Universal Travel Network**
Multi-network teleportation system supporting unlimited travel networks (silt striders, boats, teleportation, etc.). Centralized destination management with easy expansion.

### Supporting Systems

**Dialogue Cooldown Manager**
S3-powered dialogue timing system that prevents dialogue spam and manages conversation flow across multiple mods.

**Universal Menu System**
Centralized UI management system providing consistent menu interfaces and easy menu creation for any mod type.

**Class System Framework**
Extensible class-based gameplay system supporting Bard, Guard, Merchant, Noble, Smith, Publican, and Caravan classes with easy custom class creation.

### Plugin Architecture

**Modular Plugin System**
53 plugin files demonstrating various class implementations and gameplay mechanics. Each plugin is independent but can communicate with others through the framework.

**Effect Modules**
Weather effects, reputation effects, perk systems, and custom effect processors. Fully modular and extensible for new effect types.

**Unique Dialogue System**
Custom dialogue pipeline that can be adapted for any quest system, NPC interaction, or story progression needs.

## File Structure

```
scripts/
├── who_knocked/           # Interactive door system
├── Skill/                  # Advanced skill framework
├── herbalism/             # Beta release - cross-mod skills
├── jmcg_influence/        # Quest progression UI pipeline
└── engine/                # Universal framework
    ├── framework/         # Core systems
    │   ├── click_activator/
    │   ├── potion_activator/
    │   ├── effects/
    │   ├── universal_trigger/
    │   ├── universal_reputation/
    │   ├── universal_travel/
    │   └── universal_menu/
    ├── dialogue/          # Dialogue management
    └── plugins/           # Extensible class systems
```

## Installation

1. Copy the `scripts/` folder to your OpenMW data files
2. Add mod entries to your `.omwscripts` file
3. Enable in OpenMW launcher
4. Reload Lua in-game: `reloadlua`

## Design Philosophy

- Independent Mods - Each mod works standalone
- Professional Architecture - Clean, maintainable code
- Event-Driven - No polling, instant response
- Vanilla Compatible - Seamless integration
- Modular Design - Use only what you need

## Requirements

- OpenMW 0.47 or later
- Lua scripting support enabled
- S3 Framework (optional, enhances functionality)

## Community License

This framework is free for all modders to use in their own projects. Simply give credit to the Universal Framework project. No other restrictions apply.

We believe in making modding accessible to everyone, regardless of skill level. These tools are designed to help beginners create professional-quality mods and provide experienced modders with powerful, flexible systems.

## A Personal Note

We created this framework for our own mod development, building each system to solve real problems we encountered while creating complex OpenMW content. As the systems matured and proved their value, we realized they could benefit the entire community.

This framework represents hundreds of hours of development, testing, and refinement. We're releasing it freely because we believe the OpenMW modding community deserves tools that make creativity easier and more accessible. Whether you're a beginner taking your first steps into modding or an experienced developer looking for robust systems, we hope this framework helps you create something amazing.

If you use this framework in your project, we'd love to see what you create. Your success is our reward.

---

Professional OpenMW modding framework - designed for elite modders, accessible to everyone.
