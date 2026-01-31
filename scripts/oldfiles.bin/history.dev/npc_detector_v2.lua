---@diagnostic disable: undefined-global
local nearby = require("openmw.nearby")
local self = require("openmw.self")

-- Simple NPC Detection Utility
-- Console: require('scripts.Lua.Utility.npc_detector_v2').scan()

local function scan()
    print("[NPC Scan] Checking nearby NPCs...")
    
    local suspicious = {}
    local radius = 2000
    
    for _, npc in ipairs(nearby.npcs) do
        local distance = (npc.position - self.position):length()
        if distance <= radius then
            local npcId = string.lower(npc.id or "")
            local npcName = string.lower(npc.recordId or "")
            
            -- Look for child/generation patterns
            if string.find(npcId, "child") or 
               string.find(npcId, "gen") or 
               string.find(npcId, "generation") or
               string.find(npcName, "child") or
               string.find(npcName, "generation") then
               
                table.insert(suspicious, {
                    id = npc.id,
                    name = npc.recordId or "Unknown",
                    cell = npc.cell and npc.cell.name or "Unknown",
                    distance = math.floor(distance)
                })
            end
        end
    end
    
    print(string.format("[NPC Scan] Found %d suspicious NPCs:", #suspicious))
    for i, npc in ipairs(suspicious) do
        print(string.format("%d. ID: %s | Name: %s | Cell: %s | Dist: %d", 
            i, npc.id, npc.name, npc.cell, npc.distance))
    end
    
    return suspicious
end

local function disable()
    local targets = scan()
    print("[NPC Scan] Attempting to disable...")
    
    for _, target in ipairs(targets) do
        for _, npc in ipairs(nearby.npcs) do
            if npc.id == target.id then
                npc:setEnabled(false)
                print(string.format("[NPC Scan] Disabled: %s", target.id))
                break
            end
        end
    end
end

return {
    scan = scan,
    disable = disable
}
