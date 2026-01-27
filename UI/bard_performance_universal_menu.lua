-- bard_performance_universal_menu.lua
-- Universal menu system for any NPC class

local self = require('openmw.self')
local ui = require('openmw.ui')
local nearby = require('openmw.nearby')
local types = require('openmw.types')

print(">>> BARD PERFORMANCE UNIVERSAL MENU INITIALIZED <<<")

-- Universal Menu Configuration
local menuConfig = {
    -- Define menu configurations for different classes
    ["Publican"] = {
        title = "Publican Services",
        options = {
            { text = "Talk", action = "talk" },
            { text = "Perform", action = "perform" },
            { text = "Buy Drinks", action = "shop" },
            { text = "Rent Room", action = "rent" },
            { text = "Exit", action = "exit" }
        },
        talkOptions = {
            { text = "Ask about local rumors", response = "The publican shares some local gossip..." },
            { text = "Inquire about work", response = "The publican mentions business is..." },
            { text = "Ask about patrons", response = "The publican points out some regulars..." },
            { text = "Just chat", response = "You have a pleasant conversation." }
        }
    },
    ["Noble"] = {
        title = "Noble Interaction",
        options = {
            { text = "Talk", action = "talk" },
            { text = "Perform", action = "perform" },
            { text = "Request Favor", action = "favor" },
            { text = "Discuss Politics", action = "politics" },
            { text = "Exit", action = "exit" }
        },
        talkOptions = {
            { text = "Ask about court affairs", response = "The noble shares some court gossip..." },
            { text = "Inquire about family", response = "The noble mentions family matters..." },
            { text = "Discuss local events", response = "The noble talks about recent events..." },
            { text = "Just chat", response = "You have an engaging conversation." }
        }
    },
    ["Merchant"] = {
        title = "Merchant Services",
        options = {
            { text = "Talk", action = "talk" },
            { text = "Perform", action = "perform" },
            { text = "Browse Wares", action = "shop" },
            { text = "Haggle", action = "haggle" },
            { text = "Exit", action = "exit" }
        },
        talkOptions = {
            { text = "Ask about goods", response = "The merchant describes their wares..." },
            { text = "Inquire about trade routes", response = "The merchant mentions trade opportunities..." },
            { text = "Ask about competitors", response = "The merchant discusses competition..." },
            { text = "Just chat", response = "You have a business-like conversation." }
        }
    },
    ["Guard"] = {
        title = "Guard Interaction",
        options = {
            { text = "Talk", action = "talk" },
            { text = "Perform", action = "perform" },
            { text = "Report Crime", action = "report" },
            { text = "Ask about Security", action = "security" },
            { text = "Exit", action = "exit" }
        },
        talkOptions = {
            { text = "Ask about patrols", response = "The guard describes patrol routes..." },
            { text = "Inquire about recent crimes", response = "The guard mentions recent incidents..." },
            { text = "Ask about local threats", response = "The guard warns about dangers..." },
            { text = "Just chat", response = "You have a professional conversation." }
        }
    },
    ["Bard"] = {
        title = "Bard Interaction",
        options = {
            { text = "Talk", action = "talk" },
            { text = "Perform Together", action = "duel" },
            { text = "Share Songs", action = "share" },
            { text = "Discuss Music", action = "music" },
            { text = "Exit", action = "exit" }
        },
        talkOptions = {
            { text = "Ask about songs", response = "The bard shares some original compositions..." },
            { text = "Inquire about performances", response = "The bard talks about recent shows..." },
            { text = "Discuss musical theory", response = "The bard explains some musical concepts..." },
            { text = "Just chat", response = "You have an artistic conversation." }
        }
    },
    ["TemplePriest"] = {
        title = "Temple Services",
        options = {
            { text = "Talk", action = "talk" },
            { text = "Perform", action = "perform" },
            { text = "Receive Blessing", action = "blessing" },
            { text = "Donate", action = "donate" },
            { text = "Exit", action = "exit" }
        },
        talkOptions = {
            { text = "Ask about divine matters", response = "The priest shares some religious wisdom..." },
            { text = "Inquire about temple services", response = "The priest explains temple offerings..." },
            { text = "Ask about local faith", response = "The priest discusses local beliefs..." },
            { text = "Just chat", response = "You have a spiritual conversation." }
        }
    },
    ["Guild Guide"] = {
        title = "Guild Services",
        options = {
            { text = "Talk", action = "talk" },
            { text = "Perform", action = "perform" },
            { text = "Get Training", action = "training" },
            { text = "Join Guild", action = "join" },
            { text = "Exit", action = "exit" }
        },
        talkOptions = {
            { text = "Ask about guild services", response = "The guide explains guild offerings..." },
            { text = "Inquire about membership", response = "The guide discusses guild benefits..." },
            { text = "Ask about training", response = "The guide describes training programs..." },
            { text = "Just chat", response = "You have a professional conversation." }
        }
    },
    ["Default"] = {
        title = "Interaction",
        options = {
            { text = "Talk", action = "talk" },
            { text = "Perform", action = "perform" },
            { text = "Trade", action = "trade" },
            { text = "Exit", action = "exit" }
        },
        talkOptions = {
            { text = "Ask about work", response = "They mention their occupation..." },
            { text = "Inquire about local area", response = "They describe the local area..." },
            { text = "Just chat", response = "You have a pleasant conversation." }
        }
    }
}

-- Universal Menu System
local universalMenu = {
    -- Get configuration for NPC class
    getConfig = function(target)
        if not target or not target.class then
            return menuConfig["Default"]
        end
        
        local className = target.class.name
        return menuConfig[className] or menuConfig["Default"]
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
    
    -- Create the universal menu
    createMenu = function(target)
        local config = self.getConfig(target)
        local audienceCount = self.getAudienceCount()
        
        -- Create UI window
        local window = ui.create {
            layer = 'Windows',
            template = ui.templates.boxTransparent,
            props = {
                name = 'UniversalMenu',
                relativeSize = util.vector2(0.3, 0.25),
                position = util.vector2(0.35, 0.4),
                anchor = util.vector2(0, 0),
                visible = true,
            },
            content = ui.content {
                ui.text {
                    text = string.format("%s", config.title),
                    props = {
                        textSize = 16,
                        textColor = util.color.rgb(1, 1, 1),
                        align = ui.ALIGNMENT.Center,
                    }
                },
                ui.text {
                    text = string.format("%s the %s", target.recordId, target.class.name),
                    props = {
                        textSize = 12,
                        textColor = util.color.rgb(0.8, 0.8, 0.8),
                        align = ui.ALIGNMENT.Center,
                    }
                },
                ui.text {
                    text = string.format("Audience: %d people", audienceCount),
                    props = {
                        textSize = 10,
                        textColor = util.color.rgb(0.6, 0.6, 0.6),
                        align = ui.ALIGNMENT.Center,
                    }
                },
                ui.create {
                    template = ui.templates.padding,
                    content = ui.content {
                        -- Create buttons based on config
                    }
                }
            }
        }
        
        -- Add buttons based on configuration
        local buttonContent = ui.content {}
        for _, option in ipairs(config.options) do
            table.insert(buttonContent, ui.button {
                text = option.text,
                props = {
                    textSize = 12,
                },
                events = {
                    mouseClick = function()
                        self.handleAction(target, option.action, config)
                    end
                }
            })
        end
        
        -- Update the content with buttons
        window.content[4].content = buttonContent
        
        -- Store reference for cleanup
        self.currentMenu = window
        self.currentTarget = target
        self.currentConfig = config
        
        print("[Universal Menu] Created menu for:", target.recordId, "Class:", target.class.name, "Audience:", audienceCount)
    end,
    
    -- Handle menu actions
    handleAction = function(target, action, config)
        if action == "talk" then
            self.showTalkOptions(target, config)
        elseif action == "perform" then
            self.showPerformanceOptions(target, config)
        elseif action == "shop" then
            self.handleShop(target, config)
        elseif action == "exit" then
            self.closeMenu()
        elseif action == "rent" then
            self.handleRent(target, config)
        elseif action == "favor" then
            self.handleFavor(target, config)
        elseif action == "politics" then
            self.handlePolitics(target, config)
        elseif action == "haggle" then
            self.handleHaggle(target, config)
        elseif action == "report" then
            self.handleReport(target, config)
        elseif action == "security" then
            self.handleSecurity(target, config)
        elseif action == "duel" then
            self.handleDuel(target, config)
        elseif action == "share" then
            self.handleShare(target, config)
        elseif action == "music" then
            self.handleMusic(target, config)
        elseif action == "blessing" then
            self.handleBlessing(target, config)
        elseif action == "donate" then
            self.handleDonate(target, config)
        elseif action == "training" then
            self.handleTraining(target, config)
        elseif action == "join" then
            self.handleJoin(target, config)
        elseif action == "trade" then
            self.handleTrade(target, config)
        else
            print("[Universal Menu] Unknown action:", action)
        end
    end,
    
    -- Show talk options
    showTalkOptions = function(target, config)
        if not self.currentMenu then return end
        
        -- Replace content with talk options
        local talkContent = ui.content {
            ui.text {
                text = "What would you like to discuss?",
                props = {
                    textSize = 14,
                    textColor = util.color.rgb(1, 1, 1),
                    align = ui.ALIGNMENT.Center,
                }
            },
            ui.create {
                template = ui.templates.padding,
                content = ui.content {
                    -- Create talk options based on config
                }
            }
        }
        
        -- Add talk option buttons
        for _, option in ipairs(config.talkOptions) do
            table.insert(talkContent[1].content, ui.button {
                text = option.text,
                events = {
                    mouseClick = function()
                        ui.showMessage(option.response)
                        self.closeMenu()
                    end
                }
            })
        end
        
        -- Add back button
        table.insert(talkContent[1].content, ui.button {
            text = "Back",
            events = {
                mouseClick = function()
                    self.createMenu(target)
                end
            }
        })
        
        -- Update the window content
        self.currentMenu.content = talkContent
    end,
    
    -- Show performance options with 6 types
    showPerformanceOptions = function(target, config)
        if not self.currentMenu then return end
        
        local audienceCount = self.getAudienceCount()
        if audienceCount == 0 then
            ui.showMessage("There's no one here to perform for right now.")
            return
        end
        
        -- Define the 6 performance types
        local performanceTypes = {
            "Dance the handy high-kick",
            "Play the drum",
            "Play the lute and sing", 
            "Juggle",
            "Tell a tale",
            "Tell a few jokes"
        }
        
        -- Replace content with performance type selection
        local perfContent = ui.content {
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
                    -- Create buttons for each performance type
                }
            }
        }
        
        -- Add performance type buttons
        for i, perfType in ipairs(performanceTypes) do
            table.insert(perfContent[2].content, ui.button {
                text = perfType,
                props = {
                    textSize = 12,
                },
                events = {
                    mouseClick = function()
                        self.showQualityOptions(target, perfType, i)
                    end
                }
            })
        end
        
        -- Add back button
        table.insert(perfContent[2].content, ui.button {
            text = "Back",
            events = {
                mouseClick = function()
                    self.createMenu(target)
                end
            }
        })
        
        -- Update the window content
        self.currentMenu.content = perfContent
    end,
    
    -- Show quality options for selected performance type
    showQualityOptions = function(target, performanceType, typeId)
        if not self.currentMenu then return end
        
        -- Replace content with quality selection
        local qualityContent = ui.content {
            ui.text {
                text = string.format("How well will you %s?", performanceType),
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
                        text = "Brilliant Performance",
                        props = {
                            textSize = 12,
                        },
                        events = {
                            mouseClick = function()
                                self.executePerformance(target, 1, performanceType)
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
                                self.executePerformance(target, 2, performanceType)
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
                                self.executePerformance(target, 3, performanceType)
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
                                self.executePerformance(target, 4, performanceType)
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
                                self.executePerformance(target, 5, performanceType)
                            end
                        }
                    },
                    ui.button {
                        text = "Back",
                        events = {
                            mouseClick = function()
                                self.showPerformanceOptions(target, config)
                            end
                        }
                    }
                }
            }
        }
        
        -- Update the window content
        self.currentMenu.content = qualityContent
    end,
    
    -- Execute performance
    executePerformance = function(target, performanceId)
        print("[Universal Menu] Executing performance:", performanceId, "for target:", target.recordId)
        
        -- Use our existing performance system
        local interfaces = require('openmw.interfaces')
        if interfaces.PerformanceHelper then
            interfaces.PerformanceHelper.specific(performanceId)
            
            -- Show result after a delay
            self.showPerformanceResult(target, performanceId)
            return true
        else
            print("[Universal Menu] Performance helper not available")
            return false
        end
    end,
    
    -- Show performance result
    showPerformanceResult = function(target, performanceId)
        local results = {
            [1] = "Excellent show! The audience absolutely loved your performance!",
            [2] = "Good performance! The crowd seemed to enjoy it.",
            [3] = "It was... acceptable. The audience didn't complain.",
            [4] = "That wasn't your best work. Some people actually left.",
            [5] = "That was... terrible. The audience is actually angry."
        }
        
        local result = results[performanceId] or "The performance was... interesting."
        ui.showMessage(result)
        print("[Universal Menu] Performance result:", result)
        
        -- Close menu after showing result
        self.closeMenu()
    end,
    
    -- Handle other actions (placeholders for now)
    handleShop = function(target, config)
        ui.showMessage("Shop functionality coming soon!")
        self.closeMenu()
    end,
    
    handleRent = function(target, config)
        ui.showMessage("Room rental functionality coming soon!")
        self.closeMenu()
    end,
    
    handleFavor = function(target, config)
        ui.showMessage("Favor system coming soon!")
        self.closeMenu()
    end,
    
    handlePolitics = function(target, config)
        ui.showMessage("Politics system coming soon!")
        self.closeMenu()
    end,
    
    handleHaggle = function(target, config)
        ui.showMessage("Haggle system coming soon!")
        self.closeMenu()
    end,
    
    handleReport = function(target, config)
        ui.showMessage("Crime reporting system coming soon!")
        self.closeMenu()
    end,
    
    handleSecurity = function(target, config)
        ui.showMessage("Security system coming soon!")
        self.closeMenu()
    end,
    
    handleDuel = function(target, config)
        ui.showMessage("Bard duel system coming soon!")
        self.closeMenu()
    end,
    
    handleShare = function(target, config)
        ui.showMessage("Song sharing system coming soon!")
        self.closeMenu()
    end,
    
    handleMusic = function(target, config)
        ui.showMessage("Music discussion system coming soon!")
        self.closeMenu()
    end,
    
    handleBlessing = function(target, config)
        ui.showMessage("Blessing system coming soon!")
        self.closeMenu()
    end,
    
    handleDonate = function(target, config)
        ui.showMessage("Donation system coming soon!")
        self.closeMenu()
    end,
    
    handleTraining = function(target, config)
        ui.showMessage("Training system coming soon!")
        self.closeMenu()
    end,
    
    handleJoin = function(target, config)
        ui.showMessage("Guild joining system coming soon!")
        self.closeMenu()
    end,
    
    handleTrade = function(target, config)
        ui.showMessage("Trade system coming soon!")
        self.closeMenu()
    end,
    
    -- Close the menu
    closeMenu = function()
        if self.currentMenu then
            self.currentMenu:destroy()
            self.currentMenu = nil
            self.currentTarget = nil
            self.currentConfig = nil
            print("[Universal Menu] Menu closed")
        end
    end,
    
    -- Handle activation (when player activates NPC)
    handleActivation = function(target)
        self.createMenu(target)
        return true
    end,
    
    -- Add new class configuration
    addClassConfig = function(className, config)
        menuConfig[className] = config
        print("[Universal Menu] Added configuration for class:", className)
    end,
    
    -- Get available classes
    getAvailableClasses = function()
        local classes = {}
        for className, _ in pairs(menuConfig) do
            table.insert(classes, className)
        end
        return classes
    end
}

-- Make available globally
_G.UniversalMenu = universalMenu

print("[Universal Menu] Universal menu system ready")

return {
    interfaceName = "UniversalMenu",
    interface = universalMenu,
    eventHandlers = {
        BardPerformanceShowMenu = function(data)
            print("[Universal Menu] Received menu trigger event")
            
            -- Find nearest NPC to the detector position
            local nearby = require('openmw.nearby')
            local types = require('openmw.types')
            local closestNPC = nil
            local closestDistance = 1000
            
            for _, actor in pairs(nearby.actors) do
                if actor.type == types.NPC then
                    local distance = (actor.position - data.detectorPosition):length()
                    if distance < closestDistance then
                        closestDistance = distance
                        closestNPC = actor
                    end
                end
            end
            
            if closestNPC then
                print("[Universal Menu] Showing menu for:", closestNPC.recordId)
                universalMenu.createMenu(closestNPC)
            else
                print("[Universal Menu] No NPC found for menu")
            end
        end
    }
}
