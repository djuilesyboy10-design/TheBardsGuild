# Development Setup Guide

This guide covers setting up a development environment for working on The Bards Guild OpenMW mod.

## Prerequisites

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

## Project Setup

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
[Game]
data=.
data=/path/to/openmw/data-files

[General]
run scripts=1

[Lua]
scripts path=Lua
scripts path=SkillFramework
```

### 3. VS Code Setup

#### Extensions
Install these VS Code extensions:
- **EmmyLua** (for Lua type hints)
- **Lua** (by sumneko)
- **GitLens** (for Git integration)
- **Better Comments** (for code annotation)

#### Workspace Configuration
Create `.vscode/settings.json`:
```json
{
    "Lua.diagnostics.globals": [
        "openmw",
        "openmw.core",
        "openmw.self",
        "openmw.types",
        "openmw.util",
        "openmw.nearby",
        "openmw.async",
        "openmw.camera",
        "openmw.input",
        "openmw.ui",
        "openmw.storage",
        "openmw.time",
        "openmw.world",
        "openmw_aux",
        "openmw_aux.util"
    ],
    "Lua.diagnostics.disable": [
        "undefined-global"
    ],
    "Lua.workspace.library": [
        "C:/Users/djuil/Documents/mod/.idea"
    ],
    "files.associations": {
        "*.lua": "lua"
    }
}
```

### 4. EmmyLua Configuration

The project includes EmmyLua configuration files:
- `.idea/openmw.lua` - OpenMW API definitions
- `.idea/emmylua_config.lua` - Project-specific configurations

## File Structure

### Directory Layout
```
mod/
├── README.md                    # Project overview
├── openmw.cfg                   # OpenMW configuration
├── TheBardsGuild.omwscripts     # Script package
├── docs/                        # Documentation
│   ├── SkillFramework.md
│   ├── OpenMW_Lua.md
│   └── Development.md
├── Lua/                         # Lua scripts
│   └── Skill/                   # Skill implementations
│       ├── bard_skill.lua
│       └── [other skills]
├── SkillFramework/              # Core skill system
│   ├── api.lua
│   ├── actor.lua
│   ├── global.lua
│   ├── types.lua
│   ├── config/
│   ├── settings/
│   └── util/
├── story/                       # Narrative documentation
│   └── STRUCTURED_NARRATIVE_COMPENDIUM.md
├── back up esp/                 # ESP file backups
└── .idea/                       # IDE configuration
    ├── openmw.lua
    └── emmylua_config.lua
```

### Script Organization

#### Skill Scripts (`Lua/Skill/`)
- One file per custom skill
- Follow naming convention: `[skill_name]_skill.lua`
- Include EmmyLua type annotations
- Use consistent structure (registration, passives, handlers)

#### Framework (`SkillFramework/`)
- `api.lua` - Main API interface
- `actor.lua` - Actor-specific functionality
- `global.lua` - Global script management
- `types.lua` - Type definitions
- `config/` - Configuration files
- `settings/` - Mod settings
- `util/` - Utility functions

## Development Workflow

### 1. Making Changes
1. Edit Lua scripts in your preferred editor
2. Test changes in OpenMW
3. Commit changes with descriptive messages
4. Update documentation as needed

### 2. Testing
```bash
# Launch OpenMW with your mod
openmw --config openmw.cfg --data=. --debug

# Common testing flags
openmw --debug --no-sound --skip-menu
```

### 3. Debugging
- Use `print()` statements for debugging
- Check OpenMW console for Lua errors
- Use VS Code debugger with EmmyLua extension
- Test with different game scenarios

### 4. Version Control
```bash
# Create feature branch
git checkout -b feature/new-skill

# Commit changes
git add .
git commit -m "Add new bard skill with passive bonuses"

# Push changes
git push origin feature/new-skill
```

## Coding Standards

### Lua Style Guide

#### Naming Conventions
```lua
-- Constants: UPPER_SNAKE_CASE
local MAX_LEVEL = 100
local SKILL_ID = "bard_performance"

-- Variables: lower_snake_case
local currentLevel = 5
local lastUpdateTime = 0

-- Functions: lower_snake_case
local function apply_passive_bonuses()
    -- Function body
end

-- Classes/Modules: PascalCase
local SkillFramework = {}
```

#### Type Annotations
```lua
---@diagnostic disable: undefined-global

---@type openmw.interfaces.SkillFramework
local API = I.SkillFramework

---@param skillId string
---@param data table
---@return boolean
local function grant_skill_xp(skillId, data)
    -- Function implementation
end
```

#### File Structure Template
```lua
---@diagnostic disable: undefined-global

--[[
    Skill Name: [Skill Description]
    Author: [Your Name]
    Version: 1.0
]]

-- Imports
local types = require("openmw.types")
local self = require("openmw.self")
local I = require("openmw.interfaces")

-- Constants
local SKILL_ID = "skill_name"

-- State variables
local lastAppliedLevel = -1

-- Core functions
local function applyPassives()
    -- Implementation
end

-- Event handlers
local eventHandlers = {
    -- Event definitions
}

-- Engine handlers
local engineHandlers = {
    onFrame = applyPassives,
    onLoad = function(data)
        -- Load state
    end,
    onSave = function()
        -- Save state
        return {}
    end
}

-- Return interface
return {
    eventHandlers = eventHandlers,
    engineHandlers = engineHandlers
}
```

### Documentation Standards

#### Code Comments
```lua
-- Single line comment: Brief description
local variable = value

--[[
    Multi-line comment: Detailed explanation
    of complex logic or algorithms
]]

---@param paramName string Description of parameter
---@return boolean Description of return value
local function documentedFunction(paramName)
    -- Implementation
end
```

#### README Updates
- Update README.md for major features
- Update API documentation for interface changes
- Update changelog for releases

## Testing Strategies

### Unit Testing
```lua
-- Simple test function
local function testSkillRegistration()
    local skillId = "test_skill"
    API.registerSkill(skillId, {
        name = "Test Skill",
        description = "A skill for testing"
    })
    
    local stat = API.getSkillStat(skillId)
    assert(stat ~= nil, "Skill should be registered")
    assert(stat.base == 5, "Default level should be 5")
end
```

### Integration Testing
1. Test skill progression
2. Test save/load functionality
3. Test UI integration
4. Test multiplayer compatibility (if applicable)

### Performance Testing
```lua
local startTime = os.clock()
-- Run performance-intensive code
local endTime = os.clock()
print(string.format("Execution time: %.4f seconds", endTime - startTime))
```

## Common Issues and Solutions

### Lua Errors
1. **Undefined global**: Add to VS Code settings or use `---@diagnostic disable`
2. **Nil value access**: Add nil checks before accessing object properties
3. **Type errors**: Use EmmyLua type annotations

### Save Compatibility
1. Always handle missing data in onLoad
2. Use version numbers for save format changes
3. Provide migration functions for old saves

### Performance Issues
1. Throttle expensive operations in onFrame
2. Use async timers for delayed operations
3. Cache frequently accessed values

## Release Process

### Pre-release Checklist
- [ ] Update version numbers
- [ ] Update documentation
- [ ] Test all major features
- [ ] Check for Lua errors
- [ ] Verify save compatibility
- [ ] Update changelog

### Creating Release Package
```bash
# Create archive
git archive --format=zip --output=TheBardsGuild_v1.0.zip HEAD

# Add to archive (if needed)
zip -u TheBardsGuild_v1.0.zip README.md
```

### Publishing
1. Upload to mod hosting site
2. Create release notes
3. Update documentation links
4. Announce to community

## Resources

### Documentation
- [OpenMW Lua Scripting](https://openmw.readthedocs.io/en/latest/reference/lua-scripting.html)
- [EmmyLua Documentation](https://emmylua.github.io/)
- [Lua Reference Manual](https://www.lua.org/manual/5.1/)

### Community
- [OpenMW Forums](https://forum.openmw.org/)
- [OpenMW Discord](https://discord.gg/openmw)
- [Morrowind Modding Wiki](https://en.uesp.net/wiki/Morrowind:Modding)

### Tools
- [VS Code](https://code.visualstudio.com/)
- [Git](https://git-scm.com/)
- [OpenMW](https://openmw.org/)

This development guide should help you get started with contributing to The Bards Guild mod. For specific implementation questions, refer to the existing code and documentation in the project.
