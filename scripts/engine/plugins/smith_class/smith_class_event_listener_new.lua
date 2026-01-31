-- smith_class_event_listener.lua
-- Event listener for Smith Class NPC system
-- Part of the universal trigger framework

print("[SMITH_CLASS] Smith event listener loaded!")

return {
    eventHandlers = {
        SmithClassShowMenu = function()
            print("[SMITH_CLASS] Smith NPC detected - showing interaction menu")
            require("scripts.engine.plugins.smith_class.smith_class_helper").show()
        end
    }
}
