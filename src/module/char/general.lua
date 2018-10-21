--[[
    不再区分，士兵和武将，士兵也相当于一种弱化的武将
--]]

local Animation       = import(".animation")
local Magic           = import(".magic")
local Equipment       = import(".equipment")
local MagicAttack     = import(".magic_attack")
local NormalAttack    = import(".normal_attack")
local ItemUse         = import(".item_use")
local StatusMgr       = import(".status_mgr")
local GeneralInfoView = import(".general_info_view")

local STATUS_DU_DAMGE_PERCENT = 0.1 --!! 临时放在这里，毒每回合造成的hp比例伤害

local General = class("General", function()
    return display.newNode()
end)

General.ctor = function(self, uid, side, data)
    data = data or {}

    self:initModel(uid, side, data)

    self:initAnimation()
    self:initStatusIcon(data)
    self:initExtraData(data)
    self:initBloodBar()
    self:initTouchEvent()
    self:setNodeEventEnabled(true)
end

General.onEnter = function(self)
    self.handlers = {
        [EventConst.GENERAL_HP_CHANGE] = handler(self, self.updateBloodBar),
        [EventConst.GENERAL_LEVELUP]   = handler(self, self.levelUpEvent),
        [EventConst.GENERAL_ARMYUP]    = handler(self, self.armyUpEvent),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

General.onExit = function(self)
    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil
end

General.initModel = function(self, uid, side, data)
    self.model       = GeneralDataMgr.regGeneralData(uid, side, data) --!! 无需注册，已注册完成
    self.battleModel = GeneralDataMgr.regGeneralBattleData(uid, side, data) --!! 无需注册，已注册完成
end

-- 初始化武将动画，会根据职业选择
General.initAnimation = function(self)
    if not self.animation then
        local animation = Animation.new()
        animation:align(display.LEFT_BOTTOM)
        animation:addTo(self, CharViewConst.ZORDER_GENERAL_ANIMATION)
        self.animation = animation
    end

    local animationConfig = InfoUtil.getGeneralAnimation(self.model:getGeneralId(), self:getProfessionType(), self:getSide())
    self.animation:loadAnimation(animationConfig)
    self.curAnimationConfig = animationConfig
end

General.initStatusIcon = function(self, data)
    if data:getStatusMgr():getAllStatuses() then
        table.walk(data:getStatusMgr():getAllStatuses(), function(_, statusId)
            self:addStatusIcon(statusId)
        end)
    end
end

-- 初始化武将点击事件
General.initTouchEvent = function(self)
    -- 不能将General设置为TouchNode，因为Animation的大小可能比地图块大，导致点击区域变大
    -- 所以这里通过一个代理的touchNode来接受点击区域
    local touchNode = TouchNode.new()
    touchNode:size(MapConst.BLOCK_WIDTH, MapConst.BLOCK_HEIGHT)
    touchNode:align(display.LEFT_BOTTOM)
    touchNode:addTo(self, CharViewConst.ZORDER_GENERAL_TOUCH)

    touchNode.onClick = function(touchNode, event)
        self:onClick(event)
    end

    touchNode.onDoubleClick = function(touchNode, event)
        self:onDoubleClick(event)
    end

    touchNode.onLongClick = function(touchNode, event)
        self:onLongClick(event)
    end
end

-- 初始化武将装备
General.initEquips = function(self, wuqiId, wuqiLevel, wuqiExp, fangjuId, fangjuLevel, fangjuExp, shipingId)
    --!! 此接口准备废除，临时处理
    self.model:initEquip(GeneralDataConst.EQUIP_WUQI, wuqiId, wuqiLevel, wuqiExp)
    self.model:initEquip(GeneralDataConst.EQUIP_FANGJU, fangjuId, fangjuLevel, fangjuExp)
    self.model:initEquip(GeneralDataConst.EQUIP_SHIPING, shipingId)
end

General.initExtraData = function(self, data)
    if data:isActionDone() then
        self:updateActionDoneStatus(true)
        local color = self.animation:getColor()
        self.animation:setColor(cc.c3b(color.r - 100, color.g - 100, color.b - 100))
        EventMgr.triggerEvent(EventConst.GENERAL_SMALLMAP_DONE, self)
    end

    if data:getRow() then
        self:setRowAndCol(data:getRow(), data:getCol())
        self:stand(data:getDir())
    end

    if data:isHide() then
        self:setVisible(not data:isHide())
    end
end

General.initBloodBar = function(self)
    local rect = cc.rect(2, MapConst.BLOCK_HEIGHT - 5, MapConst.BLOCK_WIDTH - 4, 5)
    local bloodBg = display.newRect(rect, {fillColor = cc.c4f(0, 0, 0, 0.7), borderWidth = 0})
    bloodBg:addTo(self)

    local bloodBar = cc.ui.UILoadingBar.new({scale9 = true, capInsets = cc.rect(0, 0, 8, 8), image = "ccz/general/tile_view/hurt_fg.png", viewRect = rect})
    bloodBar:align(display.LEFT_BOTTOM, 2, MapConst.BLOCK_HEIGHT - 5)
    bloodBar:zorder(1000)
    bloodBar:addTo(self)
    self.bloodBar = bloodBar

    self:updateBloodBar()
end

General.updateBloodBar = function(self)
    local percent = self:getCurrentHp() / self:getMaxHp() * 100
    self.bloodBar:setPercent(percent)
end

General.addHurtBloodBar = function(self, attacker)
    if not self:isOpponent(attacker) then
        return
    end

    local hpPercent = self:getCurrentHp() / self:getMaxHp() * 100
    local damgeInfo = GeneralUtils.calcAttackDamge(attacker, self)
    if damgeInfo.type == "hp" then
        local rect = cc.rect(2, MapConst.BLOCK_HEIGHT - 4, MapConst.BLOCK_WIDTH - 4, 4)
        rect.x = rect.x + rect.width * (hpPercent - damgeInfo.estimatedDamgePercentLimit) / 100
        rect.width = rect.width * damgeInfo.estimatedDamgePercentLimit / 100

        local hurtBloodBar = display.newRect(rect, {fillColor = cc.c4f(1, 1, 0, 0.7), borderWidth = 0})
        hurtBloodBar:zorder(2000)
        hurtBloodBar:addTo(self)
        return hurtBloodBar
    end
end

General.addMagicHurtBloodBar = function(self, magicer, magicConfig)
    if not self:isMatchMagicTarget(magicer, magicConfig) then
        return
    end

    local hpPercent = self:getCurrentHp() / self:getMaxHp() * 100
    local damgeInfo = GeneralUtils.calcMagicDamge(magicer, self, magicConfig)
    if damgeInfo.type == "hp" then
        if magicConfig.type ~= "good" then
            local rect = cc.rect(2, MapConst.BLOCK_HEIGHT - 4, MapConst.BLOCK_WIDTH - 4, 4)
            rect.x = rect.x + rect.width * (hpPercent - damgeInfo.estimatedDamgePercentLimit) / 100
            rect.width = rect.width * damgeInfo.estimatedDamgePercentLimit / 100

            local hurtBloodBar = display.newRect(rect, {fillColor = cc.c4f(1, 1, 0, 0.7), borderWidth = 0})
            hurtBloodBar:zorder(2000)
            hurtBloodBar:addTo(self)
            return hurtBloodBar
        else
            local rect = cc.rect(2, MapConst.BLOCK_HEIGHT - 4, MapConst.BLOCK_WIDTH - 4, 4)
            rect.x = rect.x + rect.width * hpPercent / 100
            rect.width = rect.width * damgeInfo.estimatedDamgePercentLimit / 100

            local hurtBloodBar = display.newRect(rect, {fillColor = cc.c4f(0, 1, 0, 0.7), borderWidth = 0})
            hurtBloodBar:zorder(2000)
            hurtBloodBar:addTo(self)
            return hurtBloodBar
        end
    end
end

General.onClick = function(self, event)
    printInfo("点中武将%s, 阵营:%s, 坐标：(%d, %d)", self:getName(), self:getSide(), self:getRow(), self:getCol())

    if self:isActionDone() then
        TipUtils.showTip(string.format("%s回合结束，已经无法再行动。", self:getName()))
        EventMgr.triggerEvent(EventConst.GENERAL_ACTION_CANCEL_NO_ANIMATION, MapUtils.getCurrentGeneral())
        EventMgr.triggerEvent(EventConst.HIDE_ALL_VIEW)
        return
    end

    if self:isHunLuan() then
        TipUtils.showTip(string.format("%s处于混乱状态，已经无法再行动。", self:getName()))
        EventMgr.triggerEvent(EventConst.GENERAL_ACTION_CANCEL_NO_ANIMATION, MapUtils.getCurrentGeneral())
        EventMgr.triggerEvent(EventConst.HIDE_ALL_VIEW)
        return
    end

    if MapUtils.getCurrentGeneral() == self then
        if self:isPlayer() then
            EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MENU, self)
        else
            local text = string.format("这是%s部分。", self:isFriend() and "友军" or "敌军")
            TipUtils.showTip(text)

            MapUtils.setCurrentGeneral(nil)
            EventMgr.triggerEvent(EventConst.HIDE_ALL_VIEW)
        end

        return
    elseif MapUtils.getCurrentGeneral() then
        EventMgr.triggerEvent(EventConst.GENERAL_ACTION_CANCEL_NO_ANIMATION, MapUtils.getCurrentGeneral())
    end

    MapUtils.setCurrentGeneral(self)
    EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MOVE_RANGE, self)
    EventMgr.triggerEvent(EventConst.MOVE_TO_NODE, self)
end

General.onDoubleClick = function(self, event)
    printInfo("双击武将，显示其武将说明界面")

    if MapUtils.getCurrentGeneral() and MapUtils.getCurrentGeneral() ~= self then
        printInfo("已有点击武将%s，需要执行取消行为", MapUtils.getCurrentGeneral():getName())
        EventMgr.triggerEvent(EventConst.GENERAL_ACTION_CANCEL_NO_ANIMATION, MapUtils.getCurrentGeneral())
    end

    -- 这个用于介绍界面出现在左边还是右边，上边还是下边
    local isLeft, isBottom = MapUtils.getMapAreaByTouchPos(event.x, event.y)
    EventMgr.triggerEvent(EventConst.GENERAL_SHOW_TILE_VIEW, self, self:getRow(), self:getCol(), isLeft, isBottom)
end

General.onLongClick = function(self, event)
    printInfo("长按武将，显示其武将情报")

    if MapUtils.getCurrentGeneral() and MapUtils.getCurrentGeneral() ~= self then
        printInfo("已有点击武将%s，需要执行取消行为", MapUtils.getCurrentGeneral():getName())
        EventMgr.triggerEvent(EventConst.GENERAL_ACTION_CANCEL_NO_ANIMATION, MapUtils.getCurrentGeneral())
    end

    GeneralInfoView.new(self)
end

General.getAnimationConfig = function(self)
    return self.curAnimationConfig
end

General.getRes = function(self)
    return self.curAnimationConfig.prefix .. self.curAnimationConfig.res
end

General.showAnimation = function(self, action, dir, callback)
    callback = callback or function() end

    if dir and dir ~= "" then
        self.battleModel:setDir(dir)
    end

    EventMgr.triggerEvent(EventConst.MOVE_TO_NODE, self)
    if action == "weak" or action == "deepBreath" then
        -- 虚弱或喘气
        self.animation:playAction("dead", {isLoop = true})
        callback()
    elseif action == "hurt" then
        -- 受攻击
        self.animation:playAction(action, {callback = callback})
    elseif action == "die" or action == "dieForever" then
        -- 普通死亡或阵亡
        self.animation:playAction("dead", {isLoop = true})
        if action == "die" then
            self.animation:runAction(cca.blink(LONG_ANIMATION_TIME, 5))
        else
            self.animation:setFilter(filter.newFilter("EXPOSURE", {4}))
        end

        self:performWithDelay(function()
            self:setHide(true)
            callback()
        end, LONG_ANIMATION_TIME)
    elseif action == "doubleAttack" then
        -- 二次攻击
        self:showAnimation("attack", dir, function()
            self:showAnimation("attack", dir, callback)
        end)
    elseif action == "prepareAttack" or action == "raiseWuqi" then
        -- 攻击预备或举起武器
        self:showAnimation("attack", dir, callback)
    elseif action == "circle" then
        -- 转圈
        local oldDir = clone(self:getDir())
        self:showAnimation("move", "up", function()
            self:showAnimation("move", "left", function()
                self:showAnimation("move", "down", function()
                    self:showAnimation("move", "right", function()
                        self:showAnimation("stand", oldDir, callback)
                    end)
                end)
            end)
        end)
    elseif action == "dizzy" then
        -- 晕倒
        self.animation:playAction("dead", {isLoop = true})
        self:performWithDelay(function()
            self:stand()
            callback()
        end, SHORT_ANIMATION_TIME)
    else
        self.animation:playAction(action .. "_" .. self:getDir(), {callback = callback})
    end
end

General.move = function(self, movePath, callback, noCachePrePos)
    EventMgr.triggerEvent(EventConst.ADD_NONTOUCH_LAYER, self:getName() .. " move流程Start")

    if not noCachePrePos then
        self.origRow = self:getRow()
        self.origCol = self:getCol()
    end

    local walkSoundHandler = AudioMgr.playSound(self.model:getProp(GeneralDataConst.PROP_WALKSOUND), true)
    table.oneByOne(movePath, function(pos, nextCallback)
        EventMgr.triggerEvent(EventConst.MOVE_TO_NODE, self)
        self:moveStep(pos.row, pos.col, nextCallback)
    end, function()
        EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, self:getName() .. " move流程End")

        printInfo("武将(%s):新坐标(%d, %d)", self:getName(), self:getRow(), self:getCol())
        AudioMgr.stopSound(walkSoundHandler)
        if callback then
            callback()
        end
    end)
end

General.moveCancel = function(self)
    if self.origRow and self.origCol then
        self:setRowAndCol(self.origRow, self.origCol)
        self:stand()
    end
end

-- 移动动画，并且执行真正的移动
General.moveStep = function(self, row, col, callback)
    if row == self:getRow() and col == self:getCol() then
        printInfo("%s原地，无需移动", self:getName())
        callback()
        return
    end

    local dir = MapUtils.calcDirection(self:getRow(), self:getCol(), row, col)
    if dir then
        self.animation:playAction("move_" .. dir, {isLoop = true})
        self.battleModel:setDir(dir)
    end

    local x, y = MapUtils.getPosByRowAndCol(row, col)
    transition.execute(self, cca.moveTo(SHORT_ANIMATION_TIME, cc.p(x, y)), {onComplete = function()
        -- 这里不能同步更新到MapUtils上，因为这样可能会冲掉原有位置上的友军
        self:setRowAndColOnly(row, col)

        -- 通知小地图进行绘制
        EventMgr.triggerEvent(EventConst.GENERAL_SMALLMAP_MOVE, self)

        -- 刷新当前武将地图块的额外贴图
        self:refreshMarkTile(row, col)

        callback()
    end})
end

-- 刷新武将该地形的额外贴图
General.refreshMarkTile = function(self, row, col)
    --!! 还有问题，达不到预期，而且序列帧动画，不是每一帧都有影响
    local tileMark = MapUtils.getTileMark(row, col)
    if tileMark ~= "" then
        if self.tileMarkImg and self.tileMarkImg.tileMark ~= tileMark then
            self.tileMarkImg:removeSelf()
            self.tileMarkImg = nil
        end

        if not self.tileMarkImg then
            self.tileMarkImg = display.newSprite(InfoUtil.getPath(tileMark, "mapTile"))
            self.tileMarkImg:align(display.LEFT_BOTTOM)
            self.tileMarkImg:addTo(self, 100)
            self.tileMark = tileMark
        end
    else
        if self.tileMarkImg then
            self.tileMarkImg:removeSelf()
            self.tileMarkImg = nil
        end
    end
end

-- 站立动画
General.stand = function(self, dir)
    self.battleModel:setDir(dir)

    if self.battleModel:isInjury() then
        -- 重伤标记，仅存在于hurt和excitation中处理，主要是因为真正的结算被延后到了结算界面里面
        self.animation:playAction("dead", {isLoop = true})
    else
        self.animation:playAction("stand_" .. self:getDir())
    end
end

-- 格挡动画
General.defense = function(self, dir, callback)
    self:showAnimation("defense", dir, function()
        self:stand(dir)
        callback()
    end)
end

-- 撤退动画
General.retreat = function(self, callback)
    EventMgr.triggerEvent(EventConst.MOVE_TO_NODE, self)

    self.animation:playAction("defense_down")
    self:setCascadeOpacityEnabled(true)
    self:fadeOut(LONG_ANIMATION_TIME)
    self:performWithDelay(function()
        self:setHide(true)
        self.battleModel:setDie(true)
        -- 消失以后，和死亡基本算是一样的，没有什么不同的
        EventMgr.triggerEvent(EventConst.GENERAL_DIE, self)

        if callback then
            callback()
        end
    end, LONG_ANIMATION_TIME)
end

-- 复活动画
General.reborn = function(self, dir, callback)
    self:setHide(false)
    self:showAnimation("stand", dir)
    self.animation:fadeIn(MIDDLE_ANIMATION_TIME)
    self:performWithDelay(function()
        self.battleModel:setDie(false)

        if callback then
            callback()
        end
    end, MIDDLE_ANIMATION_TIME)
end

General.checkDie = function(self, callback)
    if self:isDie() then
        local dieCallback = function()
            EventMgr.triggerEvent(EventConst.GENERAL_DIE, self) -- 为了小地图变化，同时通知MapView做一些清理工作

            if self:isVisible() then
                self:showAnimation("die", nil, callback)
            elseif callback then
                callback()
            end
        end

        EventMgr.triggerEvent(EventConst.PLOT_CHECK_CONDTION, function()
            if self:getProp(GeneralDataConst.PROP_RETREATWORDS) and self.battleModel:isShowRetreatWords() then
                EventMgr.triggerEvent(EventConst.CHAT_DIALOG, self, self:getProp(GeneralDataConst.PROP_RETREATWORDS), dieCallback)
            else
                dieCallback()
            end
        end, "GeneralPropTest", self)
    else
        callback()
    end
end

-- 受击动画和激励动画公共部分
General._hurtOrExcitation = function(self, animation, hpValue, mpValue, callback)
    local valueLabel
    if hpValue > 0 then
        valueLabel = display.newTTFLabel({text = hpValue, size = 16})
    elseif mpValue > 0 then
        valueLabel = display.newTTFLabel({text = mpValue, size = 16, color = FontCyanColor})
    end

    if valueLabel then
        valueLabel:align(display.LEFT_TOP, 0, MapConst.BLOCK_HEIGHT)
        valueLabel:addTo(self.animation, CharViewConst.ZORDER_GENERAL_HURT)

        self:hideStatusIcon()
    end

    self.animation:playAction(animation, {callback = function()
        if valueLabel then
            valueLabel:removeSelf()

            self:showStatusIcon()
        end

        self:stand()

        if callback then
            callback()
        end
    end})
end

-- 激励动画
General.excitation = function(self, hpValue, mpValue, callback)
    self:_hurtOrExcitation("excitation", hpValue, mpValue, callback)
end

-- 受击动画
General.hurt = function(self, hpValue, mpValue, callback)
    self:_hurtOrExcitation("hurt", hpValue, mpValue, callback)
end

-- 使用道具对他人
General.useItem = function(self, target, itemId)
    ItemUse.new(itemId, self, target, handler(self, self.makeActionDone))
end

-- 升级处理，影响五围属性，isShowTip默认为true，表示会弹提示框，武将升级
General.levelUp = function(self, levelAdd, callback, isShowTip)
    self.isShowTip = isShowTip
    self.model:levelUp(levelAdd or 1)
    if callback then
        callback()
    end
end

General.levelUpEvent = function(self, uid, levelAdd, newMagics)
    if self:getId() ~= uid then
        return
    end

    self:excitation(0, 0)
    TipUtils2.showTip(string.format("%s升为%d级", self:getName(), self:getLevel()), display.COLOR_RED)

    -- 弹出提示框，显示武将可以学习到的新技能
    for _, magicId in ipairs(newMagics) do
        TipUtils2.showTip(string.format("%s学会了[%s]计策", self:getName(), magicId))
    end
end

General.armyUp = function(self, callback)
    if self.model:canArmyUp() then
        self.model:armyUp()
        self:initAnimation()
    end

    self:excitation(0, 0, callback)
end

General.armyUpEvent = function(self, uid, newMagics)
    if self:getId() ~= uid then
        return
    end

    TipUtils2.showTip(string.format("%s兵种升级为%s", self:getName(), self:getProfessionName()))

    -- 弹出提示框，显示武将可以学习到的新技能
    for _, magicId in ipairs(newMagics) do
        TipUtils2.showTip(string.format("%s学会了[%s]计策", self:getName(), magicId))
    end
end

-- 更新行列值，同时更新坐标，一般用于刚添加入战斗中
General.setRowAndCol = function(self, row, col)
    self:pos(MapUtils.getPosByRowAndCol(row, col))
    self:setRowAndColOnly(row, col)

    -- 刷新当前武将地图块的额外贴图
    self:refreshMarkTile(row, col)
end

General.getGeneralIcon = function(self)
    return string.format("%d_stand_down_0.png", self.curAnimationConfig.res)
end

-- 获取武将所在地形名字
General.getTileName = function(self)
    return MapUtils.getTileName(self:getRow(), self:getCol())
end

-- 返回武将在该指定方块上的移动消耗值
General.getTileMovementCost = function(self, tileType)
    if MapTileInfo[tileType].isCannotMove then
        return LimitValueInfo.Max_Movement_Cost
    end

    -- 恶路移动效果
    if self:isCanMoveIgnoreTile() then
        return 1
    end

    local movementCost = self.model:getProp(GeneralDataConst.PROP_MOVEMENTCOST)
    if movementCost and movementCost[tileType] then
        return movementCost[tileType]
    end

    return 1
end

-- 获取该兵种类型的攻击范围，row和col存在表示武将将在那个地点进行攻击
-- 优先获取装备导致的攻击范围，再获取职业本身的攻击范围
General.getAttackRange = function(self, moveRow, moveCol)
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_CHANGE_ATTACKRANGE)
    local attackRangeType = hasEffect and equips[1]:getEffectValue() or self.model:getProp(GeneralDataConst.PROP_ATTACKRANGETYPE)

    moveRow = moveRow or self:getRow()
    moveCol = moveCol or self:getCol()
    return AttackRangeUtils.getAttackRange(attackRangeType, moveRow, moveCol, moveRow, moveCol)
end

General.getAttackRangeIcon = function(self)
    return InfoUtil.getRangeIcon(self.model:getProp(GeneralDataConst.PROP_ATTACKRANGETYPE))
end

General.getAttackTargets = function(self)
    local targets = {}
    local attackRange = self:getAttackRange()
    table.walk(attackRange, function(tile)
        local target = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
        if target and target:isAlive() and target:isOpponent(self) then
            table.insert(targets, target)
        end
    end)

    return targets
end

General.getAroundRange = function(self)
    return AttackRangeUtils.getAttackRange("RANGE_RECT_8", self:getRow(), self:getCol(), self:getRow(), self:getCol())
end

-- 获得周围武将 isNoContainOppotenters 表示不包含非对手阵营的武将，默认为false， isContainSelf 表示是否包含自己，默认为true
General.getAroundTargets = function(self, isNoContainOppotenters, isContainSelf)
    local targets = {}
    local aroundRange = self:getAroundRange()
    table.walk(aroundRange, function(tile)
        local target = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
        if target and target:isAlive() then
            if (not isNoContainOppotenters) or (not self:isOpponent(target)) then
                table.insert(targets, target)
            end
        end
    end)

    if isContainSelf == 0 then
        table.removebyvalue(targets, self)
    end

    return targets
end

-- 判断武将当前攻击范围内是否有可以攻击的目标
General.hasAttackTarget = function(self)
    return (#self:getAttackTargets() > 0)
end

-- 判断目标是否在攻击范围内，moveRow和moveCol用于ai中，假定ai移动到该点去，是否还在武将攻击范围内
General.isInAttackRange = function(self, target, moveRow, moveCol)
    moveRow = moveRow or target:getRow()
    moveCol = moveCol or target:getCol()

    local range = self:getAttackRange()
    return table.findIf(range, function(tile)
        return tile.row == moveRow and tile.col == moveCol
    end)
end

-- 获取攻击影响范围 先获取有无装备有攻击影响范围效果，再获取职业的攻击影响范围
General.getHitRange = function(self, row, col, moveRow, moveCol)
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_CHANGE_HITRANGE)
    local hitRangeType = hasEffect and equips[1]:getEffectValue() or self.model:getProp(GeneralDataConst.PROP_HITRANGETYPE)
    if not hitRangeType then
        return
    end

    moveRow = moveRow or self:getRow()
    moveCol = moveCol or self:getCol()
    return AttackRangeUtils.getAttackRange(hitRangeType, row, col, moveRow, moveCol)
end

-- 这里是获取攻击范围中制定一个方块处的敌人，返回一张表
General.getHitTargets = function(self, row, col, moveRow, moveCol)
    moveRow = moveRow or self:getRow()
    moveCol = moveCol or self:getCol()

    local targets = {}
    if self.model:getProp(GeneralDataConst.PROP_HITRANGETYPE) then
        local hitRange = self:getHitRange(row, col, moveRow, moveCol)
        table.walk(hitRange, function(hitbox)
            local target = MapUtils.getGeneralByRowAndCol(hitbox.row, hitbox.col)
            if target and target:isOpponent(self) then
                table.insert(targets, target)
            end
        end)
    else
        targets = {MapUtils.getGeneralByRowAndCol(row, col)}
    end

    return targets
end

-- 获取武将攻击范围内所有可能攻击的目标，moveRow和moveCol表示武将在指定地点攻击
General.getAttackAllHitTargets = function(self, moveRow, moveCol)
    moveRow = moveRow or self:getRow()
    moveCol = moveCol or self:getCol()

    local targetInfos = {}
    local attackRange = self:getAttackRange(moveRow, moveCol)
    table.walk(attackRange, function(tile)
        local general = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
        if general and general:isOpponent(self) then
            table.insert(targetInfos, {
                mainTarget = general,
                targets = self:getHitTargets(tile.row, tile.col, moveRow, moveCol),
                row = tile.row,
                col = tile.col
            })
        end
    end)

    return targetInfos
end

-- 判断武将是否满足该策略的目标
General.isMatchMagicTarget = function(self, magicer, magicConfig)
    if self:isOpponent(magicer) and (magicConfig.type ~= "good") then
        return true
    elseif not self:isOpponent(magicer) and (magicConfig.type == "good") then
        return true
    else
        return false
    end
end

-- 获取指定策略的攻击范围
General.getMagicRange = function(self, magicConfig, moveRow, moveCol)
    moveRow = moveRow or self:getRow()
    moveCol = moveCol or self:getCol()
    return AttackRangeUtils.getAttackRange(magicConfig.rangeType, moveRow, moveCol, moveRow, moveCol)
end

-- 获取指定策略的影响范围，moveRow和moveCol存在表示武将要移动到那个点施展策略
General.getMagicHitRange = function(self, magicConfig, row, col, moveRow, moveCol)
    if not magicConfig.hitRangeType then
        return nil
    end

    moveRow = moveRow or self:getRow()
    moveCol = moveCol or self:getCol()
    return AttackRangeUtils.getAttackRange(magicConfig.hitRangeType, row, col, moveRow, moveCol)
end

-- 获取指定策略的影响范围内的所有可攻击的目标，moveRow和moveCol存在表示武将要移动到那个点施展策略
General.getMagicHitTargets = function(self, magicConfig, row, col, moveRow, moveCol)
    moveRow = moveRow or self:getRow()
    moveCol = moveCol or self:getCol()
    local targets = {}
    local hitRange = self:getMagicHitRange(magicConfig, row, col, moveRow, moveCol)
    if hitRange then
        table.walk(hitRange, function(tile)
            if MapUtils.isSupportMagicTile(magicConfig.name, tile.row, tile.col) then
                local general = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
                if general and general:isMatchMagicTarget(self, magicConfig) then
                    table.insert(targets, general)
                end
            end
        end)
    end

    return targets
end

-- 获取指定策略在策略范围内所有可以攻击的目标，返回一张表，moveRow和moveCol存在表示武将将在那个地点施展策略
General.getMagicAllHitTargets = function(self, magicId, moveRow, moveCol)
    moveRow = moveRow or self:getRow()
    moveCol = moveCol or self:getCol()

    local magicConfig = InfoUtil.getMagicConfig(magicId)
    local magicRange = self:getMagicRange(magicConfig, moveRow, moveCol)
    local targetInfos = {}
    table.walk(magicRange, function(tile)
        -- 此处需要检查策略的地形限制
        if MapUtils.isSupportMagicTile(magicId, tile.row, tile.col) then
            local general = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
            if general and general:isMatchMagicTarget(self, magicConfig) then
                local targets = self:getMagicHitTargets(magicConfig, tile.row, tile.col, moveRow, moveCol)
                if #targets > 0 then
                    table.insert(targetInfos, {mainTarget = general, targets = targets, row = tile.row, col = tile.col})
                else
                    table.insert(targetInfos, {mainTarget = general, targets = {general}, row = tile.row, col = tile.col})
                end
            end
        end
    end)

    return targetInfos
end

-- 判断传入武将与自己是否互为对手
General.isOpponent = function(self, target)
    if (self:isPlayer() or self:isFriend()) and target:isEnemy() then
        return true
    elseif self:isEnemy() and (target:isPlayer() or target:isFriend()) then
        return true
    else
        return false
    end
end

-- 判断武将是否使用策略可用，拥有策略且未被封咒即可使用
General.canUseMagic = function(self)
    return self:getAllMagics() and not self:isFengZhou()
end

-- 获取武将的可用策略, noLearnMagics防止多个拥有模仿策略的武将无限递归下去，默认为false
General.getAllMagics = function(self, minLevel, maxLevel, noLearnMagics)
    local magics = self.model:getAllMagics(minLevel, maxLevel)

    -- 如果存在模仿策略的效果，则从周围至多八个武将中获取策略
    if not noLearnMagics and self:hasEquipEffect(EquipEffectInfo.EFFECT_LEARNMAGIC) then
        local targets = self:getAroundTargets()
        if #targets > 0 then
            table.walk(targets, function(target)
                local targetMagics = target:getAllMagics(nil, nil, true) or {}
                table.insertto(magics, targetMagics)
            end)
        end
    end

    magics = table.unique(magics)
    local newMagics = {}
    for k, v in pairs(magics) do
        table.insert(newMagics, v)
    end

    if #newMagics > 0 then
        table.sort(newMagics, function(l, r)
            return l < r
        end)

        return newMagics
    end

    return nil
end

-- 获取武将所有可用的策略，排除天气，道具和mp的原因，地形判断，不由此处处理，主要供ai使用
General.getAllCanUseMagics = function(self)
    local allMagics = self:getAllMagics()
    table.filter(allMagics, function(magicId)
        local mpCost = InfoUtil.getMagicConfig(magicId).mpCost or 0
        local isMpLimit = mpCost <= self:getCurrentMp() -- 过滤mp限制
        if isMpLimit then
            local limit = InfoUtil.getMagicConfig(magicId).limit
            if limit then
                if limit.items then
                    -- 道具限制检查
                    for _, itemId in ipairs(limit.items) do
                        if not self:hasEquip(itemId) then
                            return false
                        end
                    end
                end

                if limit.weathers then
                    -- 天气限制检查
                    for _, weather in ipairs(limit.weathers) do
                        if GameData.getWeather() ~= weather then
                            return false
                        end
                    end
                end
            end

            return true
        end
    end)

    return allMagics
end

--!! 暂时提供的一个蛋疼的方法，主要由于原来提供的方法中的信息太少，没有考虑到限制的内容，目前打算在此处直接传出各种额外信息
General.getAllMagicsDetail = function(self)
    local allDetailMagics = {}
    local allMagics = self:getAllMagics()
    for _, magicId in ipairs(allMagics) do
        local detailMagic = {}

        local mpCost = InfoUtil.getMagicConfig(magicId).mpCost or 0
        detailMagic.isMpLimit = mpCost > self:getCurrentMp() -- 过滤mp限制
        local limit = InfoUtil.getMagicConfig(magicId).limit
        if limit then
            if limit.items then
                -- 道具限制检查
                for _, itemId in ipairs(limit.items) do
                    if not self:hasEquip(itemId) then
                        detailMagic.isItemLimit = true
                    end
                end
            end

            if limit.weathers then
                -- 天气限制检查
                detailMagic.isWeatherLimit = true
                for _, weather in ipairs(limit.weathers) do
                    if GameData.getWeather() == weather then
                        detailMagic.isWeatherLimit = false
                        break
                    end
                end
            end
        end

        detailMagic.isLimit = detailMagic.isMpLimit or detailMagic.isItemLimit or detailMagic.isWeatherLimit
        detailMagic.magicId = magicId
        table.insert(allDetailMagics, detailMagic)
    end

    return allDetailMagics
end

-- 暂时没有办法的实现，由于触摸层级的问题，目前只能让武将生成一个红色的攻击框，然后让真正的攻击框的触摸事件响应在武将之上
-- 移除操作，交由真正的外部BoxNode处理
General.addColorBox = function(self, color)
    local colorBox = display.newRect(MapViewConst.TILE_RECT, {fillColor = color, borderWidth = 0})
    colorBox:addTo(self, CharViewConst.ZORDER_GENERAL_BOX)
    return colorBox
end

-- 同addColorBox，只不过是这个产生的是一个图片，这个只是预览的攻击框，啥事不干
General.addSpriteBox = function(self, image)
    local spriteBox = display.newSprite(image)
    spriteBox:align(display.LEFT_BOTTOM)
    spriteBox:addTo(self, CharViewConst.ZORDER_GENERAL_BOX)
    return spriteBox
end

-- 获取防具类型的名字
General.getArmyFangjuTypeName = function(self)
    if self:getArmyCategory() == "wen" then
        return "衣服"
    elseif self:getArmyCategory() == "wu" then
        return "铠甲"
    end
end

-- 返回基础属性+装备影响+状态影响
General.getProp = function(self, prop)
    local basicProp = self:getBasicProp2(prop)
    if basicProp then
        if type(basicProp) == "number" then
            local statusProp = self:getStatusMgr():getProp(prop)
            return basicProp + statusProp
        else
            return basicProp
        end
    end
end

-- 策略施展交由MagicAttack流程处理
General.magic = function(self, magicConfig, mainTarget, targets)
    MagicAttack.new(self, magicConfig, mainTarget, targets)
end

-- 攻击处理交由NormalAttack流程处理
General.attack = function(self, mainTarget, targets)
    NormalAttack.new(self, mainTarget, targets)
end

General.getStatusMgr = function(self)
    return self.battleModel:getStatusMgr()
end

-- 武将是否被封咒
General.isFengZhou = function(self)
    return self:hasStatus("封咒")
end

-- 武将是否被混乱
General.isHunLuan = function(self)
    return self:hasStatus("混乱")
end

-- 武将是否被定身
General.isDingShen = function(self)
    return self:hasStatus("定身")
end

-- 武将是否中毒
General.isZhongDu = function(self)
    return self:hasStatus("中毒")
end

-- 判断是否拥有攻击附加状态（兵种特性或武器）
General.hasAttackStatus = function(self)
    -- 兵种即使存在兵种特性，也要判断是否触发，未触发，即为没有
    local outStatus = self.model:getProp(GeneralDataConst.PROP_OUTSTATUS)
    if outStatus then
        local outStatusRate = self.model:getProp(GeneralDataConst.PROP_OUTSTATUSRATE) or 1
        if Random.isTrigger(outStatusRate) then
            self.armyOutStatusHit = true
            printInfo("%s成功触发兵种特性", self:getName())
            return true
        end
    end

    -- 武器附带的攻击状态
    if self:hasEquipEffect(EquipEffectInfo.EFFECT_ADD_HITSTATUS) then
        return true
    end

    return false
end

-- 获取攻击附加状态
General.getAttackStatus = function(self)
    local statusIds = {}

    local outStatus = self.model:getProp(GeneralDataConst.PROP_OUTSTATUS)
    if self.armyOutStatusHit then
        table.insert(statusIds, outStatus)
        self.armyOutStatusHit = nil
    elseif outStatus then
        local outStatusRate = self.model:getProp(GeneralDataConst.PROP_OUTSTATUSRATE) or 1
        if Random.isTrigger(outStatusRate) then
            table.insert(statusIds, outStatus)
        end
    end

    local _, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_ADD_HITSTATUS)
    if equips then
        table.walk(equips, function(equip)
            local statusId = equip:getEffectValue()
            table.insert(statusIds, statusId)
        end)
    end

    return statusIds
end

----------------------------------------------------------------
-- 设置此武将回合结束，人物变暗，不可单击
General.makeActionDone = function(self, callback)
    printInfo("%s回合结束", self:getName())

    self.origRow, self.origCol = nil, nil

    -- 重置掉cache
    self:resetMoveRangeCache()

    local onActionDone = function()
        self:updateActionDoneStatus(true)
        self:stand()
        self.animation:tintBy(MIDDLE_ANIMATION_TIME, -100, -100, -100)

        self:performWithDelay(function()
            EventMgr.triggerEvent(EventConst.PLOT_CHECK_CONDTION, function()
                if callback then
                    callback()
                end

                if MapUtils.getCurrentGeneral() == self then
                    MapUtils.setCurrentGeneral(nil)
                end

                EventMgr.triggerEvent(EventConst.GENERAL_ACTION_DONE, self)
            end)
        end, MIDDLE_ANIMATION_TIME)
    end

    EventMgr.triggerEvent(EventConst.GENERAL_SMALLMAP_DONE, self)

    onActionDone()
end

General.refreshAction = function(self)
    if self:isActionDone() then
        printInfo("武将行动重置%s-%d", self:getName(), self:getScriptIndex())
        self:updateActionDoneStatus(false)
        self.animation:tintBy(0.2, 100, 100, 100)

        EventMgr.triggerEvent(EventConst.GENERAL_SMALLMAP_REFRESH, self)
    end
end

-- 判断武将是否在恢复地形上
General.isInRecoverTile = function(self)
    return MapUtils.isRecoverTile(self:getRow(), self:getCol())
end

--[[
    每回合开始时的处理，可以处理一些人物特殊技能(舞娘的觉醒)和一些道具的效果(如凤凰羽衣)
        判断顺序：
        0、ai自检，判断如果是固定目标死亡这种，需要改变ai类型
        1、舞姬和太平领清道这类道具和技能引发的移除状态效果
        2、判断武将自我移除buffer的概率
        3、buffer导致的生命减少
        4、道具和恢复地形导致的生命添加
--]]
General.turnBegin = function(self, callback)
    callback = callback or function() end

    EventMgr.triggerEvent(EventConst.MOVE_TO_NODE, self)

    printInfo("turnBegin检查:%s", self:getName())

    if not self:isPlayer() then
        -- ai类型自检，如果需要攻击和跟随的目标死亡，ai类型会改变
        if self:getAiType() == "攻击武将" then
            local fixTarget = self:getFixGeneral()
            if (not fixTarget) or fixTarget:isDie() then
                printInfo("ai的攻击目标武将已死亡，ai调整为主动出击")
                self:setFixGeneral(nil)
                self:setAiType("主动出击")
            end
        elseif self:getAiType() == "跟随武将" then
            local followTarget = self:getFixGeneral()
            if (not followTarget) or followTarget:isDie() then
                printInfo("ai的跟随目标武将已死亡，ai调整为主动出击")
                self:setFixGeneral(nil)
                self:setAiType("主动出击")
            end
        end
    end

    local PROPS_MAP = {
        Hp        = "hpHeal",
        Mp        = "mpHeal",
        Exp       = "exp",
        WuqiExp   = "wuqiExp",
        FangjuExp = "fangjuExp",
    }
    local propsChange = {hpDamge = 0, mpDamge = 0, hpHeal = 0, mpHeal = 0, exp = 0, wuqiExp = 0, fangjuExp = 0}

    local onStep2 = function()
        local onStep4 = function()
            -- 是否有每回合增加属性的道具，如凤凰羽衣，三韬六略等
            printInfo("turnBegin:是否有每回合增加属性的道具，如凤凰羽衣，三韬六略等")
            local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_TURN_BEGIN_ADD_PROP)
            if hasEffect then
                table.walk(equips, function(equip)
                    local value, valueType = equip:getEffectValue()
                    if valueType == "fix" then
                        table.walk(equip.config.effect.props, function(prop)
                            propsChange[PROPS_MAP[prop]] = value
                        end)
                    elseif valueType == "percent" then
                        table.walk(equip.config.effect.props, function(prop)
                            local newValue = math.floor(self:getProp(prop) * value)
                            propsChange[PROPS_MAP[prop]] = newValue
                        end)
                    end
                end)
            end

            printInfo("判断是否在恢复地形上")
            if self:isInRecoverTile() then
                local curePercent = MapUtils.getTileInfo(self:getRow(), self:getCol()).curePercent
                propsChange.hpHeal = math.floor(propsChange.hpHeal + self:getMaxHp() * curePercent / 100)
            end

            propsChange.general = self
            propsChange.hpDamge = propsChange.hpDamge - propsChange.hpHeal
            propsChange.mpDamge = propsChange.mpDamge - propsChange.mpHeal

            local checkHpDamge = function(general, hpDamge)
                return (hpDamge < 0 and general:getCurrentHp() < general:getMaxHp()) or hpDamge > 0
            end
            local checkMpDamge = function(general, mpDamge)
                return (mpDamge < 0 and general:getCurrentMp() < general:getMaxMp()) or mpDamge > 0
            end
            local checkExpChange = function(propsChange)
                return propsChange.exp > 0 or propsChange.wuqiExp > 0 or propsChange.fangjuExp > 0
            end

            -- 玩家会因伤害、治疗和经验变化引发hurtView，友军和敌军仅因hp和mp变化才引发hurtView
            if self:isPlayer() and (checkHpDamge(self, propsChange.hpDamge) or checkMpDamge(self, propsChange.mpDamge) or checkExpChange(propsChange)) then
                EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, {}, propsChange, false, callback)
            elseif checkHpDamge(self, propsChange.hpDamge) or checkMpDamge(self, propsChange.mpDamge) then
                EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, {}, propsChange, false, callback)
            else
                callback()
            end
        end

        local onStep3 = function()
            -- 3、buffer导致的生命减少
            printInfo("turnBegin:buffer导致的生命减少检查")
            if self:isZhongDu() then
                propsChange.hpDamge = math.min(math.floor(self:getMaxHp() * STATUS_DU_DAMGE_PERCENT), self:getCurrentHp() - 1)
                propsChange.general = self
                EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, {}, propsChange, false, function()
                    propsChange.hpDamge = 0
                    onStep4()
                end)
            else
                onStep4()
            end
        end

        -- 2、判断武将自我移除buffer的概率
        printInfo("turnBegin:判断武将自我移除buffer的概率")
        self:statusTurnBegin(onStep3)
    end

    local onStep1 = function()
        printInfo("turnBegin:去除状态的道具检查（也就是太平清领道）")
        -- 去除状态的道具处理（也就是太平清领道）
        local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_TURN_BEGIN_REMOVE_STATUS)
        if hasEffect then
            table.walk(equips, function(equip)
                table.oneByOne(equip.config.effect.statuses, function(statusId, nextCallback)
                    if self:hasStatus(statusId) then
                        self:excitation(0, 0, function()
                            self:removeStatus(statusId, nextCallback)
                        end)
                    else
                        nextCallback()
                    end
                end, onStep2)
            end)
        else
            onStep2()
        end
    end

    -- 1、舞姬和太平领清道这类道具和技能引发的移除状态效果
    -- 优先技能判断，然后在道具判断
    local turnBegin = self.model:getProp(GeneralDataConst.PROP_TURNBEGIN)
    if turnBegin then
        -- 这里以后可以扩展，实现支持各种策略或其他功能
        local magicId = turnBegin.magic
        if magicId then
            local magicConfig = clone(InfoUtil.getMagicConfig(magicId))
            magicConfig.name  = turnBegin.name or magicConfig.name -- 修改下策略的名字，如果有的话

            -- 这里目前偷懒，直接就用周围武将替代，且默认这个策略是针对我方的策略，可以设计是否包含自己
            local targets = self:getAroundTargets(true, turnBegin.isContainSelf)
            MagicAttack.new(self, magicConfig, self, targets, onStep1, false)
        else
            onStep1()
        end
    else
        onStep1()
    end
end

General.getOppositeDir = function(self)
    return MapUtils.getOppositeDir(self:getDir())
end

--[[
    获取target武将周围距离self最近一个位置
    通过获取每个可以达到位置的寻路cost值，取最低的座位目标位置
--]]
General.getNearestTile = function(self, target)
    local moveRange = self:getMoveRange(true)
    local hasCheckdTiles = {}
    local targetTile = {}
    local isFind = false

    local findNearestTile
    findNearestTile = function(row, col)
        if isFind then
            return
        end

        hasCheckdTiles[row .. "-" .. col] = true

        local checkList = {}
        if row > 1 then
            table.insert(checkList, {row = row - 1, col = col})
        end
        if row < MapUtils.getRows() then
            table.insert(checkList, {row = row + 1, col = col})
        end
        if col > 1 then
            table.insert(checkList, {row = row, col = col - 1})
        end
        if col < MapUtils.getCols() then
            table.insert(checkList, {row = row, col = col + 1})
        end

        for _, v in ipairs(checkList) do
            if not MapUtils.getTileInfo(v.row, v.col).isCannotMove and not hasCheckdTiles[v.row .. "-" .. v.col] then
                local isInMoveRange = table.findIf(moveRange, function(moveTile)
                    return moveTile.row == v.row and moveTile.col == v.col
                end)

                if isInMoveRange then
                    isFind = true
                    targetTile = {row = v.row, col = v.col}
                    return
                else
                    findNearestTile(v.row, v.col)
                end
            end

            if isFind then
                return
            end
        end
    end

    findNearestTile(target:getRow(), target:getCol())
    return targetTile.row, targetTile.col
end

-- 获取一个最近的对手
General.getNearestOppotenter = function(self)
    local calcOffset = function(l, r)
        local rowOffset = l:getRow() - r:getRow()
        local colOffset = l:getCol() - r:getCol()
        return rowOffset * rowOffset + colOffset * colOffset
    end

    local index = 1
    local oppotenters = MapUtils.getAllOppositeGenerals(self)
    local offset = calcOffset(self, oppotenters[index])
    for i = 2, #oppotenters do
        local tempOffset = calcOffset(self, oppotenters[i])
        if offset > tempOffset then
            index = i
            offset = tempOffset
        end
    end

    return oppotenters[index]
end

-- 获取移动范围内的所有恢复地形，按恢复比例，由高到低排序
General.getAllRecoverTiles = function(self)
    local recoverTiles = {}
    local moveRange = self:getMoveRange(true)
    table.walk(moveRange, function(tile)
        local tileInfo = MapUtils.getTileInfo(tile.row, tile.col)
        if tileInfo.isRecoverTile and tileInfo.curePercent then
            table.insert(recoverTiles, {tile = tile, curePercent = tileInfo.curePercent})
        end
    end)

    table.sort(recoverTiles, function(l, r)
        return l.curePercent > r.curePercent
    end)

    return recoverTiles
end

-- getMoveRange，通过cacheMoveRange进行缓存，针对ai行为，可以节约20-30ms
General.resetMoveRangeCache = function(self)
    self.cacheMoveRange = nil
end

-- 获取武将移动范围， isNoContainOthers 表示不包含其他武将，默认为false
General.getMoveRange = function(self, isNoContainOthers)
    if not self:isPlayer() and self.cacheMoveRange then
        return isNoContainOthers and self.cacheMoveRange[1] or self.cacheMoveRange[2], self.cacheMoveRange[3]
    end

    if not self:canMove() then
        return {{row = self:getRow(), col = self:getCol()}}
    end

    local moveRange, mapBlock = PathUtils.makePath(self)
    local filterMoveRange = {}
    table.walk(moveRange, function(tile)
        local target = MapUtils.getGeneralByRowAndCol(tile.row, tile.col)
        if (not target) or target == self then
            table.insert(filterMoveRange, tile)
        end
    end)

    self.cacheMoveRange = {filterMoveRange, moveRange, mapBlock}
    return isNoContainOthers and self.cacheMoveRange[1] or self.cacheMoveRange[2], self.cacheMoveRange[3]
end

General.showPlotAttack = function(self, hurter, dir, callback)
    self:showAnimation("attack", dir, function()
        self:showAnimation("stand", dir, function()
            hurter:showAnimation("hurt", "", function()
                hurter:showAnimation("weak", "", callback)
            end)
        end)
    end)
end

-- 目前主要用于Ai中判断，武将是否可以执行action，只要不混乱且未行动过即可
General.canDoAction = function(self)
    return not self:isHunLuan() and not self:isActionDone()
end

-- 用于ai和玩家判断是否允许移动
General.canMove = function(self)
    return not self:isDingShen()
end

-------------------------------------------------------------------------------------------
General.statusTurnBegin = function(self, callback)
    local statuses = self:getStatusMgr():getAllStatuses()
    table.oneByOne(statuses, function(status, nextCallback)
        status:turnBegin()
        if status:canRemove() then
            printInfo("%s的%s状态持续了%d回合，现在移除了", self:getName(), status:getName(), self:getAliveRounds() - 1)
            self:removeStatus(status:getId(), nextCallback)
        else
            printInfo("%s的%s状态继续保持，目前%d回合", self:getName(), status:getName(), self:getAliveRounds())
            nextCallback()
        end
    end, callback)
end

General.addStatus = function(self, statusId, callback)
    callback = callback or function() end

    self:getStatusMgr():addStatus(statusId)
    self:addStatusIcon(statusId)

    -- 附加状态移动到指定目标处显示
    EventMgr.triggerEvent(EventConst.MOVE_TO_NODE, self)

    if statusId == "中毒" then
        local showStatus = true
        self.statusHandler = self:schedule(function()
            if showStatus then
                self.animation:setFilter(filter.newFilter("RGB", {0, 0.7, 0}))
            else
                self.animation:clearFilter()
            end

            showStatus = not showStatus
        end, 0.3)
    end

    local animationConfig = self:getStatusMgr():getAnimationConfig(statusId)
    if animationConfig then
        local magic = Magic.new(animationConfig, callback)
        magic:addTo(self, CharViewConst.ZORDER_GENERAL_MAGIC)
    else
        local icon = display.newSprite(InfoUtil.getStatusIcon(statusId))
        icon:align(display.LEFT_TOP, 0, MapConst.BLOCK_HEIGHT)
        icon:addTo(self, CharViewConst.ZORDER_GENERAL_STATUS)

        local duration = 0.1 / 2
        local a1 = cca.moveBy(duration, MapConst.BLOCK_WIDTH / 2, -5)
        local a2 = cca.moveBy(duration, MapConst.BLOCK_WIDTH / 2 - 10, 5)
        local a3 = cca.moveBy(duration, -MapConst.BLOCK_WIDTH / 2 + 10, 5)
        local a4 = cca.moveBy(duration, -MapConst.BLOCK_WIDTH / 2, -5)
        local a5 = cca.cb(callback)
        local seq = cca.seq({a1, a2, a3, a4, a5})
        icon:runAction(seq)

        if self.statusIcon then
            self.statusIcon:removeSelf()
        end
        self.statusIcon = icon
    end
end

General.removeStatus = function(self, statusId, callback)
    callback = callback or function() end

    if self:hasStatus(statusId) then
        self:getStatusMgr():removeStatus(statusId)
        self:removeStatusIconOnly(statusId)

        -- 移除动画
        local icon = display.newSprite(InfoUtil.getStatusIcon(statusId))
        icon:runAction(cca.seq({cca.fadeOut(0.4), cca.cb(function()
            icon:removeSelf()
            callback()
        end)}))
        icon:align(display.LEFT_TOP, 0, MapConst.BLOCK_HEIGHT)
        icon:addTo(self, CharViewConst.ZORDER_GENERAL_STATUS)
    else
        callback()
    end
end

General.hasStatus = function(self, statusId)
    return self.battleModel:hasStatus(statusId)
end

General.hideStatusIcon = function(self)
    if self.statusIcon then
        self.statusIcon:hide()
    end
end

General.showStatusIcon = function(self)
    if self.statusIcon then
        self.statusIcon:show()
    end
end

General.addStatusIcon = function(self, statusId)
    self.statusIcon = display.newSprite(InfoUtil.getStatusIcon(statusId))
    self.statusIcon:align(display.LEFT_TOP, 0, MapConst.BLOCK_HEIGHT)
    self.statusIcon:addTo(self, CharViewConst.ZORDER_GENERAL_STATUS)
end

General.addStatusIconOnly = function(self, statusId)
    local icon = display.newSprite(InfoUtil.getStatusIcon(statusId))
    icon:align(display.LEFT_TOP, 0, MapConst.BLOCK_HEIGHT)
    icon:addTo(self, CharViewConst.ZORDER_GENERAL_STATUS)
    icon:setNodeEventEnabled(true)
    icon.onEnter = function(icon)
        self:hideStatusIcon()
    end
    icon.onExit = function(icon)
        self:showStatusIcon()
    end
    return icon
end

General.removeStatusIconOnly = function(self, statusId)
    if self.statusIcon then
        self.statusIcon:removeSelf()
        self.statusIcon = nil
    end

    --!! 这里应该只有毒需要移除这个状态
    if statusId == "中毒" then
        self.animation:clearFilter()
        self:stopAction(self.statusHandler)
        self.statusHandler = nil
    end
end

General.removeAllBadStatus = function(self, callback)
    table.oneByOne(StatusMappingInfo.badStatuses, function(statusId, nextCallback)
        self:removeStatus(statusId, nextCallback)
    end, callback)
end

---------------------------------------------------------------------

General.getSide = function(self)
    return self.battleModel:getSide()
end

General.getId = function(self)
    return self.model:getId()
end

General.isFriend = function(self)
    return self.battleModel:isFriend()
end

General.isEnemy = function(self)
    return self.battleModel:isEnemy()
end

General.isPlayer = function(self)
    return self.battleModel:isPlayer()
end

General.getName = function(self)
    return self.model:getName()
end

General.getLevel = function(self)
    return self.model:getLevel()
end

General.getProfessionLevel = function(self)
    return self.model:getProfessionLevel()
end

General.getMaxHp = function(self)
    return self.battleModel:getMaxHp()
end

General.getCurrentHp = function(self)
    return self.battleModel:getCurrentHp()
end

General.getMaxMp = function(self)
    return self.battleModel:getMaxMp()
end

General.getCurrentMp = function(self)
    return self.battleModel:getCurrentMp()
end

-- 获取武器类型的名字
General.getArmyWuqiTypeName = function(self)
    return self.model:getEquip(GeneralDataConst.EQUIP_WUQI):getTypeName()
end

General.getEquipment = function(self, equipType)
    return self.model:getEquip(string.lower(equipType))
end

--!! 蛋疼，先改着，到时候统一合并
General.getBasicProp2 = function(self, propName)
    return self.model:getProp(propName)
end

--!! 蛋疼，到时候，统一使用GeneralModel替换 提供2点基本能力->提升对应的1点能力，同时提升20%的能力（短暂，由一个增益状态替代）
General.addBasicProp2 = function(self, propName, value)
    self.model:addProp(propName, value)
end

General.subMp = function(self, value)
    self.battleModel:subMp(value)
end

General.addMp = function(self, value)
    self.battleModel:addMp(-value)
end

General.subHp = function(self, value, callback)
    self.battleModel:subHp(value)

    local onSubHpComplete = function()
        EventMgr.triggerEvent(EventConst.GENERAL_HP_CHANGE)

        if callback then
            callback()
        end
    end

    self:stand()

    -- 判断是否具有受伤时使用道具的效果
    if value > 0 and self:isCanUseItemWhenHurt() then
        local itemId = self:getUseItemWhenHurt()
        if self:isPlayer() then
            GameData.subItem(itemId)
        end

        ItemUse.new(itemId, self, self, onSubHpComplete)
    else
        onSubHpComplete()
    end
end

-- 获取兵种类型(大类型)
General.getArmyType = function(self)
    return self.model:getArmyType()
end

-- 获取武将部队成长率(S, A, B, C)
General.getArmyAbilityRate = function(self, abilityName)
    return self.model:getArmyAbilityRate(abilityName)
end

General.getHeadIcon = function(self)
    return InfoUtil.getPath(self.model:getProp("head"), "head")
end

-- 获取武将列传 优先获取搞笑描述
General.getGeneralDesc = function(self)
    return self.model:getProp(GeneralDataConst.PROP_FUNDESC) or self.model:getProp(GeneralDataConst.PROP_DESC)
end

-- 是否为有名武将，不是小兵的都是有名武将
General.isFamous = function(self)
    return self.model:isFamous()
end

-- 获取兵种职业类型(小类型)
General.getProfessionType = function(self)
    return self.model:getProfessionType()
end

-- 获取兵种策略相克因子，没有指明的相克因子，一律返回1
General.getArmyMagicFactor = function(self, target)
    return self.model:getProp(GeneralDataConst.PROP_MAGICFACTOR) or 1
end

-- 获取兵种分类，文官还是武将
General.getArmyCategory = function(self)
    return self.model:getProp(GeneralDataConst.PROP_ARMYCATEGORY)
end

-- 获取策略的伤害因子，这里部分兵种对部分策略可以改变其伤害因子（如舞娘施展诱惑的策略因子为1.4）
General.getMagicDamageFactor = function(self, magicConfig)
    if not magicConfig.damgeFactor then -- 非伤害技能，不考虑武将的伤害系数
        return 0
    end

    if self.model:getProp(GeneralDataConst.PROP_MAGICDAMGEFACTOR) then
        for _, magicDamgeInfo in ipairs(self.model:getProp(GeneralDataConst.PROP_MAGICDAMGEFACTOR)) do
            if magicDamgeInfo.magicName == magicConfig.name then
                return magicInfo.damgeFactor
            end
        end
    end

    return magicConfig.damgeFactor
end

-- 获取兵种职业类型名
General.getProfessionName = function(self)
    return self.model:getProfessionName()
end

-- 武将是否为单体攻击
General.isSingleHitRange = function(self)
    return not self.model:getProp(GeneralDataConst.PROP_HITRANGETYPE)
end

-- 获取兵种描述
General.getArmyDesc = function(self)
    return self.model:getProp(GeneralDataConst.PROP_PROFESSIONDESC)
end

-- 获取武将所在地形的加成数值，如果对应地形，没有加成数值，一律返回100
General.getTileAddition = function(self)
    local tileName = MapUtils.getTileName(self:getRow(), self:getCol())
    local tileAddition = self.model:getProp(GeneralDataConst.PROP_TILEADDITION)
    if tileAddition and tileAddition[tileName] then
        return tileAddition[tileName]
    end

    return 100
end

General.getCurrentExp = function(self)
    return self.model:getCurrentExp()
end

General.addExp = function(self, exp)
    self.model:addExp(exp)
end

-- 判断是否拥有这种道具特效
General.hasEquipEffect = function(self, effectType)
    return self.model:hasEquipEffect(effectType)
end

-- 判断是否为远程兵种
General.isYuanChengArmy = function(self)
    return self.model:isYuanChengArmy()
end

-- 判断是否为攻击型文官
General.isAttackerMagicerArmy = function(self)
    return self.model:isAttackerMagicerArmy()
end

-- 判断是否为近战类兵种
General.isJinZhanArmy = function(self)
    return self.model:isJinZhanArmy()
end

-- 获取暴击台词
General.getCritWords = function(self)
    return self.model:getProp(GeneralDataConst.PROP_CRITWORDS)
end

-- 获取武将mp消耗率，没有特定装备，则默认为1
General.getMagicCostRate = function(self)
    return self.model:getMagicCostRate()
end

-- 获取武将是否具有突击移动的效果
General.isCanMoveIgnoreEnemy = function(self)
    return self.model:isCanMoveIgnoreEnemy()
end

-- 是否具有抵抗暴击的效果
General.isCanDefenseCritAttack = function(self)
    return self.model:isCanDefenseCritAttack()
end

-- 是否具有抵挡二次攻击的效果
General.isCanDefenseDoubleAttack = function(self)
    return self.model:isCanDefenseDoubleAttack()
end

-- 是否具有反击再反击的效果
General.isCanAttackBackAgain = function(self)
    return self.model:isCanAttackBackAgain()
end

-- 是否具有使对手反击无效的效果
General.isCanMakeNoAttackBack = function(self)
    return self.model:isCanMakeNoAttackBack()
end

-- 是否具有引导攻击的效果 counts表明已经引导的攻击次数，默认为0
General.isCanAttackAgainWhenTargetDie = function(self, counts)
    return self.model:isCanAttackAgainWhenTargetDie(counts)
end

-- 是否具有必定暴击的效果
General.isMustCritAttack = function(self)
    return self.model:isMustCritAttack()
end

-- 是否具有必定抵抗远程攻击的效果
General.isMustDefenseYuanCheng = function(self)
    return self.model:isMustDefenseYuanCheng()
end

-- 是否具有用Mp替代Hp的效果
General.isCanUseMpReplaceHp = function(self)
    return self.model:isCanUseMpReplaceHp()
end

-- 获取受击武将被攻击时伤害倍率，默认为1
General.getDefenseAttackDamageRate = function(self)
    -- 目前就是一些道具具有此效果，如皮制马铠和铜制马铠
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_DEFENSE_ATTACK_DAMGE)
    if hasEffect then
        local effect = equips[1].config.effect
        if table.indexof(effect.armyTypes, self:getArmyType()) then
            return effect.value
        end
    end

    return 1
end

-- 是否具有恶路移动效果
General.isCanMoveIgnoreTile = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_MOVE_IGNORE_TILE)
end

-- 获取经验增加率，默认为1
General.getAddExpRate = function(self)
    local factor = 1
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_ADD_EXP)
    if hasEffect then
        table.walk(equips, function(equip)
            factor = factor + equip:getEffectValue()
        end)
    end

    return factor
end

-- 是否在受伤时可以使用道具
General.isCanUseItemWhenHurt = function(self)
    if self:isDie() then
        return false
    end

    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_WHEN_HURT_USE_ITEM)
    if hasEffect then
        if not self:isPlayer() then
            -- 其他阵营无需考虑道具数目的问题
            return true
        else
            -- 玩家阵营需要满足道具数目足够
            local itemId = equips[1]:getEffectValue()
            return GameData.getConsumeItemCountById(itemId) > 0
        end
    end
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_WHEN_HURT_USE_ITEM)
end

-- 获取受伤时会自动使用的道具
General.getUseItemWhenHurt = function(self)
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_WHEN_HURT_USE_ITEM)
    if hasEffect then
        return equips[1]:getEffectValue()
    end
end

General.isDie = function(self)
    return self.battleModel:isDie()
end

General.isAlive = function(self)
    return not self.battleModel:isDie()
end

-- 是否为过关的关键敌人
General.isKeyGeneral = function(self)
    return self.battleModel:isKeyGeneral()
end

-- 设置是否显示撤退台词
General.setShowRetreatWords = function(self, isShow)
    self.battleModel:setIsShowRetreatWords(isShow)
end

-- 只更新行列值，因为在移动过程当中，只会更新pos，而不会更新行列值
General.setRowAndColOnly = function(self, row, col)
    self.battleModel:setRowAndCol(row, col)
end

General.getRow = function(self)
    return self.battleModel:getRow()
end

General.getCol = function(self)
    return self.battleModel:getCol()
end

-- 设置战斗中的出场顺序，目前是3个阵营的出场顺序，分别算自己的
General.setScriptIndex = function(self, index)
    self.battleModel:setScriptIndex(index)
end

-- 获取战斗中的出场顺序，目前是3个阵营的出场顺序，分别算自己的
General.getScriptIndex = function(self)
    return self.battleModel:getScriptIndex()
end

-- 武将是否残血
General.isInjury = function(self)
    return self.battleModel:isInjury()
end

-- 更新武将行动状态
General.updateActionDoneStatus = function(self, isActionDone)
    self.battleModel:setIsActionDone(isActionDone)
end

-- 获取武将是否行动完毕
General.isActionDone = function(self)
    return self.battleModel:isActionDone()
end

General.setAiType = function(self, aiType, aiArgs)
    self.battleModel:setAiType(aiType, aiArgs)
end

General.getAiType = function(self)
    return self.battleModel:getAiType()
end

General.getAiArgs = function(self)
    return self.battleModel:getAiArgs()
end

-- 设置指定方块群作为移动地点
General.setFixTiles = function(self, tiles)
    self.battleModel:setFixTiles(tiles)
end

-- 获取指定移动地点
General.getFixTiles = function(self)
    return self.battleModel:getFixTiles()
end

-- 设置固定攻击武将，ai使用的
General.setFixGeneral = function(self, target)
    self.battleModel:setFixGeneral(target)
end

-- 获取固定攻击的武将
General.getFixGeneral = function(self)
    return self.battleModel:getFixGeneral()
end

General.setHide = function(self, isHide)
    self.battleModel:setHide(isHide)
    self:setVisible(not isHide)
end

-- 获取装备对于物理命中的附加因子(攻击方)，isAttacker用来判断是进攻方还是受击方，默认为false
General.getItemHitrateFactor = function(self, isAttacker, target)
    return self.model:getItemHitrateFactor(isAttacker, target)
end

-- 获取装备对于物理伤害的附加因子
General.getItemDamgeFactor = function(self, target)
    return self.model:getItemDamgeFactor(target)
end

-- 获取装备对于策略伤害的附加因子，isAttacker用来判断是进攻方还是受击方，默认为false
General.getItemMagicFactor = function(self, isAttacker, magicConfig)
    return self.model:getItemMagicFactor(isAttacker, magicConfig)
end

-- isAttacker用来判断是进攻方还是受击方，默认为false
General.getItemMagicHitRate = function(self, isAttacker)
    return self.model:getItemMagicHitRate(isAttacker)
end

General.hasEquip = function(self, equipId)
    return self.model:hasEquip(equipId)
end

-- 获取武将朝向
General.getDir = function(self)
    return self.battleModel:getDir()
end

-- 设置攻击者是谁，这样死亡时，可以通过这个询问得知是谁弄死武将的
General.setAttacker = function(self, attacker)
    self.battleModel:setAttacker(attacker)
end

-- 获取攻击者
General.getAttacker = function(self)
    return self.battleModel:getAttacker()
end

General.isMagicHited = function(self, target, magicConfig)
    return self.model:isMagicHited(target, magicConfig)
end

-- 判断本次攻击是否命中
General.isHited = function(self, target)
    return self.model:isHited(target)
end

-- 判断本次是否为暴击
General.isCrit = function(self, target)
    return self.model:isCrit(target)
end

-- 判断本次攻击是否为连击
General.isDoubleAttack = function(self, target, attackBackCount, doubleAttackCount, dieAgainAttackCount)
    return self.model:isDoubleAttack(target, attackBackCount, doubleAttackCount, dieAgainAttackCount)
end

-- 获取兵种相克因子，没有指明的相克因子，一律返回1
General.getArmydamgeFactor = function(self, target)
    return self.model:getArmydamgeFactor(target)
end

-----------------------------------------------------
General.newGetAttackAllHitTargets = function(self)
    local targetInfos = {}
    table.walk(self:getMoveRange(true), function(moveTile)
        local attackRange = self:getAttackRange(moveTile.row, moveTile.col)
        table.walk(attackRange, function(attackTile)
            local target = MapUtils.getGeneralByRowAndCol(attackTile.row, attackTile.col)
            if target and target:isOpponent(self) and not targetInfos[target] then
                targetInfos[target]            = {}
                targetInfos[target].mainTarget = target
                targetInfos[target].targets    = self:getHitTargets(attackTile.row, attackTile.col, moveTile.row, moveTile.col)
                targetInfos[target].moveRow    = moveTile.row
                targetInfos[target].moveCol    = moveTile.col
            end
        end)
    end)

    return targetInfos
end

General.newGetMagicAllHitTargets = function(self, magicId)
    Profiler.checkStart(self:getName() .. " " .. magicId .. "合并")
    local totalRanges = {}
    local magicConfig = InfoUtil.getMagicConfig(magicId)
    table.walk(self:getMoveRange(true), function(moveTile)
        local magicRange = AttackRangeUtils.getAttackRange(magicConfig.rangeType, moveTile.row, moveTile.col, moveTile.row, moveTile.col)
        table.walk(magicRange, function(magicTile)
            local isHad = table.findIf(totalRanges, function(existedTile)
                return magicTile.row == existedTile.row and magicTile.col == existedTile.col
            end)
            if not isHad then
                table.insert(totalRanges, {row = magicTile.row, col = magicTile.col, moveRow = moveTile.row, moveCol = moveTile.col})
            end
        end)
    end)
    Profiler.checkEnd()

    Profiler.checkStart(self:getName() .. " " .. magicId .. "筛选目标")
    local targetInfos = {}
    table.walk(totalRanges, function(magicTile)
        local target = MapUtils.getGeneralByRowAndCol(magicTile.row, magicTile.col)
        if target and target:isMatchMagicTarget(self, magicConfig) and MapUtils.isSupportMagicTile(magicId, magicTile.row, magicTile.col) then
            if not targetInfos[target] then
                targetInfos[target]            = {}
                targetInfos[target].mainTarget = target
                targetInfos[target].moveRow    = magicTile.moveRow
                targetInfos[target].moveCol    = magicTile.moveCol
                targetInfos[target].targets    = self:getMagicHitTargets(magicConfig, magicTile.row, magicTile.col, magicTile.moveRow, magicTile.moveCol)
                if #targetInfos[target].targets == 0 then
                    targetInfos[target].targets = {target}
                end
            end
        end
    end)
    Profiler.checkEnd()

    return targetInfos
end

return General