# Quest Monitor Framework

Event-driven system that tracks journal updates and triggers narrative events.
Part of the Universal Activator Framework.

## Event Flow

```
Quest Update → Player Script → Global Engine → Event Handler → Action
```

1. **Player Script** detects quest stage change via `onQuestUpdate`
2. Sends `JMCG_QuestStageChanged` to global engine
3. **Global Engine** looks up trigger in config, sends specific event back to player
4. **Player Script** handles the event and performs actions

## How to Add a Quest Trigger

### Step 1: Add to Config

Edit `quest_monitor_config.lua`:

```lua
["quest_id_lowercase"] = {
    [stage_number] = {
        event = "JMCG_YourEventName",
        description = "What happens at this stage"
    }
}
```

Example:
```lua
["jmcg_final"] = {
    [50] = {
        event = "JMCG_FinalTeleportToArena",
        description = "Teleport player to The Gods Arena"
    }
}
```

### Step 2: Handle Event in Player Script

Edit `quest_monitor_player.lua`:

```lua
eventHandlers = {
    JMCG_YourEventName = function(data)
        -- Perform action here
    end
}
```

## Universal Travel Integration

For teleportation, fire `UT_Travel`:

```lua
JMCG_FinalTeleportToArena = function(data)
    require("openmw.core").sendGlobalEvent("UT_Travel", {
        network = "gods_arena",
        destination = "final_arena"
    })
end
```

Then add destination to `../universal_travel/ut_destinations.lua`:

```lua
gods_arena = {
    final_arena = {
        name = "The Gods Arena",
        cell = "the gods arena", 
        pos = {2421.627, 3171.506, 14339.819},
        description = "Final confrontation arena"
    }
}
```

## File Structure

```
quest_monitor/
├── quest_monitor_config.lua      -- Quest/stage → Event mappings
├── quest_monitor_engine.lua      -- Global event handler  
├── quest_monitor_player.lua      -- Player detection & actions
└── README.md                     -- This file
```

## Registration

Required in `.omwscripts`:

```
GLOBAL: scripts/engine/framework/quest_monitor/quest_monitor_engine.lua
PLAYER: scripts/engine/framework/quest_monitor/quest_monitor_player.lua
```

## Why Event-Driven?

Uses `onQuestUpdate` - **zero CPU** until journal entry added. Highly optimized.
