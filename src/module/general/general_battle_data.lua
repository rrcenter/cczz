--[[
    武将战斗数据
        ai = {type, fixTarget, fixTiles}
        row, col, dir
        hpCur
        mpCur
        isActionDone
        isDie
        scriptIndex
        statuses
--]]

local StatusMgr = import("..char.status_mgr")

local GeneralBattleData = class("GeneralBattleData")

GeneralBattleData.ctor = function(self, uid, side, data)
    self:setId(uid)
    self:setSide(side)
    self:setHide(data.isHide or false)
    self:setDie(data.isDie or false)
    self:setIsActionDone(data.isActionDone or false)
    self:setIsKeyGeneral(data.isKeyGeneral or false)
    self:setIsShowRetreatWords(data.isShowRetreatWords or true)
    self:setRowAndCol(data.row, data.col)
    self:setDir(data.dir)
    self:setScriptIndex(data.scriptIndex)
    self:setAiType(data.aiType, data.aiArgs or {})
    self:initHpAndMp(data)
    self:initStatusMgr(data)
end

GeneralBattleData.setId = function(self, uid)
    self.id = uid
end

GeneralBattleData.getId = function(self)
    return self.id
end

GeneralBattleData.initHpAndMp = function(self, data)
    self.hpCur = data.hpCur or self:getMaxHp()
    self.mpCur = data.mpCur or self:getMaxMp()
end

GeneralBattleData.initStatusMgr = function(self, data)
    self.statusMgr = StatusMgr.new(self)

    if not data.statuses then
        return
    end

    table.walk(data.statuses, function(statusInfo)
        self.statusMgr:addStatus(statusInfo.id, statusInfo.aliveRounds)
    end)
end

GeneralBattleData.getStatusMgr = function(self)
    return self.statusMgr
end

GeneralBattleData.hasStatus = function(self, statusId)
    return self:getStatusMgr():hasStatus(statusId)
end

GeneralBattleData.setAiType = function(self, aiType, aiArgs)
    self._aiType = aiType

    if aiType == "攻击武将" or aiType == "跟随武将" then
        self:setFixGeneral(aiArgs.target)
    elseif aiType == "到指定点" or aiType == "逃至指定点" then
        self:setFixTiles({row = aiArgs.fixRow, col = aiArgs.fixCol})
    end
end

GeneralBattleData.getAiType = function(self)
    return self._aiType
end

GeneralBattleData.getAiArgs = function(self)
    local aiArgs = {}
    aiArgs.fixTarget = self:getFixGeneral()

    local fixTiles = self:getFixTiles()
    if #fixTiles > 0 then
        aiArgs.fixRow = fixTiles[1].row
        aiArgs.fixCol = fixTiles[1].col
    end

    return aiArgs
end

-- 设置固定攻击武将，ai使用的
GeneralBattleData.setFixGeneral = function(self, target)
    self._fixGeneral = target
end

-- 获取固定攻击的武将
GeneralBattleData.getFixGeneral = function(self)
    return self._fixGeneral
end

-- 设置指定方块群作为移动地点
GeneralBattleData.setFixTiles = function(self, tiles)
    self._fixTiles = tiles
end

-- 获取指定移动地点
GeneralBattleData.getFixTiles = function(self)
    return self._fixTiles or {}
end

GeneralBattleData.isDie = function(self)
    return self._isDie
end

GeneralBattleData.setDie = function(self, isDie)
    --!! 发射死亡事件
    self._isDie = isDie
end

GeneralBattleData.setHide = function(self, isHide)
    self._isHide = isHide
end

GeneralBattleData.isHide = function(self)
    return self._isHide
end

GeneralBattleData.setIsKeyGeneral = function(self, isKeyGeneral)
    self._isKeyGeneral = isKeyGeneral
end

GeneralBattleData.isKeyGeneral = function(self)
    return self._isKeyGeneral
end

GeneralBattleData.isShowRetreatWords = function(self)
    return self._isShowRetreatWords
end

GeneralBattleData.setIsShowRetreatWords = function(self, isShowRetreatWords)
    self._isShowRetreatWords = isShowRetreatWords
end

GeneralBattleData.getRow = function(self)
    return self._row
end

GeneralBattleData.getCol = function(self)
    return self._col
end

GeneralBattleData.setRowAndCol = function(self, row, col)
    self._row, self._col = row, col
end

GeneralBattleData.setScriptIndex = function(self, scriptIndex)
    self._scriptIndex = scriptIndex
end

GeneralBattleData.getScriptIndex = function(self)
    return self._scriptIndex
end

GeneralBattleData.setIsActionDone = function(self, isActionDone)
    self._isActionDone = isActionDone
end

GeneralBattleData.isActionDone = function(self)
    return self._isActionDone
end

GeneralBattleData.getDir = function(self)
    return self._dir
end

GeneralBattleData.setDir = function(self, dir)
    self._dir = dir or self._dir
end

GeneralBattleData.setAttacker = function(self, attacker)
    self._attacker = attacker
end

GeneralBattleData.getAttacker = function(self)
    return self._attacker
end

GeneralBattleData.setSide = function(self, side)
    self._side = side
end

GeneralBattleData.getSide = function(self)
    return self._side
end

GeneralBattleData.isFriend = function(self)
    return self._side == "friend"
end

GeneralBattleData.isEnemy = function(self)
    return self._side == "enemy"
end

GeneralBattleData.isPlayer = function(self)
    return self._side == "player"
end

-- 实际最大血量这里提供一个接口来获取，真正数据并不存储在这里
GeneralBattleData.getMaxMp = function(self)
    return GeneralDataMgr.getProp(self:getId(), GeneralDataConst.PROP_MPMAX)
end

GeneralBattleData.getMaxHp = function(self)
    return GeneralDataMgr.getProp(self:getId(), GeneralDataConst.PROP_HPMAX)
end

GeneralBattleData.getCurrentHp = function(self)
    return self.hpCur
end

GeneralBattleData.getCurrentMp = function(self)
    return self.mpCur
end

-- 武将是否残血，30%以下即残血
GeneralBattleData.isInjury = function(self)
    return self:getCurrentHp() < self:getMaxHp() * 0.3
end

GeneralBattleData.addMp = function(self, value)
    self:subMp(-value)
    if self.mpCur > self:getMaxMp() then
        self.mpCur = self:getMaxMp()
    end
end

GeneralBattleData.subMp = function(self, value)
    self.mpCur = self.mpCur - value
    if self.mpCur < 0 then
        self.mpCur = 0
    end
end

GeneralBattleData.subHp = function(self, value)
    self.hpCur = self.hpCur - value
    if self.hpCur <= 0 then
        self.hpCur = 0

        self:setDie(true)
    end

    if self.hpCur >= self:getMaxHp() then
        self.hpCur = self:getMaxHp()
    end
end

--[[
    武将生成保存时的数据表
    武将buffer
    武将是否行动
    当前hp
    当前mp
    位置
    朝向
    职业index
    非player记录:ai类型
    非player记录:ai额外参数
--]]
GeneralBattleData.getSaveData = function(self)
    local saveData = {}
    saveData.uid          = self:getId()
    saveData.statuses     = self:getStatusMgr():getSaveData()
    saveData.isActionDone = self:isActionDone()
    saveData.hpCur        = self:getCurrentHp()
    saveData.mpCur        = self:getCurrentMp()
    saveData.scriptIndex  = self:getScriptIndex()
    saveData.isDead       = self:isDie()
    saveData.row          = self:getRow()
    saveData.col          = self:getCol()
    saveData.dir          = self:getDir()
    saveData.isHide       = self:isHide()

    if not self:isPlayer() then
        saveData.aiType = self:getAiType()
        saveData.aiArgs = self:getAiArgs()
    end

    return saveData
end

return GeneralBattleData