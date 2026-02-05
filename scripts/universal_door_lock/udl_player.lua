-- Universal Door Lock System - Player Script (Refined)
-- Cell scanning and event communication for exterior door locking

local core = require("openmw.core")
local nearby = require("openmw.nearby")
local self = require("openmw.self")
local time = require("openmw_aux.time")
local I = require("openmw.interfaces")

local MOD_ID = "UniversalDoorLock"
local CELL_SCAN_INTERVAL = 0.5

-- State tracking
local currentCell = ""
local scannedCells = {}
local lastScanTime = 0

-- Cell whitelist for exterior cells with doors
local cellWhitelist = {}

-- Helper functions
local function msg(message)
    print("[" .. MOD_ID .. " Player] " .. message)
end

local function getCellName()
    if self.cell.name == "" then
        return string.format("Exterior %d,%d", self.cell.gridX, self.cell.gridY)
    else
        return self.cell.name
    end
end

-- Main cell scanner - only scans exterior cells
local function cellScanner()
    local gameTime = core.getGameTime()
    
    -- Throttle scanning
    if gameTime - lastScanTime < 0.5 then return end
    lastScanTime = gameTime
    
    -- Only scan exterior cells
    if not (self.cell.isExterior or self.cell:hasTag("QuasiExterior")) then return end
    
    local cellName = getCellName()
    
    -- Auto-whitelist cells with doors
    if not cellWhitelist[string.lower(cellName)] then
        if #nearby.doors > 0 then
            cellWhitelist[string.lower(cellName)] = true
            msg("Auto-whitelisted cell: " .. cellName .. " (" .. #nearby.doors .. " doors)")
        else
            return
        end
    end
    
    -- Check if we've entered a new cell
    if cellName ~= currentCell then
        currentCell = cellName
        
        -- Send door data to global script
        core.sendGlobalEvent("UDL_receiveLocalDoors", {
            cellName = cellName,
            doors = nearby.doors,
            gameTime = gameTime,
            player = self
        })
        
        msg("Scanning cell: " .. cellName .. " (" .. #nearby.doors .. " doors)")
    end
end

-- Event handlers
local function timeUpdate(data)
    -- Receive time updates from global script
    msg("Time update: " .. data.currentHour .. ":00 (Nighttime: " .. tostring(data.nighttime) .. ")")
end

local function requestLocalDoors(data)
    -- Manual door scan request
    core.sendGlobalEvent("UDL_receiveLocalDoors", {
        cellName = getCellName(),
        doors = nearby.doors,
        gameTime = core.getGameTime(),
        player = self
    })
end

-- Save/Load system
local function onSave()
    return {
        currentCell = currentCell,
        scannedCells = scannedCells,
        cellWhitelist = cellWhitelist
    }
end

local function onLoad(data)
    if data then
        currentCell = data.currentCell or ""
        scannedCells = data.scannedCells or {}
        cellWhitelist = data.cellWhitelist or {}
        msg("Loaded player state")
    end
end

-- Settings page
I.Settings.registerPage {
    key = MOD_ID,
    l10n = MOD_ID,
    name = "Universal Door Lock",
    description = "Exterior door locking system"
}

-- Start the cell scanner
time.runRepeatedly(
    cellScanner, 
    CELL_SCAN_INTERVAL,
    {initialDelay = 1, type = time.SimulationTime}
)

msg("Universal Door Lock player script loaded (Exterior Only)")

-- Console interface for door lock control
local consoleInterface = {
    -- Toggle the door lock system
    toggle = function()
        core.sendGlobalEvent("UDL_toggleSystem", nil)
        return "Toggling Universal Door Lock system..."
    end,
    
    -- Enable the door lock system
    enable = function()
        core.sendGlobalEvent("UDL_toggleSystem", true)
        return "Enabling Universal Door Lock system..."
    end,
    
    -- Disable the door lock system
    disable = function()
        core.sendGlobalEvent("UDL_toggleSystem", false)
        return "Disabling Universal Door Lock system..."
    end,
    
    -- Reload settings
    reload = function()
        core.sendGlobalEvent("UDL_reloadSettings", {})
        return "Reloading Universal Door Lock settings..."
    end,
    
    -- Show current status
    status = function()
        return "Universal Door Lock console interface ready. Commands: toggle, enable, disable, reload, status, debug"
    end,
    
    -- Debug current settings
    debug = function()
        core.sendGlobalEvent("UDL_debugSettings", {})
        return "Requesting current settings debug info..."
    end
}

return {
    interfaceName = "UniversalDoorLock",
    interface = consoleInterface,
    engineHandlers = {
        onLoad = onLoad,
        onSave = onSave
    },
    eventHandlers = {
        UDL_timeUpdate = timeUpdate,
        UDL_requestLocalDoors = requestLocalDoors
    }
}
