-- door_lock_effects.lua
-- Universal Door Lock Effects Module
-- Handles time-based door locking for the dialogue system

local doorLockEffectsData = require("scripts.engine.framework.effects.effect_data.door_lock_effects_data")
local time = require('openmw.time')
local types = require('openmw.types')
local world = require('openmw.world')
local ui = require('openmw.ui')

local M = {}

-- Check if door matches the effect criteria
local function matchesDoorCriteria(door, effect)
    -- Check door type patterns
    if effect.doorTypes then
        for _, doorType in ipairs(effect.doorTypes) do
            local doorId = door.id:lower()
            local cellName = door.cell.name:lower()
            local pattern = doorType:lower()
            
            if doorId:find(pattern) or cellName:find(pattern) then
                return true
            end
        end
    end
    
    -- Check specific door IDs
    if effect.specificDoors then
        for _, specificDoor in ipairs(effect.specificDoors) do
            if door.id:lower() == specificDoor:lower() then
                return true
            end
        end
    end
    
    -- Check cell patterns
    if effect.cellPatterns then
        for _, pattern in ipairs(effect.cellPatterns) do
            if door.cell.name:lower():find(pattern:lower()) then
                return true
            end
        end
    end
    
    return false
end

-- Apply door lock effect
function M.applyDoorLockEffect(effectId)
    local effect = doorLockEffectsData.getEffect(effectId)
    
    if not effect then
        print("[DOOR_LOCK] Error: Door lock effect '" .. effectId .. "' not found!")
        return false
    end
    
    -- Get current game time
    local currentHour = time.hour(time.getGameTime())
    
    -- Check if current time matches effect schedule
    local lockStart = effect.lockTime.start or 22
    local lockEnd = effect.lockTime.end or 8
    local shouldLock = currentHour >= lockStart or currentHour < lockEnd
    
    -- Process all doors in current cells
    local doorsProcessed = 0
    local doorsModified = 0
    
    for _, door in ipairs(world.doors) do
        if matchesDoorCriteria(door, effect) then
            doorsProcessed = doorsProcessed + 1
            
            local isCurrentlyLocked = types.Door.isLocked(door)
            
            if shouldLock and not isCurrentlyLocked then
                -- Lock the door
                local lockLevel = effect.lockLevel or 30
                types.Door.setLockLevel(door, lockLevel)
                doorsModified = doorsModified + 1
                
                if effect.showMessage then
                    local message = effect.lockMessage or "The door locks automatically."
                    ui.showMessage(message)
                end
                
                print("[DOOR_LOCK] Locked: " .. door.id .. " in " .. door.cell.name)
                
            elseif not shouldLock and isCurrentlyLocked then
                -- Unlock the door
                types.Door.setLockLevel(door, 0)
                doorsModified = doorsModified + 1
                
                if effect.showMessage then
                    local message = effect.unlockMessage or "The door unlocks automatically."
                    ui.showMessage(message)
                end
                
                print("[DOOR_LOCK] Unlocked: " .. door.id .. " in " .. door.cell.name)
            end
        end
    end
    
    if doorsProcessed > 0 then
        print("[DOOR_LOCK] Processed " .. doorsProcessed .. " doors, modified " .. doorsModified .. " (Hour: " .. currentHour .. ")")
    end
    
    return doorsModified > 0
end

-- Check if a door lock effect is available
function M.isEffectAvailable(effectId)
    return doorLockEffectsData.getEffect(effectId) ~= nil
end

-- List all available door lock effects for debugging
function M.listAvailableEffects()
    local effects = doorLockEffectsData.listEffects()
    print("[DOOR_LOCK] Available effects:")
    for _, effect in ipairs(effects) do
        print("  " .. effect)
    end
end

-- Test function to verify door lock system is working
function M.testDoorLockSystem()
    print("[DOOR_LOCK] Testing door lock system...")
    
    -- Test with a simple house locking effect
    local testResult = M.applyDoorLockEffect("night_lock_houses")
    
    if testResult then
        print("[DOOR_LOCK] ✅ Door lock system test PASSED")
        return true
    else
        print("[DOOR_LOCK] ❌ Door lock system test FAILED")
        return false
    end
end

-- Get current game time for debugging
function M.getCurrentTime()
    local hour = time.hour(time.getGameTime())
    print("[DOOR_LOCK] Current game hour: " .. hour)
    return hour
end

return M
