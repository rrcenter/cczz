
require("config")
require("cocos.init")
require("framework.init")
require("module.init")

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
