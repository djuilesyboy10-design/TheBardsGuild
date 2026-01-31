# UI Activator System Documentation

## Overview
This document captures the working structure of the Universal Activator Framework and UI formatting standards as of the final working version. This system successfully integrates custom content with vanilla Morrowind interactions.

## System Architecture

### Core Components

#### 1. Click Activator Framework
**Location**: `scripts/engine/framework/click_activator/`

**Files**:
- `click_activator.lua` - Global activation handler
- `click_activator_player.lua` - Player-side event handling  
- `choice_menu.lua` - Universal choice menu UI
- `click_activator_config.lua` - Configuration data

#### 2. Plugin Integration
**Location**: `scripts/engine/plugins/`

**Structure**: Each NPC class has its own plugin folder:
- `merchant_class/` - Merchant interactions
- `bard_class/` - Bard interactions  
- `bard_lore/` - Bard lore content

## Critical UI Implementation Standards

### Response Window Formatting

#### **WINDOW PROPERTIES** (Both merchant and bard systems use identical):
```lua
relativeSize = util.vector2(0.6, 0.4)
relativePosition = util.vector2(0.5, 0.5)
anchor = util.vector2(0.5, 0.5)
backgroundColor = util.color.rgba(0.05, 0.05, 0.05, 0.92)
```

#### **TEXT PROCESSING** (Identical in both systems):
```lua
for line in string.gmatch(text, "([^\n]*)\n?") do
    if line == "" then
        -- Empty line becomes spacing container
        table.insert(loreContent, {
            type = ui.TYPE.Container,
            props = { paddingTop = 8 },
            content = ui.content({})
        })
    else
        -- Text line with standard formatting
        table.insert(loreContent, {
            type = ui.TYPE.Text,
            props = {
                text = line,
                textSize = 28,
                textColor = util.color.rgb(0.9, 0.8, 0.6), -- Golden color
            }
        })
    end
end
```

### **CONTENT FORMATTING STANDARDS**

#### **✅ CORRECT FORMAT** (Poetic Structure):
```lua
content = [[
*The merchant glances around, then leans forward*

Ah, traveler! The talk in Balmora is all about strange lights,
lights seen over Ghostgate in the dead of night.
The Temple's calling it an omen, a sign from the gods,
but the old folk... they remember the last time such lights appeared.

And speaking of strange things,
a caravan from the west arrived without half its merchants.
They claim bandits, they claim simple thieves,
but I saw fear in their eyes that no simple thief could cause.
]]
```

#### **❌ INCORRECT FORMAT** (Prose Structure):
```lua
content = [[
Ah, traveler! The talk in Balmora is all about the strange lights seen over Ghostgate. The Temple's calling it an omen, but the old folk... they remember the last time such lights appeared.

And speaking of strange things, a caravan from the west arrived without half its merchants. They claim bandits, but I saw fear in their eyes that no simple thief could cause.
]]
```

## Key Technical Solutions

### 1. **Vanilla Menu Restoration Fix**
**Problem**: "Cannot get class of an empty object" error when switching to vanilla dialogue/barter.

**Solution**: Use async timer with 0 delay for proper UI state transition:
```lua
action = function()
    choiceMenu.closeMenu(root)
    -- Critical: Use 0 delay timer for next-frame execution
    async:newUnsavableGameTimer(0, function()
        I.UI.setMode("Dialogue")  -- or I.UI.addMode('Barter', {target = npc})
    end)
end
```

### 2. **UI Cleanup Protocol**
**Standard cleanup sequence**:
```lua
local function cleanupExistingUI()
    if root then
        auxUi.deepDestroy(root)
        root = nil
    end
    I.UI.setMode(nil)
end
```

### 3. **Choice Menu Structure**
**Standard choice menu implementation**:
```lua
-- Always include vanilla options
table.insert(choices, {
    text = "[Morrowind] Talk & Persuade",
    description = "Use standard dialogue with persuasion options",
    action = function()
        choiceMenu.closeMenu(root)
        async:newUnsavableGameTimer(0, function()
            I.UI.setMode("Dialogue")
        end)
    end
})

-- Add barter for merchants/publicans
if npcClass == "trader service" or npcClass == "publican" then
    table.insert(choices, {
        text = "[Morrowind] Barter", 
        description = "Open merchant barter interface",
        action = function()
            choiceMenu.closeMenu(root)
            async:newUnsavableGameTimer(0, function()
                I.UI.addMode('Barter', {target = npc})
            end)
        end
    })
end
```

## Content Formatting Guidelines

### **Poetic Structure Rules**:

1. **Line Length**: Keep lines under 60 characters for optimal display
2. **Stanza Breaks**: Use empty lines to create natural reading pauses
3. **Action Descriptions**: Use italicized format: `*The merchant leans in...*`
4. **Rhythm**: Break sentences at natural speaking points
5. **Emphasis**: Use line breaks to highlight important phrases

### **Example Transformation**:

**Before (Prose)**:
```
The merchant told me about strange lights over Ghostgate and said the Temple was calling it an omen, but the old folk remembered the last time this happened.
```

**After (Poetic)**:
```
The merchant told me about strange lights,
lights over Ghostgate in the dead of night.
The Temple was calling it an omen,
but the old folk remembered the last time this happened.
```

## File Dependencies

### **Required Imports**:
```lua
local ui = require("openmw.ui")
local util = require("openmw.util") 
local async = require("openmw.async")
local I = require("openmw.interfaces")
local auxUi = require("openmw_aux.ui")
```

### **Event Flow**:
1. `click_activator.lua` → Detects NPC click
2. `click_activator_player.lua` → Receives event
3. `choice_menu.lua` → Shows interaction menu
4. Plugin helper → Shows content response

## Testing Checklist

### **Functional Requirements**:
- [ ] Custom interactions work correctly
- [ ] Vanilla dialogue opens without crash
- [ ] Barter interface opens for merchants
- [ ] UI cleanup works between transitions
- [ ] Response windows display with proper formatting

### **Visual Requirements**:
- [ ] Text fits window properly (no long rectangles)
- [ ] Poetic line breaks create readable stanzas
- [ ] Golden text color (0.9, 0.8, 0.6) for lore content
- [ ] Proper spacing between sections
- [ ] Click-to-continue functionality works

## Version Lock Information

**Working Version**: Final implementation as of documentation date
**Key Fixes Applied**:
1. Async timer solution for vanilla menu transitions
2. Poetic content formatting for proper display
3. Standardized UI cleanup protocols
4. Consistent window sizing and positioning

**Do Not Modify Without Testing**:
- Async timer implementation (critical for crash prevention)
- Window size properties (0.6, 0.4 relative size)
- Text processing loop in showResult functions
- Content formatting standards

## Future Development Guidelines

### **Adding New NPC Classes**:
1. Create plugin folder: `scripts/engine/plugins/new_class/`
2. Implement helper with standardized UI functions
3. Use identical showResult() function from merchant/bard pattern
4. Format content data using poetic structure
5. Add configuration to click_activator_config.lua

### **Content Creation**:
- Always use poetic line breaks
- Keep action descriptions in italics
- Test content display in-game before finalizing
- Follow stanza break patterns for readability

---

**Document Created**: Lock down of working Universal Activator Framework
**Purpose**: Prevent regression of UI formatting and vanilla integration fixes
**Status**: ✅ WORKING VERSION - DO NOT MODIFY WITHOUT THOROUGH TESTING
