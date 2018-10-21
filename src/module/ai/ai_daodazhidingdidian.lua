--[[
    AI-到达指定地点
    朝着指定点移动，指定点是最终目的地。
    AI如果残血，如果移动范围内存在恢复地形，则向恢复地形移动，没有则保持原ai处理。
    AI如果到了指定点，AI类型会变更为被动出击。
--]]

local AiBeiDongChuji = import(".ai_beidongchuji")

local AiDaoDaZhiDingDiDian = class("AiDaoDaZhiDingDiDian")

AiDaoDaZhiDingDiDian.setGeneral = function(self, general)
    self.general = general
end

AiDaoDaZhiDingDiDian.run = function(self)
    if self.general:isInjury() then
        -- AI如果残血，如果移动范围内存在恢复地形，则向恢复地形移动，没有则保持原ai处理。
        local recoverTile = self.general:getAllRecoverTiles()[1]
        if recoverTile then
            return {AiUtils.genMoveCmd(self.general, {moveRow = recoverTile.tile.row, moveCol = recoverTile.tile.col})}
        end
    end

    local findTile
    local fixTiles = self.general:getFixTiles()
    table.findIf(fixTiles, function(tile)
        local moveTile = AiUtils.calcMoveTile(self.general, tile.row, tile.col, handler(self, self.moveToDestination))
        if moveTile then
            findTile = moveTile
            return true
        end
    end)

    if not findTile.canMoveToDestination then
        printInfo("一轮回合内达到不了指定地点，先判断区域内有无敌人，无敌人则朝指定地点移动")
        local tempAi = AiBeiDongChuji.new() -- 借用下被动出击的逻辑
        tempAi:setGeneral(self.general)

        local actionCmds = tempAi:run()
        if actionCmds[1].cmd ~= "none" then
            return actionCmds
        end
    end

    return {AiUtils.genMoveCmd(self.general, findTile)}
end

AiDaoDaZhiDingDiDian.moveToDestination = function(self)
    printInfo("%s到达了指定地点，切回被动攻击AI", self.general:getName())
    self.general:setAiType("被动出击")
    self.general:setFixTiles({})
end

return AiDaoDaZhiDingDiDian