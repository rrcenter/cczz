--[[
    道具使用框
--]]

local ItemBox = class("ItemBox", function()
    local node = display.newNode()
    node:size(MapConst.BLOCK_WIDTH, MapConst.BLOCK_HEIGHT)
    node:align(display.LEFT_BOTTOM)
    return node
end)

ItemBox.ctor = function(self, general, itemId, row, col)
    -- 如果这个指定的行列已经存在武将，则不添加rectNode，因为这样会挡住武将
    -- 目前的解决方案为，如果该区域有武将，则武将自己添加一个道具框，在此节点onExit时，移除掉该武将的box
    local target = MapUtils.getGeneralByRowAndCol(row, col)
    if target then
        self.itemBox = target:addColorBox(LightBlueColor) -- 复用addMagicBox
    else
        display.newRect(MapViewConst.TILE_RECT, {fillColor = LightBlueColor, borderWidth = 0}):addTo(self)
    end

    self.general = general
    self.itemId = itemId
    self.row = row
    self.col = col

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

ItemBox.onExit = function(self)
    if self.itemBox then
        self.itemBox:removeSelf()
        self.itemBox = nil
    end
end

ItemBox.onTouch = function(self, event)
    if event.name == "began" then
        self.moveCount = 0
    elseif event.name == "moved" then
        self.moveCount = self.moveCount + 1
        self:onMoved(event)
    elseif event.name == "ended" then
        if self.moveCount < 3 then
            self:onClicked(event)
        end
    end

    return true
end

ItemBox.onClicked = function(self, event)
    local target = MapUtils.getGeneralByRowAndCol(self.row, self.col)
    if target then
        if target:isEnemy() then
            TipUtils.showTip("此道具不能用于敌方部队。")
        else
            self.general:useItem(target, self.itemId)
            EventMgr.triggerEvent(EventConst.GENERAL_HIDE_ITEM_RANGE)
        end
    else
        printInfo("该攻击区域无武将，点击无效哦~，直接返回战斗菜单")
        EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MENU, self.general)
    end
end

ItemBox.onMoved = function(self, event)
    local xOffset = event.x - event.prevX
    local yOffset = event.y - event.prevY
    EventMgr.triggerEvent(EventConst.MOVE_MAP_VIEW, xOffset, yOffset)
end

return ItemBox