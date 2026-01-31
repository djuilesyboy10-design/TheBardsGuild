-- bard_performance_dynamic.lua
-- Pure Lua dialogue system - pushing boundaries!

local self = require('openmw.self')
local ui = require('openmw.ui')
local nearby = require('openmw.nearby')
local types = require('openmw.types')

print(">>> BARD PERFORMANCE DYNAMIC DIALOGUE INITIALIZED <<<")

-- Dynamic dialogue system
local dynamicDialogue = {
    -- Check if target NPC is publican class
    isPublican = function(target)
        if not target or not target.class then return false end
        return target.class.name == "Publican" or target.class.name == "Innkeeper"
    end,
    
    -- Get current audience count
    getAudienceCount = function()
        local count = 0
        for _, actor in pairs(nearby.actors) do
            if actor.type == types.NPC then
                local distance = (actor.position - self.position):length()
                if distance <= 1000 then
                    count = count + 1
                end
            end
        end
        return count
    end,
    
    -- Create dynamic dialogue topic
    createPerformanceTopic = function(target)
        if not self.isPublican(target) then
            return nil
        end
        
        local audienceCount = self.getAudienceCount()
        if audienceCount == 0 then
            return {
                text = "Perform?",
                response = "There's no one here to perform for right now."
            }
        end
        
        return {
            text = "Perform?",
            response = string.format("The crowd looks interested. What type of performance will you give?"),
            choices = {
                {
                    text = "Brilliant Performance",
                    action = function()
                        self.executePerformance(target, 1)
                    end
                },
                {
                    text = "Good Performance", 
                    action = function()
                        self.executePerformance(target, 2)
                    end
                },
                {
                    text = "Mediocre Performance",
                    action = function()
                        self.executePerformance(target, 3)
                    end
                },
                {
                    text = "Poor Performance",
                    action = function()
                        self.executePerformance(target, 4)
                    end
                },
                {
                    text = "Disastrous Performance",
                    action = function()
                        self.executePerformance(target, 5)
                    end
                }
            }
        }
    end,
    
    -- Execute performance
    executePerformance = function(target, performanceId)
        print("[Dynamic Dialogue] Executing performance:", performanceId, "for target:", target.recordId)
        
        -- Use our existing performance system
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            interfaces.PerformanceHelper.specific(performanceId)
            
            -- Show result after a delay
            self.showPerformanceResult(target, performanceId)
            return true
        else
            print("[Dynamic Dialogue] Performance helper not available")
            return false
        end
    end,
    
    -- Show performance result
    showPerformanceResult = function(target, performanceId)
        -- Simulate result display
        local results = {
            [1] = "Excellent show! The patrons absolutely loved your performance!",
            [2] = "Good performance! The crowd seemed to enjoy it.",
            [3] = "It was... acceptable. The patrons didn't complain.",
            [4] = "That wasn't your best work. Some patrons actually left.",
            [5] = "That was... terrible. The patrons are actually angry."
        }
        
        local result = results[performanceId] or "The performance was... interesting."
        ui.showMessage(result)
        print("[Dynamic Dialogue] Performance result:", result)
    end,
    
    -- Try to add dialogue to player
    addDialogueToPlayer = function()
        print("[Dynamic Dialogue] Attempting to add dialogue to player...")
        
        -- Check if we can access player's dialogue system
        if self and self.type and self.type.dialogue then
            print("[Dynamic Dialogue] Player dialogue system found!")
            
            -- Try to add our custom topic
            -- This is the experimental part - pushing boundaries!
            if self.type.dialogue.addTopic then
                self.type.dialogue.addTopic("Perform?", self.createPerformanceTopic)
                print("[Dynamic Dialogue] Successfully added 'Perform?' topic to player!")
                return true
            else
                print("[Dynamic Dialogue] Dialogue system doesn't support addTopic")
                return false
            end
        else
            print("[Dynamic Dialogue] Player dialogue system not accessible")
            return false
        end
    end
}

-- Initialize the system
local function initialize()
    print("[Dynamic Dialogue] Initializing dynamic dialogue system...")
    
    -- Try to add dialogue to player
    if dynamicDialogue.addDialogueToPlayer() then
        print("[Dynamic Dialogue] Dynamic dialogue system ready!")
    else
        print("[Dynamic Dialogue] Falling back to alternative method...")
        
        -- Alternative: Create a global function that can be called
        _G.BardDynamicDialogue = dynamicDialogue
        print("[Dynamic Dialogue] Global function created: BardDynamicDialogue")
    end
end

-- Initialize on load
initialize()

print("[Dynamic Dialogue] Dynamic dialogue system loaded")

return {
    interfaceName = "BardDynamicDialogue",
    interface = dynamicDialogue
}
