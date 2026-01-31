-- scripts/jmcg_tuning_master_progress.lua
local storage = require("openmw.storage")

local section = storage.playerSection("MyTravel_Propylons")

return {
    eventHandlers = {
        JMCG_SetTuningMasterStage = function(stage)
            section:set("JMCG_Tuning_Master", stage)
        end
    }
}