# World Activator Framework

Handles custom activation for world objects (Activators) like altars or pillars.

## How to Adapt

1.  **Add Object to Config**:
    Open `world_activator_config.lua` and add the record ID:
    ```lua
    ["activator_id"] = {
        event = "YourWorldEvent",
        description = "A mysterious altar"
    }
    ```

2.  **Handle Event in Player Script**:
    Add the event handler to `world_activator_player.lua`:
    ```lua
    eventHandlers = {
        YourWorldEvent = function(data)
            -- Your logic here
            require("openmw.ui").showMessage("The altar hums...")
        end
    }
    ```

## System Components
- `world_activator.lua`: Global engine (Global context).
- `world_activator_config.lua`: Object database.
- `world_activator_player.lua`: Effect implementation (Player context).
