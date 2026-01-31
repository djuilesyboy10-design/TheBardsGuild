local storage = require("openmw.storage")

-- Player-only storage
local section = storage.playerSection("MyTravel_Propylons")

if not section:get("initialized") then
    section:set("initialized", true)
    section:set("unlocked", {})
end

-- Quest stage storage
local questSection = storage.playerSection("Bards_QuestStages")

return {
    eventHandlers = {
        Set_JMCG_Tuning_Master_Stage = function(data)
            questSection:set("JMCG_Tuning_Master", data.stage)
        end
    }
}