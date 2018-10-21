--[[
    分离出magic攻击流程，专门在此处理
    1、施展策略
    2、tipbox显示策略
    3、策略动画显示
        3.1、格挡（显示MISS）
        3.2、受伤（显示伤害，HP和MP不同伤害颜色，每次仅一种伤害可以显示）
    4、受伤结算（多个单位，则多个单位进行结算）
        4.1、enemy仅结算hp，mp
            4.1.1、enemy死亡（如果有，显示死亡台词）
        4.2、player结算hp，mp，防具exp
            4.2.1、player防具升级，player人物死亡（多个条件满足，按此顺序提示）
                4.2.1.1、player死亡显示撤退台词
    5、附加状态显示（中毒等，武将死亡则进行此步，未命中显示MISS）
    6、策略结算
        6.1、enemy仅结算mp
        6.2、player结算mp，武器exp（仅增长文官类型武器），武将exp
            6.2.1、player武器升级，player武将升级（多个条件满足，按此顺序提示）
--]]

local Magic = import(".magic")
local MagicAttack = class("MagicAttack")

-- isCalc 主要实在turnBegin中作为武将技能施展时，不结算mp和经验等，默认为true，表示结算
MagicAttack.ctor = function(self, magicer, magicConfig, mainTarget, targets, finalCallback, isCalc)
    EventMgr.triggerEvent(EventConst.ADD_NONTOUCH_LAYER, "MagicAttack流程Start")

    table.sort(targets, function(l, r)
        local lIndex = l:getRow() * MapUtils.cols + l:getCol()
        local rIndex = r:getRow() * MapUtils.cols + r:getCol()
        return lIndex < rIndex
    end)

    self.magicer       = magicer
    self.magicConfig   = magicConfig
    self.magicerRow    = magicer:getRow()
    self.magicerCol    = magicer:getCol()
    self.mainTargetRow = mainTarget:getRow()
    self.mainTargetCol = mainTarget:getCol()
    self.targets       = targets
    self.hurtType      = self.magicConfig.hurtType
    self.isCalc        = (isCalc == nil) and true or isCalc
    self.finalCallback = function()
        table.oneByOne(targets, function(target, nextCallback)
            target:checkDie(nextCallback)
        end, function()
            EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, "MagicAttack流程End")

            if magicer == MapUtils.getCurrentGeneral() then
                MapUtils.setCurrentGeneral(nil)
            end

            if finalCallback then
                finalCallback()
            end
        end)
    end

    self:showTip()
end

-- 施展策略，tipbox显示策略
MagicAttack.showTip = function(self)
    local dir = MapUtils.calcDirection(self.magicerRow, self.magicerCol, self.mainTargetRow, self.mainTargetCol)
    self.magicer:showAnimation("attack", dir, function()
        self.magicer:stand()
        TipUtils.showTip(self.magicConfig.name, display.COLOR_BLACK, handler(self, self.showAnimation))
    end)
end

-- 策略动画显示，同时播放音效
MagicAttack.showAnimation = function(self)
    AudioMgr.playSound(self.magicConfig.sound)

    if self.magicConfig.specialAnimationConfig then
        -- 提供特殊技能动画处理，主要是服务像是朱雀等神技和火龙等牛逼技
        local tempZOrder = 100
        local x, y = MapUtils.getPosByRowAndCol(self.mainTargetRow, self.mainTargetCol)
        local spAnimation = Magic.new(self.magicConfig.specialAnimationConfig, handler(self, self.handleMagicType))
        spAnimation:pos(x + MapConst.BLOCK_WIDTH / 2, y + MapConst.BLOCK_HEIGHT / 2)
        spAnimation:addTo(self.magicer:getParent(), tempZOrder)
    else
        self:handleMagicType()
    end
end

-- 分类型处理不同策略
MagicAttack.handleMagicType = function(self)
    self.targetsInfo = {}

    if self.magicConfig.randomTargets then
        printInfo("特殊技能，目前应该只有青龙走这里")
        self:handleRandomTargetsMagic(self.magicConfig.randomTargets)
        return
    elseif self.hurtType == "randomMagic" then
        -- 这是为了处理随机子技能，参看八阵图，玄武
        table.oneByOne(self.targets, function(target, nextCallback)
            assert(self.magicConfig.randomMagics, "这一定是要有随机子技能才可以的")
            local randomMagicId = self.magicConfig.randomMagics[math.random(#self.magicConfig.randomMagics)]
            local randomMagicConfig = InfoUtil.getMagicConfig(randomMagicId)

            -- 玄武这种类型的技能还是移动到目标武将处查看策略效果比较好
            EventMgr.triggerEvent(EventConst.MOVE_TO_NODE, target)

            self:handleNormalMagic(target, nextCallback, randomMagicConfig, true)
        end, handler(self, self.showHurtView))
        return
    end

    table.walkAll(self.targets, function(target, nextCallback)
        self:handleNormalMagic(target, nextCallback)
    end, function()
        if self.hurtType == "status" then
            -- 属性变化，不出现受伤结算
            self:handleOutStatus()
        else
            self:showHurtView()
        end
    end)
end

-- 处理普通类型的技能
MagicAttack.handleNormalMagic = function(self, target, callback, magicConfig, forceHit)
    magicConfig = magicConfig or self.magicConfig
    local hurtType = magicConfig.hurtType

    if magicConfig.animationConfig then
        Magic.new(magicConfig.animationConfig):addTo(target, CharViewConst.ZORDER_GENERAL_MAGIC)
    end

    local targetDir = MapUtils.calcDirection(target:getRow(), target:getCol(), self.magicerRow, self.magicerCol, target.curDir)
    local isMagicHited = forceHit or self.magicer:isMagicHited(target, magicConfig)
    local isStatusHited = forceHit or self.magicer:isMagicHited(target, magicConfig) -- 不一定有，不过这里先执行纪录下来
    if isMagicHited then
        local isExcitation = (magicConfig.type == "good")
        local isHurt = not isExcitation

        local hpDamge, mpDamge = 0, 0
        local damgeInfo = GeneralUtils.calcMagicDamge(self.magicer, target, magicConfig)
        if hurtType == "subHp" or hurtType == "addHp" then
            hpDamge = damgeInfo.normalDamgeLimit
        elseif hurtType == "subMp" or hurtType == "addMp" then
            mpDamge = damgeInfo.normalDamgeLimit
        elseif hurtType == "status" then
            isStatusHited = true
        elseif hurtType == "refreshAction" then
            target:refreshAction()
            isExcitation = false
            isHurt = false
        elseif hurtType == "addHpRemoveStatus" then
            hpDamge = damgeInfo.normalDamgeLimit
        end

        if magicConfig.weatherChange then
            printInfo("影响天气变化为：%s->%s", GameData.getWeather(), magicConfig.weatherChange)
            GameData.setWeather(magicConfig.weatherChange)
            EventMgr.triggerEvent(EventConst.SHOW_WEATHER)
        end

        printInfo("对%s造成的%s策略伤害为, hp:%d, mp:%d", target:getName(), magicConfig.name, hpDamge, mpDamge)

        local targetInfo = {
            general = target,
            hpDamge = hpDamge,
            mpDamge = mpDamge,
            outStatus = magicConfig.outStatus,
            isStatusHited = isStatusHited,
            isHited = true,
        }
        table.insert(self.targetsInfo, targetInfo)

        if isHurt then
            target:hurt(hpDamge, mpDamge, callback)
        elseif isExcitation then
            target:excitation(-hpDamge, -mpDamge, callback)
        else
            printInfo("这是%s策略，直接执行回调，没有受伤和激励动画", magicConfig.name)
            callback()
        end
    else
        printInfo("%s成功抵挡策略", target:getName())

        local targetInfo = {
            general = target,
            hpDamge = 0,
            mpDamge = 0,
            outStatus = magicConfig.outStatus,
            isStatusHited = isStatusHited,
            isHited = false,
        }

        if magicConfig.outStatus and magicConfig.hurtType ~= "subHp" then
            targetInfo.isStatusHited = false
        end
        table.insert(self.targetsInfo, targetInfo)

        -- 格挡（显示MISS）
        target:defense(targetDir, callback)
    end
end

-- 这是随机随机进攻数，特殊流程，参看青龙技能，这里每轮伤害结束，都会结算一遍伤害
MagicAttack.handleRandomTargetsMagic = function(self, randomTargets)
    if randomTargets <= 0 then
        self:showAttackView()
        return
    end

    -- 这里很可能选中的敌人已经被劈死了
    local aliveTargets = {}
    table.walk(self.targets, function(target)
        if target:isAlive() then
            table.insert(aliveTargets, target)
        else
            printInfo("%s已经死亡", target:getName())
        end
    end)

    if #aliveTargets == 0 then
        -- 已经没有存活目标，直接进入策略进攻结算
        self:showAttackView()
        return
    end

    local target = aliveTargets[math.random(#aliveTargets)]
    local targetDir = MapUtils.calcDirection(target:getRow(), target:getCol(), self.magicerRow, self.magicerCol, target.curDir)
    Magic.new(self.magicConfig.animationConfig):addTo(target, CharViewConst.ZORDER_GENERAL_MAGIC)

    if self.magicer:isMagicHited(target, self.magicConfig) then
        local damgeInfo = GeneralUtils.calcMagicDamge(self.magicer, target, magicConfig)
        local hpDamge = damgeInfo.normalDamgeLimit
        local targetInfo = {general = target, hpDamge = hpDamge, mpDamge = 0, isHited = true}
        table.insert(self.targetsInfo, targetInfo)

        target:hurt(hpDamge, 0, function()
            -- 直接结算受伤界面
            -- 暂时不结算player，假定敌人绝对不会使用这个技能
            target:setAttacker(self.magicer)
            EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, {{general = target, hpDamge = hpDamge, mpDamge = 0}}, self.magicer, true, function()
                self:handleRandomTargetsMagic(randomTargets - 1)
            end)
        end)
    else
        local targetInfo = {general = target, hpDamge = 0, mpDamge = 0, isHited = false}
        table.insert(self.targetsInfo, targetInfo)

        -- 格挡（显示MISS）
        target:defense(targetDir, function()
            self:handleRandomTargetsMagic(randomTargets - 1)
        end)
    end
end

--[[
    受伤结算（多个单位，则多个单位进行结算）
        enemy仅结算hp，mp
        player结算hp，mp，防具exp
            player防具升级，player人物死亡（多个条件满足，按此顺序提示）
--]]
MagicAttack.showHurtView = function(self)
    -- 这里需要过滤，只有那些有数值损伤的敌人才需要显示受伤结算
    local filterTargetsInfo = {}
    table.walk(self.targetsInfo, function(targetInfo)
        if targetInfo.general:isPlayer() and self.isCalc then
            targetInfo.fangjuExp = GeneralUtils.calcFangjuExp(targetInfo.general, self.magicer, true, targetInfo.isHited)
            table.insert(filterTargetsInfo, targetInfo)
        else
            if targetInfo.hpDamge ~= 0 or targetInfo.mpDamge ~= 0 then
                targetInfo.general:setAttacker(self.magicer)
                table.insert(filterTargetsInfo, targetInfo)
            end
        end
    end)

    EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, filterTargetsInfo, self.magicer, true, handler(self, self.handleOutStatus))
end

-- 判断是否存在附加状态显示
MagicAttack.handleOutStatus = function(self)
    printInfo("判断是否存在附加状态显示")
    table.oneByOne(self.targetsInfo, function(targetInfo, nextCallback)
        -- 附加状态显示（中毒等，武将死亡则进行此步，未命中显示MISS）
        local statusId = targetInfo.outStatus
        local target = targetInfo.general
        local isStatusHited = targetInfo.isStatusHited
        if self.hurtType == "removeStatus" or self.hurtType == "addHpRemoveStatus" then
            printInfo("%s显示移除异常状态效果", target:getName())
            target:removeAllBadStatus(nextCallback)
        elseif statusId and isStatusHited then
            printInfo("%s中了异常状态", target:getName())
            target:addStatus(statusId, nextCallback)
        else
            nextCallback()
        end
    end, handler(self, self.showAttackView))
end

--[[
    策略结算
        enemy和friend结算mp，部分策略需要结算hp
        player结算mp，武器exp（仅增长文官类型武器），武将exp
            player武器升级，player武将升级（多个条件满足，按此顺序提示）
--]]
MagicAttack.showAttackView = function(self)
    --!! 目前add行为，暂时测试为诱惑和谍报，其他行为暂未测试与考虑，所以敌人均考虑只有1位的情况
    --!! 以后是否出现多位，再另行决议
    local magicerInfo = {general = self.magicer, hpDamge = 0, mpDamge = self.isCalc and self.magicConfig.mpCost or 0}
    if #self.targetsInfo == 1 then
        if self.magicConfig.selfType == "addMp" then
            magicerInfo.mpDamge = magicerInfo.mpDamge - self.targetsInfo[1].mpDamge
        elseif self.magicConfig.selfType == "addHp" then
            magicerInfo.hpDamge = magicerInfo.hpDamge - self.targetsInfo[1].hpDamge
        elseif self.magicConfig.selfType == "subHp" then
            --!! 为了统一，冥想的处理也直接提到这个地方，直接先乘2处理了
            magicerInfo.hpDamge = magicerInfo.hpDamge - self.targetsInfo[1].mpDamge * 2
        end
    end

    -- 进攻结算，这里判断是否有影响mp消耗的道具
    magicerInfo.mpDamge = magicerInfo.mpDamge * self.magicer:getMagicCostRate()

    if self.magicer:isPlayer() and self.isCalc then
        magicerInfo.wuqiExp = GeneralUtils.calcWuqiExp(self.magicer, self.targetsInfo, true)
        magicerInfo.exp = GeneralUtils.calcExp(self.magicer, self.targetsInfo)
    end

    if magicerInfo.hpDamge ~= 0 or magicerInfo.mpDamge ~= 0 or magicerInfo.exp or magicerInfo.wuqiExp then
        EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, self.targetsInfo, magicerInfo, false, function()
            self.magicer:makeActionDone(self.finalCallback)
        end)
    else
        self.finalCallback()
    end
end

return MagicAttack