--[[
    攻击范围层，这里会产生一个遮罩，屏蔽攻击范围外的点击
--]]

local AttackBox = import(".attack_box")

local AttackRangeLayer = class("AttackRangeLayer", function()
    return display.newNode()
end)

AttackRangeLayer.ctor = function(self, general)
    self.general = general
    self.row = general:getRow()
    self.col = general:getCol()

    local attackRange = general:getAttackRange()
    table.walk(attackRange, function(tile)
        local attackBox = AttackBox.new(general, tile.row, tile.col)
        attackBox:pos(MapUtils.getPosByRowAndCol(tile.row, tile.col))
        attackBox:addTo(self)
    end)

    self:setNodeEventEnabled(true)
end

AttackRangeLayer.onEnter = function(self)
    printInfo("进入MapMagicRangeLayer，准备注册事件")

    self.handlers = {
        [EventConst.TOUCH_ATTACK_BOX] = handler(self, self.initHitRange),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

AttackRangeLayer.onExit = function(self)
    printInfo("离开MapMagicRangeLayer，准备反注册事件")

    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil

    if self.hitRangeBoxes then
        table.walk(self.hitRangeBoxes, function(box)
            box:removeSelf()
        end)
    end
end

-- 默认不初始化攻击绿框，因为不好计算出现在哪里
AttackRangeLayer.initHitRange = function(self, row, col)
    local hitRange = self.general:getHitRange(row, col)
    if not hitRange then
        return
    end

    if self.hitRangeBoxes then
        table.walk(self.hitRangeBoxes, function(box)
            box:removeSelf()
        end)
    end
    self.hitRangeBoxes = {}

    for _, v in pairs(hitRange) do
        local target = MapUtils.getGeneralByRowAndCol(v.row, v.col)
        if target then
            table.insert(self.hitRangeBoxes, target:addSpriteBox("ccz/map/box/green_box.png"))
        else
            local hitBox = display.newSprite("ccz/map/box/green_box.png")
            hitBox:align(display.LEFT_BOTTOM, MapUtils.getPosByRowAndCol(v.row, v.col))
            hitBox:addTo(self)
            table.insert(self.hitRangeBoxes, hitBox)
        end
    end
end

return AttackRangeLayer