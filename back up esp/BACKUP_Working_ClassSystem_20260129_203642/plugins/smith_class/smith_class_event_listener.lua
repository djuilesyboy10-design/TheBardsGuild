-- smith_class_event_listener.lua
-- Event listener for Smith Class NPC interactions
-- Handles the SmithClassShowMenu event from the click activator

return {
    eventHandlers = {
        SmithClassShowMenu = function()
            print("[SMITH_CLASS] Smith class event triggered!")
            local smithHelper = require("scripts.engine.plugins.smith_class.smith_class_helper")
            smithHelper.show()
        end
    }
}
