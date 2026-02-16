local I = require('openmw.interfaces')

return {
    interfaceName = "ObjectManagement",
    interface = {
        version = 1,
        
        -- Register managed objects
        registerObjects = function(objectGroup, objects)
            -- objects = {
            --     { recordId = "my_static", pos = {x,y,z}, cell = "cell_id", conditions = {...} }
            -- }
        end,
        
        -- Enable/disable object groups
        enableGroup = function(groupName, enable)
            -- Enable or disable entire group
        end,
        
        -- Check if objects are enabled
        isGroupEnabled = function(groupName)
            -- Returns boolean
        end,
        
        -- Get object state
        getObjectState = function(objectId)
            -- Returns "enabled", "disabled", or "replaced"
        end,
        
        -- Replace objects with different records
        replaceObjects = function(groupName, newRecordId)
            -- Replace all objects in group with new record
        end
    }
}
