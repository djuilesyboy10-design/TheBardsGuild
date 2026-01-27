local I = require('openmw.interfaces')

local ALCHEMY_SKILL_GAIN = 0.02

return {
    eventHandlers = {
        HerbalismHarvest = function(data)
            if not (I and I.SkillProgression and I.SkillProgression.skillUsed) then
                return
            end

            I.SkillProgression.skillUsed('alchemy', { skillGain = ALCHEMY_SKILL_GAIN, amount = data and data.amount, recordId = data and data.recordId })
        end
    }
}
