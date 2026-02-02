-- caravan_class_event_listener.lua
-- Event listener for Caravaner Class NPC system
-- Part of the universal trigger framework

return {
    eventHandlers = {
        CaravanerClassShowMenu = function()
            print("[CARAVAN_CLASS] Caravaner NPC detected - showing interaction menu")
            require("scripts.engine.plugins.caravan_class.caravan_class_helper").show()
        end
    }
}
