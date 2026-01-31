-- bard_performance_dialogue.lua
-- Integration between dialogue system and performance system

local I = require('openmw.interfaces')

print(">>> BARD PERFORMANCE DIALOGUE INTEGRATION INITIALIZED <<<")

-- Dialogue integration functions
local dialogueInterface = {
    -- Execute performance (called from dialogue script)
    execute = function(performanceId)
        print("[Bard Dialogue] Executing performance from dialogue:", performanceId)
        
        -- Use our existing performance system
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            interfaces.PerformanceHelper.specific(performanceId)
            return true
        else
            print("[Bard Dialogue] Performance helper not available")
            return false
        end
    end,
    
    -- Get audience count (called from dialogue script)
    getAudienceCount = function()
        print("[Bard Dialogue] Getting audience count for dialogue")
        
        -- Use our existing performance system
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            -- For now, return a simple count
            -- In a full implementation, we'd count actual nearby NPCs
            return 5  -- Placeholder audience size
        else
            return 0
        end
    end,
    
    -- Show performance result (called from dialogue script)
    showResult = function(performanceId)
        print("[Bard Dialogue] Showing result for performance:", performanceId)
        
        -- This would trigger the appropriate dialogue result
        -- The dialogue system will handle showing the reaction
        return true
    end
}

-- Make functions available to MWScript
_G.BardPerformance_Execute = dialogueInterface.execute
_G.BardPerformance_GetAudienceSize = dialogueInterface.getAudienceCount
_G.BardPerformance_ShowResult = dialogueInterface.showResult

print("[Bard Dialogue] Performance dialogue integration ready")

return {
    interfaceName = "BardPerformanceDialogue",
    interface = dialogueInterface
}
