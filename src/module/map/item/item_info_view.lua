--[[
    道具详细介绍界面
--]]

local ViewWidth         = MapConst.BLOCK_WIDTH * 7
local ViewHeight        = MapConst.BLOCK_HEIGHT * 5.5
local ResPrefix         = "ccz/magic/info_view/"
local DefaultLineParams = {borderColor = GrayColor, borderWidth = 1.3}

local ItemInfoView = class("ItemInfoView", function()
    return TouchLayer.new()
end)

ItemInfoView.ctor = function(self, itemConfig)
    self:initBg()
    self:initLeft(itemConfig)
    self:initRight(itemConfig)

    display.getRunningScene():addChild(self)
end

-- 给某个节点加一个黑色边框
ItemInfoView.addColorRect = function(self, node, color)
    color = color or BlackColor
    local size = node:getContentSize()
    display.newRect(cc.rect(1, 1, size.width - 2, size.height - 2), {borderColor = color, borderWidth = 0.5}):addTo(node)
end

-- 添加一个周围是一个灰色的不闭合包围框
ItemInfoView.addGroupRect = function(self, tile, node)
    local size = node:getContentSize()

    local tileLabel
    if tile then
        tileLabel = display.newTTFLabel({text = tile, size = FontSmallSize, font = FontName, color = FontColor})
        tileLabel:align(display.LEFT_TOP, 10, size.height)
        tileLabel:addTo(node)
    end

    local points = {
        {10, size.height - 8},
        {4, size.height - 8},
        {4, 4},
        {size.width - 8, 4},
        {size.width - 8, size.height - 8},
    }

    if tile then
        table.insert(points, {tileLabel:getPositionX() + tileLabel:getContentSize().width, size.height - 8})
    else
        table.insert(points, {4, size.height - 8})
    end

    for i = 1, #points - 1 do
        display.newLine({points[i], points[i + 1]}, DefaultLineParams):addTo(node)
    end
end

ItemInfoView.addLines = function(self, node, args)
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
ItemInfoView.addTextArea = function(self, text, x, y, width, height, anchor, parent)
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

ItemInfoView.initBg = function(self)
    local bg = display.newTilesSprite(ResPrefix .. "main_bg.png", cc.rect(0, 0, ViewWidth, ViewHeight))
    bg:align(display.CENTER, display.cx, display.cy)
    bg:addTo(self)

    self:addColorRect(bg)

    self.bg = bg
end

ItemInfoView.initLeft = function(self, itemConfig)
    local width = ViewWidth * 0.6
    local height = ViewHeight
    local leftNode = display.newNode()
    leftNode:size(width, height)
    leftNode:align(display.LEFT_BOTTOM)
    leftNode:addTo(self.bg)

    local icon = display.newSprite(InfoUtil.getPath(itemConfig.icon, "item"))
    local iconSize = icon:getContentSize()
    icon:scale(MapConst.BLOCK_WIDTH * 0.7 / iconSize.width, MapConst.BLOCK_HEIGHT * 0.7 / iconSize.height)
    icon:align(display.LEFT_TOP, 10, height - 10)
    icon:addTo(leftNode)
    self:addLines(icon, {left = true, top = true})

    local nameLabel = display.newTTFLabel({text = itemConfig.name, size = FontSmallSize, font = FontName, color = FontColor})
    nameLabel:align(display.LEFT_TOP, icon:getPositionX() + MapConst.BLOCK_WIDTH * 0.7 + 3, icon:getPositionY())
    nameLabel:addTo(leftNode)

    local descNodeSize = cc.size(width * 0.5, height * 0.3)
    local descNode = display.newNode()
    descNode:size(descNodeSize.width, descNodeSize.height)
    descNode:align(display.LEFT_TOP, icon:getPositionX(), icon:getPositionY() - MapConst.BLOCK_HEIGHT * 0.7 - 5)
    descNode:addTo(leftNode)
    self:addGroupRect(nil, descNode)

    local typeText = string.format("属性: %s", itemConfig.type)
    local typeLabel = display.newTTFLabel({text = typeText, size = FontSmallSize, font = FontName, color = FontColor})
    typeLabel:align(display.LEFT_CENTER, 5, descNodeSize.height / 2 + FontSmallSize)
    typeLabel:addTo(descNode)

    local costText = string.format("价格: %s", itemConfig.cost or "无价")
    local costLabel = display.newTTFLabel({text = costText, size = FontSmallSize, font = FontName, color = FontColor})
    costLabel:align(display.LEFT_CENTER, 5, descNodeSize.height / 2 - FontSmallSize)
    costLabel:addTo(descNode)

    local effectNodeSize = cc.size(width * 0.5, height * 0.3)
    local effectNode = display.newNode()
    effectNode:size(effectNodeSize.width, effectNodeSize.height)
    effectNode:align(display.LEFT_TOP, descNode:getPositionX() + descNodeSize.width, descNode:getPositionY())
    effectNode:addTo(leftNode)
    self:addGroupRect("效果", effectNode)

    if itemConfig.effectDesc then
        local dimensions = cc.size(effectNodeSize.width * 0.8, effectNodeSize.height * 0.6)
        local effectLabel = display.newTTFLabel({text = itemConfig.effectDesc, size = FontSmallSize, font = FontName, color = FontColor, dimensions = dimensions})
        effectLabel:align(display.CENTER_BOTTOM, effectNodeSize.width / 2, 10)
        effectLabel:addTo(effectNode)
    end

    local detailNodeSize = cc.size(width * 0.8, height * 0.4)
    local detailNode = display.newNode()
    detailNode:size(detailNodeSize.width, detailNodeSize.height)
    detailNode:align(display.LEFT_TOP, icon:getPositionX(), descNode:getPositionY() - descNodeSize.height - 5)
    detailNode:addTo(leftNode)

    self:addTextArea(itemConfig.desc, 0, 0, detailNodeSize.width, detailNodeSize.height, display.LEFT_BOTTOM, detailNode)
end

ItemInfoView.initRight = function(self, itemConfig)
    local width = ViewWidth * 0.35
    local height = ViewHeight
    local rightNode = display.newNode()
    rightNode:size(width, height)
    rightNode:align(display.RIGHT_BOTTOM, ViewWidth, 0)
    rightNode:addTo(self.bg)

    local adaptArmyNodeSize = cc.size(width, height * 0.8)
    local adaptArmyNode = display.newNode()
    adaptArmyNode:size(adaptArmyNodeSize.width, adaptArmyNodeSize.height)
    adaptArmyNode:align(display.LEFT_TOP, 0, height - 10)
    adaptArmyNode:addTo(rightNode)
    if itemConfig.type == "consume" then
        self:addGroupRect("可使用的部队", adaptArmyNode)
    else
        self:addGroupRect("可装备的部队", adaptArmyNode)
    end

    local y = adaptArmyNodeSize.height - FontSmallSize * 2
    table.walk(ArmyMappingInfo["可显示兵种"], function(armyType)
        local color = FontGrayColor
        if itemConfig.armyTypeLimit then
            if table.indexof(itemConfig.armyTypeLimit, armyType) then
                color = FontColor
            end
        else
            color = FontColor
        end

        local armyTypeName = InfoUtil.getArmyConfig(armyType).name
        local armyLabel = display.newTTFLabel({text = armyTypeName, size = FontSmallSize, font = FontName, color = color})
        armyLabel:align(display.CENTER, adaptArmyNodeSize.width / 2, y)
        armyLabel:addTo(adaptArmyNode)

        y = y - FontSmallSize
    end)

    local closeButton = cc.ui.UIPushButton.new({normal = ResPrefix .. "button.png"}, {scale9 = true})
    closeButton:setButtonSize(width * 0.7, width * 0.3)
    closeButton:setButtonLabel("normal", display.newTTFLabel({text = "关闭", font = FontName, size = FontSmallSize, color = FontColor}))
    closeButton:onButtonClicked(function(event)
        self:removeSelf()
    end)
    closeButton:align(display.CENTER_BOTTOM, width / 2, 5)
    closeButton:addTo(rightNode)
end

return ItemInfoView