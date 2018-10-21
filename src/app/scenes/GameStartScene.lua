--[[
    游戏启动Scene，主要就是初始化GameStartUI
--]]

local GameStartUI = require("module.studio_ui.game_start_ui")

local GameStartScene = class("GameStartScene", function()
    return display.newScene("GameStartScene")
end)

GameStartScene.ctor = function(self)
    GameStartUI.new():addTo(self)
end

GameStartScene.onExit = function(self)
    EventMgr.triggerEvent(EventConst.SCENE_EXIT)
end

return GameStartScene
