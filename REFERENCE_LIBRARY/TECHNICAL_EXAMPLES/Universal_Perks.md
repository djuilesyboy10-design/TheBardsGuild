# Universal Perk System Implementation Guide

## Overview
A metaphysical perk system integrated with the Universal Effects Framework for OpenMW. Provides save-specific perk unlocking with effect dispatch.

## Core Components

### 1. Perk Effects Data (`perk_effects_data.lua`)
- **Purpose**: Defines available perks, level requirements, and effects
- **Structure**: Perks with level, name, description, and effects array
- **Effects**: Each effect has `type`, `data.effectId`, and `description`

### 2. Perk Effects Module (`perk_effects.lua`)
- **Purpose**: Handles perk unlocking, effect dispatch, and storage
- **Key Functions**:
  - `checkPerkUnlock(skillId, newLevel)` - Main unlock function
  - `applyDialogueEffect(effectData)` - Handles dialogue effects
  - `applyStorageEffect(effectData)` - Handles storage effects

### 3. Universal Effects Engine Integration
- **Purpose**: Dispatches perk effects to appropriate handlers
- **Dynamic Registration**: Effect handlers registered at runtime
- **Effect Types**: dialogue, storage, reputation, weather, schedule

## Storage Implementation

### Save-Specific Storage
```lua
local playerPerks = storage.playerSection('BardPerks')
playerPerks:setLifeTime(storage.LIFE_TIME.Temporary)
```

**Key Insight**: `LifeTime.Temporary` ensures perks reset when loading different saves.

## Adding New Perks

### 1. Define Perk in Data File
```lua
mystical_perk = {
    level = 100,
    name = "Mystical Insight",
    description = "See beyond the veil of reality",
    effects = {
        {
            type = 'dialogue',
            data = {effectId = 'mystical_dialogue'},
            description = 'Unlock mystical conversation options'
        }
    }
}
```

### 2. Register Perk
Add to `getAvailablePerks()` function in perk data.

## Adding New Effect Types

### 1. Create Effect Handler
```lua
local function applyCustomEffect(effectData)
    local effectId = effectData.effectId
    -- Handle effect logic
    return true
end
```

### 2. Register with Universal Effects Engine
```lua
universalEffectsEngine.registerEffectHandler('custom', applyCustomEffect)
```

## Console Testing Commands

### Unlock Perk
```lua
local perkEffects = require("scripts.engine.framework.effects.effect_modules.perk_effects")
perkEffects.checkPerkUnlock('bard_performance', 25)
```

### Debug System
```lua
perkEffects.debugPerkSystem()
```

## Key Lessons Learned

### Storage Behavior
- `storage.playerSection()` is NOT save-specific by default
- Must use `setLifeTime(storage.LIFE_TIME.Temporary)` for save-specific behavior
- `LifeTime.Persistent` (default) = global across saves
- `LifeTime.Temporary` = resets on save load
- `LifeTime.GameSession` = resets on game exit

### Module Dependencies
- Avoid circular dependencies between modules
- Use dynamic registration instead of direct requires
- Export functions directly for console testing

### Framework Integration
- Universal Effects Engine handles effect dispatch
- Plugin system handles event triggers
- Click Activator handles NPC interactions
- NEVER modify existing framework code

## File Structure
```
scripts/engine/framework/effects/
├── effect_modules/
│   ├── perk_effects.lua
│   └── perk_effects_data.lua
├── universal_effects_engine.lua
└── effect_data/
    └── perk_effects_data.lua
```

## Registration in OMWScripts
Add to PLAYER scripts:
```
PLAYER: scripts/engine/plugins/perk_trigger/perk_trigger_event_listener.lua
```

## Current Perks
- **Muse's Whisper** (Level 25): Hidden dialogue paths, Hermaeus blessing
- **Echo Weaver** (Level 50): Conversation memory, reputation boost, logging
- **Story Shaper** (Level 75): Reality warping, weather control, schedule influence

## Success Metrics
✅ Perk unlocking works
✅ Save-specific storage works
✅ Effect dispatch works
✅ Level requirements work
✅ UI notifications work
✅ No duplicate unlocks
✅ Framework integration complete
✅ Console testing available
