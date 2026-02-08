-- Scroll Activator Framework - Global Script
-- Minimal global script - UI monitoring moved to player script
-- Part of the Universal Activator Framework

local types = require('openmw.types')
local world = require('openmw.world')

-- Import configuration
local scrollConfig = require('scripts.engine.framework.scroll_activator.scroll_activator_config')

print("[SCROLL_ACTIVATOR] Scroll activator global script loaded")

return {
    eventHandlers = {
        -- Global event handlers if needed
    }
}
