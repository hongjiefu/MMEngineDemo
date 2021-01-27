
require("Asset.Scripts.native.init")
local GameMainScene = require("Asset.Scripts.BaseballScene")
package.loaded["Asset.Scripts.BaseballGlobal"]  = nil


function ONLINE_LOG(log)
    print(tostring(os.time()) ..  "  LOG:  " .. tostring(log))
end


local App = {}


function App.onStart()
    ONLINE_LOG("onStart")
    if App.mainScene then
        return
    end

    local scene = GameMainScene:new("com.wemomo.engine")
    App.mainScene = scene
    xe.Director:GetInstance():PushScene(scene)


    scene:SetGameOverCallBack(function(score)

        ONLINE_LOG("Romve Self.")

        
        local ret = {
            score = score
        }

        xe.ScriptBridge:call("GameHandler", "onGameOver", xjson.encode(ret))

        -- if xe.Director:GetInstance():GetTopScene() == App.mainScene then
        --     ONLINE_LOG("PopScene")
        --     App.mainScene = nil
        --     xe.Director:GetInstance():PopScene()
        -- end
        -- NativeHandler:removeGame(tostring(score))
    end)
end

function App.onResume()
    ONLINE_LOG("onResume")
end

function App.onPause()
    ONLINE_LOG("onPause")
end

function App.onEnd()
    ONLINE_LOG("onEnd")
end


xe.AppDeleggate = App
