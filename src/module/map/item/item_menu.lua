--[[
    道具选择菜单
--]]

local ItemInfoView = import(".item_info_view")

local ViewWidth      = MapConst.BLOCK_WIDTH * 5
local ViewHeight     = MapConst.BLOCK_HEIGHT * 6
local ListViewWidth  = MapConst.BLOCK_WIDTH * 5 - 20
local ListViewHeight = MapConst.BLOCK_HEIGHT * 4
local ItemMaxCounts  = 5
local ItemWidth      = ListViewWidth
local ItemHeight     = ListViewHeight / ItemMaxCounts
local ResPrefix      = "ccz/magic/menu/"

local MenuItem = class("MenuItem", function()
    return TouchNode.new()
end)

MenuItem.ctor = function(self, general, itemId, count)
    local itemConfig = InfoUtil.getItemConfig(itemId)
    if itemConfig then
        local iconSprite = display.newSprite(InfoUtil.getPath(itemConfig.icon, "item"))
        iconSprite:align(display.RIGHT_CENTER, ItemWidth * 0.2, ItemHeight / 2)
        iconSprite:addTo(self)

        local nameLabel = display.newTTFLabel({text = itemConfig.name, font = FontName, size = FontSmallSize, color = FontColor})
        nameLabel:align(display.LEFT_CENTER, ItemWidth * 0.2, ItemHeight / 2)
        nameLabel:addTo(self)

        local effectLabel = display.newTTFLabel({text = itemConfig.effectDesc, font = FontName, size = FontSmallSize, color = FontColor})
        effectLabel:align(display.CENTER, ItemWidth * 0.65, ItemHeight / 2)
        effectLabel:addTo(self)

        local mpLabel = display.newTTFLabel({text = count, font = FontName, size = FontSmallSize, color = FontColor})
        mpLabel:align(display.CENTER, ItemWidth * 0.9, ItemHeight / 2)
        mpLabel:addTo(self)
    end

    local lineOffset = 2
    local lineParams = {borderColor = GrayColor, borderWidth = 1.5}
    display.newLine({{lineOffset, lineOffset}, {lineOffset, ItemHeight - lineOffset}}, lineParams):addTo(self)
    display.newLine({{lineOffset + ItemWidth * 0.45, lineOffset}, {lineOffset + ItemWidth * 0.45, ItemHeight - lineOffset}}, lineParams):addTo(self)
    display.newLine({{lineOffset + ItemWidth * 0.8, lineOffset}, {lineOffset + ItemWidth * 0.8, ItemHeight - lineOffset}}, lineParams):addTo(self)
    display.newLine({{ItemWidth - lineOffset, lineOffset}, {ItemWidth - lineOffset, ItemHeight - lineOffset}}, lineParams):addTo(self)

    self.general = general
    self.itemId = itemId
    self.itemConfig = itemConfig
    self:setTouchSwallowEnabled(false)
    self:size(ItemWidth, ItemHeight)
end

MenuItem.onClick = function(self, event)
    if (not self.itemId) or self:isTouchMoved() then
        return
    end

    EventMgr.triggerEvent(EventConst.GENERAL_SHOW_ITEM_RANGE, self.general, self.itemId)
end

MenuItem.onDoubleClick = function(self, event)
    self:onClick(event)
end

MenuItem.onLongClick = function(self, event)
    if self:isTouchMoved() then
        return
    end

    ItemInfoView.new(self.itemConfig)
end

local ItemMenu = class("ItemMenu", function()
    return TouchLayer.new()
end)

ItemMenu.ctor = function(self)
    local menuNode = display.newNode()
    menuNode:align(display.CENTER)
    menuNode:addTo(self)
    self.menuNode = menuNode

    local bg = display.newTilesSprite(ResPrefix .. "menu_bg.png", cc.rect(0, 0, ViewWidth, ViewHeight))
    bg:align(display.CENTER, display.cx, display.cy)
    bg:addTo(menuNode)

    local x, y = 10, ViewHeight - 48
    local width, height = ListViewWidth * 0.45, FontSize + 2
    display.newRect(cc.rect(x, y, width, height), {borderWidth = 0.5}):addTo(bg)
    local listviewHead1 = display.newTTFLabel({text = "物品名", font = FontName, size = FontSize, color = FontColor})
    listviewHead1:align(display.CENTER, ViewWidth * 0.25, ViewHeight - 40)
    listviewHead1:addTo(bg)

    x = x + width
    width = ListViewWidth * 0.35
    display.newRect(cc.rect(x, y, width, height), {borderWidth = 0.5}):addTo(bg)
    local listviewHead2 = display.newTTFLabel({text = "效果", font = FontName, size = FontSize, color = FontColor})
    listviewHead2:align(display.CENTER, ViewWidth * 0.55, ViewHeight - 40)
    listviewHead2:addTo(bg)

    x = x + width
    width = ListViewWidth * 0.2
    display.newRect(cc.rect(x, y, width, height), {borderWidth = 0.5}):addTo(bg)
    local listviewHead3 = display.newTTFLabel({text = "库存", font = FontName, size = FontSize, color = FontColor})
    listviewHead3:align(display.CENTER, ViewWidth * 0.85, ViewHeight - 40)
    listviewHead3:addTo(bg)

    local listviewRect = cc.rect(0, 0, ListViewWidth, ListViewHeight)
    local listViewBg = display.newTilesSprite(ResPrefix .. "listview_bg.png", listviewRect)
    listViewBg:align(display.CENTER, ViewWidth / 2, ViewHeight / 2)
    listViewBg:addTo(bg)

    local itemsListView = cc.ui.UIListView.new({viewRect = listviewRect, direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
    itemsListView:setBounceable(false)
    itemsListView:align(display.LEFT_BOTTOM)
    itemsListView:addTo(listViewBg)
    self.itemsListView = itemsListView

    local cancelButton = cc.ui.UIPushButton.new({normal = ResPrefix .. "button.png"})
    cancelButton:setButtonLabel("normal", display.newTTFLabel({text = "取消", font = FontName, size = FontSize, color = FontColor}))
    cancelButton:align(display.RIGHT_BOTTOM, ViewWidth - 10, 10)
    cancelButton:addTo(bg)
    cancelButton:onButtonClicked(function(event)
        EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MENU, self.general)
    end)
end

ItemMenu.onTouch = function(self, event)
    printInfo("点中了策略菜单无效区域，不响应操作")
end

ItemMenu.initFromGeneral = function(self, general)
    self.general = general

    self.itemsListView:removeAllItems()

    local consumeItems = GameData.getAllConsumeItems()
    for itemId, count in pairs(consumeItems) do
        local item = self.itemsListView:newItem()
        item:setItemSize(ItemWidth, ItemHeight)
        item:addContent(MenuItem.new(general, itemId, count))
        self.itemsListView:addItem(item)
    end

    if #consumeItems < ItemMaxCounts then
        for i = 1, ItemMaxCounts - #consumeItems do
            local item = self.itemsListView:newItem()
            item:setItemSize(ItemWidth, ItemHeight)
            item:addContent(MenuItem.new())
            self.itemsListView:addItem(item)
        end
    end

    self.itemsListView:reload()
end

ItemMenu.pos = function(self, mapBg)
    local p = mapBg:convertToNodeSpace(cc.p(0, 0))
    self.menuNode:pos(p.x, p.y)
end

return ItemMenu