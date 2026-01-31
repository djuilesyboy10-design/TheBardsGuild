-- bard_performance_activation.lua
-- Simple activation handler for Bard Performance

print(">>> BARD PERFORMANCE ACTIVATION INITIALIZED <<<")

local Activation = require('openmw.interfaces').Activation
local types = require('openmw.types')

-- Add activation handler for all NPCs
Activation.addHandlerForType(types.NPC, function(object, actor)
    if actor == self then
        print("[Activation] Bard Performance activated on:", object.recordId)
        
        -- Add the dummy spell to trigger the menu
        types.Actor.spells(self):add("bard_performance_dummy")
        
        -- Send event directly to UniversalMenu
        local core = require('openmw.core')
        core.sendGlobalEvent('BardPerformanceShowMenu', {
            player = self,
            detectorPosition = self.position
        })
        
        print("[Activation] Menu trigger sent for:", object.recordId)
        return true
    end
    return false
end)

print("[Activation] Bard Performance activation handler ready")

return {}
