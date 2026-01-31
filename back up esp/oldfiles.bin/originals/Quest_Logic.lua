local self = require('openmw.self')
local types = require('openmw.types')
local database = require('scripts.Quest_Database')

return {
    interfaceName = "JMCG_QuestData",
    interface = {
        getMeterNumber = function()
            local totalWeight = 0
            local currentEarned = 0
            local playerQuests = types.Player.quests(self)
            
            for id, questData in pairs(database) do
                local index = 0
                -- Simple match: since database is now lowercase, this will work.
                for _, q in pairs(playerQuests) do
                    if q.id:lower() == id then 
                        index = q.stage 
                        break 
                    end
                end
                
                local w = questData.weight or 0
                local maxIdx = questData.maxIndex or 1
                
                if index >= maxIdx then
                    currentEarned = currentEarned + w
                elseif index > 0 then
                    currentEarned = currentEarned + (w * (index / maxIdx))
                end
                totalWeight = totalWeight + w
            end
            
            if totalWeight == 0 then return 0 end
            return math.floor((currentEarned / totalWeight) * 100)
        end
    }
}

