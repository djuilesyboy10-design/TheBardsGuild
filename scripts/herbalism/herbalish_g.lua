local world = require('openmw.world')
local core = require('openmw.core')
local types = require('openmw.types')
local I = require('openmw.interfaces')

local HARVEST_XP_SCALE = 0.5

local didInitDebug = false
local didActivateDebug = false
local didDispatchDebug = false

local function sendHarvestEvent(actor, payload)
    -- Travel-style: send directly to the activator (player script context)
    if actor and actor.sendEvent then
        actor:sendEvent('HerbalismHarvest', payload)
        return true
    end
    -- Fallback: keep global event path if available
    if core.sendGlobalEvent then
        core.sendGlobalEvent('HerbalismHarvest', payload)
        return true
    end
    return false
end

if not didInitDebug then
    didInitDebug = true
    print(string.format('[Herbalish] herbalish_g loaded (HARVEST_XP_SCALE=%s)', tostring(HARVEST_XP_SCALE)))
end

if types and types.Flora then
    I.Activation.addHandlerForType(types.Flora, function(object, actor)
        local player = world.player or world.players[1]
        if not player or actor ~= player then
            return false
        end

        if not didActivateDebug then
            didActivateDebug = true
            print(string.format('[Herbalish] herbalish_g first flora activate: recordId=%s', tostring(object.recordId)))
        end

        local payload = { amount = HARVEST_XP_SCALE, recordId = object.recordId }
        local ok = sendHarvestEvent(actor, payload)
        if (not didDispatchDebug) then
            didDispatchDebug = true
            print(string.format(
                '[Herbalish] herbalish_g dispatch ok=%s (types.Flora path)',
                tostring(ok)
            ))
        end

        return false  -- always allow loot for now (foundation only)
    end)

    return {}
end

return {
    engineHandlers = {
        onActivate = function(object, actor)
            if not object or not object.recordId then
                return false
            end

            local id = object.recordId:lower()
            if not (id:find("^flora_") or id:find("^plant_") or id:find("^shroom_") or id:find("^ingred_")) then
                return false
            end

            local player = world.player or world.players[1]
            if not player or actor ~= player then
                return false
            end

            local payload = { amount = HARVEST_XP_SCALE, recordId = object.recordId }
            local ok = sendHarvestEvent(actor, payload)
            if not didActivateDebug then
                didActivateDebug = true
                print(string.format(
                    '[Herbalish] herbalish_g first activate (fallback): recordId=%s ok=%s',
                    tostring(object.recordId),
                    tostring(ok)
                ))
            end

            if (not didDispatchDebug) then
                didDispatchDebug = true
                print(string.format(
                    '[Herbalish] herbalish_g dispatch ok=%s (fallback path)',
                    tostring(ok)
                ))
            end

            return false  -- always allow loot for now (foundation only)
        end
    }
}