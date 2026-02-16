-- Spell Activator Framework - Player Script
-- Event-driven spell activation using types.Actor.activeSpells
-- Part of the Universal Activator Framework

print("[SPELL_ACTIVATOR] Spell activator player script loaded")

local core = require('openmw.core')
local types = require('openmw.types')
local self = require('openmw.self')
local async = require('openmw.async')

-- Import configuration
local spellConfig = require('scripts/engine/framework/spell_activator/spell_activator_config')

-- Track previous spell state to detect changes
local wasSpellActive = false

-- Check for spell activation
local function checkSpellActivation()
    local activeSpells = types.Actor.activeSpells(self)
    local isSpellActive = activeSpells:isSpellActive("JMCG_Garden")
    
    -- Detect when spell becomes active (was false, now true)
    if not wasSpellActive and isSpellActive then
        print("[SPELL_ACTIVATOR] JMCG_Garden spell became active!")
        
        -- Get activator data
        local activatorData = spellConfig.getSpellActivator("JMCG_Garden")
        if activatorData then
            print("[SPELL_ACTIVATOR] Network: " .. (activatorData.network or "nil"))
            print("[SPELL_ACTIVATOR] Destination: " .. (activatorData.destination or "nil"))
            
            -- Send travel event to Universal Travel system
            core.sendGlobalEvent("UT_Travel", {
                network = activatorData.network or "spell_teleport",
                destination = activatorData.destination
            })
            
            print("[SPELL_ACTIVATOR] UT_Travel event sent!")
            
            -- Show immersive message to the player
            self:sendEvent("UT_ShowMessage", 
                activatorData.message or "The spell's magic envelops you, pulling you through space and time...")
            
            print("[SPELL_ACTIVATOR] Message event sent!")
            
            -- Remove the active spell (only works on temporary spells)
            -- Note: This might not work if JMCG_Garden is not a temporary spell
            -- But we can try to remove it
            local spellRemoved = false
            for _, spell in pairs(activeSpells) do
                if spell.activeSpellId == "JMCG_Garden" then
                    activeSpells:remove(spell.activeSpellId)
                    spellRemoved = true
                    print("[SPELL_ACTIVATOR] JMCG_Garden spell removed")
                    break
                end
            end
            
            if not spellRemoved then
                print("[SPELL_ACTIVATOR] Could not remove spell (may not be temporary)")
            end
            
            print("[SPELL_ACTIVATOR] Custom effect triggered")
        else
            print("[SPELL_ACTIVATOR] No activator data found for JMCG_Garden")
        end
    end
    
    -- Update state
    wasSpellActive = isSpellActive
end

-- Check spell activation periodically (event-driven but with minimal polling)
local function startSpellCheck()
    async:newUnsavableGameTimer(0.1, function()
        checkSpellActivation()
        -- Continue checking every 0.1 seconds
        async:newUnsavableGameTimer(0.1, startSpellCheck)
    end)
end

print("[SPELL_ACTIVATOR] Starting spell activation check")
startSpellCheck()

return {
    engineHandlers = {
        -- No engine handlers needed
    },
    eventHandlers = {
        -- Player event handlers if needed
    }
}
