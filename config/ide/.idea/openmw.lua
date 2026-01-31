---@meta openmw

-- OpenMW Core API
---@class openmw
openmw = {}

-- Core types and interfaces
---@class openmw.core
openmw.core = {}
function openmw.core.getGameHour() end
function openmw.core.getGameDay() end
function openmw.core.getGameState() end
function openmw.core.sendGlobalEvent(eventName, data) end

-- Types
---@class openmw.types
openmw.types = {}
---@class openmw.types.Actor
---@class openmw.types.Creature
---@class openmw.types.NPC
---@class openmw.types.Container
---@class openmw.types.Door

-- Actor/NPC stats
---@class openmw.types.NPC.stats
openmw.types.NPC.stats = {}
---@class openmw.types.NPC.stats.skills
openmw.types.NPC.stats.skills = {}
function openmw.types.NPC.stats.skills.speechcraft(actor) end
function openmw.types.NPC.stats.skills.sneak(actor) end
function openmw.types.NPC.stats.skills.mysticism(actor) end

-- Self reference
---@class openmw.self
openmw.self = {}

-- Interfaces
---@class openmw.interfaces
openmw.interfaces = {}

-- SkillFramework interface
---@class openmw.interfaces.SkillFramework
---@field registerSkill fun(id: string, config: table)
---@field skillUsed fun(id: string, options: table)
---@field getSkillStat fun(id: string): table?
---@field getSkillRecord fun(id: string): table?
---@field SPECIALIZATION table
---@field STATS_WINDOW_SUBSECTIONS table
openmw.interfaces.SkillFramework = {}
openmw.interfaces.SkillFramework.SPECIALIZATION = {
    Combat = 0,
    Magic = 1,
    Stealth = 2
}
openmw.interfaces.SkillFramework.STATS_WINDOW_SUBSECTIONS = {
    Combat = "Combat",
    Magic = "Magic",
    Stealth = "Stealth",
    Arts = "Arts",
    Misc = "Misc"
}

-- SkillProgression interface (vanilla skills)
---@class openmw.interfaces.SkillProgression
---@field skillUsed fun(skillName: string, options: table)
openmw.interfaces.SkillProgression = {}

-- UI
---@class openmw.ui
openmw.ui = {}

-- Input
---@class openmw.input
openmw.input = {}

-- Async
---@class openmw.async
openmw.async = {}

-- Event handler types
---@class EventHandlers
---@field HerbalismHarvest fun(data: table)
---@field onLoad fun(data: table?)
---@field onSave fun() return table

---@class EngineHandlers
---@field onInit fun()
---@field onLoad fun(data: table?)
---@field onSave fun() return table
---@field onFrame fun()

-- Return type for player scripts
---@return { eventHandlers: EventHandlers, engineHandlers: EngineHandlers }
