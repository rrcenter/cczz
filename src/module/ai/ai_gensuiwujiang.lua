--[[
    AI-跟随武将
    朝着指定武将移动，但不会攻击和使用策略。
--]]

local AiGenSuiWuJiang = class("AiGenSuiWuJiang")

AiGenSuiWuJiang.setGeneral = function(self, general)
    self.general = general
end

AiGenSuiWuJiang.run = function(self)
    local followGeneral = self.general:getFixGeneral()
    local toRow, toCol = self.general:getNearestTile(followGeneral)
    if not toRow then
        return {AiUtils.genNoneCmd()}
    end

    local moveTile = AiUtils.calcMoveTile(self.general, toRow, toCol)
    if not moveTile then
        return {AiUtils.genNoneCmd()}
    end

    return {AiUtils.genMoveCmd(self.general, moveTile)}
end

return AiGenSuiWuJiang