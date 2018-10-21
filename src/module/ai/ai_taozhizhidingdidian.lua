--[[
    AI-逃至指定地点
    朝着指定点移动，但不会攻击和使用策略。
    AI如果到了指定点，AI类型会变更为被动出击。
--]]

local AiTaoZhiZhiDingDiDian = class("AiTaoZhiZhiDingDiDian")

AiTaoZhiZhiDingDiDian.setGeneral = function(self, general)
    self.general = general
end

AiTaoZhiZhiDingDiDian.run = function(self)
    local findTile
    local fixTiles = self.general:getFixTiles()
    table.findIf(fixTiles, function(tile)
        local moveTile = AiUtils.calcMoveTile(self.general, tile.row, tile.col, handler(self, self.moveToDestination))
        if moveTile then
            findTile = moveTile
            return true
        end
    end)

    if findTile then
        return {AiUtils.genMoveCmd(self.general, findTile)}
    end

    return {AiUtils.genNoneCmd()}
end

AiTaoZhiZhiDingDiDian.moveToDestination = function(self)
    printInfo("%s逃到了指定地点，切回被动攻击AI", self.general:getName())
    self.general:setAiType("被动出击")
    self.general:setFixTiles({})
end

return AiTaoZhiZhiDingDiDian