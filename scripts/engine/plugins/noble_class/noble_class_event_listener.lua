-- noble_class_event_listener.lua
-- Event listener for Noble Class NPC interactions
-- Handles the NobleClassShowMenu event from the click activator

return {
    eventHandlers = {
        NobleClassShowMenu = function()
            print("[NOBLE_CLASS] Noble class event triggered!")
            local nobleHelper = require("scripts.engine.plugins.noble_class.noble_class_helper")
            nobleHelper.show()
        end
    }
}
