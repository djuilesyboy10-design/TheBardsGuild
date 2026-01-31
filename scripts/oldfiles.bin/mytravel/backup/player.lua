return {
    eventHandlers = {
        MyTravel_ShowMenuUI = function()
            -- Just calls the helper, no interface checks to crash on
            require("scripts.mytravel.ui_helper").show()
        end
    }
}

