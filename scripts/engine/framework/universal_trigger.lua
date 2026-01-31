-- universal_trigger.lua
-- Main engine for universal trigger system
-- Part 3 of 3: Engine System

print("[UNIVERSAL_TRIGGER] Universal trigger script loaded!")

local config = require("scripts.engine.framework.trigger_config")
local helpers = require("scripts.engine.framework.trigger_helpers")

local lastCheckTime = 0

-- Manual test function for Publican menu
_G.testPublicanMenu = function()
    print("[UNIVERSAL_TRIGGER] Testing Publican menu manually...")
    
    -- Try to load and call the Publican local script
    local success, publicanScript = pcall(require, "Lua.engine.plugins.publican_class.publican_local_script")
    if success then
        print("[UNIVERSAL_TRIGGER] Publican script loaded successfully")
        
        -- Call the showPublicanMenu function if it exists
        if publicanScript.showPublicanMenu then
            publicanScript.showPublicanMenu()
            print("[UNIVERSAL_TRIGGER] Publican menu should appear now!")
        else
            print("[UNIVERSAL_TRIGGER] showPublicanMenu function not found")
        end
    else
        print("[UNIVERSAL_TRIGGER] Failed to load Publican script:", publicanScript)
    end
end

-- Simple test that just tries to load the script
_G.testPublicanLoad = function()
    print("[UNIVERSAL_TRIGGER] Testing Publican script load...")
    local success, script = pcall(require, "Lua.engine.plugins.publican_class.publican_local_script")
    if success then
        print("[UNIVERSAL_TRIGGER] Script loaded successfully!")
        if script.showPublicanMenu then
            print("[UNIVERSAL_TRIGGER] showPublicanMenu function found!")
            script.showPublicanMenu()
        else
            print("[UNIVERSAL_TRIGGER] showPublicanMenu function not found")
        end
    else
        print("[UNIVERSAL_TRIGGER] Failed to load script:", script)
    end
end

print("[UNIVERSAL_TRIGGER] Use: testPublicanLoad() in console to test")

-- Simple console command to add the spell manually
_G.addPublicanSpell = function()
    print("[UNIVERSAL_TRIGGER] Manually adding bard_performance_dummy spell...")
    
    -- Try to add the spell using OMW interface
    local core = require("openmw.core")
    local player = require("openmw.world").players[1]
    
    if player then
        -- Use the core interface to add spell
        core.sendGlobalEvent("AddSpellToPlayer", {
            spellId = "bard_performance_dummy",
            playerId = player.id
        })
        print("[UNIVERSAL_TRIGGER] Spell add request sent")
    else
        print("[UNIVERSAL_TRIGGER] No player found")
    end
end

print("[UNIVERSAL_TRIGGER] Use: addPublicanSpell() to manually add spell")

-- Manual reset command for triggers
_G.resetPublicanTrigger = function()
    print("[UNIVERSAL_TRIGGER] Resetting Publican trigger...")
    
    for _, trigger in ipairs(config.triggers) do
        if trigger.name == "PublicanClass" then
            trigger.firedInCell = nil
            trigger.fired = false
            print("[UNIVERSAL_TRIGGER] Publican trigger reset!")
            break
        end
    end
end

print("[UNIVERSAL_TRIGGER] Use: resetPublicanTrigger() to reset Publican trigger")

-- Manual reset command for triggers
_G.resetPublicanTrigger = function()
    print("[UNIVERSAL_TRIGGER] Manually resetting Publican trigger...")
    
    for _, trigger in ipairs(config.triggers) do
        if trigger.name == "PublicanClass" then
            trigger.firedInCell = nil
            trigger.fired = false
            print("[UNIVERSAL_TRIGGER] Publican trigger reset! Can fire again.")
            break
        end
    end
end

print("[UNIVERSAL_TRIGGER] Use: resetPublicanTrigger() to manually reset Publican trigger")

return {
    engineHandlers = {
        onUpdate = function()
            -- Only check every 10 seconds instead of every frame
            local currentTime = os.time()
            if currentTime - lastCheckTime < 10 then
                return  -- Skip checking if less than 10 seconds has passed
            end
            
            lastCheckTime = currentTime
            
            -- Check if there are any triggers to process
            if #config.triggers == 0 then
                return  -- No triggers configured, skip checking
            end
            
            print("[TRIGGER] Checking triggers...")
            
            for _, trigger in ipairs(config.triggers) do
                -- BardClass triggers fire once per cell when a Bard is detected
                local canFire = false
                
                print("[TRIGGER] Processing trigger:", trigger.name, "Type:", trigger.type)
                
                if trigger.name == "BardClass" or trigger.name == "PublicanClass" or trigger.name == "MerchantClass" or trigger.name == "SmithClass" or trigger.name == "AlchemistClass" or trigger.name == "PublicanServiceClass" or trigger.name == "EnchanterClass" then
                    -- BardClass and PublicanClass triggers fire once per cell when NPC is detected
                    local player = require("openmw.world").players[1]
                    if player and player.cell then
                        local currentCell = player.cell.name
                        
                        -- Reset when entering a different cell (the simple fix you wanted)
                        if trigger.firedInCell and trigger.firedInCell ~= currentCell then
                            trigger.firedInCell = nil
                            print("[TRIGGER] Reset", trigger.name, "trigger for new cell:", currentCell)
                        end
                        
                        -- Only allow firing if we haven't fired in this cell yet
                        if not trigger.firedInCell then
                            canFire = true
                            print("[TRIGGER]", trigger.name, "can fire (not fired in cell)")
                        else
                            print("[TRIGGER]", trigger.name, "cannot fire (already fired in cell)")
                        end
                    end
                else
                    -- Other triggers respect the fired state
                    canFire = not trigger.fired
                    print("[TRIGGER] Trigger", trigger.name, "canFire:", canFire)
                end
                
                if canFire then
                    local conditionMet = false
                    
                    -- Check quest stage if specified (simplified for global scripts)
                    if trigger.questStage then
                        -- For now, we'll skip quest stage checking in global scripts
                        -- This can be handled by the individual trigger systems
                        print("[TRIGGER] Quest stage checking not available in global scripts")
                    end
                    
                    if trigger.type == "cell" then
                        conditionMet = helpers.checkCellCondition(trigger.cellName)
                    elseif trigger.type == "spell" then
                        conditionMet = helpers.checkSpellCondition(trigger.spellId)
                        print("[TRIGGER] Spell check for:", trigger.spellId, "Result:", conditionMet)
                    elseif trigger.type == "npc_class" then
                        conditionMet, trigger.detectedNPC = helpers.checkNPCClassCondition(trigger.npcClass, trigger.radius)
                    else
                        print("[TRIGGER] Unknown trigger type:", trigger.type)
                    end
                    
                    print("[TRIGGER] Final conditionMet:", conditionMet, "for trigger:", trigger.name)
                    
                    if conditionMet then
                        print("[TRIGGER] Firing trigger:", trigger.name)
                        helpers.fireTrigger(trigger)
                        
                        -- Mark that we've fired in this cell
                        if trigger.name == "BardClass" or trigger.name == "PublicanClass" or trigger.name == "MerchantClass" or trigger.name == "SmithClass" or trigger.name == "AlchemistClass" or trigger.name == "PublicanServiceClass" or trigger.name == "EnchanterClass" then
                            local player = require("openmw.world").players[1]
                            if player and player.cell then
                                trigger.firedInCell = player.cell.name
                                print("[TRIGGER] Marked", trigger.name, "as fired in cell:", player.cell.name)
                            end
                        end
                    else
                        print("[TRIGGER] Condition not met, not firing:", trigger.name)
                    end
                else
                    print("[TRIGGER] Cannot fire trigger:", trigger.name)
                end
            end
        end
    }
}
