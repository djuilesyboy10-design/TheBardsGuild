-- =============================================================================
-- UNIQUE DIALOGUE EVENT LISTENER
-- Handles special dialogue interactions based on reputation and context
-- Integrates with S3 Framework for professional dialogue management
-- =============================================================================

local core = require("openmw.core")
local self = require("openmw.self")
local types = require("openmw.types")
local MOD_ID = "UniqueDialogue"

-- S3 Framework Integration
local success, ScriptContext = pcall(function() return require('scripts.s3.scriptContext') end)
local success2, LogMessage = pcall(function() return require('scripts.s3.logmessage') end)
local success3, ProtectedTableModule = pcall(function() return require('scripts.s3.protectedTable') end)

-- Context detection and logging
local context = success and ScriptContext.get() or nil
local msg = core.getGMST or print
local debugLog = success2 and LogMessage or print

-- Settings management
local settings = nil
if success3 and ProtectedTableModule and ProtectedTableModule.new then
    settings = ProtectedTableModule.new({
        name = "UniqueDialogue",
        global = true,
        debug = true,
        default = {
            enableReputationDialogue = true,
            enableContextualGreetings = true,
            reputationThresholds = {
                criminal = -50,
                suspicious = -20,
                dishonorable = -5,
                neutral = 0,
                honorable = 20,
                heroic = 50,
                legendary = 100
            },
            dialogueFrequency = 0.3, -- 30% chance for special dialogue
            enableFactionResponses = true
        }
    })
end

-- =============================================================================
-- DIALOGUE TEMPLATES
-- =============================================================================

local dialogueTemplates = {
    criminal = {
        greetings = {
            "I don't talk to criminals.",
            "The guards will be hearing about this.",
            "Your reputation precedes you... and not in a good way.",
            "I have nothing for your kind."
        },
        responses = {
            "Why would I help someone like you?",
            "My services are not available to criminals.",
            "Perhaps you should change your ways before seeking help."
        }
    },
    
    suspicious = {
        greetings = {
            "What do you want?",
            "I'm watching you.",
            "You seem... troubled.",
            "State your business and be quick."
        },
        responses = {
            "I'll help, but I'm keeping an eye on you.",
            "Don't think about causing trouble.",
            "My prices are higher for... suspicious types."
        }
    },
    
    neutral = {
        greetings = {
            "Greetings, traveler.",
            "Welcome.",
            "How can I help you today?",
            "Good day to you."
        },
        responses = {
            "Certainly, what do you need?",
            "I can help with that.",
            "Let me see what I can do."
        }
    },
    
    honorable = {
        greetings = {
            "Ah, a person of honor! Welcome!",
            "It's good to see you again.",
            "Your reputation precedes you!",
            "A pleasure to meet you!"
        },
        responses = {
            "For someone of your standing, of course!",
            "It would be my honor to help.",
            "Consider it done, respected friend."
        }
    },
    
    heroic = {
        greetings = {
            "By the Nine! A hero among us!",
            "We've heard tales of your deeds!",
            "It's an honor to meet you!",
            "The people sing songs of your bravery!"
        },
        responses = {
            "Anything for a hero like you!",
            "Please, take this as a token of our gratitude!",
            "Your service to the community is unmatched!"
        }
    },
    
    legendary = {
        greetings = {
            "I... I can't believe it's you!",
            "The legends are true!",
            "We are not worthy!",
            "Your name will be remembered for generations!"
        },
        responses = {
            "Take anything you need, it's yours!",
            "The entire community owes you everything!",
            "Please, allow us to serve you!"
        }
    }
}

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

local function getReputationLevel()
    if not settings then return "neutral" end
    
    -- Request reputation from global script
    core.sendGlobalEvent("Reputation_GetReputation", {})
    return "neutral" -- Default fallback
end

local function selectDialogue(level, dialogueType)
    local templates = dialogueTemplates[level] or dialogueTemplates.neutral
    local dialogues = templates[dialogueType] or templates.greetings
    
    if #dialogues == 0 then return "Hello." end
    
    -- Select random dialogue from available options
    local index = math.random(1, #dialogues)
    return dialogues[index]
end

local function shouldTriggerDialogue()
    if not settings then return false end
    
    local frequency = settings.dialogueFrequency or 0.3
    return math.random() <= frequency
end

-- =============================================================================
-- EVENT HANDLERS
-- =============================================================================

local function onReputationResponse(data)
    if not data or not data.level then return end
    
    debugLog("Received reputation level: " .. data.level)
    
    -- Store current reputation for dialogue decisions
    if settings then
        settings.currentReputation = data.level
        settings.currentPoints = data.points
    end
end

local function onNPCInteraction(data)
    if not data or not data.npc then return end
    
    -- Check if reputation dialogue is enabled
    if not settings or not settings.enableReputationDialogue then return end
    
    -- Check if we should trigger special dialogue
    if not shouldTriggerDialogue() then return end
    
    local reputationLevel = settings.currentReputation or "neutral"
    local dialogueType = data.dialogueType or "greetings"
    
    -- Select appropriate dialogue
    local dialogue = selectDialogue(reputationLevel, dialogueType)
    
    debugLog("Selected dialogue: " .. dialogue .. " for reputation: " .. reputationLevel)
    
    -- Send dialogue to player
    local player = world.players[1]
    if player then
        player:sendEvent("UniqueDialogue_Show", {
            npc = data.npc,
            dialogue = dialogue,
            reputationLevel = reputationLevel
        })
    end
end

-- =============================================================================
-- INITIALIZATION
-- =============================================================================

-- Log initialization with context information
if success then
    msg("[UniqueDialogue] Unique Dialogue Event Listener loaded with S3 Framework support")
    if context then
        local contextNames = {
            [1] = "Local",
            [2] = "Global", 
            [3] = "Player",
            [4] = "Menu"
        }
        msg("[UniqueDialogue] Running in context: " .. (contextNames[context] or "Unknown"))
    end
else
    msg("[UniqueDialogue] Unique Dialogue Event Listener loaded (S3 Framework not available)")
end

if settings then
    msg("[UniqueDialogue] Settings management initialized")
    debugLog("[UniqueDialogue] Initialized with reputation-based dialogue system")
else
    msg("[UniqueDialogue] Settings management not available")
end

return {
    eventHandlers = {
        Reputation_Response = onReputationResponse,
        UniqueDialogue_NPCInteraction = onNPCInteraction
    }
}
