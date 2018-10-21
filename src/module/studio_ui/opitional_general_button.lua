--[[
    出阵武将中武将按钮
--]]

local OpitionalGeneralButton = class("OpitionalGeneralButton", function()
    return cc.uiloader:load("ccz/ui/FightGeneralButton.csb")
end)

OpitionalGeneralButton.ctor = function(self, generalId)
    self.root  = UIHelper.seekNodeByName(self, "Root")
    self.scale = self.root:getScaleX()
    self.size  = self.root:getContentSize()

    self.nameLabel   = UIHelper.seekNodeByName(self, "NameLabel")
    self.generalIcon = UIHelper.seekNodeByName(self, "GeneralIcon")
    self.levelLabel  = UIHelper.seekNodeByName(self, "LevelLabel")
    
    self.res = "ccz/general/icon/general_icons"
    ResMgr.addSpriteFrames(self.res)

    self.nameLabel:setString(GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_NAME))
    self.levelLabel:setString("Lv. " .. GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_LEVEL))
    self.levelLabel:setColor(display.COLOR_WHITE)
    self.generalIcon:setSpriteFrame(InfoUtil.getPath(GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_RES), "generalIcon"))

    UIHelper.buttonRegister(self.root, function()
        if self.isNoEffect or self.status == "disabled" then
            EventMgr.triggerEvent(EventConst.GENERAL_INFO_REFRESHED, generalId)
            return
        end

        if not self.isInAnimation then
            if self.status == "selected" then
                self:normal()
                EventMgr.triggerEvent(EventConst.GENERAL_BUTTON_PRESSED, generalId, false)
            else
                self:selected()
                EventMgr.triggerEvent(EventConst.GENERAL_BUTTON_PRESSED, generalId, true)
            end
        end
    end)

    self:setNodeEventEnabled(true)
end

OpitionalGeneralButton.onExit = function(self)
    ResMgr.removeSpriteFramesWithFile(self.res)
end

OpitionalGeneralButton.getWidth = function(self)
    return self.size.width * self.scale
end

OpitionalGeneralButton.getHeight = function(self)
    return self.size.height * self.scale
end

OpitionalGeneralButton.align = function(self, anchor, x, y)
    self.root:align(anchor, x, y)
end

OpitionalGeneralButton.selected = function(self)
    if self.status == "disabled" then
        return
    end

    self.isInAnimation = true
    self.generalIcon:setColor(cc.c3b(100, 100, 100))
    self:performWithDelay(function()
        self.isInAnimation = false
    end, MIDDLE_ANIMATION_TIME)

    self.status = "selected"
end

OpitionalGeneralButton.normal = function(self)
    if self.status == "disabled" then
        return
    end

    self.isInAnimation = true
    self.generalIcon:setColor(cc.c3b(255, 255, 255))
    self:performWithDelay(function()
        self.isInAnimation = false
    end, MIDDLE_ANIMATION_TIME)

    self.status = "normal"
end

OpitionalGeneralButton.disabled = function(self)
    self.levelLabel:setColor(display.COLOR_RED)
    self.generalIcon:setColor(cc.c3b(100, 100, 100))
    self.status = "disabled"
end

OpitionalGeneralButton.setNoTouchEffect = function(self, isNoEffect)
    if self.status ~= "selected" then
        self.isNoEffect = isNoEffect
    end
end

return OpitionalGeneralButton
