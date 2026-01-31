# TheBardsGuild - Critical Folder Structure Rules

## 🚨 CRITICAL RULE - Never Break This!

### **Folder Purpose:**
- **`Lua/` folder** = Working/Development folder ONLY
  - Used for development, testing, and experimentation
  - Contains work-in-progress files
  - NOT loaded by OpenMW game engine
  - Safe place to make mistakes and test ideas

- **`scripts/` folder** = Production/Deployment folder ONLY
  - Contains files that OpenMW actually loads
  - Registered in `TheBardsGuild.omwscripts`
  - Must be clean, stable, and working
  - The REAL folder that the game uses

### **Script Registration Rules:**
- **NEVER** register paths starting with `Lua/` in `TheBardsGuild.omwscripts`
- **ALWAYS** register paths starting with `scripts/` in `TheBardsGuild.omwscripts`
- **ALL** script paths in `.omwscripts` must use `scripts/` prefix

## 📁 Correct File Structure

### **Development Workflow:**
1. **Create/Work in `Lua/` folder** - Safe development environment
2. **Test and validate** - Ensure files work correctly
3. **Copy to `scripts/` folder** - Only when ready for production
4. **Register in `TheBardsGuild.omwscripts`** - Use `scripts/` paths only

### **Example:**
```
✅ CORRECT:
Working file:  Lua/engine/framework/npc_click_activator.lua
Production file: scripts/engine/framework/npc_click_activator.lua
Registration:   GLOBAL: scripts/engine/framework/npc_click_activator.lua

❌ WRONG:
Working file:  Lua/engine/framework/npc_click_activator.lua
Production file: scripts/engine/framework/npc_click_activator.lua
Registration:   GLOBAL: Lua/engine/framework/npc_click_activator.lua  ← THIS BREAKS!
```

## 🚨 Why This Rule Is Critical

### **What Happens When You Break This Rule:**
- **OpenMW cannot find** files registered with `Lua/` paths
- **Scripts fail to load** causing mysterious errors
- **Hours wasted** debugging non-existent problems
- **Frustration and confusion** trying to fix "broken" code that's actually correct

### **Real Example:**
- **Problem:** Scripts not loading, events not firing
- **Cause:** Registered `Lua/engine/framework/...` instead of `scripts/engine/framework/...`
- **Solution:** Change registration to use `scripts/` paths
- **Time wasted:** 2+ hours debugging registry errors instead of code issues

## 🛠️ Safe Development Practices

### **Development Process:**
1. **Work in `Lua/` folder** - Safe experimentation
2. **Test thoroughly** - Ensure code works before deployment
3. **Copy to `scripts/`** - Only stable, tested code
4. **Register correctly** - Use `scripts/` paths in `.omwscripts`
5. **Test in game** - Verify everything loads and works

### **File Management:**
- **Keep `Lua/` folder** for development and testing
- **Keep `scripts/` folder** clean and production-ready
- **Never mix** working files with production files
- **Clean `scripts/` folder** regularly to avoid clutter

## 📋 Registration Checklist

### **Before Adding to TheBardsGuild.omwscripts:**
- [ ] File exists in `scripts/` folder (not just `Lua/`)
- [ ] File path starts with `scripts/`
- [ ] File is tested and working
- [ ] No `Lua/` paths in registration

### **Example Registration:**
```
✅ CORRECT:
GLOBAL: scripts/engine/framework/universal_trigger.lua
PLAYER: scripts/engine/plugins/merchant_class/merchant_class_event_listener.lua

❌ WRONG:
GLOBAL: Lua/engine/framework/universal_trigger.lua
PLAYER: Lua/engine/plugins/merchant_class/merchant_class_event_listener.lua
```

## 🎯 Quick Reference

### **Path Prefixes:**
- **Development:** `Lua/` (working folder)
- **Production:** `scripts/` (deployment folder)
- **Registration:** Always `scripts/`

### **Remember:**
- **Lua folder** = Safe workspace
- **Scripts folder** = Game loads from here
- **Registration** = Scripts paths only
- **Never mix** the two in registration

## ⚡ Emergency Fix

### **If Scripts Aren't Loading:**
1. **Check TheBardsGuild.omwscripts** - Are paths using `scripts/`?
2. **Verify files exist** - Are files actually in `scripts/` folder?
3. **Fix registration** - Change any `Lua/` paths to `scripts/`
4. **Test again** - Scripts should load correctly

### **Common Mistakes:**
- Registering `Lua/` paths instead of `scripts/`
- Files only exist in `Lua/` folder, not copied to `scripts/`
- Mixed path prefixes in same registration file

## 🏆 Benefits of Following This Rule

### **Development Benefits:**
- **Safe workspace** - Experiment without breaking production
- **Clean deployment** - Only tested code in production folder
- **Easy debugging** - Clear separation of working vs production
- **No confusion** - Always know which folder to use

### **Time Savings:**
- **No wasted hours** debugging registry issues
- **Quick deployment** - Clear process from development to production
- **Easy troubleshooting** - Know exactly where to look for problems
- **Consistent workflow** - Same process every time

---

## 🚨 REMEMBER THIS ABOVE ALL ELSE:

**Lua folder = Work, Scripts folder = Deploy, Registration = Scripts only**

This rule prevents hours of debugging and ensures smooth development workflow!
