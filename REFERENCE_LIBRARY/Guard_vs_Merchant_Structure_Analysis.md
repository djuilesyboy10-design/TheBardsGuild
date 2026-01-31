# Guard vs Merchant Structure Analysis

## **🔍 Problem Identification**
Manual Guard class creation vs working Merchant class - module not found error.

## **📋 File Structure Comparison**

### **✅ Working Merchant Class**
```
merchant_class/
├── merchant_class_event_listener.lua
├── merchant_class_helper.lua
└── merchant_content_data.lua
```

### **❌ Problematic Guard Class**
```
guard_class/
├── guard_class_event_listener.lua
├── guard_class_helper.lua              # (copied from helpers/)
├── hlaalu_guard_helper.lua             # (copied from helpers/factions/)
├── guard_content_data.lua              # (copied from content/)
└── hlaalu_guard_content_data.lua       # (copied from content/factions/)
```

## **🔍 Event Listener Comparison**

### **Merchant Event Listener** (WORKING)
```lua
return {
    eventHandlers = {
        MerchantClassShowMenu = function()
            print("[MERCHANT_CLASS] Merchant NPC detected - showing interaction menu")
            require("scripts.engine.plugins.merchant_class.merchant_class_helper").show()
        end
    }
}
```

### **Guard Event Listener** (NOT WORKING)
```lua
return {
    eventHandlers = {
        GuardClassShowMenu = function(eventData)
            print("[GUARD_CLASS] Guard class event triggered!")
            
            -- Complex faction detection logic...
            
            -- Route to appropriate helper
            if isHlaalu then
                print("[GUARD_CLASS] Routing to Hlaalu guard helper")
                local hlaaluGuardHelper = require("scripts.engine.plugins.guard_class.hlaalu_guard_helper")
                hlaaluGuardHelper.show()
            else
                print("[GUARD_CLASS] Routing to default guard helper")
                local guardHelper = require("scripts.engine.plugins.guard_class.guard_class_helper")
                guardHelper.show()
            end
        end
    }
}
```

## **🎯 Key Differences Identified**

### **1. Function Signature**
- **Merchant**: `MerchantClassShowMenu = function()` (no parameters)
- **Guard**: `GuardClassShowMenu = function(eventData)` (has eventData parameter)

### **2. Event Data Handling**
- **Merchant**: Doesn't use eventData
- **Guard**: Uses eventData.npc for faction detection

### **3. Helper Loading**
- **Merchant**: Direct require and call
- **Guard**: Conditional require based on faction detection

### **4. Module Path**
- **Merchant**: `scripts.engine.plugins.merchant_class.merchant_class_helper`
- **Guard**: `scripts.engine.plugins.guard_class.hlaalu_guard_helper`

## **🔍 Potential Issues**

### **Issue 1: Event Data Parameter**
The merchant event listener doesn't expect eventData, but the guard one does. This might indicate a fundamental difference in how the events are triggered.

### **Issue 2: Module Naming**
- Merchant: `merchant_class_helper.lua`
- Guard: `hlaalu_guard_helper.lua` (different naming pattern)

### **Issue 3: File Content Verification**
Need to verify that the copied files have identical structure to working templates.

## **🛠️ Recommended Fixes**

### **Fix 1: Simplify Event Listener**
Remove eventData parameter and faction detection temporarily to match merchant pattern.

### **Fix 2: Use Standard Naming**
Rename `hlaalu_guard_helper.lua` to `guard_class_helper.lua` to match merchant pattern.

### **Fix 3: Verify File Contents**
Ensure copied files have exact same structure as working templates.

## **🧪 Testing Strategy**

1. **Step 1**: Create minimal guard helper matching merchant exactly
2. **Step 2**: Test basic functionality without faction detection
3. **Step 3**: Add faction detection once basic works
4. **Step 4: Add Hlaalu-specific content once routing works

## **📝 Next Steps**

The issue is likely in the event handling or file structure. Let's create a minimal test case first.
