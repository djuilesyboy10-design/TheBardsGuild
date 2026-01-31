---@diagnostic disable: undefined-global
local nearby = require("openmw.nearby")
local self = require("openmw.self")

-- NPC Detection Utility
-- Use in console: require('scripts.Lua.Utility.npc_detector').scanNearbyNPCs()

local function scanNearbyNPCs()
    print("[NPC Detector] Scanning nearby NPCs...")
    
    local foundNPCs = {}
    local scanRadius = 1000 -- Scan within 1000 units
    
    for _, npc in ipairs(nearby.npcs) do
        local distance = (npc.position - self.position):length()
        if distance <= scanRadius then
            table.insert(foundNPCs, {
                id = npc.id,
                name = npc.recordId or "Unknown",
                cell = npc.cell.name or "Unknown",
                distance = math.floor(distance),
                position = npc.position,
                race = npc.race and npc.race or "Unknown",
                class = npc.class and npc.class or "Unknown"
            })
        end
    end
    
    -- Print results
    print(string.format("[NPC Detector] Found %d NPCs within %d units:", #foundNPCs, scanRadius))
    for i, npc in ipairs(foundNPCs) do
        print(string.format("%d. ID: %s | Name: %s | Cell: %s | Race: %s | Class: %s | Distance: %d", 
            i, npc.id, npc.name, npc.cell, npc.race, npc.class, npc.distance))
    end
    
    return foundNPCs
end

local function findChildNPCs()
    print("[NPC Detector] Looking for child/generation NPCs...")
    
    local suspiciousNPCs = {}
    
    for _, npc in ipairs(nearby.npcs) do
        local distance = (npc.position - self.position):length()
        if distance <= 2000 then -- Larger scan radius
            local npcId = string.lower(npc.id or "")
            local npcName = string.lower(npc.recordId or "")
            local npcRace = string.lower(npc.race or "")
            
            -- Look for suspicious patterns
            if string.find(npcId, "child") or 
               string.find(npcId, "gen") or 
               string.find(npcId, "generation") or
               string.find(npcName, "child") or
               string.find(npcName, "generation") or
               string.find(npcRace, "child") then
               
                table.insert(suspiciousNPCs, {
                    id = npc.id,
                    name = npc.recordId or "Unknown",
                    cell = npc.cell.name or "Unknown",
                    race = npc.race or "Unknown",
                    distance = math.floor(distance),
                    position = npc.position
                })
            end
        end
    end
    
    print(string.format("[NPC Detector] Found %d suspicious NPCs:", #suspiciousNPCs))
    for i, npc in ipairs(suspiciousNPCs) do
        print(string.format("%d. ID: %s | Name: %s | Cell: %s | Race: %s | Distance: %d", 
            i, npc.id, npc.name, npc.cell, npc.race, npc.distance))
    end
    
    return suspiciousNPCs
end

local function disableSuspiciousNPCs()
    local suspicious = findChildNPCs()
    
    print("[NPC Detector] Attempting to disable suspicious NPCs...")
    
    for _, npc in ipairs(suspicious) do
        -- Find the actual NPC object
        for _, nearbyNPC in ipairs(nearby.npcs) do
            if nearbyNPC.id == npc.id then
                -- Try to disable it
                nearbyNPC:setEnabled(false)
                print(string.format("[NPC Detector] Disabled: %s", npc.id))
                break
            end
        end
    end
end

return {
    scanNearbyNPCs = scanNearbyNPCs,
    findChildNPCs = findChildNPCs,
    disableSuspiciousNPCs = disableSuspiciousNPCs
}
