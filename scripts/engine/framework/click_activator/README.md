# Click Activator

## What This Does
The Click Activator adds **custom interaction menus to NPCs**. When you click on certain NPCs, instead of immediately opening vanilla dialogue, it shows a choice menu with options like custom dialogue, lore, or returning to vanilla Morrowind dialogue.

## Real World Use
- Add custom dialogue options to merchants, bards, or lore-keepers
- Create "lore givers" who tell stories before letting you trade
- Add class-specific interactions (different options for priests vs warriors)
- Seamlessly integrate with vanilla dialogue (players can always choose vanilla option)

## Files in This Folder

| File | Purpose |
|------|---------|
| `click_activator.lua` | GLOBAL script - detects NPC clicks, sends events to player |
| `click_activator_player.lua` | PLAYER script - shows choice menu, handles UI |
| `click_activator_config.lua` | Config file - defines which NPC classes get custom menus |
| `choice_menu.lua` | UI helper - creates the actual choice menu display |

## How It Works (Simple Version)

```
Player Clicks NPC → Check NPC Class → Show Choice Menu → Player Chooses
                                         ↓
                    Vanilla Dialogue ←→ Custom Content
```

1. **Global Script** detects when player clicks any NPC
2. **Checks config** to see if that NPC class has custom content
3. **Sends event** to player script if custom content exists
4. **Player Script** shows choice menu with options
5. **Choice Menu** handles the UI creation and option display

## For ChatGPT/AI Prompting

**Copy this into your AI:**

```
I want to create an NPC interaction system for OpenMW that shows a choice menu when clicking certain NPCs.

The system should:
- Detect when player clicks on NPCs (use I.Activation.addHandlerForType)
- Check if NPC class matches configured classes in a data table
- Show a choice menu with: [Custom Dialogue], [Vanilla Dialogue], [Barter] options
- Custom options trigger lore/scripts, vanilla returns to normal Morrowind dialogue
- Support multiple NPC classes (merchant, bard, priest, etc.)

Architecture:
- GLOBAL script handles detection and sends events
- PLAYER script receives events and creates UI
- Config file defines which classes get which content
- Use async timers for menu transitions (prevents crashes)

Key requirement: Return false from activation handler for custom NPCs (blocks vanilla), return true to allow vanilla dialogue.
```

## Key Code Patterns

### Detecting NPC Clicks (Global)
```lua
local I = require('openmw.interfaces')
local types = require('openmw.types')

I.Activation.addHandlerForType(types.NPC, function(npc, actor)
    -- Check if this is player clicking
    local player = world.players[1]
    if actor ~= player then return true end
    
    -- Get NPC class
    local npcClass = types.NPC.record(npc).class
    
    -- Check if we have custom content
    if config[npcClass] then
        -- Send to player script for UI
        actor:sendEvent("ShowInteractionChoice", {
            npc = npc,
            class = npcClass
        })
        return false  -- Block vanilla dialogue
    end
    
    return true  -- Allow vanilla dialogue
end)
```

### Choice Menu Structure
```lua
local choices = {
    {
        text = "[Custom] Ask about local lore",
        description = "Hear stories about this region",
        action = function()
            showLoreContent(npc, "region_lore")
        end
    },
    {
        text = "[Morrowind] Talk & Persuade",
        description = "Standard dialogue",
        action = function()
            closeMenu()
            async:newUnsavableGameTimer(0, function()
                I.UI.setMode("Dialogue")
            end)
        end
    }
}
```

### Menu Transition (Critical!)
```lua
-- ALWAYS use async timer for vanilla menu transitions
action = function()
    closeMenu(root)
    async:newUnsavableGameTimer(0, function()
        I.UI.setMode("Dialogue")  -- or I.UI.addMode('Barter', {target = npc})
    end)
end
```

## Integration Points

- **NPC Class System**: Uses Morrowind's class system (publican, trader, priest, etc.)
- **Vanilla Dialogue**: Can seamlessly return to standard Morrowind interaction
- **Plugin System**: Other scripts can register content for specific NPC classes

## Registration in .omwscripts

```
GLOBAL: scripts/engine/framework/click_activator/click_activator.lua
PLAYER: scripts/engine/framework/click_activator/click_activator_player.lua
```

## Copy-Paste for Your Own Mod

1. Copy all 4 files
2. Edit `click_activator_config.lua` to add your NPC classes:
   ```lua
   local activators = {
       ["publican"] = { plugin = "merchant_class" },
       ["bard"] = { plugin = "bard_class" },
       ["priest"] = { plugin = "temple_class" }
   }
   ```
3. Create plugin folders in `scripts/engine/plugins/[your_class]/`
4. Register global and player scripts in `.omwscripts`

## Common Issues

| Problem | Solution |
|---------|----------|
| Menu doesn't appear | Check NPC class spelling (case-sensitive) |
| Can't return to vanilla | Make sure async timer wraps I.UI.setMode() |
| "Cannot get class of empty object" | Add safety checks for npc.record before accessing |
| UI crashes on close | Always use :destroy() on root widget before mode change |

## Plugin Development

Create custom content in `scripts/engine/plugins/[plugin_name]/`:

```lua
-- plugin_helper.lua
local function showContent(npc, content)
    -- Your custom UI here
    -- Use same patterns as click_activator
end

return {
    showContent = showContent
}
```

## Performance Notes
- Event-driven (no polling)
- Only activates on NPC clicks
- Lightweight - returns immediately if no custom content configured
