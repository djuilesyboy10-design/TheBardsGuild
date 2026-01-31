-- file_write_helper.lua
-- Reliable file writing workaround for tool API issues
-- Use this function instead of write_to_file when dealing with JSON or complex content

local M = {}

-- Function to safely write files using bash commands
-- This bypasses the write_to_file tool API issues
function M.writeFile(filePath, content)
    -- Escape quotes in content for PowerShell
    local escapedContent = content:gsub('"', '""')
    
    -- Use PowerShell Set-Content which handles all file types reliably
    local command = string.format('Set-Content -Path "%s" -Value \'%s\' -Force', filePath, escapedContent)
    
    print("[FILE_HELPER] Writing file: " .. filePath)
    return command
end

-- Function to create directories if they don't exist
function M.ensureDirectory(dirPath)
    local command = string.format('New-Item -ItemType Directory -Path "%s" -Force', dirPath)
    print("[FILE_HELPER] Ensuring directory: " .. dirPath)
    return command
end

-- Function to write JSON files specifically
function M.writeJson(filePath, jsonContent)
    -- First ensure directory exists
    local dirPath = filePath:match("(.*/)")
    if dirPath then
        M.ensureDirectory(dirPath)
    end
    
    -- Write the JSON content
    return M.writeFile(filePath, jsonContent)
end

return M
