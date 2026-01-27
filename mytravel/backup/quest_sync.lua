local storage = require("openmw.storage")
local types = require("openmw.types")
local self = require("openmw.self")

local section = storage.playerSection("MyTravel_Propylons")

return {
    engineHandlers = {
        onUpdate = function()
            local quests = types.Player.quests(self)
            local q = quests["JMCG_Tuning_Master"]
            if q then
                section:set("JMCG_Tuning_Master", q.stage)
            end
        end
    }
}