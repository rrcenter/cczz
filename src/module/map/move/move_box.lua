--[[
    用来表示移动方块，可以处理点击事件
--]]

local MoveBox = class("MoveBox", function()
    local node = display.newNode()
    node:size(MapConst.BLOCK_WIDTH, MapConst.BLOCK_HEIGHT)
    node:align(display.LEFT_BOTTOM)
    return node
end)

MoveBox.ctor = function(self, general, row, col)
    local COLORS_MAPS = {
        player = LightBlueColor,
        enemy  = LightGreenColor,
        friend = LightGreenColor,
    }
    local color = COLORS_MAPS[general:getSide()]

    -- 如果这个指定的行列已经存在武将，则不添加rectNode，因为这样会挡住武将
    -- 目前的解决方案为，如果该区域有武将，则武将自己添加一个绿色框，在此节点onExit时，移除掉该武将的box
    local target = MapUtils.getGeneralByRowAndCol(row, col)
    if target then
        self.moveBox = target:addColorBox(color)
    else
        display.newRect(MapViewConst.TILE_RECT, {fillColor = color, borderWidth = 0}):addTo(self)
    end

    self.general = general
    self.row = row
    self.col = col

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

MoveBox.onExit = function(self)
    if self.moveBox then
        self.moveBox:removeSelf()
        self.moveBox = nil
    end
end

MoveBox.onTouch = function(self, event)
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

MoveBox.onClicked = function(self, event)
    local general = self.general
    if not general:isPlayer() then
        TipUtils.showTip(string.format("这是%s部分。", general:isFriend() and "友军" or "敌军"))

        MapUtils.setCurrentGeneral(nil)
        EventMgr.triggerEvent(EventConst.HIDE_ALL_VIEW)

        return
    end

    printInfo("点中了移动方块：(%d, %d)", self.row, self.col)

    local target = MapUtils.getGeneralByRowAndCol(self.row, self.col)
    if target then
        if target == general then
            printInfo("再次点击武将，显示战斗菜单")
            EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MENU, general)
        elseif target:isFriend() or target:isPlayer() then
            TipUtils.showTip("因为有其他部队，所以不能移动。")
        end
    else
        EventMgr.triggerEvent(EventConst.GENERAL_MOVE, general, self.row, self.col)
    end
end

MoveBox.onMoved = function(self, event)
    local xOffset = event.x - event.prevX
    local yOffset = event.y - event.prevY
    EventMgr.triggerEvent(EventConst.MOVE_MAP_VIEW, xOffset, yOffset)
end

return MoveBox