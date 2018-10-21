--[[
    小地图控件
--]]

local SmallBlockWidth = 6
local SmallBlockHeight = 6

local MapSmallView = class("MapSmallView", function()
    return display.newNode()
end)

MapSmallView.ctor = function(self)
    self:initBg()
    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

MapSmallView.initBg = function(self)
    local bg = display.newSprite(MapUtils.getBackgroundSmallRes())
    local bgSize = bg:getContentSize()
    bg:align(display.LEFT_BOTTOM, 0, -bgSize.height)
    bg:addTo(self)
    self.bg = bg
    self.bgSize = bgSize

    local lineOffset = 2
    local lineParams = {borderColor = BlackColor, borderWidth = 2}
    display.newLine({{-lineOffset, -bgSize.height - lineOffset}, {bgSize.width + lineOffset, -bgSize.height - lineOffset}}, lineParams):addTo(self)
    display.newLine({{-lineOffset, -bgSize.height - lineOffset}, {-lineOffset, 0}}, lineParams):addTo(self)
end

MapSmallView.onEnter = function(self)
    printInfo("进入MapSmallView，准备注册事件")

    self.handlers = {
        [EventConst.GENERAL_SMALLMAP_SHOW]    = handler(self, self.generalShow),
        [EventConst.GENERAL_SMALLMAP_MOVE]    = handler(self, self.generalMove),
        [EventConst.GENERAL_SMALLMAP_DONE]    = handler(self, self.generalDone),
        [EventConst.GENERAL_SMALLMAP_REFRESH] = handler(self, self.generalRefresh),
        [EventConst.GENERAL_DIE]              = handler(self, self.generalDie),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

MapSmallView.onExit = function(self)
    printInfo("离开MapSmallView，准备反注册事件")

    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil

    -- 一定要处理，不然可能节点已经消失了，但是回调还是会执行过来
    if self.longClickHandler then
        scheduler.unscheduleGlobal(self.longClickHandler)
        self.longClickHandler = nil
    end
end

MapSmallView.onTouch = function(self, event)
    if event.name == "began" then
        self.longClickHandler = scheduler.performWithDelayGlobal(function()
            self.longClickHandler = nil
            self:onLongClicked(event)
        end, LONG_CLICK_TIME)

    elseif event.name == "ended" then
        if self.longClickHandler then
            -- 表示未执行长按处理，直接关闭长按计时器
            scheduler.unscheduleGlobal(self.longClickHandler)
            self.longClickHandler = nil

            self:onClicked(event)
        end
    end

    return true
end

MapSmallView.onLongClicked = function(self, event)
    printInfo("小地图长按，应该缩回去，然后隐藏")
    self:hideEffect()
end

MapSmallView.onClicked = function(self, event)
    printInfo("小地图单击，暂无处理")
end

MapSmallView.showEffect = function(self)
    self:show()
    self:setTouchEnabled(false)
    transition.execute(self, cca.moveBy(0.5, -self.bgSize.width, 0), {
        onComplete = function()
            self:setTouchEnabled(true)
        end,
    })
end

MapSmallView.hideEffect = function(self)
    self:setTouchEnabled(false)
    transition.execute(self, cca.moveBy(0.5, self.bgSize.width, 0), {
        onComplete = function()
            self:hide()
        end,
    })
end

MapSmallView.initWithGeneralList = function(self, playerList, friendList, enenmyList)
    self:drawGeneralListBoxes(playerList, RedColor)
    self:drawGeneralListBoxes(friendList, GreenColor)
    self:drawGeneralListBoxes(enenmyList, BlueColor)
end

MapSmallView.drawGeneralListBoxes = function(self, generalList, color)
    self.boxes = self.boxes or {}
    for _, v in pairs(generalList) do
        local x = (v:getCol() - 1) * SmallBlockWidth
        local y = self.bgSize.height - v:getRow() * SmallBlockHeight

        self.boxes[v] = display.newRect(cc.rect(x + 0.5, y + 0.5, SmallBlockWidth - 1, SmallBlockHeight - 1), {fillColor = color, borderWidth = 0}):addTo(self.bg)
        self.boxes[v]:setVisible(v:isVisible())
        self.boxes[v].x, self.boxes[v].y = x, y

        if v:isActionDone() then
            self:generalDone(v)
        end
    end
end

MapSmallView.generalShow = function(self, general, isShow)
    self.boxes[general]:setVisible(isShow)
end

MapSmallView.generalMove = function(self, general)
    local box = self.boxes[general]
    local x = (general:getCol() - 1) * SmallBlockWidth
    local y = self.bgSize.height - general:getRow() * SmallBlockHeight

    local xOffset = x - box.x
    local yOffset = y - box.y
    box:pos(xOffset, yOffset)
end

MapSmallView.generalDone = function(self, general)
    local box = self.boxes[general]
    box.tinyBox = display.newRect(cc.rect(box.x + 1, box.y + 1.5, SmallBlockWidth - 3, SmallBlockHeight - 3), {fillColor = BlackColor, borderWidth = 0})
    box.tinyBox:addTo(box)
end

MapSmallView.generalRefresh = function(self, general)
    local box = self.boxes[general]
    if box.tinyBox then
        box.tinyBox:removeSelf()
        box.tinyBox = nil
    end
end

MapSmallView.generalDie = function(self, general)
    if self.boxes[general] then
        self.boxes[general]:removeSelf()
        self.boxes[general] = nil
    end
end

return MapSmallView