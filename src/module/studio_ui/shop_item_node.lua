--[[
    商店道具
--]]

local ShopItemNode = class("ShopItemNode", function()
    return cc.uiloader:load("ccz/ui/ShopItemNode.csb")
end)

ShopItemNode.ctor = function(self, itemId, extraInfo)
    self.itemId     = itemId
    self.extraInfo  = extraInfo or {}
    self.itemConfig = InfoUtil.getItemConfig(itemId)

    self:initUI()
    self:initTouchEvent()
end

ShopItemNode.initUI = function(self)
    self.rootNode       = UIHelper.seekNodeByName(self, "Root")
    self.nameLabel      = UIHelper.seekNodeByName(self, "NameLabel")
    self.itemSprite     = UIHelper.seekNodeByName(self, "ItemSprite")
    self.selectedSprite = UIHelper.seekNodeByName(self, "SelectedSprite")

    self.nameLabel:setString(self.itemConfig.name)
    self.itemSprite:setTexture(InfoUtil.getItemPath(self.itemConfig.icon, self.itemConfig.type))
    self.selectedSprite:hide()
end

ShopItemNode.initTouchEvent = function(self)
    self.rootNode:setSwallowTouches(false)
    self.rootNode:addTouchEventListener(function(sender, et)
        if et == ccui.TouchEventType.moved then
            return
        elseif et == ccui.TouchEventType.ended then
            self:selected(true)
            EventMgr.triggerEvent(EventConst.UI_SHOP_ITEM_SELECTED, self)
        end
    end)
end

ShopItemNode.selected = function(self, isSelected)
    self.selectedSprite:setVisible(isSelected)
end

ShopItemNode.getName =  function(self)
    return self.itemConfig.name
end

ShopItemNode.getLevel = function(self)
    if self.itemConfig.type == "辅助" or self.itemConfig.type == "消耗品" then
        return
    end

    return self.extraInfo.level or 1
end

ShopItemNode.getExp = function(self)
    if self.itemConfig.type == "辅助" or self.itemConfig.type == "消耗品" then
        return
    end

    return self.extraInfo.exp or 0
end

ShopItemNode.getCost = function(self)
    return self.itemConfig.cost
end

ShopItemNode.getAbilityStr = function(self)
    if self.itemConfig.type == "辅助" or self.itemConfig.type == "消耗品" then
        return self.itemConfig.effectDesc
    end

    local addAbility = self.itemConfig.addAbility
    assert(addAbility, "此装备一定可以改变属性")
    local name = PropMappingInfo[addAbility.abilityName]
    local value = addAbility.baseValue + addAbility.addtionValue * (self:getLevel() - 1)
    return name .. "+" .. value
end

ShopItemNode.getCounts = function(self)
    return self.extraInfo.count or 1
end

ShopItemNode.getItemIndex = function(self)
    return self.extraInfo.itemIndex
end

ShopItemNode.getItemId = function(self)
    return self.itemId
end

ShopItemNode.getWidth = function(self)
    self.width = self.width or self.rootNode:getContentSize().width
    return self.width
end

ShopItemNode.getHeight = function(self)
    self.height = self.height or self.rootNode:getContentSize().height
    return self.height
end

return ShopItemNode