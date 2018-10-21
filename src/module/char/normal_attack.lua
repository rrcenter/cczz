--[[
    普通攻击流程
    1、攻击动画
        1.1、格挡（显示MISS）
        1.2、受伤（显示伤害，默认为白色）
    2、受伤结算
        2.1、enemy仅结算hp，mp（如果是龙鳞铠则用mp替换hp）
            2.1.1、enemy死亡（如果有，显示台词）
        2.2、player结算hp，mp（如果是龙鳞铠则用mp替换hp），防具exp
            2.2.1、player防具升级，player人物死亡（多个条件满足，按此顺序提示）
                2.2.1.1、player死亡显示撤退台词
    3、附加状态显示（可能是武器附加（流星锤附带混乱），也有可能是兵种特性（训熊师附带定身），这种一旦出现，概率为100%）
    4、攻击结算
        4.1、player则结算，武器exp，武将exp
            4.1.1、武器升级，武将升级
    5、如果可以反击，则进入反击流程（仅命中的主目标可以反击，非混乱状态且非死亡在攻击范围以内，则进行反击）
    6、同1、2、3、4
--]]

local NormalAttack = class("NormalAttack")

NormalAttack.ctor = function(self, attacker, mainTarget, targets, finalCallback, attackBackCount, doubleAttackCount, dieAgainAttackCount)
    EventMgr.triggerEvent(EventConst.ADD_NONTOUCH_LAYER, "NormalAttack流程Start")

    self.attacker            = attacker
    self.attackerRow         = attacker:getRow()
    self.attackerCol         = attacker:getCol()
    self.mainTarget          = mainTarget -- 主要受击对象
    self.mainTargetRow       = mainTarget:getRow()
    self.mainTargetCol       = mainTarget:getCol()
    self.targets             = targets -- 多个受击对象，主要考虑到了像是蛇矛和霹雳车的多重对象
    self.attackBackCount     = attackBackCount or 0 -- attackBackCount表示反击次数，默认为0，表示尚未反击
    self.doubleAttackCount   = doubleAttackCount or 0 -- doubleAttackCount表示连击的次数，默认为0
    self.dieAgainAttackCount = dieAgainAttackCount or 0 -- dieAgainAttackCount表示引导攻击的次数，默认为0
    self.finalCallback       = function()
        table.oneByOne(targets, function(target, nextCallback)
            target:checkDie(nextCallback)
        end, function()
            EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, "NormalAttack流程End")

            if attacker == MapUtils.getCurrentGeneral() then
                MapUtils.setCurrentGeneral(nil)
            end

            if finalCallback then
                finalCallback()
            end
        end)
    end

    -- 目标排序，行列号从低到高排
    table.sort(targets, function(l, r)
        local lIndex = l:getRow() * MapUtils.cols + l:getCol()
        local rIndex = r:getRow() * MapUtils.cols + r:getCol()
        return lIndex < rIndex
    end)

    self:handleCritAttack()
end

-- 处理攻击暴击情况
NormalAttack.handleCritAttack = function(self)
    local isCritAttack = self.attacker:isCrit(self.mainTarget)
    self.isCritAttack = isCritAttack
    local onComplete = function()
        local dir = MapUtils.calcDirection(self.attackerRow, self.attackerCol, self.mainTargetRow, self.mainTargetCol)
        self.attacker:showAnimation("attack", dir, function()
            if isCritAttack then
                printInfo("暴击高亮取消显示～")
                self.attacker.animation:clearFilter()
            end

            self.attacker:stand()
            self:showAnimation()
        end)
    end

    if isCritAttack then
        local critFunc = function()
            printInfo("暴击高亮显示～")
            self.attacker.animation:setFilter(filter.newFilter("EXPOSURE", {4}))
            onComplete()
        end

        if self.attacker:getCritWords() then
            EventMgr.triggerEvent(EventConst.CHAT_DIALOG, self.attacker, self.attacker:getCritWords(), critFunc)
        else
            critFunc()
        end
    else
        onComplete()
    end
end

-- 显示攻击和受击(格挡)动画
NormalAttack.showAnimation = function(self)
    self.targetsInfo = {}
    local targetDir = self.attacker:getOppositeDir()
    table.oneByOne(self.targets, function(target, nextCallback)
        local isHited = self.attacker:isHited(target)
        -- 暴击且道具含有防御致命一击的效果，则必定攻击不中
        local defenseCritAttack = self.isCritAttack and (target == self.mainTarget) and target:isCanDefenseCritAttack()
        -- 二次连击中第二次攻击必定防御，如果第一次攻击中出现连击，那么反击中doubleAttackCount也为1
        -- 所以需要判断下attackBackCount == 0，表示现在的攻击方就是原本的攻击者
        local defenseDoubleAttack = self.attackBackCount == 0 and self.doubleAttackCount > 0 and target:isCanDefenseDoubleAttack()

        if (not isHited) or defenseCritAttack or defenseDoubleAttack then
            local targetInfo = {
                general = target,
                hpDamge = 0,
                mpDamge = 0,
                isHited = false,
                fangjuExp = GeneralUtils.calcFangjuExp(target, self.attacker, false, false)
            }
            table.insert(self.targetsInfo, targetInfo)

            target:defense(targetDir, nextCallback)
        else
            local damgeInfo = GeneralUtils.calcAttackDamge(self.attacker, target)
            local getDamge = function(damgeLimit)
                local damge = damgeInfo.normalDamge
                if (target == self.mainTarget) and self.isCritAttack then
                    damge = damgeInfo.critDamge
                end

                if self.attackBackCount > 0 then
                    damge = math.floor(damge * 0.75)
                end

                damge = math.limitValue(damge, 1, damgeLimit)
                return damge
            end

            local hpDamge, mpDamge = 0, 0
            if damgeInfo.type == "mp" then
                mpDamge = getDamge(target:getCurrentMp())
            else
                hpDamge = getDamge(target:getCurrentHp())
            end

            local targetInfo = {
                general = target,
                hpDamge = hpDamge,
                mpDamge = mpDamge,
                isHited = true,
                fangjuExp = GeneralUtils.calcFangjuExp(target, self.attacker, false, true)
            }
            table.insert(self.targetsInfo, targetInfo)
            target:hurt(hpDamge, mpDamge, nextCallback)
        end
    end, handler(self, self.showHurtView))
end

--[[
    受伤结算
    enemy仅结算hp，mp（如果是龙鳞铠则用mp替换hp）
        enemy死亡（如果有，显示台词）
    player结算hp，mp（如果是龙鳞铠则用mp替换hp），防具exp
        player防具升级，player人物死亡（多个条件满足，按此顺序提示）
        player死亡显示撤退台词
--]]
NormalAttack.showHurtView = function(self)
    table.walk(self.targetsInfo, function(targetInfo)
        targetInfo.general:setAttacker(self.attacker)
    end)
    EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, self.targetsInfo, self.attacker, true, handler(self, self.handleOutStatus))
end

-- 附加状态显示（可能是武器附加（流星锤附带混乱），也有可能是兵种特性（训熊师附带定身））
NormalAttack.handleOutStatus = function(self)
    if self.attacker:hasAttackStatus() then
        table.oneByOne(self.targetsInfo, function(targetInfo, nextCallback)
            local general = targetInfo.general
            local statuses = self.attacker:getAttackStatus()
            table.oneByOne(statuses, function(statusId, nextCallback2)
                if not general:hasStatus(statusId) then
                    general:addStatus(statusId, nextCallback2)
                end
            end, nextCallback)
        end, handler(self, self.handleDoubleAttack))
    else
        self:handleDoubleAttack()
    end
end

-- 连击处理
NormalAttack.handleDoubleAttack = function(self)
    local isDoubleAttack = self.attacker:isDoubleAttack(self.mainTarget, self.attackBackCount, self.doubleAttackCount, self.dieAgainAttackCount)
    if self.mainTarget:isAlive() and isDoubleAttack then
        NormalAttack.new(self.attacker, self.mainTarget, self.targets, self.finalCallback, self.attackBackCount, self.doubleAttackCount + 1, self.dieAgainAttackCount)
    else
        self:showAttackView()
    end
end

--[[
    攻击结算
        player则结算，武器exp，武将exp
            武器升级，武将升级
--]]
NormalAttack.showAttackView = function(self)
    if self.attacker:isPlayer() then
        local attackerInfo = {
            general = self.attacker,
            hpDamge = 0,
            mpDamge = 0,
            exp = GeneralUtils.calcExp(self.attacker, self.targetsInfo),
            wuqiExp = GeneralUtils.calcWuqiExp(self.attacker, self.targetsInfo, false)
        }
        EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, {}, attackerInfo, false, handler(self, self.handleAgainAttack))
    else
        self:handleAgainAttack()
    end
end

-- 如果可以反击，则进入反击流程（仅命中的主目标可以反击，非混乱状态且非死亡在攻击范围以内，则进行反击）
NormalAttack.handleAgainAttack = function(self)
    if self.mainTarget:isDie() and (self.attackBackCount == 0) and self.attacker:isCanAttackAgainWhenTargetDie(self.dieAgainAttackCount) then
        -- 进攻方击败敌人时允许引导攻击
        local newTargets = self.attacker:getAttackTargets()
        if #newTargets > 0 then
            local newTarget = newTargets[math.random(#newTargets)]
            local newRow, newCol = newTarget:getRow(), newTarget:getCol()
            NormalAttack.new(self.attacker, newTarget, self.attacker:getHitTargets(newRow, newCol), self.finalCallback, self.attackBackCount, self.doubleAttackCount, self.dieAgainAttackCount + 1)
        else
            self.attacker:makeActionDone(self.finalCallback)
        end

        return
    elseif self.mainTarget:isDie() or self.attacker:isCanMakeNoAttackBack() then
        -- 目标死亡不再进行反击行为 或 判断是否有可以禁止反击的武器，如青龙偃月刀
        if self.attackBackCount == 0 or self.attackBackCount == 2 then
            self.attacker:makeActionDone(self.finalCallback)
        elseif self.attackBackCount == 1 then
            -- 相当于攻击方被反击死掉
            self.finalCallback()
        end

        return
    end

    -- 反击次数为0，或者已经反击过1次，但是原进攻者拥有反击再反击武器
    if (self.attackBackCount == 0) or (self.attackBackCount == 1 and self.mainTarget:isCanAttackBackAgain()) then
        -- 非混乱且进攻者在反击武将攻击范围内
        if not self.mainTarget:isHunLuan() and self.mainTarget:isInAttackRange(self.attacker) then
            local attackBackTargets = self.mainTarget:getHitTargets(self.attackerRow, self.attackerCol)
            NormalAttack.new(self.mainTarget, self.attacker, attackBackTargets, self.finalCallback, self.attackBackCount + 1, self.doubleAttackCount, self.dieAgainAttackCount)
        else
            self.attacker:makeActionDone(self.finalCallback)
        end
    elseif self.attackBackCount == 1 then
        self.mainTarget:makeActionDone(self.finalCallback)
    elseif self.attackBackCount == 2 then
        -- 反击再反击的情况
        self.attacker:makeActionDone(self.finalCallback)
    end
end

return NormalAttack