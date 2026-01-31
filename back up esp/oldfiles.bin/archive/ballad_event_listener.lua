return {
    eventHandlers = {
        Bard_JiubBallad_Event = function()
            print("[BARD][EVENT] Jiub Ballad event received")
            require("scripts.engine.ballad_helper").show()
        end
    }
}