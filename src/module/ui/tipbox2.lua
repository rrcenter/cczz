--[[
    提示框
    每个提示存活时间为0.4秒
    1、只有1个提示
    2、只有2个提示
    3、3个及以上提示
--]]

local TipBox = class("TipBox", function()
    return display.newNode()
end)

TipBox.ctor = function(self)
    local res = "ccz/dialog/tipbox2.png"
    local bgLeft = display.newSprite(res)
    local bgRight = display.newSprite(res)
    bgRight:setScaleX(-1)

    bgLeft:align(display.LEFT_BOTTOM)
    bgRight:align(display.LEFT_BOTTOM)

    local bgSize = bgLeft:getContentSize()
    bgLeft:setPosition(-bgSize.width, 0)
    bgRight:setPosition(bgSize.width, 0)

    self:pos(display.cx, display.height - 100)
    self:addChild(bgLeft)
    self:addChild(bgRight)
    self:addTo(display.getRunningScene())

    self.tipList = {}
    self.labelList = {}
end

TipBox.showNextTip = function(self)
    if #self.tipList == 0 then
        self:hide()
        return
    end

    local tip = table.remove(self.tipList, 1)
    local label = display.newTTFLabel({text = tip.text, color = tip.color or cc.c3b(246, 246, 246), size = 20, align = cc.TEXT_ALIGN_CENTER})
    label:pos(0, 15)
    label:addTo(self)
    table.insert(self.labelList, label)

    if #self.labelList == 2 then
        self.labelList[1]:moveBy(0.3, 0, 25)
        self.labelList[2]:pos(0, 0)
        self.labelList[2]:moveBy(0.2, 0, 15)
    end

    transition.fadeOut(label, {time = 1, onComplete = function()
        table.removebyvalue(self.labelList, label)
        label:removeSelf()
        self:showNextTip()
    end})
end

TipBox.addTip = function(self, text, color)
    table.insert(self.tipList, {text = text, color = color})
    if #self.labelList == 2 then
        printInfo("已有2个提示显示，后续显示排队中")
        return
    end

    self:showNextTip()
end

local TipUtils = {}

TipUtils.showTip = function(tip, color)
    TipUtils.tipBox = TipUtils.tipBox or TipBox.new()
    if not TipUtils.tipBox:isVisible() then
        TipUtils.tipBox:show()
    end

    TipUtils.tipBox:addTip(tip, color)
end

TipUtils.plotOver = function()
    if TipUtils.tipBox then
        TipUtils.tipBox = nil
    end
end

EventMgr.registerEvent(EventConst.PLOT_OVER, TipUtils.plotOver)
EventMgr.registerEvent(EventConst.SCENE_EXIT, TipUtils.plotOver)

return TipUtils