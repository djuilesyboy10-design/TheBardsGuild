-- guard_class_event_listener.lua
-- Event listener for Guard Class NPC interactions
-- Handles the GuardClassShowMenu event from the click activator

return {
    eventHandlers = {
        GuardClassShowMenu = function()
            print("[GUARD_CLASS] Guard class event triggered!")
            print("[GUARD_CLASS] Routing to default guard helper")
            local guardHelper = require("scripts.engine.plugins.guard_class.guard_class_helper")
            guardHelper.show()
        end
    }
}
