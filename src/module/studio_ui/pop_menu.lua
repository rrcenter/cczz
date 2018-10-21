--[[
    弹出菜单
        目前支持最多3个按钮
--]]

local PopMenu = class("PopMenu", function()
    return cc.uiloader:load("ccz/ui/PopMenu.csb")
end)

PopMenu.ctor = function(self, title, buttonInfo)
    self:initUI(title, #buttonInfo)
    self:initButtonEvent(buttonInfo)
end

PopMenu.initUI = function(self, title, buttonCount)
    self.panel       = UIHelper.seekNodeByName(self, "Panel")
    self.panelSize   = self.panel:getContentSize()
    self.button1     = UIHelper.seekNodeByName(self, "Button1")
    self.button2     = UIHelper.seekNodeByName(self, "Button2")
    self.button3     = UIHelper.seekNodeByName(self, "Button3")
    self.titleLabel  = UIHelper.seekNodeByName(self, "TitleLabel")
    self.leftArrow   = UIHelper.seekNodeByName(self, "LeftArrowSprite")
    self.rightArrow  = UIHelper.seekNodeByName(self, "RightArrowSprite")

    self.titleLabel:setString(title)

    if buttonCount == 1 then
        self:showButton1()
    elseif buttonCount == 2 then
        self:showButton2()
    end

    self.panel:setSwallowTouches(false)
end

PopMenu.showButton1 = function(self)
    self.panel:size(self.panel:getContentSize().width, self.panelSize.height * 0.5)
    self.button1:pos(self.button1:getPositionX(), self.panelSize.height * 0.15)
    self.button2:hide()
    self.button3:hide()
    self.titleLabel:pos(self.titleLabel:getPositionX(), self.panelSize.height * 0.35)
    self.leftArrow:pos(self.leftArrow:getPositionX(), self.panelSize.height * 0.2)
    self.rightArrow:pos(self.rightArrow:getPositionX(), self.panelSize.height * 0.2)
end

PopMenu.showButton2 = function(self)
    self.panel:size(self.panel:getContentSize().width, self.panelSize.height * 0.7)
    self.button1:pos(self.button1:getPositionX(), self.panelSize.height * 0.4)
    self.button2:pos(self.button2:getPositionX(), self.panelSize.height * 0.15)
    self.button2:show()
    self.button3:hide()
    self.titleLabel:pos(self.titleLabel:getPositionX(), self.panelSize.height * 0.6)
    self.leftArrow:pos(self.leftArrow:getPositionX(), self.panelSize.height * 0.35)
    self.rightArrow:pos(self.rightArrow:getPositionX(), self.panelSize.height * 0.35)
end

PopMenu.initButtonEvent = function(self, buttonInfo)
    for i = 1, #buttonInfo do
        local button = self["button" .. i]
        button:show()
        button:setTitleText(buttonInfo[i].text)
        UIHelper.buttonRegister(button, buttonInfo[i].callback)
    end
end

PopMenu.show = function(self, isLeft, anchor, x, y)
    self.panel:align(anchor, x, y)
    self:setVisible(true)

    if isLeft then
        self.leftArrow:show()
        self.rightArrow:hide()
    else
        self.leftArrow:hide()
        self.rightArrow:show()
    end
end

return PopMenu