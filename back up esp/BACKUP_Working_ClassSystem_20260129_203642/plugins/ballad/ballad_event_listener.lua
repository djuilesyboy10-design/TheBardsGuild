return {
    eventHandlers = {
        Bard_JiubBallad_Event = function()
            -- Check if quest is already completed (simplified approach)
            -- For now, we'll rely on the fired flag in trigger config
            print("[BARD][EVENT] Jiub Ballad event received")
            require("scripts.engine.plugins.ballad.ballad_helper").show()
        end
    }
}
