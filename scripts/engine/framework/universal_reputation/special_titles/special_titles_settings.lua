-- Special Titles Settings
-- Key binding and settings registration

local I = require('openmw.interfaces')

-- Register the settings page
I.Settings.registerPage {
    key = 'SpecialTitles',
    l10n = 'SpecialTitles',
    name = 'Special Titles',
    description = 'Configure Special Titles system settings',
}

-- Register the settings group
I.Settings.registerGroup {
    key = 'SettingsSpecialTitles',
    page = 'SpecialTitles',
    l10n = 'SpecialTitles',
    name = 'Special Titles Settings',
    description = 'Configure key bindings and system settings',
    permanentStorage = true,
    settings = {
        {
            key = 'enableTitlesSystem',
            name = 'Enable Special Titles System',
            description = 'Turn the Special Titles system on or off',
            default = true,
            renderer = 'checkbox',
        },
        {
            key = 'titlesMenuKey',
            name = 'Titles Menu Key',
            description = 'Press this key to open the Chronicle of Titles (default: O)',
            default = 79,  -- O key
            renderer = 'UniversalFramework/keySelection',
        },
        {
            key = 'showTitleNotifications',
            name = 'Show Title Notifications',
            description = 'Display notifications when new titles are earned',
            default = true,
            renderer = 'checkbox',
        }
    },
}

return {}
