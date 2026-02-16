# Dialogue System

## What This Does
The Dialogue System provides **dynamic NPC conversations** that respond to player actions, quest progress, and world state. Unlike static Morrowind dialogue, this system generates contextual responses based on what the player has actually done.

## Real World Use
- NPCs comment on quests you've completed
- Merchants give different rumors based on reputation
- Dynamic persuasion that considers your fame/infamy
- Context-sensitive dialogue that changes as story progresses

## Files in This Folder

| File | Purpose |
|------|---------|
| `bard_performance_dialogue.lua` | Performance evaluation system - rates player performances |
| `bard_performance_dynamic.lua` | Dynamic performance menu with audience reaction system |
| `dialogue_cooldown_manager.lua` | Prevents dialogue spam with time-based cooldowns |

## How It Works (Simple Version)

```
Player Triggers Dialogue → System Checks Conditions → Returns Contextual Response
```

1. **Event System** listens for player actions (quest completion, reputation changes)
2. **Condition Checker** looks at current game state
3. **Response Generator** picks appropriate dialogue based on conditions
4. **Cooldown Manager** prevents same dialogue from firing too often

## For ChatGPT/AI Prompting

**Copy this into your AI:**

```
I want to create a dynamic dialogue system for OpenMW that generates contextual NPC responses.

The system should:
- Listen for player events (quest complete, reputation change, skill increase)
- Store dialogue options with conditions (quest stage required, reputation threshold)
- Check conditions when dialogue triggered
- Return appropriate response based on current game state
- Include cooldown system to prevent dialogue spam

Architecture:
- Event-driven (no polling)
- Separate data file with dialogue entries and conditions
- Cooldown manager using timestamps
- Interface for other scripts to register dialogue

Each dialogue entry needs:
- text: The actual dialogue text
- conditions: { questId, minStage, reputation, etc. }
- cooldown: Time before this can trigger again
- priority: Which dialogue wins if multiple conditions match
```

## Key Code Patterns

### Dialogue Entry Structure
```lua
local dialogueEntries = {
    {
        id = "greeting_post_quest",
        text = "Thank you for saving the village! We owe you everything.",
        conditions = {
            questId = "save_village",
            minStage = 100
        },
        cooldown = 300,  -- seconds
        priority = 10
    },
    {
        id = "greeting_generic",
        text = "Hello, traveler. What brings you here?",
        conditions = {},  -- No conditions = always available
        cooldown = 60,
        priority = 1
    }
}
```

### Condition Checking
```lua
function checkConditions(conditions, playerData)
    if conditions.questId then
        local stage = playerData.questStages[conditions.questId] or 0
        if stage < conditions.minStage then
            return false
        end
    end
    
    if conditions.reputation then
        if playerData.reputation < conditions.reputation then
            return false
        end
    end
    
    return true
end
```

### Cooldown Management
```lua
local lastPlayed = {}

function canTrigger(dialogueId, cooldown)
    local now = os.time()
    if lastPlayed[dialogueId] then
        local timeSince = now - lastPlayed[dialogueId]
        if timeSince < cooldown then
            return false  -- Still on cooldown
        end
    end
    lastPlayed[dialogueId] = now
    return true
end
```

## Integration Points

- **Quest Monitor**: Provides quest stage updates
- **Reputation System**: Checks player standing with factions
- **Click Activator**: Triggers dialogue when NPCs clicked
- **Cooldown Manager**: Prevents dialogue spam

## Registration in .omwscripts

```
PLAYER: scripts/engine/framework/dialogue/dialogue_cooldown_manager.lua
-- Other files are helper modules (required by other scripts)
```

## Copy-Paste for Your Own Mod

1. Copy the dialogue files
2. Create your `dialogue_data.lua` with entries
3. Add condition checking in your NPC interaction handler:
   ```lua
   local dialogue = require('your_mod.dialogue_data')
   local response = dialogue.getResponse(playerData)
   ui.showMessage(response)
   ```

## Common Issues

| Problem | Solution |
|---------|----------|
| Dialogue not triggering | Check condition values match exactly |
| Same line repeating | Verify cooldown is being set after playing |
| Wrong priority | Higher number = higher priority (10 beats 5) |

## Performance Notes
- Zero polling - only checks when dialogue triggered
- Cooldowns stored in memory (not saved)
- Condition checks are O(1) lookups
