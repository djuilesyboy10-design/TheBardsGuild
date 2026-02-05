-- Universal Door Lock System - Global Script (Refined)
-- Exterior-only door locking system based on proven go-home pattern
-- Locks houses, shops, residences at night - keeps taverns, guilds, temples open

local core = require("openmw.core")
local time = require("openmw_aux.time")
local types = require("openmw.types")
local world = require("openmw.world")
local storage = require("openmw.storage")
local I = require("openmw.interfaces")

local MOD_ID = "UniversalDoorLock"
local UPDATE_INTERVAL = 1

-- State management
local cellDoorCount = {}
local seenDoors = {}

-- User settings
local settings = storage.globalSection("Settings" .. MOD_ID)

-- Time settings
local hourAM = settings:get("hourAM") or 6
local hourPM = settings:get("hourPM") or 20
local enableSystem = settings:get("enableSystem") ~= false -- Default true

-- Settings monitoring
local lastSettingsCheck = 0
local SETTINGS_CHECK_INTERVAL = 2.0 -- Check every 2 seconds

-- Helper functions
local function msg(message)
    print("[" .. MOD_ID .. "] " .. message)
end

local function getCurrentHour()
    return (core.getGameTime() / 3600) % 24
end

local function isNighttime(hour)
    if not enableSystem then return false end -- System disabled
    return hour < hourAM or hour >= hourPM
end

local function isExteriorDoor(door)
    -- Only process exterior doors
    local player = world.players[1]
    if not player then return false end
    
    -- Check if door is in exterior cell
    if not (door.cell.isExterior or door.cell:hasTag("QuasiExterior")) then
        return false
    end
    
    -- Check if player is close enough
    if (player.position - door.position):length() > 1000 then
        return false
    end
    
    return true
end

local function shouldLockDoor(door, currentHour)
    if not enableSystem then return false end -- System disabled
    if not isNighttime(currentHour) then return false end
    if types.Door.isLocked(door) then return false end
    
    local doorId = door.id:lower()
    local recordId = door.recordId:lower()
    local cellName = door.cell.name:lower()
    
    -- Debug: Show what we're checking
    msg("Checking door - RecordID: " .. recordId .. ", Cell: " .. cellName)
    
    -- Lock houses and residences
    if recordId:find("'s house") or recordId:find("'s home") or 
       recordId:find("house") or recordId:find("dwelling") or
       recordId:find("shack") or recordId:find("cabin") or
       cellName:find("'s house") or cellName:find("'s home") or
       cellName:find("shack") or cellName:find("cabin") then
        msg("House pattern matched: " .. recordId)
        return true
    end
    
    -- Lock shops and stores
    if recordId:find("'s shop") or recordId:find("'s store") or
       recordId:find("shop") or recordId:find("store") or
       recordId:find("trader") or
       cellName:find("'s shop") or cellName:find("'s store") or
       cellName:find("trader") then
        msg("Shop pattern matched: " .. recordId)
        return true
    end
    
    -- Lock residential buildings
    if recordId:find("residence") or recordId:find("apartment") or
       cellName:find("residence") or cellName:find("apartment") then
        msg("Residence pattern matched: " .. recordId)
        return true
    end
    
    -- Lock specific Morrowind doors by record ID patterns
    if recordId:find("in_door_") or recordId:find("ex_door_") or
       recordId:find("door_") or recordId:find("gate") then
        -- Check if it's in a residential/commercial cell
        if cellName:find("seyda neen") or cellName:find("balmora") or 
           cellName:find("ald'ruhn") or cellName:find("vivec") then
            msg("Generic door pattern matched: " .. recordId)
            return true
        end
    end
    
    -- NEVER lock these (always open)
    if recordId:find("tavern") or recordId:find("inn") or
       recordId:find("guild") or recordId:find("temple") or
       recordId:find("palace") or recordId:find("public") or
       recordId:find("fort") or recordId:find("barracks") or
       recordId:find("tradehouse") or recordId:find("trade") or
       cellName:find("tavern") or cellName:find("inn") or
       cellName:find("guild") or cellName:find("temple") or
       cellName:find("palace") or cellName:find("fort") then
        msg("Excluded door pattern matched: " .. recordId)
        return false
    end
    
    msg("No pattern matched for: " .. recordId)
    return false
end

local function shouldUnlockDoor(door, currentHour)
    if not enableSystem then return false end -- System disabled
    if isNighttime(currentHour) then return false end
    if not types.Door.isLocked(door) then return false end
    
    -- Unlock doors that we locked - match all lock patterns
    local doorId = door.id:lower()
    local recordId = door.recordId:lower()
    local cellName = door.cell.name:lower()
    
    -- Unlock houses and residences
    if recordId:find("'s house") or recordId:find("'s home") or 
       recordId:find("house") or recordId:find("dwelling") or
       recordId:find("shack") or recordId:find("cabin") or
       cellName:find("'s house") or cellName:find("'s home") or
       cellName:find("shack") or cellName:find("cabin") then
        return true
    end
    
    -- Unlock shops and stores
    if recordId:find("'s shop") or recordId:find("'s store") or
       recordId:find("shop") or recordId:find("store") or
       recordId:find("trader") or
       cellName:find("'s shop") or cellName:find("'s store") or
       cellName:find("trader") then
        return true
    end
    
    -- Unlock residential buildings
    if recordId:find("residence") or recordId:find("apartment") or
       cellName:find("residence") or cellName:find("apartment") then
        return true
    end
    
    -- Unlock generic Morrowind doors
    if recordId:find("in_door_") or recordId:find("ex_door_") or
       recordId:find("door_") or recordId:find("gate") then
        -- Check if it's in a residential/commercial cell
        if cellName:find("seyda neen") or cellName:find("balmora") or 
           cellName:find("ald'ruhn") or cellName:find("vivec") then
            return true
        end
    end
    
    return false
end

local function lockDoor(door)
    local lockLevel = 30 -- Standard lock level
    door.type.lock(door, lockLevel)
    seenDoors[door.id] = {locked = true, time = core.getGameTime()}
    
    msg("Locked door: " .. door.recordId .. " in " .. door.cell.name)
    return true
end

local function unlockDoor(door)
    door.type.unlock(door)
    seenDoors[door.id] = {locked = false, time = core.getGameTime()}
    
    msg("Unlocked door: " .. door.recordId .. " in " .. door.cell.name)
    return true
end

-- Core door processing
local function processDoors(doors, gameTime)
    local currentHour = getCurrentHour()
    local doorsProcessed = 0
    local doorsModified = 0
    
    for _, door in ipairs(doors) do
        if isExteriorDoor(door) then
            doorsProcessed = doorsProcessed + 1
            
            -- Debug: Log door info
            msg("Processing door: " .. door.id .. " in " .. door.cell.name .. " (Hour: " .. currentHour .. ")")
            
            -- Check if door should be excluded (never locked) - unlock if previously locked
            local doorId = door.id:lower()
            local recordId = door.recordId:lower()
            local cellName = door.cell.name:lower()
            
            if recordId:find("tavern") or recordId:find("inn") or
               recordId:find("guild") or recordId:find("temple") or
               recordId:find("palace") or recordId:find("public") or
               recordId:find("fort") or recordId:find("barracks") or
               recordId:find("tradehouse") or recordId:find("trade") or
               cellName:find("tavern") or cellName:find("inn") or
               cellName:find("guild") or cellName:find("temple") or
               cellName:find("palace") or cellName:find("fort") then
                -- Unlock excluded doors if they were previously locked
                if types.Door.isLocked(door) then
                    msg("Unlocking excluded door: " .. door.recordId)
                    if unlockDoor(door) then
                        doorsModified = doorsModified + 1
                    end
                end
            elseif shouldLockDoor(door, currentHour) then
                if lockDoor(door) then
                    doorsModified = doorsModified + 1
                end
            elseif shouldUnlockDoor(door, currentHour) then
                if unlockDoor(door) then
                    doorsModified = doorsModified + 1
                end
            else
                msg("Door not eligible: " .. door.id .. " (Already locked: " .. tostring(types.Door.isLocked(door)) .. ")")
            end
        end
    end
    
    if doorsModified > 0 then
        msg("Processed " .. doorsProcessed .. " doors, modified " .. doorsModified .. " (Hour: " .. currentHour .. ")")
    else
        msg("Processed " .. doorsProcessed .. " doors, no changes made (Hour: " .. currentHour .. ")")
    end
    
    return doorsModified
end

-- Event handlers
local function onObjectActive(obj)
    if not enableSystem then return end -- System disabled
    -- Process doors when player gets near them
    if obj.type == types.Door and isExteriorDoor(obj) then
        processDoors({obj}, core.getGameTime())
    end
end

local function cellChanged(data)
    if not data.doors then return end
    
    local gameTime = data.gameTime or core.getGameTime()
    local currentHour = getCurrentHour()
    
    -- Send time info to player script
    local player = world.players[1]
    if player then
        player:sendEvent("UDL_timeUpdate", {
            gameTime = gameTime,
            currentHour = currentHour,
            nighttime = isNighttime(currentHour)
        })
    end
    
    -- Process doors in this cell
    processDoors(data.doors, gameTime)
    
    -- Track door count for this cell
    if not cellDoorCount[data.cellName] then
        cellDoorCount[data.cellName] = #data.doors
        msg("Counted " .. cellDoorCount[data.cellName] .. " doors for cell: " .. data.cellName)
    end
end

local function receiveLocalDoors(data)
    cellChanged(data)
end

-- Activator integration
local function scheduleResponse(data)
    -- Schedule the response after a delay
    local delay = math.random(1.0, 3.0) -- Random delay between 1-3 seconds
    
    time.runRepeatedly(
        function()
            local player = world.players[1]
            if player and (player.position - data.door.position):length() <= 200 then
                ui.showMessage(data.message)
                
                -- Try to unlock the door
                if data.unlockChance > 0 then
                    local chance = math.random()
                    if chance <= data.unlockChance then
                        door.type.unlock(data.door)
                        ui.showMessage("The door unlocks! Someone must have answered.")
                        msg("Successfully unlocked door: " .. data.door.recordId)
                        
                        -- Notify activator
                        core.sendGlobalEvent("UDL_doorUnlocked", {
                            door = data.door,
                            method = "knock-knock",
                            doorType = data.doorType
                        })
                    end
                end
            end
        end,
        1,
        {initialDelay = delay, type = time.SimulationTime}
    )
end

local function doorUnlocked(data)
    -- Called when door is unlocked by knock-knock
    msg("Door unlocked via knock-knock: " .. data.door.recordId .. " (" .. data.doorType .. ")")
end

-- Time-based update system
local currentDayNight = nil
local function update()
    -- Check for settings changes first
    checkSettingsChanges()
    
    if not enableSystem then return end -- System disabled
    
    local player = world.players[1]
    if not (player.cell.isExterior or player.cell:hasTag("QuasiExterior")) then return end
    
    local currentHour = getCurrentHour()
    local nighttime = isNighttime(currentHour)
    local current = nighttime and "night" or "day"
    
    -- Only trigger on day/night change
    if currentDayNight ~= current then
        currentDayNight = current
        msg("Day/night change detected - currently: " .. current)
        
        player:sendEvent("UDL_requestLocalDoors", {
            gameTime = core.getGameTime(),
            nighttime = nighttime
        })
    end
end

-- Settings monitoring function
local function checkSettingsChanges()
    local currentTime = core.getGameTime()
    if currentTime - lastSettingsCheck < SETTINGS_CHECK_INTERVAL then return end
    lastSettingsCheck = currentTime
    
    local newHourAM = settings:get("hourAM") or 6
    local newHourPM = settings:get("hourPM") or 20
    local newEnableSystem = settings:get("enableSystem") ~= false
    
    -- Check if any settings changed
    if newHourAM ~= hourAM or newHourPM ~= hourPM or newEnableSystem ~= enableSystem then
        local oldState = enableSystem and "ENABLED" or "DISABLED"
        local newState = newEnableSystem and "ENABLED" or "DISABLED"
        
        hourAM = newHourAM
        hourPM = newHourPM
        enableSystem = newEnableSystem
        
        msg("Settings changed - System " .. newState .. " (Lock: " .. hourPM .. ":00, Unlock: " .. hourAM .. ":00)")
        
        -- If system was disabled, unlock all doors
        if not enableSystem and oldState == "ENABLED" then
            msg("System disabled - Unlocking all locked doors")
            for doorId, doorData in pairs(seenDoors) do
                if doorData.locked then
                    local door = world.getObjectByFormId(doorId)
                    if door and types.Door.isLocked(door) then
                        unlockDoor(door)
                    end
                end
            end
        end
    end
end

-- Settings reload function
local function reloadSettings()
    hourAM = settings:get("hourAM") or 6
    hourPM = settings:get("hourPM") or 20
    enableSystem = settings:get("enableSystem") ~= false
    
    msg("Settings reloaded - System " .. (enableSystem and "ENABLED" or "DISABLED") .. 
        " (Lock: " .. hourPM .. ":00, Unlock: " .. hourAM .. ":00)")
end

-- Turn system on/off function
local function toggleSystem(enabled)
    if enabled == nil then
        -- Toggle current state
        enabled = not enableSystem
    end
    
    settings:set("enableSystem", enabled)
    reloadSettings()
    
    -- Force door state update when enabling/disabling
    if enabled then
        msg("Door lock system ENABLED - Checking all nearby doors")
        local player = world.players[1]
        if player and (player.cell.isExterior or player.cell:hasTag("QuasiExterior")) then
            update()
        end
    else
        msg("Door lock system DISABLED - Unlocking all locked doors")
        -- Unlock all doors we've locked
        for doorId, doorData in pairs(seenDoors) do
            if doorData.locked then
                local door = world.getObjectByFormId(doorId)
                if door and types.Door.isLocked(door) then
                    unlockDoor(door)
                end
            end
        end
    end
    
    return enabled
end

-- Save/Load system
local function onSave()
    return {
        cellDoorCount = cellDoorCount,
        seenDoors = seenDoors,
        enableSystem = enableSystem,
        hourAM = hourAM,
        hourPM = hourPM
    }
end

local function onLoad(data)
    if data then
        cellDoorCount = data.cellDoorCount or {}
        seenDoors = data.seenDoors or {}
        enableSystem = data.enableSystem ~= false
        hourAM = data.hourAM or 6
        hourPM = data.hourPM or 20
        msg("Loaded door lock state - System " .. (enableSystem and "ENABLED" or "DISABLED"))
    end
end

-- Settings integration
I.Settings.registerGroup {
    key = "Settings" .. MOD_ID,
    page = MOD_ID,
    l10n = MOD_ID,
    name = "Universal Door Lock",
    description = "Exterior door locking system",
    permanentStorage = false,
    settings = {
        {
            key = "hourAM",
            name = "Morning Hour",
            description = "Hour when doors unlock (6 AM)",
            default = 6,
            min = 1,
            max = 12,
            renderer = "number"
        },
        {
            key = "hourPM", 
            name = "Evening Hour", 
            description = "Hour when doors lock (8 PM)",
            default = 20,
            min = 13,
            max = 23,
            renderer = "number"
        },
        {
            key = "enableSystem",
            name = "Enable Door Locking",
            description = "Enable automatic door locking system",
            default = true,
            renderer = "checkbox"
        }
    }
}

-- Start time-based checking
time.runRepeatedly(update, UPDATE_INTERVAL, {
    initialDelay = 1 * time.second,
    type = time.SimulationTime
})

msg("Universal Door Lock system loaded (Exterior Only)")

return {
    engineHandlers = {
        onObjectActive = onObjectActive,
        onSave = onSave,
        onLoad = onLoad
    },
    eventHandlers = {
        UDL_cellChanged = cellChanged,
        UDL_receiveLocalDoors = receiveLocalDoors,
        UDL_scheduleResponse = scheduleResponse,
        UDL_doorUnlocked = doorUnlocked,
        UDL_reloadSettings = reloadSettings,
        UDL_toggleSystem = toggleSystem
    }
}
