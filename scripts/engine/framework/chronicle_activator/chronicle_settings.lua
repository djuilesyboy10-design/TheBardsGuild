-- Chronicle Generator Settings
-- Clean implementation using shared universal framework

local I = require('openmw.interfaces')

-- Register the settings page
I.Settings.registerPage {
    key = 'ChronicleGenerator',
    l10n = 'ChronicleGenerator',
    name = 'Chronicle Generator',
    description = 'Configure the Chronicle Generator UI system',
}

-- Register the settings group
I.Settings.registerGroup {
    key = 'SettingsChronicle_Generator',
    page = 'ChronicleGenerator',
    name = 'Chronicle Generator Settings',
    description = 'Configure Chronicle Generator behavior',
    l10n = 'ChronicleGenerator',
    permanentStorage = false,
    settings = {
        {
            key = 'enableChronicleSystem',
            name = 'Enable Chronicle System',
            description = 'Turn the Chronicle Generator on or off',
            default = true,
            renderer = 'checkbox',
        },
        {
            key = 'chronicleMenuKey',
            name = 'Chronicle Menu Key',
            description = 'Click and press a key to set',
            default = 67,  -- C key (consistent with global script)
            renderer = 'UniversalFramework/keySelection',  -- Use shared universal renderer
        },
    },
}

-- Return empty table (no direct exports)
return {}
