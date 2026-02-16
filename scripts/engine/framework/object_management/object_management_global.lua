local world = require('openmw.world')
local util = require('openmw.util')
local config = require('scripts.engine.framework.object_management.object_management_config')

-- Core object manipulation function
local function removeObject(object)
    print("[ObjectManagement] Removing object: " .. object.recordId)
    object:remove()
end

-- Object state management - support disable and enable
local function updateObjectGroup(groupName)
    local group = config[groupName]
    if not group then return end

    print("[ObjectManagement] Processing group: " .. groupName)
    for _, objectData in pairs(group.objects) do
        print("[ObjectManagement] Processing object: " .. objectData.recordId .. " in cell: " .. tostring(objectData.cell))
        if objectData.conditions.type == "disable" then
            if objectData.cell then
                local cell = world.getCellByName(objectData.cell)
                if cell then
                    print("[ObjectManagement] Found cell: " .. objectData.cell .. ", searching for objects...")
                    local foundObjects = 0
                    for _, object in ipairs(cell:getAll()) do
                        if object:isValid() and object.recordId == objectData.recordId then
                            foundObjects = foundObjects + 1
                            removeObject(object)
                        end
                    end
                    print("[ObjectManagement] Found and removed " .. foundObjects .. " objects")
                else
                    print("[ObjectManagement] ERROR: Could not find cell: " .. objectData.cell)
                end
            end
        elseif objectData.conditions.type == "enable" then
            if objectData.cell and objectData.position then
                local cell = world.getCellByName(objectData.cell)
                if cell then
                    print("[ObjectManagement] Manifesting object: " .. objectData.recordId .. " in " .. objectData.cell)
                    local pos = util.vector3(objectData.position.x, objectData.position.y, objectData.position.z)
                    local rot = util.eulerVector(util.vector3(objectData.rotation.x or 0, objectData.rotation.y or 0, objectData.rotation.z or 0))
                    world.createObject(objectData.recordId):spawn{cell = cell, position = pos, rotation = rot}
                end
            end
        end
    end
end

-- Event handlers
local eventHandlers = {
    JMCG_QuestStageChanged = function(data)
        local questId = data.questId:lower()
        local stage = data.stage
        print("[ObjectManagement] Quest changed: " .. questId .. " stage " .. tostring(stage))

        for groupName, groupData in pairs(config) do
            if groupData.questId:lower() == questId and groupData.stage == stage then
                updateObjectGroup(groupName)
            end
        end
    end,
    
    ObjectManagement_UpdateGroup = function(data)
        if data.groupName and config[data.groupName] then
            updateObjectGroup(data.groupName)
        end
    end
}

-- Initial setup
local function initializeObjects()
    print("[ObjectManagement] Initializing object management system...")
    print("[ObjectManagement] Initialization complete")
end

return {
    engineHandlers = {
        onInit = initializeObjects
    },
    eventHandlers = eventHandlers
}
