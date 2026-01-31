# NPC Removal Guide - Lost Children of Morrowind

## Problem
- **Source ESP**: "Generations - Children in Vvardenfell.esp"
- **Issue**: NPCs trapped by Hermaeus Mora that need removal
- **Location**: Various towns in Vvardenfell

## Safe Removal Options

### Option 1: Disable Entire Mod (Easiest)
Edit `openmw.cfg` and comment out:
```
# content=Generations - Children in Vvardenfell.esp
```

**Pros**: Simple, removes all child NPCs
**Cons**: Removes ALL content from the mod

### Option 2: Create Patch ESP (Recommended)
Create a new ESP that:
1. Loads AFTER "Generations - Children in Vvardenfell.esp"
2. Disables specific problematic NPCs
3. Keeps any assets you want to keep

### Option 3: Edit ESP Directly (Advanced)
Use TES3CMD or MWEdit to:
1. Open "Generations - Children in Vvardenfell.esp"
2. Find specific NPC records
3. Delete or disable them

## Implementation Steps

### Step 1: Identify Problem NPCs
In-game, use console to identify NPCs:
1. Click on problematic NPC
2. Note their EditorID (shows in console)
3. List all problematic NPCs

### Step 2: Create Patch ESP
1. Use TES3CMD: `tes3cmd create-patch "TheBardsGuild_NPC_Removal.esp"`
2. Load after Generations ESP
3. Add disabled NPC records

### Step 3: Update Load Order
In `openmw.cfg`, ensure:
```
content=Generations - Children in Vvardenfell.esp
content=TheBardsGuild_NPC_Removal.esp  # Load AFTER
```

## Tools Needed
- **TES3CMD**: For ESP editing
- **MWEdit**: For visual ESP editing
- **OpenMW CS**: Alternative editor

## Safety Precautions
1. **Backup original ESP** before editing
2. **Test on new save** first
3. **Document changes** for future reference
4. **Check for dependencies** other mods might have

## Console Commands for Testing
```
# Get NPC EditorID in-game
GetPCCell
GetPos
GetAngle

# Disable specific NPC (temporary)
disable
```

## Next Steps
1. Identify specific NPCs to remove
2. Choose removal method
3. Implement changes
4. Test thoroughly
5. Update documentation
