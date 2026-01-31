-- bard_class_event_listener.lua
-- Event listener for Bard Class NPC system
-- Part of the universal trigger framework

return {
    eventHandlers = {
        BardClassShowMenu = function()
            print("[BARD_CLASS] Bard NPC detected - showing interaction menu")
            require("scripts.engine.plugins.bard_class.bard_class_helper").show()
        end
    }
}
