--[[
    AI-被动出击
    物理攻击区域内有敌方单位才会移动，法师也是这样判断。
    所谓物理攻击区域，是指一回合的移动范围内可以物理攻击到的所有区域。
    AI如果残血，如果移动范围内存在恢复地形，则向恢复地形移动，没有则保持原ai处理。
--]]

local AiBeiDongChuji = class("AiBeiDongChuji")

AiBeiDongChuji.setGeneral = function(self, general)
    self.general = general
end

AiBeiDongChuji.run = function(self)
    if self.general:isInjury() then
        -- AI如果残血，如果移动范围内存在恢复地形，则向恢复地形移动，没有则保持原ai处理
        local recoverTile = self.general:getAllRecoverTiles()[1]
        if recoverTile then
            return {AiUtils.genMoveCmd(self.general, {moveRow = recoverTile.tile.row, moveCol = recoverTile.tile.col})}
        end
    end

    local actionCmds = {}
    local actionCost = AiUtils.newCalcTileCost(self.general)
    if actionCost.cost == 0 then
        actionCmds[1] = AiUtils.genNoneCmd()
    else
        if actionCost.targetInfo.moveRow ~= self.general:getRow() or actionCost.targetInfo.moveCol ~= self.general:getCol() then
            local moveCmd = AiUtils.genMoveCmd(self.general, actionCost.targetInfo)
            table.insert(actionCmds, moveCmd)
        end

        if actionCost.type == "magic" then
            local magicCmd = AiUtils.genMagicCmd(self.general, actionCost)
            table.insert(actionCmds, magicCmd)
        else
            local attackCmd = AiUtils.genAttackCmd(self.general, actionCost)
            table.insert(actionCmds, attackCmd)
        end
    end

    return actionCmds
end

return AiBeiDongChuji