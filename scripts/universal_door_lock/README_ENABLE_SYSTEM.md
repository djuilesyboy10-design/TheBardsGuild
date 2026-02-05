# Universal Door Lock - Enable/Disable System

## Overview
The Universal Door Lock system now includes full enable/disable functionality with console commands and settings integration.

## Settings Page

### Location
OpenMW Settings → Universal Door Lock

### Available Settings
1. **Enable Door Locking** (checkbox)
   - Default: ✅ Enabled
   - Turns the entire door locking system on/off

2. **Morning Hour** (number: 1-12)
   - Default: 6 AM
   - When doors automatically unlock

3. **Evening Hour** (number: 13-23)
   - Default: 8 PM (20:00)
   - When doors automatically lock

## Console Commands

### Basic Commands
Type in console: `UniversalDoorLock.command()`

| Command | Action |
|---------|--------|
| `UniversalDoorLock.toggle()` | Toggle system on/off |
| `UniversalDoorLock.enable()` | Force enable system |
| `UniversalDoorLock.disable()` | Force disable system |
| `UniversalDoorLock.reload()` | Reload settings |
| `UniversalDoorLock.status()` | Show available commands |

### Examples
```
UniversalDoorLock.toggle()      # Toggle the system
UniversalDoorLock.enable()      # Turn it on
UniversalDoorLock.disable()     # Turn it off
UniversalDoorLock.reload()      # Reload settings after changes
UniversalDoorLock.status()      # Show help
```

## System Behavior

### When ENABLED:
- Locks exterior doors at night (default 8 PM - 6 AM)
- Keeps taverns, guilds, temples always open
- Processes door states automatically
- Shows debug messages

### When DISABLED:
- No automatic door locking/unlocking
- Unlocks any doors previously locked by the system
- All door processing stops
- System remains inactive until re-enabled

## Save/Load Support
- System state (enabled/disabled) is saved with game
- Settings persist across sessions
- Door lock state preserved

## Integration Points

### Event Handlers Added:
- `UDL_reloadSettings` - Reload settings from storage
- `UDL_toggleSystem` - Toggle system on/off with optional parameter

### Functions Available:
- `reloadSettings()` - Reload all settings
- `toggleSystem(enabled)` - Toggle system (true=enable, false=disable, nil=toggle)

## Testing

### To Test Enable/Disable:
1. Open console and type `UniversalDoorLock.toggle()`
2. Verify system stops/starts processing doors
3. Check settings page reflects changes
4. Save/load game to verify persistence

### To Test Settings:
1. Open OpenMW settings → Universal Door Lock
2. Toggle "Enable Door Locking" checkbox
3. Change lock/unlock hours
4. Use `UniversalDoorLock.reload()` to apply changes

## Troubleshooting

### System Not Responding:
- Check console: `UniversalDoorLock.reload()`
- Verify settings page shows correct state
- Check debug messages in console

### Settings Not Applying:
- Use `UniversalDoorLock.reload()` after changing settings
- Restart game if needed
- Check .omwscripts registration

### Doors Not Unlocking When Disabled:
- System should automatically unlock all doors it locked
- Use `UniversalDoorLock.disable()` to force unlock
- Check debug messages for unlock operations
