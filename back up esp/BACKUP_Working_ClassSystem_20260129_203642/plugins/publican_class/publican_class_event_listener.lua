-- publican_class_event_listener.lua
-- Event listener for Publican Class NPC system
-- Part of the universal trigger framework

return {
    eventHandlers = {
        PublicanClassShowMenu = function(eventData)
            print("[PUBLICAN_CLASS] Publican class event triggered!")
            require("scripts.engine.plugins.publican_class.publican_class_helper").show()
        end
    }
}
