# NPC Schedule System

## What This Does
The NPC Schedule System makes NPCs **move around and change behavior based on time of day**. NPCs can go to work, visit taverns, go home to sleep, or follow custom daily routines.

## Real World Use
- Shopkeepers open/close stores at specific times
- Guards patrol different routes day vs night
- NPCs visit taverns after work hours
- Create realistic town life with daily routines

## Files in This Folder

| File | Purpose |
|------|---------|
| `npc_schedule_global.lua` | GLOBAL script - tracks time, calculates what NPCs should be doing |
| `npc_schedule_player.lua` | PLAYER script - receives schedule updates, applies to nearby NPCs |
| `npc_schedule_data.lua` | Data file - defines schedules for each NPC (optional) |

## How It Works (Simple Version)

```
Game Time Changes → Global Calculates Schedules → Sends to Player → Apply to NPCs
```

1. **Global Script** checks game time every few minutes
2. **Calculates** what each NPC should be doing based on schedule
3. **Sends events** to player script with movement commands
4. **Player Script** applies movement to NPCs near the player
5. **NPCs walk** to their scheduled destinations

## For ChatGPT/AI Prompting

**Copy this into your AI:**

```
I want to create an NPC schedule system for OpenMW where NPCs follow daily routines.

The system should:
- Track game time (hours, days)
- Define schedules: [time ranges] → [destination positions]
- Move NPCs to scheduled locations when time changes
- Handle transitions smoothly (NPCs walk between points)
- Support different schedules per NPC type (merchant, guard, villager)

Architecture:
- GLOBAL: Checks time periodically (newUnsavableGameTimer), calculates all NPC schedules
- PLAYER: Receives movement commands, applies to nearby NPCs using AI packages
- DATA: Schedule table with NPC ID, time blocks, and destinations

Example schedule:
{
    npcId = "npc_caius",
    routines = {
        [6] = { pos = caiusOffice, action = "work" },    -- 6AM: go to office
        [12] = { pos = eightPlates, action = "eat" },    -- 12PM: lunch at tavern
        [18] = { pos = caiusOffice, action = "work" },   -- 6PM: back to work
        [22] = { pos = caiusHouse, action = "sleep" }    -- 10PM: go home
    }
}

Use core.getGameTime() for time checking. Send movement commands via events.
```

## Key Code Patterns

### Schedule Structure
```lua
local schedules = {
    ["npc_caius_cosades"] = {
        [6] = { 
            position = { x = 100, y = 200, z = 50 },
            cell = "Balmora",
            action = "work"
        },
        [12] = { 
            position = { x = 150, y = 250, z = 50 },
            cell = "Balmora",
            action = "eat"
        }
    }
}
```

### Time Check (Global)
```lua
local function checkSchedules()
    local gameTime = core.getGameTime()
    local hour = math.floor(gameTime % 24)
    
    for npcId, schedule in pairs(schedules) do
        local currentRoutine = schedule[hour]
        if currentRoutine then
            -- Send movement command
            core.sendGlobalEvent("NPCSchedule_Move", {
                npcId = npcId,
                destination = currentRoutine.position,
                cell = currentRoutine.cell
            })
        end
    end
end

-- Check every 5 minutes
async:newUnsavableGameTimer(300, checkSchedules)
```

### Apply Movement (Player)
```lua
eventHandlers = {
    NPCSchedule_Move = function(data)
        local npc = findNPCById(data.npcId)
        if npc and nearby.isNear(player, npc, 5000) then
            -- Only move NPCs near player (performance)
            npc:setAI(data.destination)
        end
    end
}
```

## Integration Points

- **World Time**: Uses core.getGameTime() for accurate tracking
- **AI System**: Hooks into OpenMW's pathfinding
- **Cell System**: Handles NPCs moving between exterior/interior cells

## Registration in .omwscripts

```
GLOBAL: scripts/engine/framework/npc_schedule/npc_schedule_global.lua
PLAYER: scripts/engine/framework/npc_schedule/npc_schedule_player.lua
```

## Copy-Paste for Your Own Mod

1. Copy both schedule files
2. Edit schedule data with your NPCs and locations:
   ```lua
   local mySchedules = {
       ["my_npc_id"] = {
           [8] = { position = {x=100,y=200,z=0}, cell="Balmora" }
       }
   }
   ```
3. Register global and player scripts

## Common Issues

| Problem | Solution |
|---------|----------|
| NPCs not moving | Check position coordinates are valid |
| Performance lag | Only update NPCs within 5000 units of player |
| NPCs stuck | Ensure destination cell is loaded |
| Wrong times | Remember gameTime is in hours (0-23) |

## Performance Notes
- Only updates NPCs near player
- Timer-based (not frame-based)
- Minimal memory usage (just position data)
