--[[
    战斗条件界面
    目前战斗条件仅以下几种：
        1、击败指定武将
        2、达到或逃至指定地点
        3、坚持多少回合
        任何情况下，歼灭所有敌军，战斗即结束
    主要就是显示一个描述文本，如果战斗条件是1、2则高亮区域，也就是一个蓝色款，闪烁一下
--]]

local BattleConditionLayer = class("BattleConditionLayer", function()
    return display.newColorLayer(LayerLightBlackColor)
end)

BattleConditionLayer.ctor = function(self, winContent, maxRounds, callback)
    self:addTo(display.getRunningScene(), TOP_ZORDER)

    self:initUi(winContent, maxRounds)
    self:initWinConditionEvent(callback)
end

BattleConditionLayer.initUi = function(self, winContent, maxRounds)
    local x = display.width * 0.06
    local winTitleLabel = cc.ui.UILabel.new({text = "胜利条件", size = FontSuperSize, font = FontName})
    winTitleLabel:align(display.LEFT_TOP, x, display.height * 0.9)
    winTitleLabel:addTo(self)

    if device.platform ~= "windows" and device.platform ~= "mac" then
        winTitleLabel:enableOutline(FontRedColor, 2)
    else
        winTitleLabel:setColor(FontRedColor)
    end

    local winContentLabel = cc.ui.UILabel.new({text = winContent, size = FontSuperSize, font = FontName})
    winContentLabel:align(display.LEFT_TOP, x, display.height * 0.9 - FontSuperSize * 1.2)
    winContentLabel:addTo(self)

    local roundsLimitContent = string.format("回合数限制 %d", maxRounds)
    local roundsLimitLabel = cc.ui.UILabel.new({text = roundsLimitContent, size = FontSuperSize, font = FontName})
    roundsLimitLabel:align(display.LEFT_BOTTOM, x, display.height * 0.15)
    roundsLimitLabel:addTo(self)
end

BattleConditionLayer.initWinConditionEvent = function(self, callback)
    self:performWithDelay(function()
        self:removeSelf()
        callback()
    end, LONE_ALIVE_TIME)
end

return BattleConditionLayer