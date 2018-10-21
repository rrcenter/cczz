--[[
    武将节点，以后逐步将所有用到武将的地方用此节点替换掉
--]]

local GeneralNode = class("GeneralNode", function()
    return cc.uiloader:load("ccz/ui/GeneralNode.csb")
end)

GeneralNode.ctor = function(self, generalId)
    self:initUI()
    self:initTouchEvent()
    self:refreshUI(generalId)
end

GeneralNode.initUI = function(self)
    self.panel          = UIHelper.seekNodeByName(self, "Panel")
    self.headSprite     = UIHelper.seekNodeByName(self, "HeadSprite")
    self.nameLabel      = UIHelper.seekNodeByName(self, "NameLabel")
    self.levelLabel     = UIHelper.seekNodeByName(self, "LevelLabel")
    self.selectedSprite = UIHelper.seekNodeByName(self, "SelectSprite")
end

GeneralNode.refreshUI = function(self, generalId)
    self.generalId = generalId

    local headPath = InfoUtil.getPath(GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_HEAD), "head")
    self.headSprite:setTexture(headPath)
    self.nameLabel:setString(GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_NAME))
    self.levelLabel:setString("Lv " .. GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_LEVEL))
end

GeneralNode.initTouchEvent = function(self)
    self.panel:setSwallowTouches(false)
    self.panel:addTouchEventListener(function(sender, et)
        if et == ccui.TouchEventType.moved then
            return
        elseif et == ccui.TouchEventType.ended then
            self:selected(true)
            EventMgr.triggerEvent(EventConst.UI_GENERAL_SELECTED, self)
        end
    end)
end

GeneralNode.getGeneralId = function(self)
    return self.generalId
end

GeneralNode.selected = function(self, isSelected)
    self.selectedSprite:setVisible(isSelected)
end

GeneralNode.showLevel = function(self, isShow)
    self.levelLabel:setVisible(isShow)
end

GeneralNode.getWidth = function(self)
    self.width = self.width or self.panel:getContentSize().width
    return self.width
end

GeneralNode.getHeight = function(self)
    self.height = self.height or self.panel:getContentSize().height
    return self.height
end

GeneralNode.center = function(self)
    self:pos(self:getWidth() / 2, self:getHeight() / 2)
end

return GeneralNode
