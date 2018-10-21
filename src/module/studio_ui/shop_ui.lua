--[[
    商店界面
--]]

local ShopItemNode = import(".shop_item_node")

local ShopUI = class("ShopUI", function()
    return display.newLayer()
end)

ShopUI.ctor = function(self, callback)
    self.callback = callback or function() end
    self:initUI()
    self:initTouchEvent()
    self:initEventHandles()
    self:refreshItemList("Buy")
    self:refreshMoney()

    self:setNodeEventEnabled(true)
end

ShopUI.initEventHandles = function(self)
    self.handlers = {
        [EventConst.UI_SHOP_ITEM_SELECTED] = handler(self, self.itemSelected),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

ShopUI.onExit = function(self)
    self.callback()
end

ShopUI.initUI = function(self)
    self.uiNode = cc.uiloader:load("ccz/ui/ShopUI.csb")
    self.uiNode:addTo(self)

    local rootNode = UIHelper.seekNodeByName(self.uiNode, "Panel")
    rootNode:align(display.CENTER, display.cx, display.cy)

    self.moneyLabel     = UIHelper.seekNodeByName(self.uiNode, "MoneyLabel")
    self.nameLabel      = UIHelper.seekNodeByName(self.uiNode, "NameLabel")
    self.levelNode      = UIHelper.seekNodeByName(self.uiNode, "LevelNode")
    self.levelLabel     = UIHelper.seekNodeByName(self.uiNode, "LevelLabel")
    self.expNode        = UIHelper.seekNodeByName(self.uiNode, "ExpNode")
    self.expProgress    = UIHelper.seekNodeByName(self.uiNode, "ProgressBar")
    self.expLabel       = UIHelper.seekNodeByName(self.uiNode, "ProgressLabel")
    self.abilityLabel   = UIHelper.seekNodeByName(self.uiNode, "AbilityLabel")
    self.costLabel      = UIHelper.seekNodeByName(self.uiNode, "CostLabel")
    self.subButton      = UIHelper.seekNodeByName(self.uiNode, "SubButton")
    self.addButton      = UIHelper.seekNodeByName(self.uiNode, "AddButton")
    self.numNode        = UIHelper.seekNodeByName(self.uiNode, "NumNode")
    self.numLabel       = UIHelper.seekNodeByName(self.uiNode, "NumLabel")
    self.totalCostLabel = UIHelper.seekNodeByName(self.uiNode, "TotalCostLabel")
    self.shopButton     = UIHelper.seekNodeByName(self.uiNode, "ShopButton")
    self.itemsList      = UIHelper.seekNodeByName(self.uiNode, "ItemsListView")
    self.sellButton     = UIHelper.seekNodeByName(self.uiNode, "SellButton")
    self.buyButton      = UIHelper.seekNodeByName(self.uiNode, "BuyButton")

    self.listSize = self.itemsList:getContentSize()
end

ShopUI.initTouchEvent = function(self)
    UIHelper.buttonRegisterByName(self.uiNode, "CloseButton", function()
        self:removeSelf()
    end)

    UIHelper.buttonRegister(self.subButton, function()
        self:refreshTotalCostInfo(-1)
    end)

    UIHelper.buttonRegister(self.addButton, function()
        self:refreshTotalCostInfo(1)
    end)

    UIHelper.buttonRegister(self.shopButton, function()
        if self.currentType == "Buy" then
            self:onItemBuy()
        elseif self.currentType == "Sell" then
            self:onItemSell()
        end
    end)

    UIHelper.buttonRegister(self.buyButton, function()
        self:refreshItemList("Buy")
    end)

    UIHelper.buttonRegister(self.sellButton, function()
        self:refreshItemList("Sell")
    end)
end

-- 当卖出某个装备时，需要强制刷新道具列表
ShopUI.refreshItemList = function(self, listViewType, isForce)
    if not isForce and self.currentType == listViewType then
        return
    end

    self.currentType = listViewType
    self.buyButton:setBright(listViewType ~= "Buy")
    self.sellButton:setBright(listViewType ~= "Sell")

    self.itemsList:setClippingType(1)
    self.itemsList:removeAllItems()

    local addItem = function(itemInfo, i, parent)
        if not itemInfo then
            return
        end

        local padding = 10
        local item = ShopItemNode.new(itemInfo.itemId, itemInfo)
        item:pos(padding * i + item:getWidth() * (i - 0.5), item:getHeight() / 2)
        item:addTo(parent)
        return item
    end

    local allItems = (listViewType == "Buy") and GameData.getAllCanBuyShopItems() or GameData.getAllCanSellShopItems()
    for i = 1, #allItems, 4 do
        local layout = ccui.Layout:create()
        local firstNode = addItem(allItems[i], 1, layout)
        addItem(allItems[i + 1], 2, layout)
        addItem(allItems[i + 2], 3, layout)
        addItem(allItems[i + 3], 4, layout)

        if i == 1 then
            firstNode:selected(true)
            self:refreshItemInfo(firstNode)
        end

        layout:size(self.listSize.width, firstNode:getHeight())
        self.itemsList:pushBackCustomItem(layout)
    end

    if #allItems == 0 then
        self:hideItemInfo()
    end
end

ShopUI.hideItemInfo = function(self)
    self.levelNode:hide()
    self.expNode:hide()
    self.numNode:hide()
    self.costLabel:hide()
    self.abilityLabel:hide()
    self.totalCostLabel:hide()
    self.nameLabel:setString("无")

    UIHelper.buttonEnabled(self.shopButton, false)
end

ShopUI.refreshItemInfo = function(self, itemNode)
    self.selectedNode = itemNode

    if itemNode:getLevel() then
        self.levelNode:show()
        self.levelLabel:setString(itemNode:getLevel())
    else
        self.levelNode:hide()
    end

    if itemNode:getExp() then
        self.expNode:show()
        self.expProgress:setPercent(itemNode:getExp())
        self.expLabel:setString(itemNode:getExp() .. "/100")
    else
        self.expNode:hide()
    end

    if self.currentType == "Buy" then
        self.costLabel:setString(itemNode:getCost())
        self.subButton:hide()
        self.addButton:show()
        self.shopButton:setTitleText("买入")
        UIHelper.buttonEnabled(self.shopButton, GameData.getMoney() >= itemNode:getCost())
    else
        self.costLabel:setString(itemNode:getCost() * 0.5)
        self.addButton:hide()
        self.subButton:setVisible(itemNode:getCounts() > 1)
        self.shopButton:setTitleText("卖出")
        UIHelper.buttonEnabled(self.shopButton, true)
    end

    self.numNode:show()
    self.costLabel:show()
    self.abilityLabel:show()
    self.totalCostLabel:show()

    self.nameLabel:setString(itemNode:getName())
    self.abilityLabel:setString(itemNode:getAbilityStr())
    self.numLabel:setString(itemNode:getCounts())
    self.totalCostLabel:setString(itemNode:getCounts() * tonumber(self.costLabel:getString()))
end

ShopUI.refreshTotalCostInfo = function(self, value)
    local newNum = tonumber(self.numLabel:getString()) + value
    local newTotalCost = newNum * self.selectedNode:getCost()
    self.numLabel:setString(newNum)
    self.totalCostLabel:setString(newTotalCost)

    if self.currentType == "Buy" then
        self.subButton:setVisible(newNum > 1)
        UIHelper.buttonEnabled(self.shopButton, GameData.getMoney() >= newTotalCost)
    elseif self.currentType == "Sell" then
        local count = self.selectedNode:getCounts()
        assert(count > 1, "如果数目本身只有1个，这个按钮不可能开启的")
        self.addButton:setVisible(newNum < count)
        self.subButton:setVisible(newNum > 1)
    end
end

ShopUI.itemSelected = function(self, itemNode)
    if self.selectedNode == itemNode then
        return
    end

    if self.selectedNode then
        self.selectedNode:selected(false)
    end

    itemNode:selected(true)
    self.selectedNode = itemNode
    self:refreshItemInfo(itemNode)
end

ShopUI.onItemBuy = function(self)
    GameData.addMoney(-tonumber(self.totalCostLabel:getString()))
    GameData.addItem(self.selectedNode:getItemId(), tonumber(self.numLabel:getString()))
    self:refreshMoney()
    self:refreshItemInfo(self.selectedNode)

    UIHelper.buttonEnabled(self.shopButton, GameData.getMoney() >= self.selectedNode:getCost())
end

ShopUI.onItemSell = function(self)
    GameData.addMoney(tonumber(self.totalCostLabel:getString()))
    GameData.subItem(self.selectedNode:getItemId(), tonumber(self.numLabel:getString()), self.selectedNode:getItemIndex())
    self:refreshMoney()

    self:refreshItemList("Sell", true)
end

ShopUI.refreshMoney = function(self, money)
    GameData.addMoney(money or 0)
    self.moneyLabel:setString(GameData.getMoney())
end

return ShopUI