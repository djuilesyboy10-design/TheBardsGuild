# Object Management Framework

The Object Management system allows you to dynamically manipulate the game world based on quest progression. You can either **remove (disable)** existing objects or **manifest (enable)** new ones.

## How to Adapt

1.  **Add a Group to Config**:
    Open `object_management_config.lua` and define your group:
    ```lua
    return {
        my_secret_altar = {
            questId = "my_quest_id",
            stage = 20,
            objects = {
                {
                    recordId = "my_altar_id",
                    cell = "My Cell Name",
                    position = {x = 100, y = 200, z = 300},
                    rotation = {x = 0, y = 0, z = 0},
                    conditions = { type = "enable" } -- This will spawn the object
                }
            }
        },
        clean_up_rubble = {
            questId = "my_quest_id",
            stage = 30,
            objects = {
                {
                    recordId = "rubble_static_id",
                    cell = "My Cell Name",
                    conditions = { type = "disable" } -- This will remove all instances of this ID in the cell
                }
            }
        }
    }
    ```

2.  **Logic Types**:
    -   **`disable`**: Scans the specified `cell` for all objects with the matching `recordId` and removes them.
    -   **`enable`**: Spawns a new instance of `recordId` at the specified `position` and `rotation`.

## System Components
- `object_management_global.lua`: Handles the heavy lifting of spawning and removing objects.
- `object_management_player.lua`: Listens for quest events (via Quest Monitor) and triggers the Global script.
- `object_management_config.lua`: Your database of world changes.

## Performance
This system is **event-driven**. It uses zero CPU until a quest stage actually changes, at which point it executes the requested world manipulation instantly.
