--[[
    地形块的介绍界面
        大小为2*3个方块大小
        主要内容是，点击方块的截图，点中方块的名字，点中方块支持的策略
--]]

local ViewWidth  = MapConst.BLOCK_WIDTH * 3
local ViewHeight = MapConst.BLOCK_HEIGHT * 2

local TileView = class("TileView", function()
    return display.newNode()
end)

TileView.ctor = function(self)
    self:align(display.LEFT_BOTTOM)
    self:size(ViewWidth, ViewHeight)

    local rectNode = display.newRect(cc.rect(0, 0, ViewWidth, ViewHeight), {fillColor = LightBlackColor, borderColor = LightBlackColor})
    rectNode:addTo(self)

    local tileSprite = display.newSprite()
    tileSprite:align(display.LEFT_TOP, 10, ViewHeight - 10)
    tileSprite:addTo(self)
    self.tileSprite = tileSprite

    local tileNameLabel = cc.ui.UILabel.new({text = "测试", size = FontSize, font = FontName})
    tileNameLabel:align(display.LEFT_TOP, 70, ViewHeight - 15)
    tileNameLabel:addTo(self)
    self.tileNameLabel = tileNameLabel

    local cannotMoveLabel = cc.ui.UILabel.new({text = "无法移动", size = FontSize, font = FontName, color = FontGrayColor})
    cannotMoveLabel:align(display.LEFT_TOP, 70, ViewHeight - 35)
    cannotMoveLabel:hide()
    cannotMoveLabel:addTo(self)
    self.cannotMoveLabel = cannotMoveLabel

    self.magicTypeSprites = {}
    local magicTypeSize = 16
    local offset = (ViewWidth - magicTypeSize * 4) / 5
    local x, y = offset + magicTypeSize / 2, 20
    local magicTypeSprites = {
        {name = "fire", res = "ccz/magic/type/fire.png"},
        {name = "water", res = "ccz/magic/type/water.png"},
        {name = "mountain", res = "ccz/magic/type/mountain.png"},
        {name = "wind", res = "ccz/magic/type/wind.png"},
    }
    for _, v in ipairs(magicTypeSprites) do
        local magicTypeSprite = GraySprite.new(v.res)
        magicTypeSprite:align(display.CENTER, x, y)
        magicTypeSprite:addTo(self)
        self.magicTypeSprites[v.name] = magicTypeSprite

        x = x + offset + magicTypeSize
    end
end

TileView.initFromTile = function(self, tileInfo, rect)
    UIUtils.captureScreen(rect, self.tileSprite)
    self.tileNameLabel:setString(tileInfo.name)

    if tileInfo.isCannotMove then
        self.cannotMoveLabel:show()
    else
        self.cannotMoveLabel:hide()
    end

    for name, sprite in pairs(self.magicTypeSprites) do
        if tileInfo[name .. "Support"] then
            sprite:normal()
        else
            sprite:gray()
        end
    end
end

return TileView