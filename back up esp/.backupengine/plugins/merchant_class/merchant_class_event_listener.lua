-- merchant_class_event_listener.lua
-- Event listener for Merchant Class NPC system
-- Part of the universal trigger framework

print("[MERCHANT_CLASS] Merchant event listener loaded!")

-- Add cooldown to prevent double event processing
local lastEventTime = 0
local EVENT_COOLDOWN = 1.0 -- 1 second cooldown (os.time only has second precision)

return {
    eventHandlers = {
        MerchantClassShowMenu = function()
            print("[MERCHANT_CLASS] Merchant NPC detected - showing interaction menu")
            require("scripts.engine.plugins.merchant_class.merchant_class_helper").show()
        end
    }
}
