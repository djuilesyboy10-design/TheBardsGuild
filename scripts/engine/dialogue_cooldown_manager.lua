-- dialogue_cooldown_manager.lua
-- S3-powered cooldown system for dialogue reputation effects
-- Prevents abuse of reputation gains through automated storage and tracking

local ProtectedTable = require('scripts.s3.protectedTable')
local LogMessage = require('scripts.s3.logmessage')
local time = require('openmw.time')

local cooldownManager = {}

-- Initialize S3 storage for cooldowns with automatic persistence
local cooldownStorage = ProtectedTable:new('DialogueEffectsCooldowns')

-- Cooldown periods (in game time seconds)
local COOLDOWN_PERIODS = {
    hlaalu_favor = 4 * 3600,      -- 4 hours for House Hlaalu favor
    temple_blessing = 4 * 3600,   -- 4 hours for Temple blessing
    fighter_guild_respect = 4 * 3600, -- 4 hours for Fighters Guild respect
    imperial_favor = 4 * 3600,    -- 4 hours for Imperial favor
    thieves_guild_trust = 4 * 3600 -- 4 hours for Thieves Guild trust
}

-- Check if an effect can be applied (cooldown expired)
function cooldownManager.canApplyEffect(effectId)
    local lastTime = cooldownStorage[effectId] or 0
    local currentTime = time.getGameTime()
    local cooldownPeriod = COOLDOWN_PERIODS[effectId] or (4 * 3600)
    
    return (currentTime - lastTime) >= cooldownPeriod
end

-- Get remaining cooldown time in hours
function cooldownManager.getRemainingCooldown(effectId)
    local lastTime = cooldownStorage[effectId] or 0
    local currentTime = time.getGameTime()
    local cooldownPeriod = COOLDOWN_PERIODS[effectId] or (4 * 3600)
    local remaining = cooldownPeriod - (currentTime - lastTime)
    
    if remaining <= 0 then
        return 0
    else
        return math.ceil(remaining / 3600) -- Convert to hours
    end
end

-- Apply effect with cooldown management
function cooldownManager.applyEffect(effectId)
    if cooldownManager.canApplyEffect(effectId) then
        -- Update cooldown timestamp
        cooldownStorage[effectId] = time.getGameTime()
        
        -- Apply reputation effect through universal effects engine
        local effectsEngine = require('scripts.engine.framework.effects.universal_effects_engine')
        local success = effectsEngine.processEffect({
            type = "reputation",
            effectId = effectId
        })
        
        if success then
            LogMessage("Reputation effect applied: " .. effectId)
            return true, "Effect applied successfully!"
        else
            -- Rollback cooldown on failure
            cooldownStorage[effectId] = nil
            LogMessage("Failed to apply effect: " .. effectId)
            return false, "Failed to apply effect."
        end
    else
        local remainingHours = cooldownManager.getRemainingCooldown(effectId)
        LogMessage("Effect cooldown active: " .. effectId .. " (" .. remainingHours .. " hours remaining)")
        return false, "Cooldown active. Try again in " .. remainingHours .. " hours."
    end
end

-- Get list of all effects and their cooldown status
function cooldownManager.getCooldownStatus()
    local status = {}
    for effectId, period in pairs(COOLDOWN_PERIODS) do
        local remaining = cooldownManager.getRemainingCooldown(effectId)
        status[effectId] = {
            cooldownPeriod = period / 3600, -- in hours
            remainingHours = remaining,
            canApply = remaining == 0
        }
    end
    return status
end

-- Reset all cooldowns (for testing/debugging)
function cooldownManager.resetAllCooldowns()
    for effectId, _ in pairs(COOLDOWN_PERIODS) do
        cooldownStorage[effectId] = nil
    end
    LogMessage("All dialogue effect cooldowns reset")
end

return cooldownManager
