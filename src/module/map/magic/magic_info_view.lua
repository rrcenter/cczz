--[[
    策略信息介绍界面
--]]

local ViewWidth         = MapConst.BLOCK_WIDTH * 6
local ViewHeight        = MapConst.BLOCK_HEIGHT * 5
local ResPrefix         = "ccz/magic/info_view/"
local DefaultLineParams = {borderColor = GrayColor, borderWidth = 1.3}

local MagicInfoView = class("MagicInfoView", function()
    return TouchLayer.new()
end)

MagicInfoView.ctor = function(self, magicConfig)
    self:initBg()
    self:initLeft(magicConfig)
    self:initRight(magicConfig)

    display.getRunningScene():addChild(self)
end

-- 给某个节点加一个黑色边框
MagicInfoView.addColorRect = function(self, node, color)
    color = color or BlackColor
    local size = node:getContentSize()
    display.newRect(cc.rect(1, 1, size.width - 2, size.height - 2), {borderColor = color, borderWidth = 0.5}):addTo(node)
end

-- 添加一个周围是一个灰色的不闭合包围框
MagicInfoView.addGroupRect = function(self, tile, node)
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

MagicInfoView.addLines = function(self, node, args)
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

-- 多行文本说明，带左上边框
MagicInfoView.addTextArea = function(self, text, x, y, width, height, anchor, parent)
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

MagicInfoView.initBg = function(self)
    local bg = display.newTilesSprite(ResPrefix .. "main_bg.png", cc.rect(0, 0, ViewWidth, ViewHeight))
    bg:align(display.CENTER, display.cx, display.cy)
    bg:addTo(self)

    self:addColorRect(bg)

    self.bg = bg
end

MagicInfoView.initLeft = function(self, magicConfig)
    local width = ViewWidth * 0.7
    local height = ViewHeight
    local leftNode = display.newNode()
    leftNode:size(width, height)
    leftNode:align(display.LEFT_BOTTOM)
    leftNode:addTo(self.bg)

    local icon = display.newSprite(InfoUtil.getMagicIcon(magicConfig.name))
    local iconSize = icon:getContentSize()
    icon:scale(MapConst.BLOCK_WIDTH * 0.7 / iconSize.width, MapConst.BLOCK_HEIGHT * 0.7 / iconSize.height)
    icon:align(display.LEFT_TOP, 10, height - 10)
    icon:addTo(leftNode)

    local nameLabel = display.newTTFLabel({text = magicConfig.name, size = FontSmallSize, font = FontName, color = FontColor})
    nameLabel:align(display.LEFT_TOP, icon:getPositionX() + MapConst.BLOCK_WIDTH * 0.7 + 3, icon:getPositionY())
    nameLabel:addTo(leftNode)

    local descNodeSize = cc.size(width * 0.8, height * 0.3)
    local descNode = display.newNode()
    descNode:size(descNodeSize.width, descNodeSize.height)
    descNode:align(display.LEFT_TOP, icon:getPositionX(), icon:getPositionY() - MapConst.BLOCK_HEIGHT * 0.7 - 5)
    descNode:addTo(leftNode)
    self:addColorRect(descNode, GrayColor)

    local effectText = string.format("效果\t\t:%s", magicConfig.effectDesc)
    local effectLabel = display.newTTFLabel({text = effectText, size = FontSmallSize, font = FontName, color = FontColor})
    effectLabel:align(display.LEFT_TOP, 10, descNodeSize.height - 5)
    effectLabel:addTo(descNode)

    local mpText = string.format("消耗MP\t\t:%d", magicConfig.mpCost)
    local mpLabel = display.newTTFLabel({text = mpText, size = FontSmallSize, font = FontName, color = FontColor})
    mpLabel:align(display.LEFT_TOP, 10, effectLabel:getPositionY() - FontSmallSize - 3)
    mpLabel:addTo(descNode)

    local targetText = string.format("使用对象\t:%s", (magicConfig.type == "good") and "我军或友军" or "敌军")
    local targetLabel = display.newTTFLabel({text = targetText, size = FontSmallSize, font = FontName, color = FontColor})
    targetLabel:align(display.LEFT_TOP, 10, mpLabel:getPositionY() - FontSmallSize - 3)
    targetLabel:addTo(descNode)

    local detailNodeSize = cc.size(width * 0.8, height * 0.4)
    local detailNode = display.newNode()
    detailNode:size(detailNodeSize.width, detailNodeSize.height)
    detailNode:align(display.LEFT_TOP, icon:getPositionX(), descNode:getPositionY() - descNodeSize.height - 5)
    detailNode:addTo(leftNode)

    self:addTextArea(magicConfig.desc, 0, 0, detailNodeSize.width, detailNodeSize.height, display.LEFT_BOTTOM, detailNode)
end

MagicInfoView.initRight = function(self, magicConfig)
    local width = ViewWidth * 0.3
    local height = ViewHeight
    local rightNode = display.newNode()
    rightNode:size(width, height)
    rightNode:align(display.RIGHT_BOTTOM, ViewWidth, 0)
    rightNode:addTo(self.bg)

    local rangeNodeSize = cc.size(width, height * 0.4)
    local rangeNode = display.newNode()
    rangeNode:size(rangeNodeSize.width, rangeNodeSize.height)
    rangeNode:align(display.LEFT_TOP, 0, height - 10)
    rangeNode:addTo(rightNode)

    local rangeIcon = display.newSprite(InfoUtil.getRangeIcon(magicConfig.rangeType or "RANGE_SELF"))
    rangeIcon:align(display.CENTER_BOTTOM, rangeNodeSize.width / 2, 10)
    rangeIcon:addTo(rangeNode)
    self:addGroupRect("可能范围", rangeNode)

    local hitNode = display.newNode()
    hitNode:size(rangeNodeSize.width, rangeNodeSize.height)
    hitNode:align(display.LEFT_TOP, 0, rangeNode:getPositionY() - rangeNodeSize.height - 5)
    hitNode:addTo(rightNode)

    local hitRangeImage = InfoUtil.getRangeIcon(magicConfig.hitRangeType or "RANGE_SELF")
    local hitRangeIcon = display.newSprite(hitRangeImage)
    hitRangeIcon:align(display.CENTER_BOTTOM, rangeNodeSize.width / 2, 10)
    hitRangeIcon:addTo(hitNode)
    self:addGroupRect("影响范围", hitNode)

    local closeButton = cc.ui.UIPushButton.new({normal = ResPrefix .. "button.png"}, {scale9 = true})
    closeButton:setButtonSize(width * 0.7, width * 0.3)
    closeButton:setButtonLabel("normal", display.newTTFLabel({text = "关闭", font = FontName, size = FontSmallSize, color = FontColor}))
    closeButton:onButtonClicked(function(event)
        self:removeSelf()
    end)
    closeButton:align(display.CENTER_BOTTOM, width / 2, 5)
    closeButton:addTo(rightNode)
end

return MagicInfoView