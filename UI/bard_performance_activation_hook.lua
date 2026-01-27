-- bard_performance_activation_hook.lua
-- Hook into activation system to trigger universal menu

local self = require('openmw.self')
local ui = require('openmw.ui')

print(">>> BARD PERFORMANCE ACTIVATION HOOK INITIALIZED <<<")

-- Activation Hook System
local activationHook = {
    -- Handle activation events
    onActivate = function(target)
        if not target or not target.recordId then
            return false
        end
        
        print("[Activation Hook] Player activated:", target.recordId)
        
        -- Check if we have the universal menu system
        if _G.UniversalMenu then
            print("[Activation Hook] UniversalMenu available, creating menu...")
            return _G.UniversalMenu.handleActivation(target)
        else
            print("[Activation Hook] UniversalMenu not available")
            return false
        end
    end
}

-- Register for activation events
if self then
    self:registerEvent("onActivate", activationHook.onActivate)
    print("[Activation Hook] Registered for activation events")
else
    print("[Activation Hook] Could not register for activation events")
end

-- Make available globally for testing
_G.BardActivationHook = activationHook

print("[Activation Hook] Activation hook system ready")

return {
    interfaceName = "BardActivationHook",
    interface = activationHook
}
