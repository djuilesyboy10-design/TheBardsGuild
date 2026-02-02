-- Universal Framework Menu System
-- Main menu integration for framework-wide configuration
-- Simplified version - proof of concept

local I = require("openmw.interfaces")
local MOD_ID = "UniversalFramework"  -- Use unique MOD_ID to avoid conflict

-- Register the settings group (Universal Door Lock pattern)
I.Settings.registerGroup {
    key = "Settings" .. MOD_ID,
    page = MOD_ID,
    l10n = MOD_ID,
    name = "name_Page",
    description = "desc_Page",
    permanentStorage = false,
    settings = {
        {
            key = "enableFramework",
            name = "name_EnableFramework",
            description = "desc_EnableFramework",
            default = true,
            renderer = "checkbox"
        }
    },
}

print("[" .. MOD_ID .. "] Menu system initialized")
print("[" .. MOD_ID .. "] Framework menu should appear in Settings > Scripts")
