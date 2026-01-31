# Faction-Based NPC System Formula
## **🎯 PROVEN WORKING METHOD**

### **📋 Overview**
Successfully created faction-specific guard interactions with separate dialogue, UI theming, and content routing.

---

## **🏗️ Working Architecture**

### **File Structure**
```
guard_class/
├── guard_class_event_listener.lua          # Main event router
├── guard_class_helper.lua                 # Default guard helper
├── guard_content_data.lua                 # Default guard content
├── hlaalu_guard_helper.lua                # Hlaalu-specific helper
└── hlaalu_guard_content_data.lua          # Hlaalu-specific content
```

### **🔧 Core Components**

#### **1. Event Listener (Faction Router)**
```lua
-- guard_class_event_listener.lua
return {
    eventHandlers = {
        GuardClassShowMenu = function(eventData)
            -- Faction detection logic
            local isHlaalu = false
            if eventData and eventData.npc then
                local types = require("openmw.types")
                local npcRecord = types.NPC.record(eventData.npc)
                if npcRecord and npcRecord.name then
                    isHlaalu = string.find(string.lower(npcRecord.name), "hlaalu") ~= nil
                end
            end
            
            -- Route to appropriate helper
            if isHlaalu then
                require("scripts.engine.plugins.guard_class.hlaalu_guard_helper").show()
            else
                require("scripts.engine.plugins.guard_class.guard_class_helper").show()
            end
        end
    }
}
```

#### **2. Faction-Specific Helper**
```lua
-- hlaalu_guard_helper.lua
local hlaaluGuardContent = require("scripts.engine.plugins.guard_class.hlaalu_guard_content_data")

local function showChoiceMenu()
    -- Hlaalu-themed UI (gold colors)
    local choices = {
        {
            text = "What's the security situation like here?",
            action = function()
                close()
                local content = hlaaluGuardContent[1]
                showResult(content.content)
            end
        }
        -- ... more choices
    }
    -- UI creation with Hlaalu theming
end

function M.show()
    showChoiceMenu()
end

return M
```

#### **3. Faction-Specific Content**
```lua
-- hlaalu_guard_content_data.lua
local hlaaluGuardContent = {
    [1] = {
        title = "Hlaalu Security",
        content = [[
*The Hlaalu guard adjusts their House insignia*

Security in Hlaalu territory?
It's different than Imperial justice.
We protect House interests first,
the Empire second.
]]
    }
    -- ... more content entries
}

return hlaaluGuardContent
```

---

## **🎨 UI Theming by Faction**

### **Default Guards (Steel Blue)**
```lua
textColor = util.color.rgb(0.8, 0.8, 0.9)  -- Steel blue
```

### **Hlaalu Guards (Gold)**
```lua
textColor = util.color.rgb(1.0, 0.8, 0.2)  -- House Hlaalu gold
```

---

## **🚀 Quick Faction Creation Formula**

### **Step 1: Create Faction Helper**
```bash
# Copy base helper
cp guard_class_helper.lua [faction]_guard_helper.lua
```

### **Step 2: Update Helper Content**
```lua
-- Change require path
local [faction]GuardContent = require("scripts.engine.plugins.guard_class.[faction]_guard_content_data")

-- Update UI theming
textColor = util.color.rgb([r], [g], [b])  -- Faction colors

-- Update title
text = "What would you like to ask this [faction] guard?",
```

### **Step 3: Create Faction Content**
```bash
# Copy base content
cp guard_content_data.lua [faction]_guard_content_data.lua
```

### **Step 4: Update Event Listener**
```lua
-- Add faction detection
if string.find(string.lower(npcRecord.name), "[faction]") ~= nil then
    is[Faction] = true
end

-- Add routing
if is[Faction] then
    require("scripts.engine.plugins.guard_class.[faction]_guard_helper").show()
```

---

## **🎯 Faction Detection Methods**

### **Method 1: Name-Based (RELIABLE)**
```lua
if npcRecord.name then
    isHlaalu = string.find(string.lower(npcRecord.name), "hlaalu") ~= nil
end
```

### **Method 2: Faction System (Advanced)**
```lua
local factions = require("openmw.types").Factions
for _, faction in ipairs(factions.records) do
    if faction.name and string.find(string.lower(faction.name), "hlaalu") then
        -- Check NPC membership
        isHlaalu = true
        break
    end
end
```

---

## **📋 Implementation Checklist**

### **✅ Required Files**
- [ ] `[class]_class_event_listener.lua` - Event router
- [ ] `[class]_class_helper.lua` - Default helper
- [ ] `[class]_content_data.lua` - Default content
- [ ] `[faction]_[class]_helper.lua` - Faction helper
- [ ] `[faction]_[class]_content_data.lua` - Faction content

### **✅ Configuration Updates**
- [ ] Add class to `click_activator_config.lua`
- [ ] Register event listener in `TheBardsGuild.omwscripts`

### **✅ Key Requirements**
- [ ] Use exact require path: `scripts.engine.plugins.[class].[helper]`
- [ ] Event listener must handle `eventData` parameter
- [ ] Faction detection must be robust
- [ ] UI theming must match faction identity

---

## **🔍 Troubleshooting**

### **Module Not Found Error**
- **Cause**: Incorrect require path or file location
- **Fix**: Use exact path pattern: `scripts.engine.plugins.[class].[helper]`
- **Verify**: Files exist in correct directory

### **Faction Detection Not Working**
- **Cause**: NPC name doesn't contain faction keyword
- **Fix**: Use name-based detection as fallback
- **Debug**: Log NPC name and faction data

### **UI Not Showing**
- **Cause**: Helper not loading or content missing
- **Fix**: Verify require paths in helper files
- **Debug**: Check for Lua errors in console

---

## **🎯 Next Faction Templates**

### **Redoran Guards**
- **Colors**: Dark red/burgundy
- **Themes**: Honor, duty, tradition
- **Detection**: "redoran" in NPC name

### **Imperial Guards**
- **Colors**: Silver/white
- **Themes**: Law, order, Empire
- **Detection**: "imperial" in NPC name

### **Telvanni Guards**
- **Colors**: Purple/magenta
- **Themes**: Magic, knowledge, power
- **Detection**: "telvanni" in NPC name

---

## **🏆 Success Metrics**

✅ **Faction Detection**: Working
✅ **Content Routing**: Working  
✅ **UI Theming**: Working
✅ **Module Loading**: Working
✅ **Event Handling**: Working

**This formula is PROVEN and ready for rapid faction deployment!** 🚀
