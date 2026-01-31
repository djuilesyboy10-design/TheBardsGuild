-- File comparison script
-- Compare two Lua files for exact structural differences

local function compareFiles(file1, file2)
    local f1 = io.open(file1, "r")
    local f2 = io.open(file2, "r")
    
    if not f1 then
        print("ERROR: Cannot open file: " .. file1)
        return false
    end
    
    if not f2 then
        print("ERROR: Cannot open file: " .. file2)
        return false
    end
    
    local content1 = f1:read("*all")
    local content2 = f2:read("*all")
    
    f1:close()
    f2:close()
    
    -- Normalize line endings and remove trailing whitespace
    content1 = content1:gsub("\r\n", "\n"):gsub("%s+$", "")
    content2 = content2:gsub("\r\n", "\n"):gsub("%s+$", "")
    
    if content1 == content2 then
        print("✅ Files are IDENTICAL")
        return true
    else
        print("❌ Files are DIFFERENT")
        
        -- Find first difference
        local lines1 = {}
        local lines2 = {}
        
        for line in content1:gmatch("[^\n]*") do
            table.insert(lines1, line)
        end
        
        for line in content2:gmatch("[^\n]*") do
            table.insert(lines2, line)
        end
        
        local maxLines = math.max(#lines1, #lines2)
        
        for i = 1, maxLines do
            local line1 = lines1[i] or ""
            local line2 = lines2[i] or ""
            
            if line1 ~= line2 then
                print(string.format("First difference at line %d:", i))
                print("File 1: " .. line1)
                print("File 2: " .. line2)
                break
            end
        end
        
        return false
    end
end

-- Compare merchant and publican helpers
local merchantFile = "scripts/engine/plugins/merchant_class/merchant_class_helper.lua"
local publicanFile = "scripts/engine/plugins/publican_class/publican_class_helper.lua"

print("🔍 Comparing Merchant and Publican helper files:")
print("Merchant: " .. merchantFile)
print("Publican: " .. publicanFile)
print("")

local result = compareFiles(merchantFile, publicanFile)

if result then
    print("🎉 Both files have identical structure!")
else
    print("⚠️  Files have structural differences")
end
