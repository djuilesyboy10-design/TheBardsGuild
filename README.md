# The Bards Guild - OpenMW Mod

A comprehensive narrative-driven mod for OpenMW featuring the Bards Guild, a custom skill system, and an intricate story about preserving lost memories in a fractured Mundus.

## Overview

The Bards Guild mod introduces:
- **Custom Skill Framework**: Advanced skill system with Lua scripting
- **Narrative System**: Complex story arcs involving Hermaeus Mora, temporal fractures, and lost memories
- **12 Cultural Frequencies**: Collect musical notes from each race to restore reality
- **Dynamic Book System**: Personalized ending based on player choices
- **Rumor Echo Network**: Quest outcomes propagate through taverns across Vvardenfell

## Quick Start

1. Install OpenMW 0.47+ with Lua scripting support
2. Copy `TheBardsGuild.omwscripts` to your OpenMW data files
3. Enable the mod in OpenMW launcher
4. Start a new game or load an existing save

## Project Structure

```
mod/
├── Lua/                    # Lua scripts and skill definitions
│   └── Skill/             # Custom skill implementations
├── SkillFramework/        # Core skill system API
├── story/                 # Narrative documentation
├── back up esp/           # ESP file backups
└── openmw.cfg            # OpenMW configuration
```

## Core Features

### Skill Framework
- **Lore Keeping** (bard_performance): Primary skill with passive bonuses
- Passive bonuses to Speechcraft, Sneak, and Mysticism
- XP gain through various activities (herbalism, performance, etc.)

### Narrative Systems
- **The Margin of the World**: Apocrypha sub-realm for erased realities
- **Temporal Contradictions**: Dragon breaks, failed mantlings, erased histories
- **Rumor Propagation**: 7-tavern network for spreading quest outcomes

### Major Quest Lines
1. **Lost Song Symphony**: Collect 12 cultural frequencies
2. **Hist Memory Arc**: Argonian deep-dreaming rituals
3. **PR Warfare**: Faction influence in Balmora
4. **Saint Jiub's Finale**: Red Mountain climax
5. **Iron Orc Reclamation**: Valenvaryon settlement

## Documentation

- [Skill Framework API](docs/SkillFramework.md) - Custom skill system documentation
- [OpenMW Lua Guide](docs/OpenMW_Lua.md) - Lua scripting reference
- [Development Setup](docs/Development.md) - Development environment setup
- [Narrative Compendium](story/STRUCTURED_NARRATIVE_COMPENDIUM.md) - Complete story overview

## Requirements

- OpenMW 0.47 or later
- Lua scripting support enabled
- Morrowind.esm (vanilla assets only)

## Technical Notes

- 100% vanilla assets (no custom meshes/textures)
- One script per item design pattern
- Performance optimized for high framerate
- Clean save compatibility

## Contributing

1. Follow the asset rule: use only vanilla Morrowind assets
2. Maintain one script per item for clean edits
3. Test performance impact of new features
4. Update documentation for new systems

## License

This mod is released under the same license as OpenMW.
