# Misc Activator Framework

Handles custom usage effects for miscellaneous items (keys, relics, tools).

## How to Adapt

1.  **Add Item to Config**:
    Open `misc_activator_config.lua` and add your item record ID:
    ```lua
    ["your_item_id"] = {
        event = "YourCustomEvent",
        description = "Narrative description"
    }
    ```

2.  **Handle Event in Player Script**:
    Add the event handler to `misc_activator_player.lua`:
    ```lua
    eventHandlers = {
        YourCustomEvent = function(data)
            -- Your logic here (e.g., show message, trigger teleport)
            require("openmw.ui").showMessage("You used the " .. data.item.recordId)
        end
    }
    ```

## System Components
- `misc_activator.lua`: Global engine (Global context).
- `misc_activator_config.lua`: Item database.
- `misc_activator_player.lua`: Effect implementation (Player context).
