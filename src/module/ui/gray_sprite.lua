--[[
    灰度图
        其实应该有的，不过这里就是简便处理下，可以变灰和还原
--]]

local GraySprite = class("GraySprite", function(filename, x, y)
    return display.newSprite(filename, x, y, {class = cc.FilteredSpriteWithOne})
end)

-- 还原成正常颜色
GraySprite.normal = function(self)
    if self.isGray then
        self.isGray = false

        self:clearFilter()
    end
end

-- 变灰
GraySprite.gray = function(self)
    if not self.isGray then
        self.isGray = true

        local grayFilter = filter.newFilter("GRAY")
        self:setFilter(grayFilter)
    end
end

return GraySprite
