# PowerShell script to fix Bard's Ring UI to use event-driven system
$file = "scripts\jmcg_influence\bard_ring_ui.lua"
$backup = $file + ".backup"

# Create backup
Copy-Item $file $backup

# Read the file
$content = Get-Content $file

# Replace the return block with event-driven version
$newContent = @"
return {
    eventHandlers = {
        JMCG_BardInfluence_Update = function(value)
            print("[BARD_RING_UI] Received influence update: " .. value .. "%")
            if value ~= lastValue then
                draw(value)
                lastValue = value
                print("[BARD_RING_UI] Updated UI display")
            else
                print("[BARD_RING_UI] Value unchanged, skipping update")
            end
        end
    },
    engineHandlers = {
        onLoad = function()
            -- Initialize with current value on load
            if I.JMCG_BardInfluence then
                local currentValue = I.JMCG_BardInfluence.getCurrent() or 0
                print("[BARD_RING_UI] Initializing with current value: " .. currentValue .. "%")
                draw(currentValue)
                lastValue = currentValue
            end
        end
    }
}
"@

# Replace the old return block
$content = $content -replace 'return \{[\s\S]*?\}', $newContent

# Write the file
$content | Set-Content $file

Write-Host "Bard's Ring UI updated to use event-driven system"
Write-Host "Backup created: $backup"
