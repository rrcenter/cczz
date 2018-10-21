--[[
    移动范围层
--]]

local MoveBox = import(".move_box")

local MoveRangeLayer = class("MoveRangeLayer", function()
    return display.newNode()
end)

MoveRangeLayer.ctor = function(self, general, path)
    table.walk(path, function(tile)
        local moveBox = MoveBox.new(general, tile.row, tile.col)
        moveBox:pos(MapUtils.getPosByRowAndCol(tile.row, tile.col))
        moveBox:addTo(self)
    end)

    self.general = general
    self:initAttakRange() -- 仅仅起一个显示作用，真正的攻击范围实现在AttackRangeLayer中

    self:setNodeEventEnabled(true)
end

MoveRangeLayer.onExit = function(self)
    table.walk(self.attackRangeBoxes, function(box)
        box:removeSelf()
    end)
end

MoveRangeLayer.initAttakRange = function(self)
    self.attackRangeBoxes = {}
    local attackRange = self.general:getAttackRange()
    table.walk(attackRange, function(tile)
        local general = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
        if general then
            if general ~= self.general then
                table.insert(self.attackRangeBoxes, general:addSpriteBox("ccz/map/box/red_box.png"))
            end
        else
            local attackBox = display.newSprite("ccz/map/box/red_box.png")
            attackBox:align(display.LEFT_BOTTOM, MapUtils.getPosByRowAndCol(tile.row, tile.col))
            attackBox:addTo(self)
            table.insert(self.attackRangeBoxes, attackBox)
        end
    end)
end

MoveRangeLayer.hideAttackRange = function(self)
    table.walk(self.attackRangeBoxes, function(box)
        box:hide()
    end)
end

return MoveRangeLayer