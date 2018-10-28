package.path = package.path .. ";src/"
cc.FileUtils:getInstance():setPopupNotify(false)
cc.FileUtils:getInstance():addSearchPath("res/ccz/ui/") -- 坑爹，cocos studio中引用了其他csd，则需要将其引用的csd放入res根目录下，否则则需要添加搜索路径

local breakSocketHandle,debugXpCall = require("luaIde.LuaDebugjit")("localhost",7003)

cc.Director:getInstance():getScheduler():scheduleScriptFunc(breakSocketHandle, 0.3, false) 

function __G__TRACKBACK__(errorMessage)
    printError(tostring(errorMessage) .. "\n")
    debugXpCall();  
end

local main = function()
    require("app.MyApp").new():run()    
end

local status, msg = xpcall(main, __G__TRACKBACK__)

if not status then
    print(msg)
end