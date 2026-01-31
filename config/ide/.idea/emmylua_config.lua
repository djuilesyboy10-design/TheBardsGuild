-- EmmyLua configuration for The Bards Guild mod
-- This helps with code completion and error checking

-- Global definitions for our mod
---@class BardSkillConfig
---@field name string
---@field description string
---@field icon table
---@field attribute string
---@field specialization number
---@field startLevel number
---@field maxLevel number
---@field skillGain table
---@field statsWindowProps table

-- Common event data structures
---@class HarvestData
---@field amount number
---@field recordId string

-- SkillFramework API patterns
API = {} -- Global reference to SkillFramework
SKILL_ID = "" -- Global skill ID pattern

return {}
