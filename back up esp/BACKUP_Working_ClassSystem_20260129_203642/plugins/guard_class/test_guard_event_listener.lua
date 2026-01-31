-- test_guard_event_listener.lua
-- Minimal test event listener matching merchant pattern exactly

print("[GUARD_CLASS] Test guard event listener loaded!")

return {
    eventHandlers = {
        GuardClassShowMenu = function()
            print("[GUARD_CLASS] Test guard NPC detected - showing interaction menu")
            require("scripts.engine.plugins.guard_class.test_guard_helper").show()
        end
    }
}
