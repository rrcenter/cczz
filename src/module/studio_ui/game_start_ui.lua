--[[
    游戏启动界面
--]]

local LoadingUI = import(".loading_ui")

local GameStartUI = class("GameStartUI", function()
    return cc.uiloader:load("ccz/ui/GameStartUI.csb")
end)

GameStartUI.ctor = function(self)
    self:initUI()
    self:initTouchEvent()
end

GameStartUI.initUI = function(self)
    self:pos(display.cx, display.cy)

    self.rootNode    = UIHelper.seekNodeByName(self, "Root")
    self.startButton = UIHelper.seekNodeByName(self, "StartButton")
    self.loadButton  = UIHelper.seekNodeByName(self, "LoadButton")
end

GameStartUI.initTouchEvent = function(self)
    UIHelper.buttonRegister(self.startButton, function()
        printInfo("游戏重新开始，初始化游戏起始数据")
        EventMgr.triggerEvent(EventConst.NEW_GAME)

        self:enterGame()
    end)

    UIHelper.buttonRegister(self.loadButton, function()
        printInfo("弹出载入进度界面")
        local loadingUI = LoadingUI.new()
        loadingUI:addTo(display.getRunningScene())
    end)
end

GameStartUI.enterGame = function(self)
    printInfo("正在切换场景，进入MainScene")
    local newScene = require("app.scenes.MainScene").new()
    display.replaceScene(newScene)
end

return GameStartUI