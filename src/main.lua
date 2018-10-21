
function __G__TRACKBACK__(errorMessage)
    print("----------------------------------------")
    print("LUA ERROR: " .. tostring(errorMessage) .. "\n")
    print(debug.traceback("", 2))
    print("----------------------------------------")

    --!! 1、错误信息可以发送给服务器，目前没有

    -- 2、错误信息显示在游戏内，这个仅在开发过程中
    require("module.ui.error_panel").new(tostring(errorMessage), debug.traceback("", 2))
end

package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("res/ccz/ui/") -- 坑爹，cocos studio中引用了其他csd，则需要将其引用的csd放入res根目录下，否则则需要添加搜索路径
require("app.MyApp").new():run()
