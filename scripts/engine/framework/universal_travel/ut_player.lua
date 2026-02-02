-- scripts/universal_travel/ut_player.lua
-- Universal Travel System - Player Event Handler

return {
    eventHandlers = {
        UT_ShowMenu = function(network)
            -- Universal menu call - works for any network
            require("scripts.engine.framework.universal_travel.ut_ui").showMenu(network)
        end
    }
}
