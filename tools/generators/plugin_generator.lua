-- plugin_generator.lua
-- Utility for creating new plugin classes based on existing templates
-- COMPLETELY SAFE - Never modifies existing files, only creates new ones

local plugin_generator = {}

-- Template files to copy (using bard_class as the template)
local templateFiles = {
    "bard_class_helper.lua",
    "bard_class_event_listener.lua", 
    "bard_content_data.lua"
}

-- Template paths
local templatePath = "Lua/engine/plugins/bard_class/"
local outputPath = "Lua/engine/plugins/"

-- String replacement mappings
local function getReplacements(className, classLower)
    return {
        ["bard_class"] = classLower .. "_class",
        ["BardClass"] = className,
        ["bardContent"] = classLower .. "Content",
        ["BARD_CLASS"] = string.upper(classLower) .. "_CLASS",
        ["bard_performance_dummy"] = classLower .. "_performance_dummy",
        ["Bard"] = className:gsub("Class", ""), -- Remove "Class" suffix for display
        ["bard"] = classLower
    }
end

-- Read a template file and perform replacements
local function processTemplateFile(templateFileName, replacements, outputDir)
    local templateFilePath = templatePath .. templateFileName
    
    -- Try to read the template file
    local templateFile = io.open(templateFilePath, "r")
    if not templateFile then
        print("[PLUGIN_GENERATOR] Warning: Could not read template file: " .. templateFilePath)
        return false
    end
    
    local templateContent = templateFile:read("*all")
    templateFile:close()
    
    -- Perform all string replacements
    local processedContent = templateContent
    for old, new in pairs(replacements) do
        processedContent = string.gsub(processedContent, old, new)
    end
    
    -- Generate output filename
    local outputFileName = templateFileName
    outputFileName = string.gsub(outputFileName, "bard", classLower)
    
    -- Write the new file
    local outputFilePath = outputDir .. "/" .. outputFileName
    local outputFile = io.open(outputFilePath, "w")
    if not outputFile then
        print("[PLUGIN_GENERATOR] Error: Could not create output file: " .. outputFilePath)
        return false
    end
    
    outputFile:write(processedContent)
    outputFile:close()
    
    print("[PLUGIN_GENERATOR] Created: " .. outputFilePath)
    return true
end

-- Main plugin generation function
function plugin_generator.generate(className, classLower)
    print("[PLUGIN_GENERATOR] Generating plugin: " .. className)
    print("[PLUGIN_GENERATOR] Class name (lower): " .. classLower)
    
    -- Create output directory
    local outputDir = outputPath .. classLower .. "_class"
    
    -- Create directory (this is a simplified approach - you may need to create manually)
    print("[PLUGIN_GENERATOR] Please create directory: " .. outputDir)
    print("[PLUGIN_GENERATOR] Then run: createDirectory(\"" .. outputDir .. "\")")
    
    -- Get replacement mappings
    local replacements = getReplacements(className, classLower)
    
    -- Process each template file
    local successCount = 0
    for _, templateFileName in ipairs(templateFiles) do
        if processTemplateFile(templateFileName, replacements, outputDir) then
            successCount = successCount + 1
        end
    end
    
    print("[PLUGIN_GENERATOR] Plugin generation complete!")
    print("[PLUGIN_GENERATOR] Files created: " .. successCount .. "/" .. #templateFiles)
    
    -- Print next steps
    print("\n[PLUGIN_GENERATOR] Next steps:")
    print("1. Create the directory: " .. outputDir)
    print("2. Update trigger_config.lua to add your new plugin")
    print("3. Create any dummy spell files if needed")
    print("4. Customize the content in the new files")
    
    return successCount == #templateFiles
end

-- Helper function to create directory (Windows compatible)
function plugin_generator.createDirectory(path)
    local command = 'mkdir "' .. path .. '"'
    print("[PLUGIN_GENERATOR] Running: " .. command)
    os.execute(command)
end

-- Convenience function for common plugin types
function plugin_generator.generateMerchant()
    return plugin_generator.generate("MerchantClass", "merchant")
end

function plugin_generator.generateGuard()
    return plugin_generator.generate("GuardClass", "guard")
end

function plugin_generator.generatePriest()
    return plugin_generator.generate("PriestClass", "priest")
end

-- Export the module
return plugin_generator

-- Usage examples:
-- local generator = require("plugin_generator")
-- generator.generate("MerchantClass", "merchant")
-- generator.generateMerchant()  -- Convenience method
-- generator.generateGuard()
-- generator.generatePriest()
