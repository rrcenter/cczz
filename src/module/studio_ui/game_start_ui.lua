--[[
    游戏启动界面
--]]

local LoadingUI = import(".loading_ui")

local GameStartUI = class("GameStartUI", function()
    return display.newLayer()
end)

GameStartUI.ctor = function(self)
    self:initUI()
    self:initTouchEvent()
end

GameStartUI.initUI = function(self)
    self.uiNode = cc.uiloader:load("ccz/ui/GameStartUI.csb")
    self.uiNode:addTo(self)

    self.rootNode    = UIHelper.seekNodeByName(self.uiNode, "Root")
    self.startButton = UIHelper.seekNodeByName(self.uiNode, "StartButton")
    self.loadButton  = UIHelper.seekNodeByName(self.uiNode, "LoadButton")

    self.rootNode:align(display.CENTER, display.cx, display.cy)
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
        loadingUI:addTo(self)
    end)
end

GameStartUI.enterGame = function(self)
    printInfo("正在切换场景，进入MainScene")
    local newScene = require("app.scenes.MainScene").new()
    display.replaceScene(newScene)
end

return GameStartUI