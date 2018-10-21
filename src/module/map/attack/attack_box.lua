--[[
    真正的攻击显示框
--]]

local AttackBox = class("AttackBox", function()
    local node = display.newNode()
    node:size(MapConst.BLOCK_WIDTH, MapConst.BLOCK_HEIGHT)
    node:align(display.LEFT_BOTTOM)
    return node
end)

AttackBox.ctor = function(self, general, row, col)
    -- 如果这个指定的行列已经存在武将，则不添加rectNode，因为这样会挡住武将
    -- 目前的解决方案为，如果该区域有武将，则武将自己添加一个红色边框，在此节点onExit时，移除掉该武将的box
    local target = MapUtils.getGeneralByRowAndCol(row, col)
    if target then
        if target ~= general then
            self.attackBox = target:addColorBox(LightRedColor)
            self.hurtBloodBar = target:addHurtBloodBar(general)
        end
    else
        display.newRect(MapViewConst.TILE_RECT, {fillColor = LightRedColor, borderWidth = 0}):addTo(self)
    end

    self.general = general
    self.row = row
    self.col = col

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

AttackBox.onExit = function(self)
    if self.attackBox then
        self.attackBox:removeSelf()
        self.attackBox = nil
    end

    if self.hurtBloodBar then
        self.hurtBloodBar:removeSelf()
        self.hurtBloodBar = nil
    end

    -- 一定要处理，不然可能节点已经消失了，但是回调还是会执行过来
    if self.longClickHandler then
        scheduler.unscheduleGlobal(self.longClickHandler)
        self.longClickHandler = nil
    end
end

AttackBox.onTouch = function(self, event)
    if event.name == "began" then
        self.moveCount = 0
        self.longClickHandler = scheduler.performWithDelayGlobal(function()
            self.longClickHandler = nil
            self:onLongClicked(event)
        end, LONG_CLICK_TIME)
    elseif event.name == "moved" then
        self.moveCount = self.moveCount + 1
        self:onMoved(event)
    elseif event.name == "ended" then
        if self.moveCount < 3 then
            if self.longClickHandler then
                -- 表示未执行长按处理，直接关闭长按计时器
                scheduler.unscheduleGlobal(self.longClickHandler)
                self.longClickHandler = nil

                self:onClicked(event)
            end
        end
    end

    return true
end

AttackBox.onClicked = function(self, event)
    local target = MapUtils.getGeneralByRowAndCol(self.row, self.col)
    if target and target:isEnemy() then
        local targets = self.general:getHitTargets(target:getRow(), target:getCol())
        self.general:attack(target, targets)

        EventMgr.triggerEvent(EventConst.GENERAL_HIDE_ATTACK_RANGE)
    end

    EventMgr.triggerEvent(EventConst.HIDE_ATTACK_PREVIEW)
end

AttackBox.onLongClicked = function(self, event)
    local target = MapUtils.getGeneralByRowAndCol(self.row, self.col)
    if not target then
        printInfo("该攻击区域无武将，点击无效哦~，如果显示攻击框，则隐藏它")
        EventMgr.triggerEvent(EventConst.HIDE_ATTACK_PREVIEW)
        EventMgr.triggerEvent(EventConst.TOUCH_ATTACK_BOX, self.row, self.col)
        return
    end

    if target:isEnemy() then
        EventMgr.triggerEvent(EventConst.SHOW_ATTACK_PREVIEW, self.general, target)
        EventMgr.triggerEvent(EventConst.TOUCH_ATTACK_BOX, self.row, self.col)
    else
        TipUtils.showTip("不能攻击己方部队。")
    end
end

AttackBox.onMoved = function(self, event)
    local xOffset = event.x - event.prevX
    local yOffset = event.y - event.prevY
    EventMgr.triggerEvent(EventConst.MOVE_MAP_VIEW, xOffset, yOffset)
end

return AttackBox