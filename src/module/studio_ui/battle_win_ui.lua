--[[
    战斗胜利界面
--]]

local BattleWinUI = class("BattleWinUI", function()
    return display.newLayer()
end)

BattleWinUI.ctor = function(self, callback)
    self:initUI()
    self:initTouchEvent(callback)
end

BattleWinUI.initUI = function(self)
    self.uiNode = cc.uiloader:load("ccz/ui/BattleWinUI.csb")
    self.uiNode:addTo(self)

    self.rootNode = UIHelper.seekNodeByName(self.uiNode, "Root")
    self.moneyLabel = UIHelper.seekNodeByName(self.uiNode, "MoneyLabel")
    self.itemNode1 = UIHelper.seekNodeByName(self.uiNode, "RewardItemNode1")
    self.itemNode2 = UIHelper.seekNodeByName(self.uiNode, "RewardItemNode2")
    self.itemNode3 = UIHelper.seekNodeByName(self.uiNode, "RewardItemNode3")

    self.moneyLabel:setString(GameData.getRewardMoney())
    self.rootNode:center()

    local fillItemNode = function(itemNode, itemId)
        local itemConfig = InfoUtil.getItemConfig(itemId)
        local itemSprite = UIHelper.seekNodeByName(itemNode, "ItemSprite")
        local nameLabel  = UIHelper.seekNodeByName(itemNode, "NameLabel")

        itemSprite:setTexture(InfoUtil.getItemPath(itemConfig.icon, itemConfig.type))
        nameLabel:setString(itemConfig.name)
    end

    local items = GameData.getRewardItems()
    if #items == 0 then
        self.itemNode1:hide()
        self.itemNode2:hide()
        self.itemNode3:hide()
    elseif #items == 1 then
        self.itemNode2:hide()
        self.itemNode3:hide()
        fillItemNode(self.itemNode1, items[1].itemId)
    elseif #items == 2 then
        self.itemNode1:hide()
        fillItemNode(self.itemNode2, items[1].itemId)
        fillItemNode(self.itemNode3, items[2].itemId)
    else
        fillItemNode(self.itemNode2, items[1].itemId)
        fillItemNode(self.itemNode1, items[2].itemId)
        fillItemNode(self.itemNode3, items[3].itemId)
    end
end

BattleWinUI.initTouchEvent = function(self, callback)
    UIHelper.buttonRegisterByName(self.uiNode, "ContinueButton", function()
        self:removeSelf()
        callback()
    end)
end

BattleWinUI.getWidth = function(self)
    self.width = self.width or self.rootNode:getContentSize().width
    return self.width
end

BattleWinUI.getHeight = function(self)
    self.height = self.height or self.rootNode:getContentSize().height
    return self.height
end

return BattleWinUI