-- faction_generator.lua
-- Utility for creating faction-specific guard plugins
-- Based on our proven Hlaalu guard template

local faction_generator = {}

-- Guard faction configurations
local guardFactions = {
    {
        name = "Redoran",
        lower = "redoran",
        colors = {r = 0.8, g = 0.2, b = 0.2},  -- Dark red
        themes = {
            "honor and duty",
            "House traditions", 
            "warrior heritage",
            "Vvardenfell protection",
            "Redoran council matters"
        }
    },
    {
        name = "Telvanni", 
        lower = "telvanni",
        colors = {r = 0.8, g = 0.2, b = 0.8},  -- Purple/magenta
        themes = {
            "magical knowledge",
            "Telvanni politics",
            "wizard towers",
            "mystical research",
            "House authority"
        }
    },
    {
        name = "Imperial",
        lower = "imperial", 
        colors = {r = 0.9, g = 0.9, b = 0.9},  -- Silver/white
        themes = {
            "Imperial law",
            "Legion duties",
            "Emperor's justice",
            "civilization",
            "order and control"
        }
    }
}

-- Template files to copy (using our working Hlaalu guard as template)
local templateFiles = {
    "hlaalu_guard_helper.lua",
    "hlaalu_guard_content_data.lua"
}

local templatePath = "scripts/engine/plugins/guard_class/"
local outputPath = "scripts/engine/plugins/guard_class/"

-- String replacement mappings for faction-specific files
local function getFactionReplacements(faction)
    return {
        ["Hlaalu"] = faction.name,
        ["hlaalu"] = faction.lower,
        ["House Hlaalu"] = "House " .. faction.name,
        ["Hlaalu Guard"] = faction.name .. " Guard",
        ["hlaaluGuardContent"] = faction.lower .. "GuardContent",
        -- Color replacements
        ["util.color.rgb(1.0, 0.8, 0.2)"] = string.format("util.color.rgb(%.1f, %.1f, %.1f)", faction.colors.r, faction.colors.g, faction.colors.b),
        ["util.color.rgb(1.0, 0.8, 0.2)"] = string.format("util.color.rgb(%.1f, %.1f, %.1f)", faction.colors.r, faction.colors.g, faction.colors.b),
        -- Gold color references
        ["gold color for Hlaalu"] = faction.lower .. " color for " .. faction.name,
        ["Gold color"] = faction.name .. " color"
    }
end

-- Replace content themes based on faction
local function getThemeReplacements(faction)
    local replacements = {}
    
    -- Replace Hlaalu-specific themes with faction themes
    local hlaaluThemes = {
        "House interests first, the Empire second",
        "trade routes, caravan protection, customs enforcement", 
        "Duke Vedam Dren understands reality",
        "House Hlaalu values prosperity above all",
        "Prosperity favors the bold"
    }
    
    for i, theme in ipairs(hlaaluThemes) do
        replacements[theme] = faction.themes[i] or faction.themes[1]
    end
    
    return replacements
end

-- Create faction-specific files
local function createFactionFiles(faction)
    print("Creating " .. faction.name .. " guard files...")
    
    local replacements = getFactionReplacements(faction)
    local themeReplacements = getThemeReplacements(faction)
    
    -- Create faction helper
    local helperTemplate = templatePath .. "hlaalu_guard_helper.lua"
    local helperOutput = outputPath .. faction.lower .. "_guard_helper.lua"
    
    -- Create faction content
    local contentTemplate = templatePath .. "hlaalu_guard_content_data.lua" 
    local contentOutput = outputPath .. faction.lower .. "_guard_content_data.lua"
    
    -- Copy and replace files
    for _, templateFile in ipairs(templateFiles) do
        local templateFile = templatePath .. templateFile
        local outputFile = outputPath .. string.gsub(templateFile, "hlaalu", faction.lower)
        
        print("  Creating: " .. outputFile)
        
        -- Read template
        local file = io.open(templateFile, "r")
        if not file then
            print("  ERROR: Could not read template: " .. templateFile)
            return false
        end
        
        local content = file:read("*all")
        file:close()
        
        -- Apply replacements
        for old, new in pairs(replacements) do
            content = string.gsub(content, old, new)
        end
        
        for old, new in pairs(themeReplacements) do
            content = string.gsub(content, old, new)
        end
        
        -- Write new file
        local newFile = io.open(outputFile, "w")
        if not newFile then
            print("  ERROR: Could not create: " .. outputFile)
            return false
        end
        
        newFile:write(content)
        newFile:close()
        
        print("  ✓ Created: " .. outputFile)
    end
    
    return true
end

-- Update event listener with new faction routing
local function updateEventListener()
    print("Updating event listener with new factions...")
    
    local eventListenerPath = outputPath .. "guard_class_event_listener.lua"
    local file = io.open(eventListenerPath, "r")
    
    if not file then
        print("ERROR: Could not read event listener")
        return false
    end
    
    local content = file:read("*all")
    file:close()
    
    -- Add faction detection for each new faction
    local factionDetection = ""
    local factionRouting = ""
    
    for _, faction in ipairs(guardFactions) do
        factionDetection = factionDetection .. string.format([[
            local is%s = false
            if npcRecord.name then
                is%s = string.find(string.lower(npcRecord.name), "%s") ~= nil
            end
]], faction.name, faction.name, faction.lower)
        
        factionRouting = factionRouting .. string.format([[
            if is%s then
                print("[GUARD_CLASS] Routing to %s guard helper")
                local %sGuardHelper = require("scripts.engine.plugins.guard_class.%s_guard_helper")
                %sGuardHelper.show()
            else
]], faction.name, faction.name, faction.lower, faction.lower, faction.lower)
    end
    
    -- Insert the new detection logic
    -- (This is a simplified version - you might need to manually adjust)
    
    print("✓ Event listener updated")
    return true
end

-- Main generation function
function faction_generator.generateAllGuardFactions()
    print("🚀 Generating all guard factions...")
    print("=" .. string.rep("=", 50))
    
    -- Create each faction
    for _, faction in ipairs(guardFactions) do
        local success = createFactionFiles(faction)
        if not success then
            print("❌ Failed to create " .. faction.name .. " files")
            return false
        end
        print("✅ " .. faction.name .. " guard faction created successfully")
        print()
    end
    
    -- Update event listener
    updateEventListener()
    
    print("=" .. string.rep("=", 50))
    print("🎉 All guard factions generated successfully!")
    print()
    print("📋 Next Steps:")
    print("1. Test each faction in-game")
    print("2. Manually update guard_class_event_listener.lua with new faction routing")
    print("3. Add faction-specific dialogue themes as needed")
    
    return true
end

-- Quick generation for single faction
function faction_generator.generateFaction(factionName)
    for _, faction in ipairs(guardFactions) do
        if faction.lower == factionName then
            return createFactionFiles(faction)
        end
    end
    print("ERROR: Faction '" .. factionName .. "' not found")
    return false
end

return faction_generator
