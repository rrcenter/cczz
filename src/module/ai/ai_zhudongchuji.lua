--[[
    AI-主动出击
    物理攻击区域内无敌方单位时，会主动朝最近的敌方单位移动。
    AI如果残血，如果移动范围内存在恢复地形，则向恢复地形移动，没有则保持原ai处理。
--]]

local AiZhuDongChuji = class("AiZhuDongChuji")

AiZhuDongChuji.setGeneral = function(self, general)
    self.general = general
end

AiZhuDongChuji.run = function(self)
    if self.general:isInjury() then
        -- AI如果残血，如果移动范围内存在恢复地形，则向恢复地形移动，没有则保持原ai处理。
        local recoverTile = self.general:getAllRecoverTiles()[1]
        if recoverTile then
            return {AiUtils.genMoveCmd(self.general, {moveRow = recoverTile.tile.row, moveCol = recoverTile.tile.col})}
        end
    end

    local actionCmds = {}
    local actionCost = AiUtils.newCalcTileCost(self.general)
    if actionCost.cost == 0 then
            -- 找一个最近的目标，向其移动
        local target = self.general:getNearestOppotenter()
        local toRow, toCol = self.general:getNearestTile(target)
        if not toRow then
            return {AiUtils.genNoneCmd()}
        end

        local moveTile = AiUtils.calcMoveTile(self.general, toRow, toCol)
        if not moveTile then
            return {AiUtils.genNoneCmd()}
        end

        printInfo("%s攻击范围内无敌人，找最近的一个目标为%s(%d, %d)，向其移动", self.general:getName(), target:getName(), toRow, toCol)
        return {AiUtils.genMoveCmd(self.general, moveTile)}
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

return AiZhuDongChuji