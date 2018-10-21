--[[
    战斗菜单
        大小 = 2 * 3个方格
        攻击
        策略
        道具
        待命
        取消
--]]

local ViewWidth  = MapConst.BLOCK_WIDTH * 2
local ViewHeight = MapConst.BLOCK_HEIGHT * 3
local ItemWidth  = ViewWidth
local ItemHeight = (ViewHeight - 4) / 5
local ItemStartY = 2
local ItemStartX = ViewWidth / 2
local ResPrefix  = "ccz/general/menu/"

local MenuItem = class("MenuItem", function()
    return display.newNode()
end)

MenuItem.ctor = function(self, text, image, callback)
    self:size(ItemWidth, ItemHeight)

    local nameLabel = display.newTTFLabel({text = text, font = FontName, size = FontSize, color = FontColor})
    nameLabel:align(display.CENTER, ItemStartX, ItemHeight / 2)
    nameLabel:addTo(self)
    self.nameLabel = nameLabel

    -- 绘制下右两条线，显示这像是个按钮
    local lineOffset = 2
    local lineParams = {borderColor = BlackColor, borderWidth = 2}
    display.newLine({{lineOffset, lineOffset}, {ItemWidth - lineOffset, lineOffset}}, lineParams):addTo(self)
    display.newLine({{ItemWidth - lineOffset, lineOffset}, {ItemWidth - lineOffset, ItemHeight - lineOffset}}, lineParams):addTo(self)

    if image then
        local leftSprite = GraySprite.new(image)
        leftSprite:align(display.LEFT_CENTER, 10, ItemHeight / 2)
        leftSprite:addTo(self)
        self.leftSprite = leftSprite

        local rightSprite = GraySprite.new(image)
        rightSprite:align(display.RIGHT_CENTER, ItemWidth - 10, ItemHeight / 2)
        rightSprite:addTo(self)
        self.rightSprite = rightSprite
    end

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, callback)
end

MenuItem.gray = function(self)
    self.leftSprite:gray()
    self.rightSprite:gray()
    self:setTouchEnabled(false)
    self.nameLabel:setColor(FontRedColor)
end

MenuItem.normal = function(self)
    self.leftSprite:normal()
    self.rightSprite:normal()
    self:setTouchEnabled(true)
    self.nameLabel:setColor(FontColor)
end

local GeneralMenu = class("GeneralMenu", function()
    return TouchLayer.new()
end)

GeneralMenu.ctor = function(self)
    local menuNode = display.newNode()
    menuNode:align(display.LEFT_BOTTOM)
    menuNode:addTo(self)
    self.menuNode = menuNode

    local bg = display.newTilesSprite(ResPrefix .. "menu_bg.png", cc.rect(0, 0, ViewWidth, ViewHeight))
    bg:addTo(menuNode)

    local itemInfos = {
        {text = "取消", callback = handler(self, self.onCancelCallback)},
        {text = "待命", image = ResPrefix .. "stop.png", callback = handler(self, self.onStopCallback)},
        {text = "道具", image = ResPrefix .. "item.png", callback = handler(self, self.onItemCallback)},
        {text = "策略", image = ResPrefix .. "magic.png", callback = handler(self, self.onMagicCallback)},
        {text = "攻击", image = ResPrefix .. "attack.png", callback = handler(self, self.onAttackCallback)},
    }

    self.items = {}
    local startY = ItemStartY
    table.walk(itemInfos, function(itemInfo)
        local item = MenuItem.new(itemInfo.text, itemInfo.image, itemInfo.callback)
        item:align(display.CENTER_BOTTOM, ItemStartX, startY)
        item:addTo(menuNode)
        self.items[itemInfo.text] = item

        startY = startY + ItemHeight
    end)
end

GeneralMenu.onTouch = function(self, event)
    printInfo("点中了战斗菜单无效区域，不响应操作")
end

GeneralMenu.onAttackCallback = function(self)
    printInfo("点中了攻击菜单")
    EventMgr.triggerEvent(EventConst.GENERAL_SHOW_ATTACK_RANGE, MapUtils.getCurrentGeneral())
end

GeneralMenu.onMagicCallback = function(self)
    printInfo("点中了策略菜单")
    EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MAGIC_MENU, MapUtils.getCurrentGeneral())
end

GeneralMenu.onItemCallback = function(self)
    printInfo("点中了道具菜单")
    EventMgr.triggerEvent(EventConst.GENERAL_SHOW_ITEM_MENU, MapUtils.getCurrentGeneral())
end

GeneralMenu.onStopCallback = function(self)
    printInfo("点中了待命菜单")
    EventMgr.triggerEvent(EventConst.GENERAL_ACTION_STOP, MapUtils.getCurrentGeneral())
end

GeneralMenu.onCancelCallback = function(self)
    printInfo("点中了取消菜单")
    EventMgr.triggerEvent(EventConst.GENERAL_ACTION_CANCEL_NO_ANIMATION, MapUtils.getCurrentGeneral())
end

-- 设置其中的菜单的位置，这里直接覆盖掉layer的pos方法
GeneralMenu.pos = function(self, x, y)
    self.menuNode:pos(x, y)

    -- 主要就是需要检测攻击和道具这两项按钮，是否禁用
    local general = MapUtils.getCurrentGeneral()
    if not general then
        printError("有问题，这里应该有武将才对")
    end

    if general:hasAttackTarget() then
        self.items["攻击"]:normal()
    else
        self.items["攻击"]:gray()
    end

    if general:canUseMagic() then
        self.items["策略"]:normal()
    else
        self.items["策略"]:gray()
    end

    if GameData.getConsumeItemsCount() > 0 then
        self.items["道具"]:normal()
    else
        self.items["道具"]:gray()
    end
end

return GeneralMenu