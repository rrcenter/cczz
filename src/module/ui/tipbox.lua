--[[
    提示框
        在屏幕中央显示一个提示信息
--]]

local AliveTime  = 0.4
local ZORDER     = 1000
local LastTipBox = nil

local TipBox = class("TipBox", function()
    return TouchLayer.new()
end)

TipBox.ctor = function(self, tip, color, callback)
    if LastTipBox then
        LastTipBox:setTouchSwallowEnabled(true)
        LastTipBox:removeSelf()
    end
    LastTipBox = self

    local label = display.newTTFLabel({text = tip, size = FontBigSize, font = FontName, color = color or FontLightBlueColor})
    label:align(display.CENTER, display.cx, display.cy)
    label:addTo(self, 2)

    local bgWidth  = label:getContentSize().width + MapConst.BLOCK_WIDTH
    local bgHeight = MapConst.BLOCK_HEIGHT
    if GameData.isRPlot() then
        if label:getContentSize().width > MapConst.BLOCK_WIDTH * 6 then
            label:setDimensions(MapConst.BLOCK_WIDTH * 5.5, MapConst.BLOCK_HEIGHT * 2.5)

            bgWidth  = MapConst.BLOCK_WIDTH * 6
            bgHeight = MapConst.BLOCK_HEIGHT * 3
        end
    end

    local bgTileSprite = display.newTilesSprite("ccz/dialog/tipbox-bg.png", cc.rect(0, 0, bgWidth, bgHeight))
    bgTileSprite:align(display.CENTER, display.cx, display.cy)
    bgTileSprite:addTo(self)

    self:setTouchSwallowEnabled(false)

    self.finalCallback = function()
        self:hide()

        if callback then
            callback()
        end
    end
end

TipBox.onTouch = function(self, event)
    self.finalCallback()
end

local TipUtils = {}

TipUtils.showTip = function(tip, color, callback)
    local tipBox = TipBox.new(tip, color, callback)
    tipBox:addTo(display.getRunningScene(), ZORDER)
    tipBox:performWithDelay(function()
        tipBox:hide()

        if callback then
            callback()
        end
    end, AliveTime)
end

TipUtils.showTips = function(tips, color, finalCallback)
    table.oneByOne(tips, function(tip, nextCallback)
        TipUtils.showTip(tip, color, nextCallback)
    end)
end

TipUtils.hide = function()
    if LastTipBox and LastTipBox:isVisible() then
        LastTipBox:hide()
    end
end

TipUtils.plotOver = function()
    if LastTipBox then
        LastTipBox = nil
    end
end

EventMgr.registerEvent(EventConst.PLOT_OVER, TipUtils.plotOver)
EventMgr.registerEvent(EventConst.SCENE_EXIT, TipUtils.plotOver)

return TipUtils