--[[
    目前有好几种武将预览界面类似界面
    除了底部以外，其他基本相同，将公共部位抽离出来

    武将名  兵种类型 Lv. 1
    hp图片       进度条
    mp图片       进度条
    自定义的一行
--]]

local ViewWidth    = MapConst.BLOCK_WIDTH * 4
local ViewHeight   = MapConst.BLOCK_HEIGHT * 2
local BgColor      = LightBlackColor
local HpMpWidth    = ViewWidth * 0.6
local HpMpHeight   = 8
local HpMpViewRect = cc.rect(0, 0, HpMpWidth, HpMpHeight)

local GeneralViewBasic = class("GeneralViewBasic", function()
    return display.newNode()
end)

GeneralViewBasic.ctor = function(self, w, h)
    w = w or ViewWidth
    h = h or ViewHeight

    self:align(display.LEFT_BOTTOM)
    self:size(w, h)

    display.newRect(cc.rect(0, 0, w, h), {fillColor = BgColor, borderWidth = 0}):addTo(self)

    -- 第一行 名字
    local nameLabel = cc.ui.UILabel.new({text = "名字", size = FontSize, font = FontName})
    nameLabel:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, h * 0.85)
    nameLabel:addTo(self)
    self.nameLabel = nameLabel

    -- 第一行 兵种类型
    local armyTypeLabel = display.newTTFLabel({text = "兵种类型 Lv 1", size = FontSize, font = FontName})
    armyTypeLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 2.5, h * 0.85)
    armyTypeLabel:addTo(self)
    self.armyTypeLabel = armyTypeLabel

    local createProgress = function(image, x, y, parent, zorder)
        local progress = cc.ui.UILoadingBar.new({
            scale9 = true,
            capInsets = cc.rect(0, 0, 8, 8),
            image = "ccz/general/tile_view/" .. image .. ".png",
            viewRect = HpMpViewRect,
            percent = 0,
        })
        progress:align(display.CENTER, x, y)
        progress:addTo(parent, zorder)

        return progress
    end

    -- 第二行 HP
    self.hpNode = display.newNode()
    self.hpNode:addTo(self)

    local hpSprite = display.newSprite("ccz/general/tile_view/hp.png")
    hpSprite:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, h * 0.55)
    hpSprite:addTo(self.hpNode)

    local hpX = MapConst.BLOCK_WIDTH * 2.5 / 2
    local hpY = hpSprite:getPositionY()
    self.healHpProgress = createProgress("heal_fg", hpX, hpY, self.hpNode, 1)
    self.hurtHpProgress = createProgress("hurt_fg", hpX, hpY, self.hpNode, 1)
    self.hpProgress = createProgress("hp_fg", hpX, hpY, self.hpNode, 2)

    -- 生成一个黑色进度条底图
    display.newRect(cc.rect(self.hpProgress:getPositionX(), self.hpProgress:getPositionY(), HpMpWidth, HpMpHeight), {fillColor = BlackColor, borderWidth = 0}):addTo(self.hpNode)

    local hpLabel = display.newTTFLabel({text = "100 / 100", size = FontSize, font = FontName})
    hpLabel:align(display.CENTER_BOTTOM,  MapConst.BLOCK_WIDTH * 2.5, hpSprite:getPositionY())
    hpLabel:addTo(self.hpNode, 3)
    self.hpLabel = hpLabel

    -- 第三行 MP
    self.mpNode = display.newNode()
    self.mpNode:addTo(self)

    local mpSprite = display.newSprite("ccz/general/tile_view/mp.png")
    mpSprite:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, h * 0.35)
    mpSprite:addTo(self.mpNode)

    local mpX = MapConst.BLOCK_WIDTH * 2.5 / 2
    local mpY = mpSprite:getPositionY()
    self.healMpProgress = createProgress("heal_fg", mpX, mpY, self.mpNode, 1)
    self.hurtMpProgress = createProgress("hurt_fg", mpX, mpY, self.mpNode, 1)
    self.mpProgress = createProgress("mp_fg", mpX, mpY, self.mpNode, 2)

    -- 生成一个黑色进度条底图
    display.newRect(cc.rect(self.mpProgress:getPositionX(), mpSprite:getPositionY(), HpMpWidth, HpMpHeight), {fillColor = BlackColor, borderWidth = 0}):addTo(self.mpNode)

    local mpLabel = display.newTTFLabel({text = "40 / 40", size = FontSize, font = FontName})
    mpLabel:align(display.CENTER_BOTTOM, MapConst.BLOCK_WIDTH * 2.5, mpSprite:getPositionY())
    mpLabel:addTo(self.mpNode, 3)
    self.mpLabel = mpLabel
end

GeneralViewBasic.setNameString = function(self, name, side)
    local NAME_COLOR_MAPS = {
        player = FontRedColor,
        enemy  = FontBlueColor,
        friend = FontOrangeColor,
    }

    self.nameLabel:setString(name)
    if device.platform ~= "windows" and device.platform ~= "mac" then
        self.nameLabel:enableOutline(NAME_COLOR_MAPS[side], 2)
    else
        self.nameLabel:setColor(NAME_COLOR_MAPS[side])
    end
end

return GeneralViewBasic