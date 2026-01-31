-- schedule_effects_data.lua
-- Test case: Hull's temple night schedule

local scheduleEffects = {
    {
        id = "hull_temple_night",
        name = "Hull's Temple Night Schedule",
        npcId = "hull",  -- Hull the Argonian in Balmora
        schedule = {
            {
                time = 20,  -- 8 PM (night starts)
                action = "go_to_temple",
                from = "balmora",
                to = "balmora_temple",
                position = { x = 0, y = 0, z = 0 },  -- Temple entrance
                onGround = true,
                rotation = { yaw = 0 }
            },
            {
                time = 7,  -- 7 AM (night ends)
                action = "return_to_balmora",
                from = "balmora_temple", 
                to = "balmora",
                position = { x = 0, y = 0, z = 0 },  -- Back to her spot
                onGround = true,
                rotation = { yaw = 0 }
            }
        }
    }
}

-- Helper function to get effect by ID
function getScheduleEffect(effectId)
    for _, effect in ipairs(scheduleEffects) do
        if effect.id == effectId then
            return effect
        end
    end
    return nil
end

-- Get all schedule effects
function getAllScheduleEffects()
    return scheduleEffects
end

return {
    getScheduleEffect = getScheduleEffect,
    getAllScheduleEffects = getAllScheduleEffects
}
