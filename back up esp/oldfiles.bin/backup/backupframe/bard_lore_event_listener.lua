-- bard_lore_event_listener.lua
-- Event listener for BardLore system
-- Part of the universal trigger framework

return {
    eventHandlers = {
        BardLoreShowMenu = function()
            print("[BARDLORE][EVENT] BardLore event received")
            require("scripts.engine.bard_lore_helper").show()
        end
    }
}
