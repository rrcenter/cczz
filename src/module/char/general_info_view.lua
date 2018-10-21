--[[
    武将详细介绍界面
--]]

local MagicInfoView = require("module.map.magic.magic_info_view")
local ItemInfoView = require("module.map.item.item_info_view")

local ViewWidth         = MapConst.BLOCK_WIDTH * 6
local ViewHeight        = MapConst.BLOCK_HEIGHT * 8
local TitleWidth        = ViewWidth
local TitleHeight       = MapConst.BLOCK_HEIGHT / 2
local LeftWidth         = MapConst.BLOCK_WIDTH * 3
local LeftHeight        = MapConst.BLOCK_HEIGHT * 6
local LeftMiddleWidth   = LeftWidth
local LeftMiddleHeight  = MapConst.BLOCK_HEIGHT * 1.5
local LeftBottomWidth   = LeftWidth
local LeftBottomHeight  = MapConst.BLOCK_HEIGHT * 2.5
local RightWidth        = MapConst.BLOCK_WIDTH * 3
local RightHeight       = MapConst.BLOCK_HEIGHT * 6.5
local RightTopWidth     = RightWidth
local RightTopHeight    = MapConst.BLOCK_WIDTH
local RightBottomWidth  = RightWidth
local RightBottomHeight = MapConst.BLOCK_HEIGHT * 5.5
local ResPrefix         = "ccz/general/info_view/"
local DefaultLineParams = {borderColor = GrayColor, borderWidth = 1.3}

local GeneralInfoView = class("GeneralInfoView", function()
    return TouchLayer.new()
end)

GeneralInfoView.ctor = function(self, general)
    self.general = general

    self:initBg()
    self:initTile("武将资料")
    self:initLeft(general)
    self:initRight(general)
    self:initBottom()

    display.getRunningScene():addChild(self)
end

-- 给某个节点加一个黑色边框
GeneralInfoView.addBlackRect = function(self, node)
    local size = node:getContentSize()
    display.newRect(cc.rect(1, 1, size.width - 2, size.height - 2), {borderColor = BlackColor, borderWidth = 0.5}):addTo(node)
end

-- 添加一个周围是一个灰色的不闭合包围框
GeneralInfoView.addGroupRect = function(self, tile, node)
    local size = node:getContentSize()

    local tileLabel = display.newTTFLabel({text = tile, size = FontSmallSize, font = FontName, color = FontColor})
    tileLabel:align(display.LEFT_TOP, 10, size.height)
    tileLabel:addTo(node)

    local points = {
        {10, size.height - 8},
        {4, size.height - 8},
        {4, 4},
        {size.width - 8, 4},
        {size.width - 8, size.height - 8},
        {tileLabel:getPositionX() + tileLabel:getContentSize().width, size.height - 8},
    }
    for i = 1, #points - 1 do
        display.newLine({points[i], points[i + 1]}, DefaultLineParams):addTo(node)
    end
end

GeneralInfoView.addLines = function(self, node, args)
    args = args or {}

    local size = node:getContentSize()
    local width = args.width or size.width
    local height = args.height or size.height
    local points = {
        {1, 1},
        {1, height - 1},
        {width - 1, height - 1},
        {width - 1, 1},
    }

    if args.left then
        display.newLine({points[1], points[2]}, DefaultLineParams):addTo(node)
    end

    if args.top then
        display.newLine({points[2], points[3]}, DefaultLineParams):addTo(node)
    end

    if args.right then
        display.newLine({points[3], points[4]}, DefaultLineParams):addTo(node)
    end

    if args.bottom then
        display.newLine({points[4], points[1]}, DefaultLineParams):addTo(node)
    end
end

-- 添加一个进度条，带边框和说明label
GeneralInfoView.addProgress = function(self, text, percent, image, width, height)
    local progress = cc.ui.UILoadingBar.new({
        scale9 = true,
        capInsets = cc.rect(0, 0, 8, 8),
        image = image,
        viewRect = cc.rect(0, 0, width, height),
        percent = percent,
    })
    progress:align(display.LEFT_CENTER)

    local progressLabel
    if text then
        progressLabel = display.newTTFLabel({text = text, size = height - 1, font = FontName, color = FontColor})
        progressLabel:align(display.CENTER, width / 2, height / 2)
        progressLabel:addTo(progress)
    end

    self:addLines(progress, {top = true, left = true, width = width, height = height})

    return progress, progressLabel
end

-- 多行文本说明，带左上边框
GeneralInfoView.addTextArea = function(self, text, x, y, width, height, anchor, parent)
    local node = display.newNode()
    node:size(width, height)
    node:align(anchor, x, y)
    node:addTo(parent)

    local dimensions = cc.size(width * 1.1, height * 0.8)
    local contentLabel = display.newTTFLabel({text = text, size = FontSmallSize - 2, font = FontName, color = FontColor, dimensions = dimensions})
    contentLabel:align(display.LEFT_TOP, 0, height)
    contentLabel:addTo(node)

    self:addLines(node, {top = true, left = true})

    return contentLabel
end

GeneralInfoView.initBg = function(self)
    local bg = display.newTilesSprite(ResPrefix .. "main_bg.png", cc.rect(0, 0, ViewWidth, ViewHeight))
    bg:align(display.CENTER, display.cx, display.cy)
    bg:addTo(self)

    self:addBlackRect(bg)

    self.bg = bg
end

GeneralInfoView.initTile = function(self, tileText)
    local tileBg = display.newScale9Sprite(ResPrefix .. "tile_bg.png", TitleWidth / 2, ViewHeight, cc.size(TitleWidth, TitleHeight))
    tileBg:align(display.TOP_CENTER)
    tileBg:addTo(self.bg)

    local tileLable = display.newTTFLabel({text = tileText, size = FontSmallSize, font = FontName, color = FontColor})
    tileLable:align(display.CENTER, TitleWidth / 2, TitleHeight / 2)
    tileLable:addTo(tileBg)

    self:addBlackRect(tileBg)
end

GeneralInfoView.initLeft = function(self, general)
    self:initLeftBg()
    self:initLeftTop(general)
    self:initLeftMiddle(general)
    self:initLeftBottom(general)
end

GeneralInfoView.initLeftBg = function(self)
    local leftBg = display.newNode()
    leftBg:size(LeftWidth, LeftHeight)
    leftBg:align(display.LEFT_TOP, 2, ViewHeight - TitleHeight)
    leftBg:addTo(self.bg)

    self.leftBg = leftBg
end

-- 武将头像，名字和阵营
GeneralInfoView.initLeftTop = function(self, general)
    local generalHeadIcon = display.newSprite(general:getHeadIcon())
    generalHeadIcon:align(display.LEFT_TOP, 0, LeftHeight)
    generalHeadIcon:addTo(self.leftBg)
    self.generalHeadIcon = generalHeadIcon

    local leftX = generalHeadIcon:getPositionX() + generalHeadIcon:getContentSize().width + 3
    local generalNameLabel = display.newTTFLabel({text = general:getName(), size = FontSmallSize, font = FontName, color = FontColor})
    generalNameLabel:align(display.LEFT_TOP, leftX, LeftHeight - 10)
    generalNameLabel:addTo(self.leftBg)
    self.generalNameLabel = generalNameLabel

    local sideText = "[ 我军 ]"
    if general:isFriend() then
        sideText = "[ 友军 ]"
    elseif general:isEnemy() then
        sideText = "[ 敌军 ]"
    end
    local generalSideLabel = display.newTTFLabel({text = sideText, size = FontSmallSize, font = FontName, color = FontColor})
    generalSideLabel:align(display.LEFT_TOP, leftX, LeftHeight - FontSmallSize * 2)
    generalSideLabel:addTo(self.leftBg)
    self.generalSideLabel = generalSideLabel
end

-- 部队属性，兵种类型，等级和武将经验值
GeneralInfoView.initLeftMiddle = function(self, general)
    local node = display.newNode()
    node:size(LeftMiddleWidth, LeftMiddleHeight)
    node:align(display.LEFT_TOP, 0, LeftHeight - self.generalHeadIcon:getContentSize().height - 10)
    node:addTo(self.leftBg)
    self.leftMiddleNode = node

    self:addGroupRect("部队属性", node)

    local leftX = 10
    local armyNameLabel = display.newTTFLabel({text = general:getProfessionName(), size = FontSmallSize, font = FontName, color = FontColor})
    armyNameLabel:align(display.LEFT_TOP, leftX, LeftMiddleHeight * 0.7)
    armyNameLabel:addTo(node)
    self.armyNameLabel = armyNameLabel

    local lvText = string.format("Lv %d  Exp", general:getLevel())
    local lvLabel = display.newTTFLabel({text = lvText, size = FontSmallSize, font = FontName, color = FontColor})
    lvLabel:align(display.LEFT_TOP, leftX, LeftMiddleHeight * 0.35)
    lvLabel:addTo(node)
    self.lvLabel = lvLabel

    local exp = general:getCurrentExp()
    local maxExp = GeneralUtils.getPropMaxLimit("exp")
    local expText = string.format("%d/%d", exp, maxExp)
    local expProgress, expLabel = self:addProgress(expText, exp / maxExp * 100, ResPrefix .. "exp_fg.png", 40, 12)
    expProgress:pos(lvLabel:getPositionX() + lvLabel:getContentSize().width + 5, lvLabel:getPositionY() - FontSmallSize - 6)
    expProgress:addTo(node)
    self.expProgress = expProgress
    self.expLabel = expLabel
end

-- 状态，hp，mp和状态说明（中毒，混乱还是属性升降）
GeneralInfoView.initLeftBottom = function(self, general)
    local node = display.newNode()
    node:size(LeftBottomWidth, LeftBottomHeight)
    node:align(display.LEFT_TOP, 0, self.leftMiddleNode:getPositionY() - self.leftMiddleNode:getContentSize().height)
    node:addTo(self.leftBg)
    self.leftBottomNode = node

    self:addGroupRect("状态", node)

    local leftX = 10
    local label1 = display.newTTFLabel({text = "HP", size = FontSmallSize, font = FontName, color = FontColor})
    label1:align(display.LEFT_TOP, leftX, LeftBottomHeight * 0.85)
    label1:addTo(node)

    local hp = general:getCurrentHp()
    local maxHp = general:getMaxHp()
    local hpText = string.format("%d/%d", hp, maxHp)
    local hpProgress, hpLabel = self:addProgress(hpText, hp / maxHp * 100, ResPrefix .. "hp_fg.png", LeftBottomWidth * 0.6, 12)
    hpProgress:pos(label1:getPositionX() + label1:getContentSize().width + 5, label1:getPositionY() - FontSmallSize - 6)
    hpProgress:addTo(node)
    self.hpProgress = hpProgress
    self.hpLabel = hpLabel

    local label2 = display.newTTFLabel({text = "MP", size = FontSmallSize, font = FontName, color = FontColor})
    label2:align(display.LEFT_TOP, leftX, label1:getPositionY() - FontSmallSize - 3)
    label2:addTo(node)

    local mp = general:getCurrentMp()
    local maxMp = general:getMaxMp()
    local mpText = string.format("%d/%d", mp, maxMp)
    local mpProgress, mpLabel = self:addProgress(mpText, mp / maxMp * 100, ResPrefix .. "mp_fg.png", LeftBottomWidth * 0.6, 12)
    mpProgress:pos(hpProgress:getPositionX(), label2:getPositionY() - FontSmallSize - 6)
    mpProgress:addTo(node)
    self.mpProgress = mpProgress
    self.mpLabel = mpLabel

    local x, y = leftX, label2:getPositionY() - FontSmallSize * 1.5
    local w, h = LeftBottomWidth * 0.8, LeftBottomHeight * 0.45
    self.statusLabel = self:addTextArea(general:getStatusMgr():getStatusDesc(), x, y, w, h, display.LEFT_TOP, self.leftBg)
end

GeneralInfoView.showLeft = function(self, general)
    self.generalHeadIcon:setTexture(general:getHeadIcon())
    self.generalNameLabel:setString(general:getName())

    local sideText = "[ 我军 ]"
    if general:isFriend() then
        sideText = "[ 友军 ]"
    elseif general:isEnemy() then
        sideText = "[ 敌军 ]"
    end
    self.generalSideLabel:setString(sideText)
    self.armyNameLabel:setString(general:getProfessionName())
    self.lvLabel:setString(string.format("Lv %d  Exp", general:getLevel()))

    local exp = general:getCurrentExp()
    local maxExp = GeneralUtils.getPropMaxLimit("exp")
    self.expProgress:setPercent(exp / maxExp * 100)
    self.expLabel:setString(string.format("%d/%d", exp, maxExp))

    local hp = general:getCurrentHp()
    local maxHp = general:getMaxHp()
    self.hpProgress:setPercent(hp / maxHp * 100)
    self.hpLabel:setString(string.format("%d/%d", hp, maxHp))

    local mp = general:getCurrentMp()
    local maxMp = general:getMaxMp()
    self.mpProgress:setPercent(mp / maxMp * 100)
    self.mpLabel:setString(string.format("%d/%d", mp, maxMp))

    self.statusLabel:setString(general:getStatusMgr():getStatusDesc())
end

GeneralInfoView.initRight = function(self, general)
    self:initRightBg()
    self:initRightTop()
    self:initRightBottom()
end

GeneralInfoView.initRightBg = function(self)
    local rightBg = display.newNode()
    rightBg:size(RightWidth, RightHeight)
    rightBg:align(display.RIGHT_TOP, ViewWidth - 2, ViewHeight - TitleHeight)
    rightBg:addTo(self.bg)

    self.rightBg = rightBg
end

-- 武将列传，部队属性，能力，装备，策略按钮
GeneralInfoView.initRightTop = function(self)
    local node = display.newNode()
    node:size(RightTopWidth, RightTopHeight)
    node:align(display.LEFT_TOP, 0, RightHeight)
    node:addTo(self.rightBg)
    self.rightTopNode = node

    local createButton = function(x, y, width, height, anchor, text, callback)
        local button1 = cc.ui.UIPushButton.new({normal = ResPrefix .. "button.png"}, {scale9 = true})
        button1:setButtonSize(width, height)
        button1:setButtonLabel("normal", display.newTTFLabel({text = text, font = FontName, size = FontSmallSize, color = FontColor}))
        button1:onButtonClicked(function(event)
            callback()
        end)
        button1:align(anchor, x, y)
        button1:addTo(node)
    end

    local pos = {
        {0, RightTopHeight},
        {RightTopWidth / 2, RightTopHeight},
        {0, 0},
        {RightTopWidth / 3, 0},
        {RightTopWidth / 3 * 2, 0},
    }
    createButton(pos[1][1], pos[1][2], RightTopWidth / 2, RightTopHeight / 2, display.LEFT_TOP, "武将列传", handler(self, self.showButton1View))
    createButton(pos[2][1], pos[2][2], RightTopWidth / 2, RightTopHeight / 2, display.LEFT_TOP, "部队属性", handler(self, self.showButton2View))
    createButton(pos[3][1], pos[3][2], RightTopWidth / 3, RightTopHeight / 2, display.LEFT_BOTTOM, "能力", handler(self, self.showButton3View))
    createButton(pos[4][1], pos[4][2], RightTopWidth / 3, RightTopHeight / 2, display.LEFT_BOTTOM, "装备", handler(self, self.showButton4View))
    createButton(pos[5][1], pos[5][2], RightTopWidth / 3, RightTopHeight / 2, display.LEFT_BOTTOM, "策略", handler(self, self.showButton5View))
end

GeneralInfoView.initRightBottom = function(self)
    self:showButton1View()
end

GeneralInfoView.hideAllButtonView = function(self)
    for i = 1, 5 do
        local nodeView = self["node" .. i .. "View"]
        if nodeView then
            nodeView:hide()
        end
    end
end

-- 显示武将列传
GeneralInfoView.showButton1View = function(self)
    self:hideAllButtonView()
    self.showButtonViewIndex = 1

    if self.node1View then
        self.node1View.wuliLabel:setString(string.format("武力 %d", self.general:getBasicProp2("wuli")))
        self.node1View.minjieLabel:setString(string.format("敏捷 %d", self.general:getBasicProp2("minjie")))
        self.node1View.zhiliLabel:setString(string.format("智力 %d", self.general:getBasicProp2("zhili")))
        self.node1View.yunqiLabel:setString(string.format("运气 %d", self.general:getBasicProp2("yunqi")))
        self.node1View.tongshuaiLabel:setString(string.format("统率 %d", self.general:getBasicProp2("tongshuai")))
        self.node1View.generalDescLabel:setString(self.general:getGeneralDesc())

        self.node1View:show()
    else
        local node = display.newNode()
        node:size(RightBottomWidth, RightBottomHeight)
        node:align(display.LEFT_BOTTOM)
        node:addTo(self.rightBg)
        self.node1View = node

        local BasicPropWidth = RightBottomWidth * 0.9
        local BasicPropHeight = MapConst.BLOCK_HEIGHT * 2
        local basicPropNode = display.newNode()
        basicPropNode:size(BasicPropWidth, BasicPropHeight)
        basicPropNode:align(display.CENTER_TOP, RightBottomWidth / 2, RightBottomHeight * 0.9)
        basicPropNode:addTo(node)

        self:addGroupRect("基本能力", basicPropNode)

        local wuliText = string.format("武力 %d", self.general:getBasicProp2("wuli"))
        local wuliLabel = display.newTTFLabel({text = wuliText, size = FontSmallSize, font = FontName, color = FontColor})
        wuliLabel:align(display.CENTER_TOP, BasicPropWidth * 0.25, BasicPropHeight * 0.8)
        wuliLabel:addTo(basicPropNode)
        node.wuliLabel = wuliLabel

        local minjieText = string.format("敏捷 %d", self.general:getBasicProp2("minjie"))
        local minjieLabel = display.newTTFLabel({text = minjieText, size = FontSmallSize, font = FontName, color = FontColor})
        minjieLabel:align(display.CENTER_TOP, BasicPropWidth * 0.7, BasicPropHeight * 0.8)
        minjieLabel:addTo(basicPropNode)
        node.minjieLabel = minjieLabel

        local zhiliText = string.format("智力 %d", self.general:getBasicProp2("zhili"))
        local zhiliLabel = display.newTTFLabel({text = zhiliText, size = FontSmallSize, font = FontName, color = FontColor})
        zhiliLabel:align(display.CENTER_TOP, BasicPropWidth * 0.25, BasicPropHeight * 0.6)
        zhiliLabel:addTo(basicPropNode)
        node.zhiliLabel = zhiliLabel

        local yunqiText = string.format("运气 %d", self.general:getBasicProp2("yunqi"))
        local yunqiLabel = display.newTTFLabel({text = yunqiText, size = FontSmallSize, font = FontName, color = FontColor})
        yunqiLabel:align(display.CENTER_TOP, BasicPropWidth * 0.7, BasicPropHeight * 0.6)
        yunqiLabel:addTo(basicPropNode)
        node.yunqiLabel = yunqiLabel

        local tongshuaiText = string.format("统率 %d", self.general:getBasicProp2("tongshuai"))
        local tongshuaiLabel = display.newTTFLabel({text = tongshuaiText, size = FontSmallSize, font = FontName, color = FontColor})
        tongshuaiLabel:align(display.CENTER_TOP, BasicPropWidth * 0.25, BasicPropHeight * 0.4)
        tongshuaiLabel:addTo(basicPropNode)
        node.tongshuaiLabel = tongshuaiLabel

        local x, y = RightBottomWidth / 2, basicPropNode:getPositionY() - BasicPropHeight * 1.1
        local w, h = BasicPropWidth, MapConst.BLOCK_HEIGHT * 2.5
        node.generalDescLabel = self:addTextArea(self.general:getGeneralDesc(), x, y, w, h, display.CENTER_TOP, node)
    end
end

-- 部队属性
GeneralInfoView.showButton2View = function(self)
    self:hideAllButtonView()
    self.showButtonViewIndex = 2

    if self.node2View then

        self.node2View.generalIcon:displayFrame(self.general:getGeneralIcon())
        self.node2View.armyNameLabel:setString(self.general:getProfessionName())
        self.node2View.armyWuqiLabel:setString(string.format("武器: %s", self.general:getArmyWuqiTypeName()))
        self.node2View.armyFangjuLabel:setString(string.format("防具: %s", self.general:getArmyFangjuTypeName()))

        local RATE_MAP = {"C", "B", "A", "S"}
        local ABILITY_MAPPING = {
            ["attack"]    = "攻击力",
            ["explode"]   = "精神力",
            ["defense"]   = "防御力",
            ["morale"]    = "爆发力",
            ["mentality"] = "士气",
        }
        table.walk(ABILITY_MAPPING, function(abilityName, abilityKey)
            self.node2View[abilityKey .. "RateLabel"]:setString(string.format("%s %s", abilityName, self.general:getArmyAbilityRate(abilityKey)))
        end)

        self.node2View.movementLabel:setString(string.format("移动力 %d", self.general:getProp(GeneralDataConst.PROP_MOVEMENT)))
        self.node2View.attackRangeIcon:setTexture(self.general:getAttackRangeIcon())
        self.node2View.generalDescLabel:setString(self.general:getArmyDesc())

        self.node2View:show()
    else
        local node = display.newNode(RightBottomWidth, RightBottomHeight)
        node:align(display.LEFT_BOTTOM)
        node:addTo(self.rightBg)
        self.node2View = node

        local rightTopWidth = RightBottomWidth * 0.8
        local rightTopHeight = MapConst.BLOCK_HEIGHT
        local topNode = display.newNode()
        topNode:size(rightTopWidth, rightTopHeight)
        topNode:align(display.CENTER_TOP, RightBottomWidth / 2, RightBottomHeight * 0.9)
        topNode:addTo(node)

        local generalIconBg = display.newScale9Sprite(ResPrefix .. "general_bg.png", 0, 0, cc.size(MapConst.BLOCK_WIDTH, MapConst.BLOCK_HEIGHT))
        generalIconBg:align(display.LEFT_BOTTOM, 0, 0)
        generalIconBg:addTo(topNode)

        local generalIcon = display.newSprite("#" .. self.general:getGeneralIcon())
        generalIcon:align(display.LEFT_BOTTOM, 0, 0)
        generalIcon:addTo(topNode)
        node.generalIcon = generalIcon

        local FontSmallSize = FontSmallSize - 2
        local armyNameLabel = display.newTTFLabel({text = self.general:getProfessionName(), size = FontSmallSize, font = FontName, color = FontColor})
        armyNameLabel:align(display.LEFT_TOP, generalIcon:getPositionX() + MapConst.BLOCK_WIDTH + 4, rightTopHeight)
        armyNameLabel:addTo(topNode)
        node.armyNameLabel = armyNameLabel

        local armyWuqiText = string.format("武器: %s", self.general:getArmyWuqiTypeName())
        local armyWuqiLabel = display.newTTFLabel({text = armyWuqiText, size = FontSmallSize, font = FontName, color = FontColor})
        armyWuqiLabel:align(display.LEFT_TOP, armyNameLabel:getPositionX(), armyNameLabel:getPositionY() - FontSmallSize * 1.3)
        armyWuqiLabel:addTo(topNode)
        node.armyWuqiLabel = armyWuqiLabel

        local armyFangjuText = string.format("防具: %s", self.general:getArmyFangjuTypeName())
        local armyFangjuLabel = display.newTTFLabel({text = armyFangjuText, size = FontSmallSize, font = FontName, color = FontColor})
        armyFangjuLabel:align(display.LEFT_TOP, armyWuqiLabel:getPositionX(), armyWuqiLabel:getPositionY() - FontSmallSize * 1.3)
        armyFangjuLabel:addTo(topNode)
        node.armyFangjuLabel = armyFangjuLabel

        local rightMiddleWidth = RightBottomWidth * 0.85
        local rightMiddleHeight = MapConst.BLOCK_HEIGHT * 2
        local middleNode = display.newNode()
        middleNode:size(rightMiddleWidth, rightMiddleHeight)
        middleNode:align(display.LEFT_TOP, topNode:getPositionX() - rightTopWidth / 2, topNode:getPositionY() - rightTopHeight * 1.1)
        middleNode:addTo(node)

        local attackRateText = string.format("攻击力 %s", self.general:getArmyAbilityRate("attack"))
        local attackRateLabel = display.newTTFLabel({text = attackRateText, size = FontSmallSize, font = FontName, color = FontColor})
        attackRateLabel:align(display.LEFT_TOP, 0, rightMiddleHeight)
        attackRateLabel:addTo(middleNode)
        node.attackRateLabel = attackRateLabel

        local mentalityRateText = string.format("精神力 %s", self.general:getArmyAbilityRate("mentality"))
        local mentalityRateLabel = display.newTTFLabel({text = mentalityRateText, size = FontSmallSize, font = FontName, color = FontColor})
        mentalityRateLabel:align(display.LEFT_TOP, 0, attackRateLabel:getPositionY() - FontSmallSize * 1.1)
        mentalityRateLabel:addTo(middleNode)
        node.mentalityRateLabel = mentalityRateLabel

        local defenseRateText = string.format("防御力 %s", self.general:getArmyAbilityRate("defense"))
        local defenseRateLabel = display.newTTFLabel({text = defenseRateText, size = FontSmallSize, font = FontName, color = FontColor})
        defenseRateLabel:align(display.LEFT_TOP, 0, mentalityRateLabel:getPositionY() - FontSmallSize * 1.1)
        defenseRateLabel:addTo(middleNode)
        node.defenseRateLabel = defenseRateLabel

        local explodeRateText = string.format("爆发力 %s", self.general:getArmyAbilityRate("explode"))
        local explodeRateLabel = display.newTTFLabel({text = explodeRateText, size = FontSmallSize, font = FontName, color = FontColor})
        explodeRateLabel:align(display.LEFT_TOP, 0, defenseRateLabel:getPositionY() - FontSmallSize * 1.1)
        explodeRateLabel:addTo(middleNode)
        node.explodeRateLabel = explodeRateLabel

        local moraleRateText = string.format("士气     %s", self.general:getArmyAbilityRate("morale"))
        local moraleRateLabel = display.newTTFLabel({text = moraleRateText, size = FontSmallSize, font = FontName, color = FontColor})
        moraleRateLabel:align(display.LEFT_TOP, 0, explodeRateLabel:getPositionY() - FontSmallSize * 1.1)
        moraleRateLabel:addTo(middleNode)
        node.moraleRateLabel = moraleRateLabel

        local movementText = string.format("移动力 %d", self.general:getProp(GeneralDataConst.PROP_MOVEMENT))
        local movementLabel = display.newTTFLabel({text = movementText, size = FontSmallSize, font = FontName, color = FontColor})
        movementLabel:align(display.LEFT_TOP, 0, moraleRateLabel:getPositionY() - FontSmallSize * 1.1)
        movementLabel:addTo(middleNode)
        node.movementLabel = movementLabel

        local attackRangeLabel = display.newTTFLabel({text = "攻击范围", size = FontSmallSize, font = FontName, color = FontColor})
        attackRangeLabel:align(display.LEFT_TOP, attackRateLabel:getPositionX() + attackRateLabel:getContentSize().width * 1.3, rightMiddleHeight)
        attackRangeLabel:addTo(middleNode)

        local attackRangeIcon = display.newSprite(self.general:getAttackRangeIcon())
        attackRangeIcon:align(display.LEFT_TOP, attackRangeLabel:getPositionX(), attackRangeLabel:getPositionY() - FontSmallSize * 2)
        attackRangeIcon:addTo(middleNode)
        node.attackRangeIcon = attackRangeIcon

        local x, y = RightBottomWidth / 2, middleNode:getPositionY() - rightMiddleHeight
        local w, h = rightTopWidth, RightHeight * 0.25
        node.generalDescLabel = self:addTextArea(self.general:getArmyDesc(), x, y, w, h, display.CENTER_TOP, node)
    end
end

-- 能力
GeneralInfoView.showButton3View = function(self)
    self:hideAllButtonView()
    self.showButtonViewIndex = 3

    if self.node3View then
        local props = {"attack", "mentality", "defense", "explode", "morale"}
        for i, prop in ipairs(props) do
            local origValue = self.general:getBasicProp2(prop)
            local maxValue  = GeneralUtils.getPropMaxLimit(prop)
            local value     = self.general:getProp(prop)
            local percent1  = value / maxValue * 100
            local percent2  = origValue / maxValue * 100
            local text      = string.format("%d/%d", value, origValue)
            if value == origValue then
                text = value
            end

            self.node3View.childs[prop].progress1:setPercent(percent1)
            self.node3View.childs[prop].progress2:setPercent(percent2)
            self.node3View.childs[prop].label:setString(text)
        end

        self.node3View.childs["movement"]:setString(self.general:getProp(GeneralDataConst.PROP_MOVEMENT))

        self.node3View:show()
    else
        self.node3View = display.newNode()
        self.node3View:addTo(self.rightBg)
        self.node3View.childs = {}

        local width = RightBottomWidth * 0.8
        local height = RightBottomHeight * 0.15

        local createPropProgress = function(text, prop, x, y)
            local node = display.newNode()
            node:size(width, height)
            node:align(display.CENTER_TOP, x, y)
            node:addTo(self.node3View)

            self:addGroupRect(text, node)

            local origValue = self.general:getBasicProp2(prop)
            local maxValue = GeneralUtils.getPropMaxLimit(prop)
            local value = self.general:getProp(prop)
            local progress1 = self:addProgress(nil, value / maxValue * 100, ResPrefix .. "prop_extra.png", 80, 12)
            progress1:pos(10, 8)
            progress1:addTo(node)

            local text = string.format("%d/%d", value, origValue)
            if value == origValue then
                text = value
            end
            local progress2, label2 = self:addProgress(text, origValue / maxValue * 100, ResPrefix .. "prop.png", 80, 12)
            progress2:pos(10, 8)
            progress2:addTo(node)

            self.node3View.childs[prop] = {}
            self.node3View.childs[prop].progress1 = progress1
            self.node3View.childs[prop].progress2 = progress2
            self.node3View.childs[prop].label = label2
        end

        createPropProgress("攻击力", "attack", RightBottomWidth / 2, RightBottomHeight * 0.95)
        createPropProgress("精神力", "mentality", RightBottomWidth / 2, RightBottomHeight * 0.8)
        createPropProgress("防御力", "defense", RightBottomWidth / 2, RightBottomHeight * 0.65)
        createPropProgress("爆发力", "explode", RightBottomWidth / 2, RightBottomHeight * 0.5)
        createPropProgress("士气", "morale", RightBottomWidth / 2, RightBottomHeight * 0.35)

        local node1 = display.newNode()
        node1:size(width, height)
        node1:align(display.CENTER_TOP, RightBottomWidth / 2, RightBottomHeight * 0.2)
        node1:addTo(self.node3View)

        self:addGroupRect("移动力", node1)

        local movementLabel = display.newTTFLabel({text = self.general:getProp(GeneralDataConst.PROP_MOVEMENT), size = FontSmallSize, font = FontName, color = FontColor})
        movementLabel:align(display.CENTER_RIGHT, width / 2, height / 2)
        movementLabel:addTo(node1)
        self.node3View.childs["movement"] = movementLabel
    end
end

-- 装备
GeneralInfoView.showButton4View = function(self)
    self:hideAllButtonView()
    self.showButtonViewIndex = 4

    local showItem = function(node, itemInfo)
        node.nameLabel:setString(itemInfo.name)
        node.icon:setTexture(InfoUtil.getPath(itemInfo.icon, "equip") or "ccz/item/none.png")

        if itemInfo.lv then
            node.lvLabel:setString("Lv " .. itemInfo.lv)
            node.lvLabel:show()
        else
            node.lvLabel:hide()
        end

        if itemInfo.exp then
            node.expProgress:setPercent(itemInfo.percent)
            node.expProgress:show()

            if itemInfo.exp == "Max" then
                node.expLabel:setString(itemInfo.exp)
            else
                node.expLabel:setString(itemInfo.exp .. "/" .. itemInfo.maxExp)
            end
            node.expLabel:show()
        else
            node.expProgress:hide()
            node.expLabel:hide()
        end

        if itemInfo.abilityDesc then
            node.descLabel:setString(itemInfo.abilityDesc)
            node.descLabel:show()
        else
            node.descLabel:hide()
        end
    end

    if self.node4View then
        local wuqi = self.general:getEquipment(GeneralDataConst.EQUIP_WUQI)
        local wuqiInfo = {
            name        = wuqi:getName() or "武器: 无",
            icon        = wuqi:getIcon(),
            lv          = wuqi:getLevel(),
            exp         = wuqi:getExp(),
            maxExp      = wuqi:getMaxExp(),
            percent     = wuqi:getExpPercent(),
            abilityDesc = wuqi:getAbilityDesc(),
        }
        showItem(self.node4View.wuqiNode, wuqiInfo)
        self.node4View.wuqiNode.itemConfig = wuqi:getConfig()

        local fangju = self.general:getEquipment(GeneralDataConst.EQUIP_FANGJU)
        local fangjuInfo = {
            name        = fangju:getName() or "防具: 无",
            icon        = fangju:getIcon(),
            lv          = fangju:getLevel(),
            exp         = fangju:getExp(),
            maxExp      = fangju:getMaxExp(),
            percent     = fangju:getExpPercent(),
            abilityDesc = fangju:getAbilityDesc(),
        }
        showItem(self.node4View.fangjuNode, fangjuInfo)
        self.node4View.fangjuNode.itemConfig = fangju:getConfig()

        local shiping = self.general:getEquipment(GeneralDataConst.EQUIP_SHIPING)
        local shipingInfo = {
            name = shiping:getName() or "辅助: 无",
            icon = shiping:getIcon(),
            abilityDesc = shiping:getEffectDesc(),
        }
        showItem(self.node4View.shipingNode, shipingInfo)
        self.node4View.shipingNode.itemConfig = shiping:getConfig()

        self.node4View:show()
    else
        self.node4View = display.newNode()
        self.node4View:addTo(self.rightBg)

        local creatItem = function(x, y)
            local width = RightBottomWidth * 0.9
            local height = RightBottomHeight * 0.3
            local node = display.newNode()
            node:size(width, height)
            node:align(display.LEFT_BOTTOM, x, y)
            node:addTo(self.node4View)

            local leftX = 2
            local nameLabel = display.newTTFLabel({text = "", size = FontSmallSize, font = FontName, color = FontColor})
            nameLabel:align(display.LEFT_TOP, leftX, height)
            nameLabel:addTo(node)
            node.nameLabel = nameLabel

            local icon = display.newSprite("ccz/item/none.png")
            icon:align(display.LEFT_TOP, leftX, height - FontSmallSize - 10)
            icon:addTo(node)
            node.icon = icon

            self:addLines(icon, {top = true, left = true})

            local lvLabel = display.newTTFLabel({text = "", size = FontSmallSize * 0.8, font = FontName, color = FontColor})
            lvLabel:align(display.LEFT_TOP, icon:getPositionX() + icon:getContentSize().width + 3, icon:getPositionY())
            lvLabel:addTo(node)
            node.lvLabel = lvLabel

            local expProgress, expLabel = self:addProgress("", 100, ResPrefix .. "exp_fg.png", 80, 12)
            expProgress:pos(lvLabel:getPositionX(), icon:getPositionY() - icon:getContentSize().height)
            expProgress:addTo(node)
            node.expProgress = expProgress
            node.expLabel = expLabel

            local descLabel = display.newTTFLabel({text = "", size = FontSmallSize * 0.8, font = FontName, color = FontColor})
            descLabel:align(display.LEFT_TOP, leftX, icon:getPositionY() - icon:getContentSize().height - 5)
            descLabel:addTo(node)
            node.descLabel = descLabel

            display.newLine({{0, 0}, {width, 0}}, DefaultLineParams):addTo(node)

            node:setTouchEnabled(true)
            node:addNodeEventListener(cc.NODE_TOUCH_EVENT, function()
                if node.itemConfig then
                    ItemInfoView.new(node.itemConfig)
                end
            end)

            return node
        end

        self.node4View.wuqiNode = creatItem(RightBottomWidth * 0.05, RightBottomHeight * 0.65)
        self.node4View.fangjuNode = creatItem(RightBottomWidth * 0.05, RightBottomHeight * 0.35)
        self.node4View.shipingNode = creatItem(RightBottomWidth * 0.05, RightBottomHeight * 0.05)

        local wuqi = self.general:getEquipment(GeneralDataConst.EQUIP_WUQI)
        local wuqiInfo = {
            name        = wuqi:getName() or "武器: 无",
            icon        = wuqi:getIcon(),
            lv          = wuqi:getLevel(),
            exp         = wuqi:getExp(),
            maxExp      = wuqi:getMaxExp(),
            percent     = wuqi:getExpPercent(),
            abilityDesc = wuqi:getAbilityDesc(),
        }
        showItem(self.node4View.wuqiNode, wuqiInfo)
        self.node4View.wuqiNode.itemConfig = wuqi:getConfig()

        local fangju = self.general:getEquipment(GeneralDataConst.EQUIP_FANGJU)
        local fangjuInfo = {
            name        = fangju:getName() or "防具: 无",
            icon        = fangju:getIcon(),
            lv          = fangju:getLevel(),
            exp         = fangju:getExp(),
            maxExp      = fangju:getMaxExp(),
            percent     = fangju:getExpPercent(),
            abilityDesc = fangju:getAbilityDesc(),
        }
        showItem(self.node4View.fangjuNode, fangjuInfo)
        self.node4View.fangjuNode.itemConfig = fangju:getConfig()

        local shiping = self.general:getEquipment(GeneralDataConst.EQUIP_SHIPING)
        local shipingInfo = {
            name = shiping:getName() or "辅助: 无",
            icon = shiping:getIcon(),
            abilityDesc = shiping:getEffectDesc(),
        }
        showItem(self.node4View.shipingNode, shipingInfo)
        self.node4View.shipingNode.itemConfig = shiping:getConfig()
    end
end

-- 策略
GeneralInfoView.showButton5View = function(self)
    self:hideAllButtonView()
    self.showButtonViewIndex = 5

    local width = RightBottomWidth * 0.9
    local height = RightBottomHeight * 0.9
    local createListView = function(headers, parent)
        local node = display.newTilesSprite(ResPrefix .. "listview_bg.png", cc.rect(0, 0, width, height))
        node:align(display.CENTER_TOP, RightBottomWidth / 2, height)
        node:addTo(parent)

        local headerHeight = height * 0.1
        local headerNode = display.newScale9Sprite(ResPrefix .. "button.png", 0, 0, cc.size(width, headerHeight))
        headerNode:align(display.LEFT_TOP, 0, height)
        headerNode:addTo(node)

        local rect = cc.rect(0, 0, width * 0.6, headerHeight)
        for _, v in ipairs(headers) do
            local label = display.newTTFLabel({text = v, size = FontSmallSize, font = FontName, color = FontColor})
            label:align(display.CENTER, rect.x + rect.width / 2, rect.y + rect.height / 2)
            label:addTo(headerNode)

            display.newRect(rect, DefaultLineParams):addTo(headerNode)
            rect.x = rect.x + rect.width
            rect.width = width - rect.width
        end

        local listView = cc.ui.UIListView.new({viewRect = cc.rect(0, 0, width, height - headerHeight), direction = cc.ui.UIScrollView.DIRECTION_VERTICAL})
        listView:align(display.LEFT_BOTTOM)
        listView:addTo(node)
        listView:onTouch(function(event)
            if "clicked" == event.name then
                if event.item.magicConfig then
                    MagicInfoView.new(event.item.magicConfig)
                end
            end
        end)

        return listView
    end

    local fillListView = function(listView)
        local listItemWidth = width
        local listItemHeight = height * 0.9 / 5
        local createListItem = function(magicConfig)
            local node = display.newNode()
            node:size(listItemWidth, listItemHeight)
            node:align(display.CENTER_TOP, RightBottomWidth / 2, height)

            if magicConfig then
                local icon = display.newSprite(InfoUtil.getMagicIcon(magicConfig.name))
                local iconSize = icon:getContentSize()
                local iconHeight = listItemHeight * 0.8
                icon:scale(iconHeight / iconSize.width, iconHeight / iconSize.height)
                icon:align(display.LEFT_CENTER, 0, listItemHeight / 2)
                icon:addTo(node)

                local iconName = display.newTTFLabel({text = magicConfig.name, size = FontSmallSize - 2, font = FontName, color = FontColor})
                iconName:align(display.LEFT_CENTER, iconHeight + 2, listItemHeight / 2)
                iconName:addTo(node)

                local mpLabel = display.newTTFLabel({text = magicConfig.mpCost, size = FontSmallSize - 2, font = FontName, color = FontColor})
                mpLabel:align(display.CENTER, width * 0.75, listItemHeight / 2)
                mpLabel:addTo(node)
            end

            display.newLine({{width * 0.6, 0}, {width * 0.6, listItemHeight}}, DefaultLineParams):addTo(node)

            return node
        end

        listView:removeAllItems()

        local items = {}
        local allMagics = self.general:getAllMagics()
        if allMagics then
            for _, v in ipairs(allMagics) do
                local magicConfig = InfoUtil.getMagicConfig(v)
                table.insert(items, magicConfig)
            end
        end

        for _, v in ipairs(items) do
            local menuItem = listView:newItem()
            menuItem.magicConfig = v
            menuItem:setItemSize(listItemWidth, listItemHeight)
            menuItem:addContent(createListItem(v))
            listView:addItem(menuItem)
        end

        if #items < 5 then
            for i = 1, 5 - #items do
                local menuItem = listView:newItem()
                menuItem:setItemSize(listItemWidth, listItemHeight)
                menuItem:addContent(createListItem())
                listView:addItem(menuItem)
            end
        end

        listView:reload()
    end

    if self.node5View then
        fillListView(self.node5View.listview)
        self.node5View:show()
    else
        self.node5View = display.newNode()
        self.node5View:addTo(self.rightBg)

        self.node5View.listview = createListView({"策略", "MP"}, self.node5View)
        fillListView(self.node5View.listview)
    end
end

GeneralInfoView.showRight = function(self)
    self[string.format("showButton%dView", self.showButtonViewIndex)](self)
end

GeneralInfoView.initBottom = function(self)
    local bottomNode = display.newNode()
    bottomNode:size(ViewWidth, MapConst.BLOCK_HEIGHT)
    bottomNode:align(display.CENTER_BOTTOM, ViewWidth / 2, 0)
    bottomNode:addTo(self.bg)

    local createButton = function(x, y, width, height, anchor, text, callback)
        local button = cc.ui.UIPushButton.new({normal = ResPrefix .. "button.png"}, {scale9 = true})
        button:setButtonSize(width, height)
        button:setButtonLabel("normal", display.newTTFLabel({text = text, font = FontName, size = FontSmallSize, color = FontColor}))
        button:onButtonClicked(function(event)
            callback()
        end)
        button:align(anchor, x, y)
        button:addTo(bottomNode)
    end

    self.generals = MapUtils.getAllGenerals()
    table.sort(self.generals, function(l, r)
        local lIndex = l:getRow() * MapUtils.cols + l:getCol()
        local rIndex = r:getRow() * MapUtils.cols + r:getCol()
        return lIndex < rIndex
    end)
    table.sort(self.generals, function(l, r)
        if l:isPlayer() and (r:isFriend() or r:isEnemy()) then
            return true
        elseif l:isFriend() and r:isEnemy() then
            return true
        else
            return false
        end
    end)

    self.generalIndex = table.indexof(self.generals, self.general)

    local width = ViewWidth * 0.2
    local height = MapConst.BLOCK_HEIGHT / 2
    createButton(10, 10, width, height, display.LEFT_BOTTOM, "上一武将", function()
        if self.generalIndex == 1 then
            self.generalIndex = #self.generals
        else
            self.generalIndex = self.generalIndex - 1
        end

        self.general = self.generals[self.generalIndex]
        self:showLeft(self.general)
        self:showRight()
    end)

    createButton(20 + width, 10, width, height, display.LEFT_BOTTOM, "下一武将", function()
        if self.generalIndex == #self.generals then
            self.generalIndex = 1
        else
            self.generalIndex = self.generalIndex + 1
        end

        self.general = self.generals[self.generalIndex]
        self:showLeft(self.general)
        self:showRight()
    end)

    createButton(ViewWidth * 0.7, 10, width, height, display.LEFT_BOTTOM, "关闭", function()
        self:removeSelf()
    end)
end

return GeneralInfoView