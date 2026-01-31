# Universal Activator Framework - Roadmap

## 🎯 Objective
Create a universal, plug-and-play system for ALL activator types in Morrowind (containers, objects, doors, custom items), following the same architectural principles as our successful NPC trigger system.

## 🏗️ Foundation: Adapt Herbalism System

### **Why Adapt Herbalism:**
- ✅ **Proven Architecture**: Working flawlessly in production
- ✅ **Event-Driven Design**: Perfect universal pattern
- ✅ **Skill Integration**: Shows framework compatibility
- ✅ **Battle-Tested**: Real-world debugging completed
- ✅ **Clean Separation**: Global detection + Player events

### **Herbalism Pattern to Universalize:**
```lua
-- GLOBAL (herbalish_g.lua) → UNIVERSAL (universal_activator.lua)
I.Activation.addHandlerForType(types.Flora, function(object, actor))
    → Universal activation hook for any type

-- PLAYER (herbalish_p.lua) → UNIVERSAL (activator_event_handlers.lua)
eventHandlers = { HerbalismHarvest = function(data) }
    → Universal event handling system
```

## 🚀 Phase 1: Foundation Architecture (Session 1)

### **Core Files to Create:**

#### **1. `universal_activator.lua`**
```lua
-- Adapted from herbalish_g.lua
local activatorEngine = {
    handlers = {},
    
    registerActivator = function(config)
        table.insert(activatorEngine.handlers, config)
        print("[ACTIVATOR] Registered:", config.name)
    end,
    
    handleActivation = function(object, actor)
        -- Universal logic adapted from herbalism pattern
    end
}

-- Universal activation hooks (adapted from flora activation)
I.Activation.addHandlerForType(types.Container, function(object, actor))
I.Activation.addHandlerForType(types.Door, function(object, actor))
I.Activation.addHandlerForId(specificId, function(object, actor))
```

#### **2. `activator_helpers.lua`**
```lua
-- Adapted from trigger_helpers.lua pattern
return {
    checkActivatorCondition = function(config, object, actor)
        -- Skill checks, item requirements, quest conditions
    end,
    
    fireActivatorEvent = function(config, object, actor)
        -- Event dispatch system
    end
}
```

#### **3. `activator_config.lua`**
```lua
-- Configuration for all activator types
return {
    activators = {
        {
            name = "HerbalismPlant",
            type = "flora",
            event = "HerbalismHarvest",
            condition = {skill = "herbalism"}
        },
        {
            name = "ChronalShardContainer", 
            type = "container",
            objectId = "jm_chronal_chest_01",
            event = "ChronalShardFound",
            condition = {skill = "bard_skill", level = 25}
        }
    }
}
```

### **Migration Strategy:**
1. **Extract herbalism logic** into universal pattern
2. **Keep herbalism working** (no breaking changes)
3. **Add new activator types** using same pattern
4. **Test both systems** in parallel

## 🎯 Phase 2: Integration & Extension (Session 2)

### **Extend to Merchant System:**
```lua
-- Add NPC activation triggers
{
    name = "MerchantDialogueTrigger",
    type = "npc_activation",
    npcClass = "trader service",
    event = "MerchantInteractionEvent",
    condition = {disposition = 50}
}
```

**How it works:**
- Player activates NPC (talks to them)
- Universal activator intercepts activation
- Checks conditions (disposition, reputation, skills)
- Fires event for enhanced dialogue options

### **Propylon Integration:**
```lua
{
    name = "PropylonTuningFork",
    type = "object",
    objectId = "jm_devils_tuning_fork", 
    event = "PropylonJumpEvent",
    condition = {skill = "bard_skill", maxJumps = 5}
}
```

## 🚀 Phase 3: Plugin Generator (Session 3)

### **`activator_generator.lua`**
```lua
-- Adapted from plugin_generator.lua pattern
local activator_generator = {}

-- Templates based on activator types
local templates = {
    container = "container_template.lua",
    object = "object_template.lua", 
    door = "door_template.lua",
    npc = "npc_activation_template.lua"
}

function activator_generator.generate(activatorType, config)
    -- Generate complete activator system
end
```

### **Generated Files (Per Activator):**
```
scripts/engine/plugins/activator_name/
├── activator_name_event_listener.lua
├── activator_name_helper.lua  
└── activator_name_config.lua
```

## 🎯 Phase 4: Advanced Features (Session 4)

### **Multi-Condition Logic:**
```lua
condition = {
    operator = "AND",
    requirements = {
        {type = "skill", skill = "bard_skill", level = 25},
        {type = "item", itemId = "jm_key_mystic"},
        {type = "quest", topic = "jm_quest", stage = 10}
    }
}
```

### **Chain Reactions:**
```lua
onSuccess = {
    fireEvent = "UnlockSecretDoor",
    giveItem = "jm_reward_item",
    updateQuest = "jm_quest_stage_20"
}
```

### **Risk/Reward System (Propylon):**
```lua
riskProfile = {
    baseRisk = 0.1,
    skillModifier = -0.02, -- Per 25 skill points
    jumpPenalty = 0.15, -- Per extra jump
    misfireScenarios = {"cell_trap_01", "cell_trap_02"}
}
```

## 🎯 Phase 5: Testing & Documentation (Session 5)

### **Test Coverage:**
- ✅ Herbalism system unchanged (regression test)
- ✅ New activator types work correctly
- ✅ Performance impact < 1%
- ✅ Error handling comprehensive

### **Documentation:**
- API reference
- Migration guide from manual to universal
- Troubleshooting common issues
- Example implementations

## 🚀 Implementation Timeline

### **Week 1: Foundation**
- **Session 1 (2-3 hrs):** Adapt herbalism → Universal system
- **Session 2 (2-3 hrs):** Integration with merchant/propylon

### **Week 2: Tools & Polish**  
- **Session 3 (2-3 hrs):** Plugin generator
- **Session 4 (2-3 hrs):** Advanced features
- **Session 5 (2-3 hrs):** Testing & documentation

**Total: ~10-15 hours**

## 🏆 Success Metrics

### **Technical:**
- ✅ Zero breaking changes to existing systems
- ✅ New activator creation < 5 minutes
- ✅ Performance impact < 1%
- ✅ 100% backward compatibility

### **Usability:**
- ✅ Simple configuration syntax
- ✅ Comprehensive documentation
- ✅ Working examples
- ✅ Easy troubleshooting

### **Integration:**
- ✅ Works with NPC trigger system
- ✅ Compatible with skill framework
- ✅ Future-proof architecture
- ✅ Community adoption ready

## 🎯 The End Vision

**Before:** Each activator = custom coding, debugging, maintenance
**After:** Each activator = configuration entry, automatic generation

**Universal Activator Types:**
- ✅ **Containers** (herbalism, chests, barrels)
- ✅ **Objects** (propylon fork, custom items)
- ✅ **Doors** (secret doors, quest doors)
- ✅ **NPCs** (enhanced dialogue triggers)
- ✅ **Flora** (plants, harvesting)
- ✅ **Custom** (any future activator type)

## 🚀 Quick Start Examples

### **Create Container Activator:**
```lua
generator.generate("container", {
    name = "MyChest",
    objectId = "my_chest_01",
    event = "MyChestEvent",
    condition = {skill = "security", level = 30}
})
```

### **Create NPC Activator:**
```lua
generator.generate("npc_activation", {
    name = "EnhancedMerchant",
    npcClass = "trader service", 
    event = "EnhancedMerchantEvent",
    condition = {disposition = 60}
})
```

### **Create Propylon Activator:**
```lua
generator.generate("object", {
    name = "RiskyPropylon",
    objectId = "jm_propylon_activator",
    event = "PropylonJumpEvent", 
    condition = {skill = "bard_skill", maxJumps = 5}
})
```

---

**Result:** Complete plug-and-play system for ANY activator type in Morrowind! 🗡️✨

## 📝 Notes & Decisions

### **Key Architectural Decision:**
Adapt herbalism system rather than build fresh because:
- Proven, tested architecture
- Zero risk of breaking existing functionality  
- Perfect event-driven pattern
- Already integrates with skill framework

### **Integration Strategy:**
- Keep herbalism working unchanged (regression safety)
- Build universal system alongside
- Gradually migrate/add new activator types
- Test both systems in parallel

### **Future Expansion:**
- Any new activator type = configuration entry
- Plugin generator handles file creation
- Universal system handles all logic
- Perfect integration with existing frameworks
