
require("config")
require("cocos.init")
require("framework.init")
require("module.init")

-- printInfo = function() end

-- 重定向print，将输出写入指定文件
if device.platform == "mac" then
    local debugLogPath = device.writablePath .. "debug.log"
    debugLogPath = "/Users/zwsatan/Desktop/csdncode/ccz/debug.log"
    os.execute("rm -f " .. debugLogPath)
    print = function(...)
        local params = {...}
        for i, v in ipairs(params) do
            if type(v) == "boolean" then
                params[i] = v and "true" or "false"
            end
        end
        io.writefile(debugLogPath, table.concat(params, " ") .. "\n", "a+")
    end
end

local MyApp = class("MyApp", cc.mvc.AppBase)

function MyApp:ctor()
    math.randomseed(os.time())
    math.random()
    math.random()
    math.random()
    math.random()

    MyApp.super.ctor(self)
end

function MyApp:run()
    cc.FileUtils:getInstance():addSearchPath("res/")
    self:enterScene("GameStartScene")
end

return MyApp
