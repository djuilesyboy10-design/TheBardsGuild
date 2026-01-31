-- GLOBAL SCRIPT (OpenMW 0.49 safe)
-- Debug probe: verifies BalladGate interface works

local I = require("openmw.interfaces")

return {
    engineHandlers = {
        onInit = function()
            local gate = I.BalladGate
            if not gate then
                print("[BARD][PROBE] BalladGate interface missing")
                return
            end

            local available = gate.isJiubBalladAvailable()
            print("[BARD][PROBE] Jiub Ballad available:", available)
        end
    }
}