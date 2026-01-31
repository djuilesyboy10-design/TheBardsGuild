# The Bards Guild - Development Guide

## 🎯 Overview
Comprehensive development guide for The Bards Guild OpenMW mod. This guide covers setup, API usage, framework integration, and best practices for professional OpenMW mod development.

## 🛠️ Prerequisites

### Required Software
- **OpenMW 0.47+** with Lua scripting support
- **Morrowind.esm** (vanilla game files)
- **Text Editor/IDE** with Lua support (recommended: VS Code with EmmyLua)
- **Git** (for version control)

### Recommended Tools
- **VS Code** with EmmyLua extension
- **OpenMW Launcher** for testing
- **MWEdit** or **TES3CMD** for ESP editing (if needed)
- **Git GUI** (SourceTree, GitKraken, etc.)

## 🚀 Project Setup

### 1. Clone/Download the Project
```bash
git clone <repository-url>
cd mod
```

### 2. Configure OpenMW
1. Install OpenMW 0.47 or later
2. Copy Morrowind.esm to OpenMW data files directory
3. Configure `openmw.cfg` for development:
```ini
data=.
data="C:\path\to\TheBardsGuild"
```

### 3. Development Environment
- **Lua/ folder** - Development workspace (safe for testing)
- **scripts/ folder** - Production code (what OpenMW loads)
- **TheBardsGuild.omwscripts** - Script registration file

## 📁 Critical Folder Structure Rules

### 🚨 NEVER BREAK THESE RULES

### Folder Purpose:
- **`Lua/` folder** = Working/Development folder ONLY
  - Used for development, testing, and experimentation
  - Contains work-in-progress files
  - NOT loaded by OpenMW game engine
  - Safe place to make mistakes and test ideas

- **`scripts/` folder** = Production/Deployment folder ONLY
  - Contains files that OpenMW actually loads
  - Registered in `TheBardsGuild.omwscripts`
  - Must be clean, stable, and working
  - The REAL folder that the game uses

### Script Registration Rules:
- **NEVER** register paths starting with `Lua/` in `TheBardsGuild.omwscripts`
- **ALWAYS** register paths starting with `scripts/` in `TheBardsGuild.omwscripts`
- **ALL** script paths in `.omwscripts` must use `scripts/` prefix

### Development Workflow:
1. **Create/Work in `Lua/` folder** - Safe development environment
2. **Test and validate** - Ensure files work correctly
3. **Copy to `scripts/` folder** - Only when ready for production
4. **Register in `TheBardsGuild.omwscripts`** - Use `scripts/` paths only

## 🔧 OpenMW Lua API Reference

### Core Modules
```lua
-- Core OpenMW modules
local core = require('openmw.core')
local self = require('openmw.self')
local types = require('openmw.types')
local util = require('openmw.util')
local nearby = require('openmw.nearby')
local async = require('openmw.async')
local camera = require('openmw.camera')
local input = require('openmw.input')
local ui = require('openmw.ui')
local storage = require('openmw.storage')
local time = require('openmw.time')
local world = require('openmw.world')
local auxUtil = require('openmw_aux.util')
```

### Interfaces
```lua
local I = require('openmw.interfaces')
-- Available interfaces: I.UI, I.Activation, I.SkillFramework, etc.
```

### Event System
```lua
-- Global events
core.sendGlobalEvent("eventName", eventData)

-- Event handlers
eventHandlers = {
    eventName = function(data)
        -- Handle event
    end
}
```

## 🎯 Framework Integration

### Universal Activator Framework
The revolutionary click-based NPC interaction system that replaces old trigger systems.

#### Core Components:
- **Click Activator** - `scripts/engine/framework/click_activator/`
- **Choice Menu** - Universal interaction menu
- **Plugin System** - Modular NPC classes

#### Creating New NPC Classes:
```lua
-- Method 1: Use Plugin Generator (Recommended)
local generator = require("plugin_generator")
generator.generate("SmithClass", "smith")

-- Method 2: Manual 3-Step Process
-- 1. Create plugin folder: scripts/engine/plugins/your_class/
-- 2. Add event listener to TheBardsGuild.omwscripts
-- 3. Customize content data
```

### Skill Framework Integration
Custom skill system with full vanilla integration.

#### Bard Skill Example:
```lua
local API = I.SkillFramework
local SKILL_ID = "bard_performance"

-- Registration
API.registerSkill(SKILL_ID, {
    name = "Bard Performance",
    description = "The art of musical performance and persuasion",
    icon = { fgr = "icons/bard_skill.dds" },
    attribute = "personality",
    specialization = API.SPECIALIZATION.Stealth,
    startLevel = 5,
    maxLevel = 100,
    skillGain = { [1] = 0.0 },
    statsWindowProps = {
        subsection = API.STATS_WINDOW_SUBSECTIONS.Arts
    }
})

-- XP Gain
API.skillUsed(SKILL_ID, { 
    useType = 1, 
    scale = amount 
})
```

### Universal Travel Network
Multi-network travel system with quest integration and cooldowns.

#### Components:
- **Destinations Database** - `scripts/universal_travel/ut_destinations.lua`
- **Travel UI** - `scripts/universal_travel/ut_ui.lua`
- **Network Support** - Daedric, Propylon, Guild networks

## 🎨 UI Development Standards

### Professional UI Patterns
```lua
local ui = require('openmw.ui')
local util = require('openmw.util')
local async = require('openmw.async')
local I = require('openmw.interfaces')
local auxUi = require('openmw_aux.ui')

-- Standard Window Properties
relativeSize = util.vector2(0.6, 0.4)
relativePosition = util.vector2(0.5, 0.5)
anchor = util.vector2(0.5, 0.5)
backgroundColor = util.color.rgba(0.05, 0.05, 0.05, 0.92)
```

### Poetic Text Processing
```lua
for line in string.gmatch(text, "([^\n]*)\n?") do
    if line == "" then
        -- Empty line becomes spacing
        table.insert(content, {
            type = ui.TYPE.Container,
            props = { paddingTop = 8 },
            content = ui.content({})
        })
    else
        -- Text line with golden formatting
        table.insert(content, {
            type = ui.TYPE.Text,
            props = {
                text = line,
                textSize = 28,
                textColor = util.color.rgb(0.9, 0.8, 0.6),
            }
        })
    end
end
```

### Critical Menu Transition Fix
```lua
-- ALWAYS use async timer for vanilla menu transitions
action = function()
    choiceMenu.closeMenu(root)
    async:newUnsavableGameTimer(0, function()
        I.UI.setMode("Dialogue")  -- or I.UI.addMode('Barter', {target = npc})
    end)
end
```

## 🎮 Universal Effects Framework

### Effect System Integration
Metaphysical perk system with save-specific unlocking and effect dispatch.

#### Core Components:
- **Perk Effects Data** - Defines available perks and requirements
- **Perk Effects Module** - Handles unlocking and dispatch
- **Universal Effects Engine** - Dynamic effect registration

#### Storage Implementation
```lua
local playerPerks = storage.playerSection('BardPerks')
playerPerks:setLifeTime(storage.LIFE_TIME.Temporary)
```

## 🏆 Quick Class Creation Guide

### LESSONS LEARNED

#### 1. OMWScripts Registration REQUIRED
- ❌ **Myth**: Plugins work automatically without registration
- ✅ **Reality**: Event listeners MUST be registered in `TheBardsGuild.omwscripts`
- **Pattern**: `PLAYER: scripts/engine/plugins/[class_name]/[class_name]_event_listener.lua`

#### 2. NPC Class Detection Matters
- **Smith NPCs**: Class is `"smith"` (not `"smith service"`)
- **Merchant NPCs**: Class is `"trader service"`
- **Bard NPCs**: Class is `"bard"`
- **Always verify**: Check console logs for actual NPC class names

#### 3. Vanilla Dialogue Fix (CRITICAL)
- **Wrong**: `I.UI.setMode("Dialogue")` 
- **Right**: `I.UI.addMode('Dialogue', {target = npc})`

#### 4. UI Cleanup Protocol
```lua
local function cleanupExistingUI()
    if root then
        auxUi.deepDestroy(root)
        root = nil
    end
    I.UI.setMode(nil)
end
```

## 🧪 Testing Procedures

### Manual Testing Approach
OpenMW requires in-game validation for proper testing.

### Key Test Areas:
- **NPC Detection** - Verify trigger boundaries and event firing
- **UI Display** - Test all menu interactions and transitions
- **Skill Progression** - Validate XP gain and level-ups
- **Travel Network** - Test all destination networks and cooldowns
- **Save/Load** - Verify data persistence across sessions

### Testing Checklist:
- [ ] Framework components load correctly
- [ ] NPC interactions work as expected
- [ ] UI menus display and close properly
- [ ] Skill system integrates with vanilla
- [ ] Travel network functions correctly
- [ ] Data persists after save/load

## 🚀 Performance Optimization

### Best Practices:
- **Event-driven architecture** - Zero polling, instant response
- **Clean event handlers** - No background processing when idle
- **Efficient data structures** - Optimized for real-time gameplay
- **Memory management** - Proper cleanup and garbage collection

### Performance Metrics:
- **Memory usage**: ~47MB total
- **Idle operations**: Zero background processing
- **Response time**: Instant event-driven reactions
- **Scalability**: Supports complex narrative systems

## 📚 Additional Resources

### Reference Library
- **SKILL_SYSTEMS/** - Custom skill implementations
- **GAMEPLAY_SYSTEMS/** - Core gameplay mechanics
- **UI_SYSTEMS/** - User interface examples
- **PERSONAL_NOTES/** - Development insights and discoveries

### Documentation
- **TESTING_GUIDE.md** - Comprehensive testing procedures
- **FOLDER_STRUCTURE_RULES.md** - Critical development rules
- **REFERENCE_LIBRARY.md** - Knowledge base index

## 🎯 Development Philosophy

### Core Principles:
- **Clean architecture** - Modular, extensible design
- **Professional standards** - Industry-best practices
- **Performance focus** - Optimized for real-time gameplay
- **Community ready** - Well-documented and extensible

### Golden Rule:
**"You never, ever, ever want to do anything on-brain unless it's absolutely essential, there's no way around it"**

- ✅ **ONLY fix what's explicitly broken**
- ❌ **NEVER add features without permission**
- ❌ **NEVER make unauthorized improvements**
- ✅ **ALWAYS ask before making changes**
- ✅ **STICK TO EXACT original functionality**

---

## 🚀 Ready for Development

This guide provides everything needed for professional OpenMW mod development with The Bards Guild framework. Follow these standards and procedures for efficient, maintainable, and high-quality mod development.

**For detailed testing procedures, see TESTING_GUIDE.md**
**For critical folder rules, see FOLDER_STRUCTURE_RULES.md**
**For reference materials, see REFERENCE_LIBRARY/**
