--[[
    策略选择菜单
    5 * 6
--]]

local MagicInfoView = import(".magic_info_view")

local ViewWidth     = MapConst.BLOCK_WIDTH * 5
local ViewHeight    = MapConst.BLOCK_HEIGHT * 6
local ListWidth     = MapConst.BLOCK_WIDTH * 5 - 20
local ListHeight    = MapConst.BLOCK_HEIGHT * 4
local ItemCounts    = 5
local ItemWidth     = ListWidth
local ItemHeight    = ListHeight / ItemCounts
local MpHeight      = 12
local MpWidth       = ViewWidth * 0.5
local ResPrefix     = "ccz/magic/menu/"

local MenuItem = class("MenuItem", function()
    return TouchNode.new()
end)

MenuItem.ctor = function(self, general, magicConfig)
    if magicConfig then
        local iconSprite = GraySprite.new(InfoUtil.getMagicIcon(magicConfig.name))
        iconSprite:align(display.RIGHT_CENTER, ItemWidth * 0.2, ItemHeight / 2)
        iconSprite:addTo(self)
        self.iconSprite = iconSprite

        local nameLabel = display.newTTFLabel({text = magicConfig.name, font = FontName, size = FontSmallSize, color = FontColor})
        nameLabel:align(display.LEFT_CENTER, ItemWidth * 0.2, ItemHeight / 2)
        nameLabel:addTo(self)
        self.nameLabel = nameLabel

        local effectLabel = display.newTTFLabel({text = magicConfig.effectDesc, font = FontName, size = FontSmallSize, color = FontColor})
        effectLabel:align(display.CENTER, ItemWidth * 0.6, ItemHeight / 2)
        effectLabel:addTo(self)
        self.effectLabel = effectLabel

        local mpLabel = display.newTTFLabel({text = magicConfig.mpCost, font = FontName, size = FontSmallSize, color = FontColor})
        mpLabel:align(display.CENTER, ItemWidth * 0.9, ItemHeight / 2)
        mpLabel:addTo(self)
        self.mpLabel = mpLabel
    end

    local lineOffset = 2
    local lineParams = {borderColor = GrayColor, borderWidth = 1.5}
    display.newLine({{lineOffset, lineOffset}, {lineOffset, ItemHeight - lineOffset}}, lineParams):addTo(self)
    display.newLine({{lineOffset + ItemWidth * 0.4, lineOffset}, {lineOffset + ItemWidth * 0.4, ItemHeight - lineOffset}}, lineParams):addTo(self)
    display.newLine({{lineOffset + ItemWidth * 0.8, lineOffset}, {lineOffset + ItemWidth * 0.8, ItemHeight - lineOffset}}, lineParams):addTo(self)
    display.newLine({{ItemWidth - lineOffset, lineOffset}, {ItemWidth - lineOffset, ItemHeight - lineOffset}}, lineParams):addTo(self)

    self.general = general
    self.magicConfig = magicConfig
    self:setTouchSwallowEnabled(false)
    self:size(ItemWidth, ItemHeight)
end

MenuItem.gray = function(self)
    if self.magicConfig then
        self:setTouchEnabled(false)

        self.iconSprite:gray()
        self.nameLabel:setColor(display.COLOR_RED)
        self.effectLabel:setColor(display.COLOR_RED)
        self.mpLabel:setColor(display.COLOR_RED)
    end
end

MenuItem.onClick = function(self, event)
    if (not self.magicConfig) or self:isTouchMoved() then
        return
    end

    if self.magicConfig.target == "self" then
        printInfo("直接施放技能，作用目标为自己")
        EventMgr.triggerEvent(EventConst.HIDE_ALL_VIEW)

        self.general:magic(self.magicConfig, self.general, {self.general})
    elseif self.magicConfig.target == "allEnemies" then
        printInfo("全屏攻击技能")
        EventMgr.triggerEvent(EventConst.HIDE_ALL_VIEW)

        local targets = MapUtils.getAllOppositeGenerals(self.general)
        self.general:magic(self.magicConfig, self.general, targets)
    elseif self.magicConfig.target == "allPlayersAndFriends" then
        printInfo("全屏恢复技能")
        EventMgr.triggerEvent(EventConst.HIDE_ALL_VIEW)

        local targets = MapUtils.getAllPlayerAndFriendGenerals(self.general)
        self.general:magic(self.magicConfig, self.general, targets)
    elseif self.magicConfig.target == "all" then
        printInfo("全屏不分敌我技能")
        EventMgr.triggerEvent(EventConst.HIDE_ALL_VIEW)

        local targets = MapUtils.getAllGenerals()
        self.general:magic(self.magicConfig, self.general, targets)
    else
        EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MAGIC_RANGE, self.general, self.magicConfig)
    end
end

MenuItem.onDoubleClick = function(self, event)
    self:onClick(event)
end

MenuItem.onLongClick = function(self, event)
    if self:isTouchMoved() then
        return
    end

    MagicInfoView.new(self.magicConfig)
end

local MagicMenu = class("MagicMenu", function()
    return TouchLayer.new()
end)

MagicMenu.ctor = function(self)
    local menuNode = display.newNode()
    menuNode:align(display.CENTER)
    menuNode:addTo(self)
    self.menuNode = menuNode

    local bg = display.newTilesSprite(ResPrefix .. "menu_bg.png", cc.rect(0, 0, ViewWidth, ViewHeight))
    bg:align(display.CENTER, display.cx, display.cy)
    bg:addTo(menuNode)

    -- 顶部武将描述
    local nameLabel = display.newTTFLabel({text = "郭嘉", font = FontName, size = FontSize, color = FontColor})
    nameLabel:align(display.LEFT_TOP, ViewWidth * 0.05, ViewHeight - 10)
    nameLabel:addTo(bg)
    self.nameLabel = nameLabel

    local mpLabel = display.newTTFLabel({text = "MP:", font = FontName, size = FontSize, color = FontColor})
    mpLabel:align(display.LEFT_TOP, ViewWidth * 0.3, ViewHeight - 10)
    mpLabel:addTo(bg)

    display.newRect(cc.rect(ViewWidth * 0.45 - 1, mpLabel:getPositionY() - MpHeight - 1, ViewWidth * 0.5 + 2, MpHeight + 2), {borderWidth = 0.5}):addTo(bg)

    local mpProgress = cc.ui.UILoadingBar.new({
        scale9 = true,
        capInsets = cc.rect(0, 0, 8, 8),
        image = ResPrefix .. "mp_fg.png",
        viewRect = cc.rect(0, 0, MpWidth, MpHeight),
        percent = 50,
    })
    mpProgress:align(display.LEFT_TOP, ViewWidth * 0.45, mpLabel:getPositionY() - MpHeight)
    mpProgress:addTo(bg)
    self.mpProgress = mpProgress

    local mpLabel = display.newTTFLabel({text = "20 / 40", font = FontName, size = MpHeight, color = FontColor})
    mpLabel:align(display.CENTER, ViewWidth * 0.25, MpHeight * 0.5)
    mpLabel:addTo(mpProgress)
    self.mpLabel = mpLabel

    -- 中间的策略列表框
    display.newRect(cc.rect(10, ViewHeight - 48, ViewWidth * 0.4, FontSize + 2), {borderWidth = 0.5}):addTo(bg)
    local listviewHead1 = display.newTTFLabel({text = "策略名", font = FontName, size = FontSize, color = FontColor})
    listviewHead1:align(display.CENTER, ViewWidth * 0.25, ViewHeight - 40)
    listviewHead1:addTo(bg)

    display.newRect(cc.rect(10 + ViewWidth * 0.4, ViewHeight - 48, ViewWidth * 0.3, FontSize + 2), {borderWidth = 0.5}):addTo(bg)
    local listviewHead2 = display.newTTFLabel({text = "效果", font = FontName, size = FontSize, color = FontColor})
    listviewHead2:align(display.CENTER, ViewWidth * 0.55, ViewHeight - 40)
    listviewHead2:addTo(bg)

    display.newRect(cc.rect(10 + ViewWidth * 0.7, ViewHeight - 48, ListWidth - ViewWidth * 0.7, FontSize + 2), {borderWidth = 0.5}):addTo(bg)
    local listviewHead3 = display.newTTFLabel({text = "MP", font = FontName, size = FontSize, color = FontColor})
    listviewHead3:align(display.CENTER, ViewWidth * 0.85, ViewHeight - 40)
    listviewHead3:addTo(bg)

    local listviewRect = cc.rect(0, 0, ListWidth, ListHeight)
    local magicListViewBg = display.newTilesSprite(ResPrefix .. "listview_bg.png", listviewRect)
    magicListViewBg:align(display.CENTER, ViewWidth / 2, ViewHeight / 2)
    magicListViewBg:addTo(bg)

    local magicListView = cc.ui.UIListView.new({viewRect = listviewRect, direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
    magicListView:align(display.LEFT_BOTTOM)
    magicListView:addTo(magicListViewBg)
    self.magicListView = magicListView

    local cancelButton = cc.ui.UIPushButton.new({normal = ResPrefix .. "button.png"})
    cancelButton:setButtonLabel("normal", display.newTTFLabel({text = "取消", font = FontName, size = FontSize, color = FontColor}))
    cancelButton:align(display.RIGHT_BOTTOM, ViewWidth - 10, 10)
    cancelButton:addTo(bg)
    cancelButton:onButtonClicked(function(event)
        EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MENU, self.general)
    end)
end

MagicMenu.onTouch = function(self, event)
    printInfo("点中了策略菜单无效区域，不响应操作")
end

MagicMenu.initFromGeneral = function(self, general)
    self.general = general

    self.nameLabel:setString(general:getName())
    self.mpProgress:setPercent(general:getCurrentMp() / general:getMaxMp() * 100)
    self.mpLabel:setString(general:getCurrentMp() .. " / " .. general:getMaxMp())

    self.magicListView:removeAllItems()

    local magics = general:getAllMagicsDetail()
    for i, v in ipairs(magics) do
        local magicConfig = InfoUtil.getMagicConfig(v.magicId)
        local magicItem = MenuItem.new(general, magicConfig)
        if v.isLimit then
            magicItem:gray()
        end

        local item = self.magicListView:newItem()
        item:setItemSize(ItemWidth, ItemHeight)
        item:addContent(magicItem)
        self.magicListView:addItem(item)
    end

    if #magics < ItemCounts then
        for i = 1, ItemCounts - #magics do
            local item = self.magicListView:newItem()
            item:setItemSize(ItemWidth, ItemHeight)
            item:addContent(MenuItem.new())
            self.magicListView:addItem(item)
        end
    end

    self.magicListView:reload()
end

MagicMenu.pos = function(self, mapBg)
    local p = mapBg:convertToNodeSpace(cc.p(0, 0))
    self.menuNode:pos(p.x, p.y)
end

return MagicMenu