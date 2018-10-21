--[[
    战利品
--]]

local BattleRewardItemNode = class("BattleRewardItemNode", function()
    return cc.uiloader:load("ccz/ui/BattleRewardItemNode.csb")
end)

BattleRewardItemNode.ctor = function(self, itemId)
    self.itemConfig = InfoUtil.getItemConfig(itemId)

    self:initUI()
    self:initTouchEvent()
end

BattleRewardItemNode.initUI = function(self)
    local itemSprite = UIHelper.seekNodeByName(self, "ItemSprite")
    local nameLabel = UIHelper.seekNodeByName(self, "NameLabel")

    itemSprite:setTexture(InfoUtil.getItemPath(self.itemConfig.icon, self.itemConfig.type))
    nameLabel:setString(self.itemConfig.name)
end

BattleRewardItemNode.initTouchEvent = function(self)
    printInfo("暂不处理，之后这里点击可以弹出道具说明") --!!
end

return BattleRewardItemNode