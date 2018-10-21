--[[
    策略攻击范围层，这里会产生一个遮罩，屏蔽范围外的点击
--]]

local MagicBox = import(".magic_box")

local MagicRangeLayer = class("MagicRangeLayer", function()
    return display.newNode()
end)

MagicRangeLayer.ctor = function(self, general, magicConfig)
    self.magicConfig = magicConfig
    self.general = general
    self.row = general:getRow()
    self.col = general:getCol()

    local magicRange = general:getMagicRange(magicConfig)
    table.walk(magicRange, function(tile)
        local magicBox = MagicBox.new(general, magicConfig, tile.row, tile.col)
        magicBox:pos(MapUtils.getPosByRowAndCol(tile.row, tile.col))
        magicBox:addTo(self)
    end)

    if magicConfig.hitRangeType then
        self:initAttackRange(self.row, self.col)
    end

    if magicConfig.outStatus then
        self:initGeneralStatus(magicConfig.outStatus, magicRange)
    end

    self:setNodeEventEnabled(true)
end

MagicRangeLayer.onEnter = function(self)
    printInfo("进入MapMagicRangeLayer，准备注册事件")

    self.handlers = {
        [EventConst.TOUCH_MAGIC_BOX] = handler(self, self.initAttackRange),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

MagicRangeLayer.onExit = function(self)
    printInfo("离开MapMagicRangeLayer，准备反注册事件")

    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil

    if self.attackRangeBoxes then
        table.walk(self.attackRangeBoxes, function(box)
            box:removeSelf()
        end)
    end

    if self.statusIcons then
        table.walk(self.statusIcons, function(statusIcon)
            statusIcon:removeSelf()
        end)
    end
end

-- 如果当前的策略为属性增减策略，则显示出攻击范围内用有次属性状态的icon
MagicRangeLayer.initGeneralStatus = function(self, statusId, magicRange)
    self.statusIcons = {}

    table.walk(magicRange, function(tile)
        local general = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
        if general and general:hasStatus(statusId) then
            local statusIcon = general:addStatusIconOnly(statusId)
            if statusIcon then
                table.insert(self.statusIcons, statusIcon)
            end
        end
    end)
end

MagicRangeLayer.initAttackRange = function(self, row, col)
    local magicHitRange = self.general:getMagicHitRange(self.magicConfig, row, col, self.row, self.col)
    if not magicHitRange then
        return
    end

    if self.attackRangeBoxes then
        table.walk(self.attackRangeBoxes, function(box)
            box:removeSelf()
        end)
    end
    self.attackRangeBoxes = {}

    table.walk(magicHitRange, function(tile)
        local general = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
        if general then
            table.insert(self.attackRangeBoxes, general:addSpriteBox("ccz/map/box/green_box.png"))
        else
            local attackBox = display.newSprite("ccz/map/box/green_box.png")
            attackBox:align(display.LEFT_BOTTOM, MapUtils.getPosByRowAndCol(tile.row, tile.col))
            attackBox:addTo(self)
            table.insert(self.attackRangeBoxes, attackBox)
        end
    end)
end

return MagicRangeLayer