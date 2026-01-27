-- bard_performance_ui_menu.lua
-- Simple UI menu for publican interactions

local self = require('openmw.self')
local ui = require('openmw.ui')
local nearby = require('openmw.nearby')
local types = require('openmw.types')

print(">>> BARD PERFORMANCE UI MENU INITIALIZED <<<")

-- UI Menu System
local uiMenu = {
    -- Check if target is publican class
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
    
    -- Create the UI menu
    createMenu = function(target)
        if not self.isPublican(target) then
            ui.showMessage("This is not a publican.")
            return
        end
        
        local audienceCount = self.getAudienceCount()
        
        -- Create UI window
        local window = ui.create {
            layer = 'Windows',
            template = ui.templates.boxTransparent,
            props = {
                name = 'BardPerformanceMenu',
                relativeSize = util.vector2(0.3, 0.2),
                position = util.vector2(0.35, 0.4),
                anchor = util.vector2(0, 0),
                visible = true,
            },
            content = ui.content {
                ui.text {
                    text = string.format("%s the %s", target.recordId, target.class.name),
                    props = {
                        textSize = 16,
                        textColor = util.color.rgb(1, 1, 1),
                        align = ui.ALIGNMENT.Center,
                    }
                },
                ui.text {
                    text = string.format("Audience: %d people", audienceCount),
                    props = {
                        textSize = 12,
                        textColor = util.color.rgb(0.8, 0.8, 0.8),
                        align = ui.ALIGNMENT.Center,
                    }
                },
                ui.create {
                    template = ui.templates.padding,
                    content = ui.content {
                        ui.button {
                            text = "Talk",
                            props = {
                                textSize = 14,
                            },
                            events = {
                                mouseClick = function()
                                    self.showTalkOptions(target)
                                end
                            }
                        },
                        ui.button {
                            text = "Perform",
                            props = {
                                textSize = 14,
                            },
                            events = {
                                mouseClick = function()
                                    self.showPerformanceOptions(target)
                                end
                            }
                        },
                        ui.button {
                            text = "Exit",
                            props = {
                                textSize = 14,
                            },
                            events = {
                                mouseClick = function()
                                    self.closeMenu()
                                end
                            }
                        }
                    }
                }
            }
        }
        
        -- Store reference for cleanup
        self.currentMenu = window
        self.currentTarget = target
        
        print("[UI Menu] Created menu for:", target.recordId, "Audience:", audienceCount)
    end,
    
    -- Show talk options
    showTalkOptions = function(target)
        if not self.currentMenu then return end
        
        -- Replace content with talk options
        self.currentMenu.content = ui.content {
            ui.text {
                text = string.format("What would you like to discuss with %s?", target.recordId),
                props = {
                    textSize = 14,
                    textColor = util.color.rgb(1, 1, 1),
                    align = ui.ALIGNMENT.Center,
                }
            },
            ui.create {
                template = ui.templates.padding,
                content = ui.content {
                    ui.button {
                        text = "Ask about local rumors",
                        events = {
                            mouseClick = function()
                                ui.showMessage("The publican shares some local gossip...")
                                self.closeMenu()
                            end
                        }
                    },
                    ui.button {
                        text = "Inquire about work",
                        events = {
                            mouseClick = function()
                                ui.showMessage("The publican mentions business is...")
                                self.closeMenu()
                            end
                        }
                    },
                    ui.button {
                        text = "Just chat",
                        events = {
                            mouseClick = function()
                                ui.showMessage("You have a pleasant conversation.")
                                self.closeMenu()
                            end
                        }
                    },
                    ui.button {
                        text = "Back",
                        events = {
                            mouseClick = function()
                                self.createMenu(target)
                            end
                        }
                    }
                }
            }
        }
    end,
    
    -- Show performance options
    showPerformanceOptions = function(target)
        if not self.currentMenu then return end
        
        local audienceCount = self.getAudienceCount()
        if audienceCount == 0 then
            ui.showMessage("There's no one here to perform for right now.")
            return
        end
        
        -- Replace content with performance options
        self.currentMenu.content = ui.content {
            ui.text {
                text = "What type of performance will you give?",
                props = {
                    textSize = 14,
                    textColor = util.color.rgb(1, 1, 1),
                    align = ui.ALIGNMENT.Center,
                }
            },
            ui.text {
                text = string.format("Audience: %d people", audienceCount),
                props = {
                    textSize = 12,
                    textColor = util.color.rgb(0.8, 0.8, 0.8),
                    align = ui.ALIGNMENT.Center,
                }
            },
            ui.create {
                template = ui.templates.padding,
                content = ui.content {
                    ui.button {
                        text = "Brilliant Performance",
                        props = {
                            textSize = 12,
                        },
                        events = {
                            mouseClick = function()
                                self.executePerformance(target, 1)
                            end
                        }
                    },
                    ui.button {
                        text = "Good Performance",
                        props = {
                            textSize = 12,
                        },
                        events = {
                            mouseClick = function()
                                self.executePerformance(target, 2)
                            end
                        }
                    },
                    ui.button {
                        text = "Mediocre Performance",
                        props = {
                            textSize = 12,
                        },
                        events = {
                            mouseClick = function()
                                self.executePerformance(target, 3)
                            end
                        }
                    },
                    ui.button {
                        text = "Poor Performance",
                        props = {
                            textSize = 12,
                        },
                        events = {
                            mouseClick = function()
                                self.executePerformance(target, 4)
                            end
                        }
                    },
                    ui.button {
                        text = "Disastrous Performance",
                        props = {
                            textSize = 12,
                        },
                        events = {
                            mouseClick = function()
                                self.executePerformance(target, 5)
                            end
                        }
                    },
                    ui.button {
                        text = "Back",
                        events = {
                            mouseClick = function()
                                self.createMenu(target)
                            end
                        }
                    }
                }
            }
        }
    end,
    
    -- Execute performance
    executePerformance = function(target, performanceId)
        print("[UI Menu] Executing performance:", performanceId, "for target:", target.recordId)
        
        -- Use our existing performance system
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            interfaces.PerformanceHelper.specific(performanceId)
            
            -- Show result after a delay
            self.showPerformanceResult(target, performanceId)
            return true
        else
            print("[UI Menu] Performance helper not available")
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
        print("[UI Menu] Performance result:", result)
        
        -- Close menu after showing result
        self.closeMenu()
    end,
    
    -- Close the menu
    closeMenu = function()
        if self.currentMenu then
            self.currentMenu:destroy()
            self.currentMenu = nil
            self.currentTarget = nil
            print("[UI Menu] Menu closed")
        end
    end,
    
    -- Handle activation (when player activates publican)
    handleActivation = function(target)
        if self.isPublican(target) then
            self.createMenu(target)
            return true
        else
            return false
        end
    end
}

-- Make available globally
_G.BardPerformanceMenu = uiMenu

print("[UI Menu] Bard performance UI menu system ready")

return {
    interfaceName = "BardPerformanceMenu",
    interface = uiMenu
}
