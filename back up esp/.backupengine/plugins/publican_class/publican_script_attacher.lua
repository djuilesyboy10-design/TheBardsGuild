-- publican_script_attacher.lua
-- Global script that automatically attaches local script to Publican NPCs

local types = require("openmw.types")

return {
    engineHandlers = {
        onActorActive = function(actor)
            -- Check if this is a Publican NPC
            if actor.type == types.NPC then
                local record = types.NPC.record(actor.recordId)
                if record and (record.class == "Publican" or record.class == "Innkeeper") then
                    print("[PUBLICAN_ATTACH] Found Publican NPC:", actor.recordId)
                    
                    -- Check if script is already attached
                    local hasScript = false
                    for _, script in ipairs(actor.object.scripts or {}) do
                        if script == "Lua.engine.plugins.publican_class.publican_local_script" then
                            hasScript = true
                            break
                        end
                    end
                    
                    -- Attach the local script if not already attached
                    if not hasScript then
                        actor.object:addScript("Lua.engine.plugins.publican_class.publican_local_script")
                        print("[PUBLICAN_ATTACH] Attached local script to:", actor.recordId)
                    end
                end
            end
        end
    }
}
