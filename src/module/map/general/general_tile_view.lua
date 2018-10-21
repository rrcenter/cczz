--[[
    武将在地形时的介绍界面
        大小为2*4个方块大小
        主要内容是，武将等级，hp，mp和敌我说明，地形对武将的加成（正数或负数）

    自定义内容：
    player
    经验     xxx 地形名 加成数值

    friend
    友军    地形名 加成数值

    enemy
    敌军    地形名 加成数值
--]]

local GeneralViewBasic = import(".general_view_basic")

local ViewWidth  = MapConst.BLOCK_WIDTH * 4
local ViewHeight = MapConst.BLOCK_HEIGHT * 2

local GeneralTileView = class("GeneralTileView", function()
    return GeneralViewBasic.new()
end)

GeneralTileView.ctor = function(self)
    -- 第四行 描述信息，根据阵营不同显示不同
    local descLabel = display.newTTFLabel({text = "Exp", size = FontSize, font = FontName})
    descLabel:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, ViewHeight * 0.15)
    descLabel:addTo(self)
    self.descLabel = descLabel

    -- 第四行 经验值信息
    local expLabel = display.newTTFLabel({text = "100", size = FontSize, font = FontName, color = FontWhiteColor})
    expLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 1.5, ViewHeight * 0.15)
    expLabel:hide()
    expLabel:addTo(self)
    self.expLabel = expLabel

    -- 第四行 地形信息
    local tileNameLabel = display.newTTFLabel({text = "草地", size = FontSize, font = FontName, color = MapViewConst.GENERAL_TILE_COLOR})
    tileNameLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 2.2, ViewHeight * 0.15)
    tileNameLabel:addTo(self)
    self.tileNameLabel = tileNameLabel

    -- 第四行 地形加成信息
    local tileAdditionLabel = display.newTTFLabel({text = "100%", size = FontSize, font = FontName})
    tileAdditionLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 3, ViewHeight * 0.15)
    tileAdditionLabel:addTo(self)
    self.tileAdditionLabel = tileAdditionLabel
end

GeneralTileView.initFromGeneral = function(self, general)
    self:setNameString(general:getName(), general:getSide())

    local armyTypeText = string.format("%s Lv %d", general:getProfessionName(), general:getLevel())
    self.armyTypeLabel:setString(armyTypeText)

    local maxHp = general:getMaxHp()
    local currentHp = general:getCurrentHp()
    self.hpLabel:setString(string.format("%d / %d", currentHp, maxHp))
    self.hpProgress:setPercent(currentHp / maxHp * 100)

    local maxMp = general:getMaxMp()
    local currentMp = general:getCurrentMp()
    self.mpLabel:setString(string.format("%d / %d", currentMp, maxMp))
    self.mpProgress:setPercent(currentMp / maxMp * 100)

    self.tileNameLabel:setString(general:getTileName())
    self.tileAdditionLabel:setString(general:getTileAddition() .. "%")

    if general:isPlayer() then
        self:initPlayer(general)
    elseif general:isFriend() then
        self:initFriend(general)
    elseif general:isEnemy() then
        self:initEnemy(general)
    end
end

GeneralTileView.initPlayer = function(self, general)
    self.descLabel:setString("Exp")
    self.descLabel:setColor(FontWhiteColor)
    self.expLabel:setString(general:getCurrentExp())
    self.expLabel:show()
end

GeneralTileView.initFriend = function(self, general)
    self.expLabel:hide()
    self.descLabel:setString("友军")
    self.descLabel:setColor(FontOrangeColor)
end

GeneralTileView.initEnemy = function(self, general)
    self.expLabel:hide()
    self.descLabel:setString("敌军")
    self.descLabel:setColor(FontLightBlueColor)
end

return GeneralTileView