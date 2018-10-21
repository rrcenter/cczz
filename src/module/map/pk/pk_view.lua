--[[
    单挑界面
--]]

local PkGeneral = import(".pk_general")

local ResPrefix = "ccz/pk/"
local ViewWidth  = display.width * 0.9
local ViewHeight = display.height * 0.9

local PkView = class("PkView", function()
    return display.newLayer()
end)

PkView.ctor = function(self, callback)
    local rect = cc.rect(display.cx - ViewWidth / 2, display.cy - ViewHeight / 2, ViewWidth, ViewHeight)
    local clipnode = display.newClippingRegionNode(rect)
    clipnode:addTo(self)

    self.bg = display.newSprite(ResPrefix .. "pk_bg.png")
    self.bg:align(display.CENTER, display.cx, display.cy)
    self.bg:addTo(clipnode)

    local bgSize = self.bg:getContentSize()
    self.bg:setScale(ViewWidth / bgSize.width, ViewHeight / bgSize.height)
    self.width, self.height = bgSize.width, bgSize.height

    self.fg = display.newTilesSprite(ResPrefix .. "pk_fg.png", cc.rect(0, 0, ViewWidth, ViewHeight))
    self.fg:align(display.CENTER, display.cx, display.cy)
    self.fg:addTo(clipnode)

    self:setNodeEventEnabled(true)
    self:addTo(display.getRunningScene())

    callback()
end

PkView.onEnter = function(self)
    printInfo("进入PkView，准备注册事件")

    self.handlers = {
        [EventConst.PK_PREPARE]         = handler(self, self.prepare),
        [EventConst.PK_GENERAL_SHOW]    = handler(self, self.generalShow),
        [EventConst.PK_SHOW_START]      = handler(self, self.showStart),
        [EventConst.PK_SHOW_DIALOG]     = handler(self, self.showDialog),
        [EventConst.PK_GENERAL_ACTION]  = handler(self, self.generalAction),
        [EventConst.PK_GENERAL_ATTACK]  = handler(self, self.generalAttack),
        [EventConst.PK_GENERAL_ATTACK2] = handler(self, self.generalAttack2),
        [EventConst.PK_GENERAL_DIE]     = handler(self, self.generalDie),
        [EventConst.PK_OVER]            = handler(self, self.over),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

PkView.onExit = function(self)
    printInfo("离开PkView，准备反注册事件")

    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil
end

-- 前景，主界面显示一次，即隐藏
PkView.initFg = function(self)
    local width, height = ViewWidth, ViewHeight
    local leftHeadIcon = display.newSprite(self.leftGeneral:getHeadIcon())
    leftHeadIcon:align(display.LEFT_TOP, width * 0.05, height * 0.9)
    leftHeadIcon:addTo(self.fg)

    local leftNameLabel = display.newTTFLabel({text = self.leftGeneral:getName(), size = FontLargerSize, font = FontName, color = FontBlueColor})
    leftNameLabel:align(display.LEFT_TOP, leftHeadIcon:getPositionX() + leftHeadIcon:getContentSize().width + 10, height * 0.85)
    leftNameLabel:addTo(self.fg)
    self.leftNameLabel = leftNameLabel

    local rightHeadIcon = display.newSprite(self.rightGeneral:getHeadIcon())
    rightHeadIcon:align(display.RIGHT_BOTTOM, width * 0.95, height * 0.1)
    rightHeadIcon:hide()
    rightHeadIcon:addTo(self.fg)
    self.fgRightHeadIcon = rightHeadIcon

    local rightNameLabel = display.newTTFLabel({text = self.rightGeneral:getName(), size = FontLargerSize, font = FontName, color = FontRedColor})
    rightNameLabel:align(display.RIGHT_BOTTOM, rightHeadIcon:getPositionX() - rightHeadIcon:getContentSize().width - 10, height * 0.15)
    rightNameLabel:hide()
    rightNameLabel:addTo(self.fg)
    self.fgRightNameLabel = rightNameLabel

    local vsLabel = display.newTTFLabel({text = "VS", size = FontLargerSize, font = FontName, color = FontWhiteColor})
    vsLabel:align(display.CENTER, width / 2, height / 2)
    vsLabel:hide()
    vsLabel:addTo(self.fg)
    self.vsLabel = vsLabel
end

-- 后景，真正的单挑界面
PkView.initBg = function(self)
    local width, height = self.width, self.height
    local leftHeadIcon = GraySprite.new(self.leftGeneral:getHeadIcon())
    leftHeadIcon:align(display.LEFT_TOP, width * 0.05, height * 0.9)
    leftHeadIcon:addTo(self.bg)
    self.leftHeadIcon = leftHeadIcon

    local leftNameLabel = display.newTTFLabel({text = self.leftGeneral:getName(), size = FontSmallSize, font = FontName, color = FontWhiteColor})
    leftNameLabel:align(display.CENTER_TOP, leftHeadIcon:getPositionX() + leftHeadIcon:getContentSize().width / 2, leftHeadIcon:getPositionY() - leftHeadIcon:getContentSize().height)
    leftNameLabel:addTo(self.bg)

    local rightHeadIcon = GraySprite.new(self.rightGeneral:getHeadIcon())
    rightHeadIcon:align(display.RIGHT_BOTTOM, width * 0.95, height * 0.1)
    rightHeadIcon:addTo(self.bg)
    self.rightHeadIcon = rightHeadIcon

    local rightNameLabel = display.newTTFLabel({text = self.rightGeneral:getName(), size = FontSmallSize, font = FontName, color = FontWhiteColor})
    rightNameLabel:align(display.CENTER_BOTTOM, rightHeadIcon:getPositionX() - rightHeadIcon:getContentSize().width / 2, rightHeadIcon:getPositionY() + rightHeadIcon:getContentSize().height)
    rightNameLabel:addTo(self.bg)

    if device.platform ~= "windows" and device.platform ~= "mac" then
        leftNameLabel:enableOutline(FontBlueColor, 1)
        rightNameLabel:enableOutline(FontRedColor, 1)
    else
        leftNameLabel:setColor(FontBlueColor)
        rightNameLabel:setColor(FontRedColor)
    end
end

--[[
    这里默认generalId1为我方武将，generalId2为敌方武将
    这里其实只是初始化两个武将，并不显示，然后界面上分别显示两个武将的名字即可
--]]
PkView.prepare = function(self, generalId1, generalId2, callback)
    self.rightGeneral = PkGeneral.new(generalId1, "left")
    self.rightGeneral:addTo(self.bg)

    self.leftGeneral = PkGeneral.new(generalId2, "right")
    self.leftGeneral:addTo(self.bg)

    self:initBg()
    self:initFg()

    self:performWithDelay(function()
        self.vsLabel:show()

        self:performWithDelay(function()
            self.fgRightHeadIcon:show()
            self.fgRightNameLabel:show()

            self:performWithDelay(function()
                self.fg:hide()
                callback()
            end, LONG_ANIMATION_TIME)

        end, LONG_ANIMATION_TIME)

    end, LONG_ANIMATION_TIME)
end

-- 仅显示单个武将入场
PkView.generalShow = function(self, isLeftGeneral, content, action, callback)
    local general = isLeftGeneral and self.leftGeneral or self.rightGeneral
    if isLeftGeneral then
        general:pos(self.width / 2 - general:getOffset(), ViewHeight * 0.5)
    else
        general:pos(self.width / 2 + general:getOffset(), ViewHeight * 0.5   )
    end

    general:show(function()
        general:showAnimation(action)
        self:showDialog(isLeftGeneral, content, false, callback)
    end)
end

-- 显示胜负两个字样
PkView.showStart = function(self, callback)
    local startLabel = display.newTTFLabel({text = "胜 负", size = FontSuperSize, font = FontName, color = FontWhiteColor})
    startLabel:align(display.CENTER, self.width / 2, self.height / 2)
    startLabel:addTo(self.bg)

    self:performWithDelay(function()
        startLabel:hide()
        callback()
    end, LONG_ANIMATION_TIME)
end

-- 显示武将对话，如果允许延时，则延时0.4秒
PkView.showDialog = function(self, isLeftGeneral, content, isDelay, callback)
    local chatNode = display.newNode()
    chatNode:addTo(self.bg)

    local chatBgLeft = display.newSprite(ResPrefix .. "left_boundary.png")
    chatBgLeft:addTo(chatNode)

    local chatBgMiddle = display.newScale9Sprite(ResPrefix .. "middle.png", 0, 0, cc.size(ViewWidth * 0.7, chatBgLeft:getContentSize().height))
    chatBgMiddle:addTo(chatNode)

    local chatBgRight = display.newSprite(ResPrefix .. "right_boundary.png")
    chatBgRight:addTo(chatNode)

    local chatX = isLeftGeneral and ViewWidth * 0.6 or ViewWidth * 0.5
    local chatY = isLeftGeneral and ViewHeight * 0.85 or ViewHeight * 0.2
    chatBgLeft:align(display.RIGHT_CENTER, chatX - chatBgMiddle:getContentSize().width / 2, chatY)
    chatBgMiddle:align(display.CENTER, chatX, chatY)
    chatBgRight:align(display.LEFT_CENTER, chatX + chatBgMiddle:getContentSize().width / 2, chatY)

    if isLeftGeneral then
        local leftArrow = display.newSprite(ResPrefix .. "left_arrow.png")
        leftArrow:align(display.RIGHT_CENTER, chatBgLeft:getPositionX() - chatBgLeft:getContentSize().width, chatY + 10)
        leftArrow:addTo(chatNode)
    else
        local rightArrow = display.newSprite(ResPrefix .. "right_arrow.png")
        rightArrow:align(display.LEFT_CENTER, chatBgRight:getPositionX() + chatBgRight:getContentSize().width, chatY + 10)
        rightArrow:addTo(chatNode)
    end

    local width, height = chatBgMiddle:getContentSize().width, chatBgMiddle:getContentSize().height
    local dimensions = cc.size(width * 0.8, height * 0.8)
    local contentLabel = FadeLabel.new({text = content, fontName = FontName, fontSize = FontSize, fontColor = FontColor, dimensions = dimensions})
    contentLabel:align(display.LEFT_TOP, width * 0.1, height * 0.9)
    contentLabel:addTo(chatBgMiddle)
    contentLabel:playFadeInAnim(40, function()
        chatNode:removeSelf()
        callback()
    end)
end

-- 显示武将动作
PkView.generalAction = function(self, isLeftGeneral, action, callback)
    local general = isLeftGeneral and self.leftGeneral or self.rightGeneral
    general:showAnimation(action, callback)
end

-- 单挑攻击 攻击方 单挑攻击方式 攻击是否没命中
PkView.generalAttack = function(self, isLeftGeneral, action, isNoHited, callback)
    local attacker = isLeftGeneral and self.leftGeneral or self.rightGeneral
    local defenser = isLeftGeneral and self.rightGeneral or self.leftGeneral

    if action == "互相冲锋" then
        attacker:showAnimation("互相冲锋")
        defenser:showAnimation("互相冲锋", callback)
    elseif action == "原地攻击" then
        attacker:showAnimation("原地攻击", callback)
        defenser:showAnimation(isNoHited and "格挡" or "命中")

    elseif action == "移动攻击" then
        attacker:showAnimation("移动攻击", callback)
        defenser:showAnimation(isNoHited and "格挡" or "命中")
    else
        assert(false, "尚未实现此单挑命令：" .. action)
    end
end

-- 单挑攻击 攻击方 单挑攻击方式 是否是致命一击攻击
PkView.generalAttack2 = function(self, isLeftGeneral, action, isCritAttack, callback)
    local attacker = isLeftGeneral and self.leftGeneral or self.rightGeneral
    if isCritAttack then
        attacker:highlight()
    end
    attacker:showAnimation("攻击")

    local defenser = isLeftGeneral and self.rightGeneral or self.leftGeneral
    defenser:showAnimation(action, callback)
end

-- 显示武将死亡，武将动画和头像均灰掉
PkView.generalDie = function(self, isLeftGeneral, callback)
    local generalIcon = isLeftGeneral and self.leftHeadIcon or self.rightHeadIcon
    local general = isLeftGeneral and self.leftGeneral or self.rightGeneral
    general:showAnimation("死亡", function()
        generalIcon:gray()
        callback()
    end)
end

-- 单挑结束，关闭单挑界面
PkView.over = function(self, callback)
    self:performWithDelay(function()
        self:removeSelf()
        callback()
    end, MIDDLE_ANIMATION_TIME)
end

return PkView