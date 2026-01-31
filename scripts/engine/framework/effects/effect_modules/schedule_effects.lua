-- schedule_effects.lua
-- Schedule effects module for Universal Effects Framework
-- Handles NPC movement and scheduling

local scheduleEffectsData = require("scripts.engine.framework.effects.effect_data.schedule_effects_data")
local world = require('openmw.world')
local types = require('openmw.types')

local M = {}

-- Current active schedules
local activeSchedules = {}

-- Find NPC by ID
local function findNPCById(npcId)
    local player = world.player or world.players[1]
    if not player then return nil end
    
    local cells
    if world.getActiveCells then
        cells = world.getActiveCells()
    elseif player.cell then
        cells = { player.cell }
    else
        return nil
    end
    
    for _, cell in ipairs(cells) do
        for _, npc in ipairs(cell:getObjects(types.NPC)) do
            if npc.recordId:lower() == npcId:lower() then
                return npc
            end
        end
    end
    
    return nil
end

-- Apply schedule effect to NPC
function M.applyScheduleEffect(effectData)
    local effectId = effectData.effectId
    if not effectId then
        print("[SCHEDULE] Error: No effectId provided in effect data")
        return false
    end
    
    local schedule = scheduleEffectsData.getScheduleEffect(effectId)
    if not schedule then
        print("[SCHEDULE] Error: Schedule effect not found: " .. effectId)
        return false
    end
    
    local npc = findNPCById(schedule.npcId)
    if not npc then
        print("[SCHEDULE] NPC not found: " .. schedule.npcId)
        return false
    end
    
    -- Get current game time
    local currentHour = (world.getGameTime() / 3600) % 24
    
    -- Check which schedule action should be active
    for _, action in ipairs(schedule.schedule) do
        local shouldExecute = false
        
        if action.time == 20 and currentHour >= 20 then
            shouldExecute = true  -- Night schedule (8 PM onwards)
        elseif action.time == 7 and currentHour < 7 then
            shouldExecute = true  -- Night schedule (before 7 AM)
        end
        
        if shouldExecute then
            -- Check if this action is already active
            local actionKey = schedule.npcId .. "_" .. action.action
            if not activeSchedules[actionKey] then
                -- Teleport the NPC
                local success = npc:teleport(
                    action.to,
                    action.position,
                    {
                        onGround = action.onGround,
                        rotation = action.rotation
                    }
                )
                
                if success then
                    activeSchedules[actionKey] = true
                    print("[SCHEDULE] Moved " .. schedule.npcId .. " to " .. action.to .. " at " .. currentHour .. ":00")
                    return true
                else
                    print("[SCHEDULE] Failed to move " .. schedule.npcId)
                    return false
                end
            end
        end
    end
    
    return false
end

-- Clear active schedules (for testing/reset)
function M.clearActiveSchedules()
    activeSchedules = {}
end

-- Get current active schedules (for debugging)
function M.getActiveSchedules()
    return activeSchedules
end

return M
