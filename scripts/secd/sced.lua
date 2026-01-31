local world = require('openmw.world')
local types = require('openmw.types')
local core = require('openmw.core')

-- Settings
local NIGHT_START = 20 -- 8 PM
local NIGHT_END = 7    -- 7 AM

return {
    engineHandlers = {
        onUpdate = function()
            local hour = world.getGameTime() / 3600 % 24
            local isNight = (hour >= NIGHT_START or hour < NIGHT_END)

            local player = world.player
            if not player then
                return
            end

            local cells
            if world.getActiveCells then
                cells = world.getActiveCells()
            elseif player.cell then
                cells = { player.cell }
            else
                return
            end

            for _, cell in ipairs(cells) do
                -- 1. HANDLE NPCs (Street People)
                if not cell.isInterior or cell.behavesAsExterior then
                    for _, npc in ipairs(cell:getObjects(types.NPC)) do
                        local rec = types.NPC.record(npc)
                        -- Don't hide guards, publicans, or the player
                        if not rec.isGuard and rec.class ~= "publican" and npc ~= player then
                            -- Logic: Hide if night (Weather check can be added here)
                            npc.enabled = not isNight 
                        end
                    end
                end

                -- 2. HANDLE DOORS (Locking)
                for _, door in ipairs(cell:getObjects(types.Door)) do
                    local dest = types.Door.destCell(door)
                    if dest and dest.isInterior then
                        -- If it's night, lock the door. If day, unlock.
                        -- (You can add a check here to NOT lock if dest has a Publican)
                        if isNight then
                            types.Lockable.setLocked(door, true)
                            types.Lockable.setLockLevel(door, 50)
                        else
                            types.Lockable.setLocked(door, false)
                        end
                    end
                end
            end
        end
    }
}