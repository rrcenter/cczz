--[[
    AI-攻击武将
    朝着指定武将移动，指定武将所在的地点是最终目的地，该目的地会随着指定武将的移动而改变。
    攻击范围无法攻击到指定目标，则攻击攻击范围内可以攻击到的敌人，无敌人，则像指定目标移动。
    AI如果残血，如果移动范围内存在恢复地形，则向恢复地形移动，没有则保持原ai处理。
    如果指定武将被击退，则转为主动攻击类型
--]]

local AiGongJiWuJiang = class("AiGongJiWuJiang")

AiGongJiWuJiang.setGeneral = function(self, general)
    self.general = general
end

AiGongJiWuJiang.run = function(self)
    if self.general:isInjury() then
        -- AI如果残血，如果移动范围内存在恢复地形，则向恢复地形移动，没有则保持原ai处理。
        local recoverTile = self.general:getAllRecoverTiles()[1]
        if recoverTile then
            return {AiUtils.genMoveCmd(self.general, {moveRow = recoverTile.tile.row, moveCol = recoverTile.tile.col})}
        end
    end

    local fixTargetInfo
    local fixTarget = self.general:getFixGeneral()
    local moveRange = self.general:getMoveRange(true)
    local tileIndex = table.findIf(moveRange, function(tile)
        local targetInfos = self.general:getAttackAllHitTargets(tile.row, tile.col)
        local targetIndex = table.findIf(targetInfos, function(targetInfo)
            return targetInfo.mainTarget == fixTarget
        end)

        if targetIndex then
            fixTargetInfo = targetInfos[targetIndex]
            return true
        end
    end)

    if fixTargetInfo then
        local toRow, toCol = moveRange[tileIndex].row, moveRange[tileIndex].col
        if toRow == self.general:getRow() and toCol == self.general:getCol() then
            return {AiUtils.genAttackCmd(self.general, {targetInfo = fixTargetInfo})}
        end

        local moveCmd = AiUtils.genMoveCmd(self.general, {moveRow = toRow, moveCol = toCol})
        local attackCmd = AiUtils.genAttackCmd(self.general, {targetInfo = fixTargetInfo})
        return {moveCmd, attackCmd}
    else
        -- 攻击范围内有敌人，则攻击敌人，无则朝攻击目标移动
        local actionCost = AiUtils.newCalcTileCost(self.general)
        if actionCost.cost > 0 then
            local actionCmds = {}
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

            return actionCmds
        else
            local toRow, toCol = self.general:getNearestTile(fixTarget)
            if not toRow then
                return {AiUtils.genNoneCmd()}
            end

            local moveTile = AiUtils.calcMoveTile(self.general, toRow, toCol)
            if not moveTile then
                return {AiUtils.genNoneCmd()}
            end

            return {AiUtils.genMoveCmd(self.general, moveTile)}
        end
    end
end

return AiGongJiWuJiang