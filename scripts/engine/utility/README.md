# Engine Utility Scripts

## What This Does
Utility scripts are **debugging and development tools** - not part of the main gameplay systems. These are for testing, profiling, and console commands during development.

## Files in This Folder

| File | Purpose |
|------|---------|
| `performance_console_working.lua` | Console commands for testing Bard Performance system |
| `performance_menu_simple.lua` | Simple performance helper with basic UI |

## Important Note
**These files are NOT registered in `.omwscripts`** - they run standalone in the console or export functions for manual testing.

## performance_console_working.lua

Console debugging utility for the Bard Performance system.

### Usage
Open the OpenMW console (`~` key) and type:
```lua
testPerformance()  -- Test the performance system
getPerformanceData()  -- Get current performance stats
```

### What It Does
- Tests `BardPerformance` interface availability
- Sends test events to verify event system
- Exports helper functions to global namespace for console access
- Helps debug performance-related features without UI

## performance_menu_simple.lua

Simple menu-based performance system.

### Features
- Counts nearby NPCs as "audience"
- Sends `BardPerformance` global events
- Provides `performanceHelper` global for console use
- Basic UI for selecting performance type

### Console Commands
```lua
performanceHelper.startPerformance("brilliant")  -- Start performance
performanceHelper.getAudienceCount()  -- Count nearby NPCs
performanceHelper.stopPerformance()  -- End performance
```

## How These Differ From Main Systems

| Main Systems | Utility Scripts |
|--------------|-----------------|
| Registered in `.omwscripts` | Not registered |
| Run automatically | Run manually via console |
| Part of gameplay | For debugging only |
| Required for mod to work | Optional development tools |

## When to Use These

### Use During Development:
- Testing if events are firing correctly
- Debugging UI systems without full game loop
- Manual testing of performance triggers
- Checking if interfaces are available

### Don't Use in Production:
- These clutter the global namespace
- They bypass normal game flow
- Not balanced for actual gameplay

## Creating Your Own Utilities

Template for a debug utility:
```lua
-- my_debug_utility.lua
local core = require("openmw.core")
local world = require("openmw.world")

-- Export to global for console access
_G.myDebugTool = {
    testEvent = function()
        core.sendGlobalEvent("TestEvent", {test = true})
        print("Test event sent")
    end,
    
    checkNPC = function(npcId)
        for _, actor in ipairs(world.activeActors) do
            if actor.recordId == npcId then
                print("Found: " .. npcId)
                return actor
            end
        end
        print("NPC not found")
    end
}

print("[DEBUG] My debug tool loaded. Use myDebugTool.testEvent() in console")

return {}
```

## For ChatGPT/AI Prompting

**Copy this if you want debug utilities:**

```
I want to create a debug utility script for OpenMW that:
- Exports functions to the global namespace for console access
- Helps test my main systems without full gameplay
- Sends test events
- Prints debug information
- Is NOT registered in .omwscripts (runs standalone)

Example functions:
- testEvent() - sends a test event
- checkState() - prints current game state
- resetData() - clears stored data for testing
- spawnTestNPC() - creates a test NPC
```

## Performance Testing Tips

1. **Use `core.sendGlobalEvent()`** to simulate player actions
2. **Check `world.activeActors`** to see nearby NPCs
3. **Print to console** with `print("[DEBUG] message")`
4. **Export functions globally** with `_G.myFunction = function() ... end`

## Why Keep These Separate?

- Clean separation between gameplay and debugging
- Can delete/ignore utilities for release builds
- Won't accidentally break main systems
- Other developers can use their own tools

## Cleaning Up for Release

Before releasing your mod:
```bash
# Remove or disable utility scripts
mv scripts/engine/utility/ scripts/engine/utility_dev/

# Or add to .gitignore
# Or check if debug mode enabled before loading
```

## Summary
These are **developer tools** - useful for building and testing, but not part of the player experience. Keep them in their own folder and don't register them in `.omwscripts`.
