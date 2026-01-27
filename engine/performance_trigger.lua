-- performance_trigger.lua
-- Keybinding system to trigger performance menu

local input = require('openmw.input')
local I = require('openmw.interfaces')

local keybind = input.getKey('p')  -- Press 'P' to open performance menu

print(">>> BARD PERFORMANCE TRIGGER INITIALIZED <<<")

-- Handle key press
return {
    engineHandlers = {
        onKeyPress = function(key)
            if key.code == keybind.code then
                -- Open performance menu
                if I.BardPerformanceMenu then
                    I.BardPerformanceMenu.showMenu()
                else
                    print("[Bard] Performance menu interface not available")
                end
                
                return true -- Consume the key press
            end
            return false
        end
    }
}
