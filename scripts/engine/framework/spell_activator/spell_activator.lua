-- Spell Activator Framework
-- Handles custom spell cast effects using spell monitoring
-- Part of the Universal Activator Framework

local types = require('openmw.types')
local self = require('openmw.self')
local spellConfig = require('scripts.engine.framework.spell_activator.spell_activator_config')

-- Track last checked spells to avoid repeated processing
local lastSpellCount = 0
local processedSpells = {}

-- Check for custom spell activation
local function checkForCustomSpells()
    local spells = types.Actor.spells(self)
    local currentSpellCount = #spells
    
    -- Only check if spell count changed (optimization)
    if currentSpellCount == lastSpellCount then
        return
    end
    
    lastSpellCount = currentSpellCount
    
    -- Check each spell for custom activation
    for _, spell in ipairs(spells) do
        local spellId = string.lower(spell.id) -- Normalize to lowercase
        
        -- Skip if we already processed this spell recently
        if processedSpells[spellId] then
            -- Check if it's time to process again (cooldown)
            local currentTime = require('openmw.core').getGameTime()
            if currentTime - processedSpells[spellId] < 10 then -- 10 second cooldown
                goto continue
            end
        end
        
        -- Check if this spell has custom activation
        local activatorData = spellConfig.getSpellActivator(spellId)
        if activatorData then
            print("[SPELL_ACTIVATOR] Custom spell detected: " .. spellId)
            
            -- Mark as processed with cooldown
            processedSpells[spellId] = require('openmw.core').getGameTime()
            
            -- Send event to player script
            self:sendEvent(activatorData.event, {
                spell = spell,
                actor = self,
                activatorData = activatorData
            })
            
            break -- Only process one spell per check
        end
        
        ::continue::
    end
end

return {
    engineHandlers = {
        onUpdate = function()
            -- Check for custom spells every frame
            checkForCustomSpells()
        end
    }
}
