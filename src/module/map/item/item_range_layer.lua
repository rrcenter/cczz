--[[
    道具使用范围层，这里会产生一个遮罩，屏蔽范围外的点击
--]]

local ItemBox = import(".item_box")

local ItemRangeLayer = class("ItemRangeLayer", function()
    return display.newNode()
end)

ItemRangeLayer.ctor = function(self, general, itemId)
    local itemRange = AttackRangeUtils.getAttackRange("RANGE_RECT_8", general:getRow(), general:getCol(), general:getRow(), general:getCol())
    table.walk(itemRange, function(tile)
        local ItemBox = ItemBox.new(general, itemId, tile.row, tile.col)
        ItemBox:pos(MapUtils.getPosByRowAndCol(tile.row, tile.col))
        ItemBox:addTo(self)
    end)
end

return ItemRangeLayer