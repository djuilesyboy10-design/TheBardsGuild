local world = require('openmw.world')
local core = require('openmw.core')

return {
    engineHandlers = {
        onActivate = function(object, actor)
            local id = object.recordId:lower()
            if not (id:find("^flora_") or id:find("^plant_") or id:find("^shroom_") or id:find("^ingred_")) then
                return false
            end

            if actor ~= world.player then
                return false
            end

            -- Send event to player script(s)
            core.sendGlobalEvent('HerbalismHarvest', { amount = 5.0 })  -- high test value

            return false  -- always allow loot for now (foundation only)
        end
    }
}