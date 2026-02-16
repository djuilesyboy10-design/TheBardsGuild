# Universal Travel System

## What This Does
**Teleportation network** for fast travel between discovered locations. Uses Propylon chambers or custom teleport points with distance-based costs.

## Files
- `ut_global.lua` - GLOBAL script managing travel network
- `ut_player.lua` - PLAYER script for UI and location selection
- `ut_data.lua` - Travel point definitions and costs

## For AI Prompting
```
Create fast travel system with:
- Discoverable teleport points throughout world
- Distance calculation for travel cost
- UI showing discovered/undiscovered locations
- Cost system (gold or resource based)
- Event-driven travel requests
```

## Key Pattern
```lua
-- Discover location
core.sendGlobalEvent("Travel_Discover", {pointId = "location_id"})

-- Travel request
core.sendGlobalEvent("Travel_Request", {
    from = currentPoint,
    to = destinationPoint
})
```

## Registration
```
GLOBAL: scripts/engine/framework/universal_travel/ut_global.lua
PLAYER: scripts/engine/framework/universal_travel/ut_player.lua
```
