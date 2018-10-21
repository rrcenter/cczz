--[[
    AI相关的一些辅助借口
    被动出击、主动出击、攻击武将、到达指定地点的 AI 如果残血,会朝着本方第一个出场的有名武 将方向移动,如果该名武将已撤退,则会朝最近的敌方单位移动。
    到达指定地点、逃至指定地点的 AI 如果到了指定点,AI 类型会变更为被动出击。
--]]

local AiUtils = {}

--[[
    第1项：可击毙目标。（78）
    即预估伤害值大于等于目标剩余HP。这项价值的确很高，但也不是不可超越。若不满足这项，则看第2项。

    第2项：对目标的伤害大于等于总HP的10%。（14）

    第3项：对目标的伤害小于总HP的10%，目标剩余HP小于总HP的41%。（14）
    这就是所谓的电脑会优先攻击血少的目标，也就是亚残血理论，优先度与第2项相同。若不满足这项，则看第4项。

    第4项：对目标的伤害小于总HP的10%，目标剩余HP大于等于总HP的41%，AI类型是主动出击。（8）
    若这项再不满足，则跟单体攻击伤害有关的价值为0。1~4项是互斥的，最多只能满足其中一项。

    第5项：AI拥有多体攻击的能力，目标是单体状态。（-4）

    第6项：AI拥有多体攻击的能力，目标是连体状态。（10*A+4*B）
    A和B都是目标连着的人数。A是满足第1项的人数，B是满足第2项的人数。

    第7项：目标混乱。（8）

    第8项：目标是有名武将。（4）

    第9项：目标是有名武将，且第一个出场（友军AI）。（8）

    第10项：可不在目标的攻击范围内攻击（无反击）。（1）
    这就是我们通常说的无反击，其实这是一种位置价值，并非攻击武将的价值。
    攻击混乱的敌人、或者装备青龙刀都是“无反击”，但这些“无反击”并无价值。

    第11项：非残血时可进入恢复地形攻击目标。（8或7或6）
    AI前一回合处于100%及以下的地形 8
    AI前一回合处于110%及以下的地形 7
    AI前一回合处于120%及以下的地形 6

    第12项：残血时可进入恢复地形攻击目标。（X+50）
    在第11项的基础上加上50。

    第13项：可进入目的地攻击目标。（10）
    “攻击武将”，“到指定点”，“跟随武将”，“逃至指定点”这四种AI都是有目的地的，这比较好理解。
    还有上面介绍AI类型时说过，有四种AI残血时，会朝着本方第一个出场的有名武将方向移动，这个有名武将的位置也是一个目的地。
    如果一回合内不能移动到这些目的地，那么就会产生一个临时目的地。
    如果目的地被自己人占据，还会产生新的目的地。
    关于目的地的具体算法，请看《曹操传AI站位规律》一文。

    第14项：可进入目的地上下左右四格攻击目标。（9）

    第15项：以上几个位置若无法攻击到目标，则其位置价值减少1
    此项可以用来判断AI是去攻击目标还是去某个位置。有个例外是，如果恢复地形和目的地是同一个地方，那么作为恢复地形的价值不用减1。
--]]
-- mainTarget主要目标，targets如果具有多体攻击，这里内容应该大于1
-- moveRow和moveCol表明移动的地点，没有则表明是武将自己所在的点
AiUtils.getAttackCost = function(general, mainTarget, targets, aiType, moveRow, moveCol)
    moveRow = moveRow or general:getRow()
    moveCol = moveCol or general:getCol()

    local getSingleTargetCost = function(target)
        local cost, index = 0
        local damgeInfo = GeneralUtils.calcAttackDamge(general, target)
        if damgeInfo.type == "hp" then
            local targetHp = target:getCurrentHp()
            local targetMaxHp = target:getMaxHp()
            if damgeInfo.estimatedDamge >= target:getCurrentHp() then
                cost = 78 -- 可击毙目标。（78）
                index = 1
            elseif damgeInfo.estimatedDamgePercent >= 10 then
                cost = 14 -- 对目标的伤害大于等于总HP的10%。（14）
                index = 2
            elseif damgeInfo.estimatedDamgePercent < 10 and target:getCurrentHp() < target:getMaxHp() * 0.41 then
                cost = 14 -- 对目标的伤害小于总HP的10%，目标剩余HP小于总HP的41%。（14）
                index = 3
            elseif damgeInfo.estimatedDamgePercent < 10 and target:getCurrentHp() >= target:getMaxHp() * 0.41 and aiType == "主动出击" then
                cost = 8 -- 对目标的伤害小于总HP的10%，目标剩余HP大于等于总HP的41%，AI类型是主动出击。（8）
                index = 4
            end
        end

        return cost, index
    end

    local attackCost = getSingleTargetCost(mainTarget)
    if not general:isSingleHitRange() then
        if #targets == 1 then
            attackCost = attackCost - 4 -- AI拥有多体攻击的能力，目标是单体状态。（-4）
        else
            -- AI拥有多体攻击的能力，目标是连体状态。（10*A+4*B），A和B都是目标连着的人数。A是满足第1项的人数，B是满足第2项的人数。
            local A, B = 0, 0
            table.walk(targets, function(target)
                local _, index = getSingleTargetCost()
                if index == 1 then
                    A = A + 1
                elseif index == 2 then
                    B = B + 1
                end
            end)
            attackCost = attackCost + 10 * A + 4 * B
        end
    end

    if mainTarget:isHunLuan() then
        attackCost = attackCost + 8 -- 目标混乱。（8）
    end

    if mainTarget:isFamous() then
        attackCost = attackCost + 4 -- 目标是有名武将。（4）
        if mainTarget:getScriptIndex() == 1 and general:isFriend() then
            attackCost = attackCost + 8 -- 目标是有名武将，且第一个出场（友军AI）。（8）
        end
    end

    if not mainTarget:isInAttackRange(general, moveRow, moveCol) then
        attackCost = attackCost + 1 -- 可不在目标的攻击范围内攻击（无反击）。（1）
    end

    -- 是否移动到的区域是可恢复区域
    if MapUtils.isRecoverTile(moveRow, moveCol) then
        local tileAdditon = general:getTileAddition()
        if tileAdditon <= 100 then
            attackCost = attackCost + 8 -- AI前一回合处于100%及以下的地形 8
        elseif tileAdditon <= 110 then
            attackCost = attackCost + 7 -- AI前一回合处于110%及以下的地形 7
        elseif tileAdditon <= 120 then
            attackCost = attackCost + 6 -- AI前一回合处于120%及以下的地形 6
        end

        if general:isInjury() then
            attackCost = attackCost + 50 -- 残血时可进入恢复地形攻击目标。（X+50）
        end
    end

    return attackCost
end

--[[
    攻击策略说明：
    1、跟物理伤害类似，策略伤害也是看比例，所以可以利用精神力低血少的人把敌军法师引上来。
    这也是典韦怕策略的原因之一，由于血少，敌军法师的灼热对他的伤害经常超过30%，所以虽然和许褚同样是C档次的精神力，但比许褚更容易被集火。

    2、和物理伤害不同的是，策略伤害会把伤害浮动值算进去。
    比如目标总HP是300，AI对其策略伤害是98，算上浮动伤害最高有102，那么也算是在[30%，100%)的区间内。

    3、诱惑必须是AI的HP未满时才会有使用价值。

    4、群伤策略的连体状态算法估计是和物理攻击一样的，未验证。

    辅助和妨碍策略说明：
    1、封咒、谎报、谎言这三种策略看的是命中率，太低了AI就不会使用。
    2、谎报的价值是30，也就是说如果AI对目标的策略伤害小于其总HP的30%，就会优先使用谎报。
    3、谎报和伤害在[30%，100%)区间的灼热都是30的价值，AI的使用规律是这样的。
    4、用觉醒解混乱有40的价值，解麻痹的价值有30，比一般的物理攻击价值高，所以杨家将里的战神经常优先使用觉醒。

    补给策略说明：
    1、输送的价值比大补给高，所以即使是近距离，AI也是使用输送。
    2、援队和援军的价值是一样的，这点比较奇怪。当用援队和援军能补给到相同数量的人时，AI优先使用援队。

    以上所说的策略价值是在AI可以在原地施放策略，而且攻击范围内无敌方单位时的价值。
    如果需要移动施放策略，或者攻击范围内有敌方单位，所有策略价值要减去1。
    不过这里似乎还跟AI类型有关，未详细测试。
    另外，当物理攻击价值和策略价值相同时，使用优先度为物理攻击>攻击策略>补给策略>辅助和妨碍策略。

    攻击策略
             (0-10%) [10%-30%) [30%-100%)     这是预估伤害值+4占总HP的比例范围
    1 灼热等     1       10       30           包括四系所有单体策略
    2 定身      11       20       40          目标不处于麻痹状态时才会使用
    3 毒烟       9       18       38          目标不处于中毒状态时才会使用
    4 诱惑       6       15       35          自身HP未满，但不是残血
      诱惑      16       25       45          自身残血
          策略击毙目标的价值似乎跟物理攻击一样是78，不太确定
    5 群伤策略            X-4                   目标是单体状态，X是对应的单体策略的价值
      群伤策略            X+4*N                 目标是连体状态，N是目标连着的人数

    辅助和妨碍策略
    6 谍报            20                    自身MP小于等于总MP的20%，且目标有MP时才会使用。
    7 封咒            22                    目标是文官，且命中率大于等于60%时才会使用
    8 谎报            30                    命中率大于等于35%时才会使用
    9 谎言          26+(4+3*N)              对中心目标的命中率大于等于35%时才会使用
    10 觉醒   混乱    40
       觉醒   封咒    35                     目标是文官
       觉醒   封咒    5                      目标是非文官
       觉醒   麻痹    30                     目标的AI类型是二、四、五、六、七
       觉醒   麻痹    5                      目标的AI类型是一、三
       觉醒   中毒    5
         若目标同时中多种异常状态，则取优先值最高的一种，而不是叠加
    11 大觉醒        X-4                     目标是单体状态，X时觉醒对应的价值
       大觉醒        X+3*N                   目标是连体状态，N时目标连着的人数
    12  回归          3                     目标的AI类型不能是坚守原地

    补给策略
    13  小补级         50                   目标残血
    14  大补给         55                   目标残血
    15   输送         60                   目标残血
    16   援队援军      46                   目标残血，单体状态
         援队援军      50+5＊N               目标残血，连体状态，N是目标连着的HP小于等于60%的人数
    17  建言          12                   目标是文官和穿龙鳞铠的武将，且MP小于等于20%
    以上的策略价值都是AI可以原地不动释放策略，且攻击范围内无敌方单位时的价值。
--]]
-- isMove表示武将移动过，hasAttackTargets表示武将攻击范围内有敌人
-- moveRow和moveCol表明移动的地点，没有则表明是武将自己所在的点
AiUtils.getMagicCost = function(general, isMove, hasAttackTargets, moveRow, moveCol)
    moveRow = moveRow or general:getRow()
    moveCol = moveCol or general:getCol()

    local getAttackMagicCost = function(target, magicId)
        local cost = 0
        local magicConfig = InfoUtil.getMagicConfig(magicId)
        local damgeInfo = GeneralUtils.calcMagicDamge(general, target, magicConfig)
        if damgeInfo.type == "hp" then
            -- 这是预估伤害值+4占总HP的比例范围
            local damgePercent = damgeInfo.estimatedDamgePercent + math.floor(4 / target:getMaxHp() * 100)
            if (magicId == "定身" or magicId == "定军")and (not target:isDingShen()) then
                -- 目标不处于麻痹状态时才会使用
                if damgePercent < 10 then
                    cost = 11
                elseif damgePercent < 30 then
                    cost = 20
                elseif damgePercent < 100 then
                    cost = 40
                else
                    cost = 78
                end
            elseif (magicId == "毒烟" or magicId == "毒雾") and (not target:isZhongDu()) then
                -- 目标不处于中毒状态时才会使用
                if damgePercent < 10 then
                    cost = 9
                elseif damgePercent < 30 then
                    cost = 18
                elseif damgePercent < 100 then
                    cost = 38
                else
                    cost = 78
                end
            elseif magicId == "诱惑" then
                if general:isInjury() then
                    -- 自身残血
                    if damgePercent < 10 then
                        cost = 16
                    elseif damgePercent < 30 then
                        cost = 25
                    elseif damgePercent < 100 then
                        cost = 45
                    else
                        cost = 78
                    end
                elseif general:getCurrentHp() < general:getMaxHp() then
                    -- 自身HP未满，但不是残血
                    if damgePercent < 10 then
                        cost = 6
                    elseif damgePercent < 30 then
                        cost = 15
                    elseif damgePercent < 100 then
                        cost = 35
                    else
                        cost = 78
                    end
                end
            elseif table.indexof(MagicMappingInfo.AllNonStatusAttackMagics, magicId) then
                if damgePercent < 10 then
                    cost = 1
                elseif damgePercent < 30 then
                    cost = 10
                elseif damgePercent < 100 then
                    cost = 30
                else
                    cost = 78
                end
            end
        end

        return cost
    end

    local getFuZhuMagicCost = function(mainTarget, targets, magicId)
        local cost = 0
        local target = mainTarget
        local magicConfig = InfoUtil.getMagicConfig(magicId)
        local hitrate = GeneralUtils.calcMagicHitrate(general, target, magicConfig)
        local damgeInfo = GeneralUtils.calcMagicDamge(general, target, magicConfig)
        if magicId == "谍报" and general:getCurrentMp() <= general:getMaxMp() * 0.2 and target:getCurrentMp() > 0 then
            cost = 20 -- 自身MP小于等于总MP的20%，且目标有MP时才会使用。
        elseif magicId == "封咒" and target:getArmyCategory() == "wen" and hitrate >= 60 and (not target:isFengZhou()) then
            cost = 22 -- 目标是文官，且命中率大于等于60%时才会使用
        elseif magicId == "谎报" and hitrate >= 35 and (not target:isHunLuan()) then
            cost = 30 -- 命中率大于等于35%时才会使用
        elseif magicId == "谎言" and hitrate >= 35 and (not target:isHunLuan()) then
            if #targets == 1 then
                cost = 26 -- 谎言 单体 26
            else
                cost = 26 + 4 + 3 * #targets -- 谎言 26+(4+3*N) 对中心目标的命中率大于等于35%时才会使用
            end
        elseif magicId == "觉醒" or magicId == "大觉醒" then
            -- 若目标同时中多种异常状态，则取优先值最高的一种，而不是叠加
            local tempCosts = {}
            if target:isHunLuan() then
                table.insert(tempCosts, 40)
            end

            if target:isFengZhou() then
                if target:getArmyCategory() == "wen" then
                    table.insert(tempCosts, 35) -- 目标是文官 35
                else
                    table.insert(tempCosts, 5) -- 非文官5
                end
            end

            if target:isDingShen() then
                if target:getAiType() == "被动出击" or target:getAiType() == "坚守原地" then
                    table.insert(tempCosts, 5) -- 目标的AI类型是一、三
                else
                    table.insert(tempCosts, 30) -- 目标的AI类型是二、四、五、六、七
                end
            end

            if target:isZhongDu() then
                table.insert(tempCosts, 5)
            end

            if #tempCosts > 0 then
                cost = math.max(tempCosts)
            end

            if #targets == 1 then
                if magicId == "大觉醒" then
                    cost = cost - 4 -- 大觉醒 X-4 目标是单体状态，X时觉醒对应的价值
                end
            else
                cost = cost + 3 * #targets -- 大觉醒 X+3*N 目标是连体状态，N时目标连着的人数
            end
        elseif magicId == "回归" and target:getAiType() ~= "坚守原地" then
            cost = 3 -- 目标的AI类型不能是坚守原地
        end

        return cost
    end

    local getHealMagicCost = function(mainTarget, targets, magicId)
        local cost = 0
        local target = mainTarget
        local magicConfig = InfoUtil.getMagicConfig(magicId)
        local damgeInfo = GeneralUtils.calcMagicDamge(general, target, magicConfig)
        if magicId == "小补给" and target:isInjury() then
            cost = 50 -- 小补给 50 目标残血
        elseif magicId == "大补给" and target:isInjury() then
            cost = 55 -- 大补给 55 目标残血
        elseif magicId == "输送" and target:isInjury() then
            cost = 60 -- 输送 60 目标残血
        elseif magicId == "援军" or magicId == "援队" and target:isInjury() then
            if #targets == 1 then
                cost = 46 -- 援队援军 46 目标残血，单体状态
            else
                cost = 50 + 5 * #targets -- 援队援军 50+5＊N 目标残血，连体状态，N是目标连着的HP小于等于60%的人数
            end
        elseif magicId == "建言" then
            local isWuCondition = (target:getArmyCategory() == "wu") and target:isCanUseMpReplaceHp()
            if (target:getArmyCategory() == "wen" or isWuCondition) and target:getCurrentMp() <= target:getMaxMp() * 0.2 then
                cost = 12 -- 建言 12 目标是文官和穿龙鳞铠的武将，且MP小于等于20%
            end
        end

        return cost
    end

    local magicCosts = {}
    local allMagics = general:getAllCanUseMagics() -- 此处返回的策略，已经过滤过天气，道具和mp的限制
    table.filter(allMagics, function(magicId)
        return table.indexof(MagicMappingInfo.AllAiMagics, magicId)
    end)

    table.walk(allMagics, function(magicId)
        local index = 0
        local cost = 0
        local targetInfos = general:getMagicAllHitTargets(magicId, moveRow, moveCol)
        table.walk(targetInfos, function(targetInfo)
            local targets = targetInfo.targets
            if table.indexof(MagicMappingInfo.AllAttackMagics, magicId) then
                -- 攻击策略
                index = 1
                if #targets >= 1 then
                    cost = getAttackMagicCost(targetInfo.mainTarget, magicId)
                    if #targets == 1 then
                        if table.indexof(MagicMappingInfo.AllMultiAttackMagics, magicId) then
                            cost = cost - 4 -- 群伤策略 X-4 目标是单体状态，X是对应的单体策略的价值
                        end
                    else
                        cost = cost + 4 * #targets -- 群伤策略 X+4*N 目标是连体状态，N是目标连着的人数
                    end
                end
            elseif table.indexof(MagicMappingInfo.AllHealMagics, magicId) then
                -- 补给策略
                index = 2
                cost = getHealMagicCost(targetInfo.mainTarget, targets, magicId)
            elseif table.indexof(MagicMappingInfo.AllFuZhuMagics, magicId) then
                -- 辅助和妨碍策略
                index = 3
                cost = getFuZhuMagicCost(targetInfo.mainTarget, targets, magicId)
            end

            if isMove or hasAttackTargets then
                -- 如果需要移动施放策略，或者攻击范围内有敌方单位，所有策略价值要减去1。
                cost = cost - 1
            end

            if DEBUG_SHOW_AI_UTILS then
                printInfo("%s策略对%s的价值为:%d", magicId, targetInfo.mainTarget:getName(), cost)
            end
            table.insert(magicCosts, {magicId = magicId, cost = cost, index = index, targetInfo = targetInfo})
        end)
    end)

    -- 遍历找cost最高的一个策略，如果策略cost相同，则攻击策略>补给策略>辅助和妨碍策略
    table.sort(magicCosts, function(l, r)
        if l.cost == r.cost then
            return l.index < r.index
        end

        return l.cost > r.cost
    end)

    if magicCosts[1] and magicCosts[1].cost == 0 then
        return
    end

    return magicCosts[1]
end

-- 计算一个指定moveRow和moveCol处最大的attackCost或magicCost
AiUtils.calcTileCost = function(general, moveRow, moveCol)
    local attackCosts = {}
    local attackTargetInfos = general:getAttackAllHitTargets(moveRow, moveCol)
    table.walk(attackTargetInfos, function(attackTargetInfo)
        local cost = AiUtils.getAttackCost(general, attackTargetInfo.mainTarget, attackTargetInfo.targets, "被动出击", moveRow, moveCol)
        table.insert(attackCosts, {cost = cost, targetInfo = attackTargetInfo})
    end)

    table.sort(attackCosts, function(l, r)
        return l.cost > r.cost
    end)

    local maxMagicCost
    if general:canUseMagic() then
        local isMove = (moveRow ~= general:getRow()) or (moveCol ~= general:getCol())
        local hasAttackTargets = #attackCosts > 0
        maxMagicCost = AiUtils.getMagicCost(general, isMove, hasAttackTargets, moveRow, moveCol)
        if maxMagicCost then
            maxMagicCost.type = "magic"
        end
    end

    local maxAttackCost = attackCosts[1]
    if maxAttackCost then
        maxAttackCost.type = "attack"
    end

    if maxAttackCost and maxMagicCost then
        if maxAttackCost.cost > maxMagicCost.cost then
            return maxAttackCost
        else
            return maxMagicCost
        end
    elseif maxAttackCost then
        return maxAttackCost
    elseif maxMagicCost then
        return maxMagicCost
    else
        return {cost = 0}
    end
end

--[[
    传入武将和指定目的地，以及到达目的之后的回调，返回武将可以移动到的位置
    目前的算法是，算上武将地形移动消耗，生成从武将到目的点的一条路径
    然后计算这条路径与武将移动范围的重合性，找到武将最大移动到路径上的点
    没找到，返回nil
--]]
AiUtils.calcMoveTile = function(general, toRow, toCol, callback)
    local blockMap = MapUtils.getMapBlocksByGeneral(general)
    local movePath = SearchPathUtils.getAiAPath(blockMap, general:getRow(), general:getCol(), toRow, toCol)
    if not movePath then
        printInfo("%s没有搜寻到指定地点(%d, %d)的路径", general:getName(), toRow, toCol)
        return nil
    end

    local moveRange = general:getMoveRange(true)
    local pathIndex = table.findIf(movePath, function(path, i)
        return table.findIf(moveRange, function(tile)
            return tile.row == path.row and tile.col == path.col
        end)
    end)

    if pathIndex then
        local canMoveToDestination = false
        local destRow, destCol = movePath[pathIndex].row, movePath[pathIndex].col
        if destRow == toRow and destCol == toCol then
            printInfo("%s到达了指定地点", general:getName())
            canMoveToDestination = true
            if callback then
                callback()
            end
        end

        printInfo("%s将移动到(%d, %d)去", general:getName(), destRow, destCol)
        return {moveRow = destRow, moveCol = destCol, canMoveToDestination = canMoveToDestination}
    end

    return nil
end

-- 生成攻击命令
AiUtils.genAttackCmd = function(general, attackCost)
    return {
        cmd        = "attack",
        attacker   = general,
        mainTarget = attackCost.targetInfo.mainTarget,
        targets    = attackCost.targetInfo.targets,
    }
end

-- 生成策略命令
AiUtils.genMagicCmd = function(general, magicCost)
    return {
        cmd         = "magic",
        magicer     = general,
        magicConfig = InfoUtil.getMagicConfig(magicCost.magicId),
        mainTarget  = magicCost.targetInfo.mainTarget,
        targets     = magicCost.targetInfo.targets,
    }
end

AiUtils.genMoveCmd = function(general, moveCost)
    return {
        cmd = "move",
        mover = general,
        moveRow = moveCost.moveRow,
        moveCol = moveCost.moveCol,
    }
end

-- 生成啥都不做命令
AiUtils.genNoneCmd = function()
    return {cmd = "none"}
end

----------------------------------------------------------------------------
AiUtils.newCalcTileCost = function(general)
    local maxAttackCost = {cost = 0}
    table.walk(general:newGetAttackAllHitTargets(), function(targetInfo)
        local cost = AiUtils.getAttackCost(general, targetInfo.mainTarget, targetInfo.targets, "被动出击", targetInfo.moveRow, targetInfo.moveCol)
        if maxAttackCost.cost < cost then
            maxAttackCost = {cost = cost, targetInfo = targetInfo}
        end
    end)

    local maxMagicCost = {cost = 0}
    if general:canUseMagic() then
        local allMagics = general:getAllCanUseMagics() -- 此处返回的策略，已经过滤过天气，道具和mp的限制
        table.walk(allMagics, function(magicId)
            if table.indexof(MagicMappingInfo.AllAiMagics, magicId) then
                local magicCost = AiUtils.getNewMagicCost(general, magicId)
                if maxMagicCost.cost < magicCost.cost then
                    maxMagicCost = magicCost
                end
            end
        end)
    end

    maxAttackCost.type = "attack"
    maxMagicCost.type = "magic"

    return (maxAttackCost.cost > maxMagicCost.cost) and maxAttackCost or maxMagicCost
end

AiUtils.getSingleMagicCost = function(general, magicId, targetInfo)
    local getAttackMagicCost = function(general, target, magicId)
        local cost = 0
        local magicConfig = InfoUtil.getMagicConfig(magicId)
        local damgeInfo = GeneralUtils.calcMagicDamge(general, target, magicConfig)
        if damgeInfo.type == "hp" then
            -- 这是预估伤害值+4占总HP的比例范围
            local damgePercent = damgeInfo.estimatedDamgePercent + math.floor(4 / target:getMaxHp() * 100)
            if (magicId == "定身" or magicId == "定军")and (not target:isDingShen()) then
                -- 目标不处于麻痹状态时才会使用
                if damgePercent < 10 then
                    cost = 11
                elseif damgePercent < 30 then
                    cost = 20
                elseif damgePercent < 100 then
                    cost = 40
                else
                    cost = 78
                end
            elseif (magicId == "毒烟" or magicId == "毒雾") and (not target:isZhongDu()) then
                -- 目标不处于中毒状态时才会使用
                if damgePercent < 10 then
                    cost = 9
                elseif damgePercent < 30 then
                    cost = 18
                elseif damgePercent < 100 then
                    cost = 38
                else
                    cost = 78
                end
            elseif magicId == "诱惑" then
                if general:isInjury() then
                    -- 自身残血
                    if damgePercent < 10 then
                        cost = 16
                    elseif damgePercent < 30 then
                        cost = 25
                    elseif damgePercent < 100 then
                        cost = 45
                    else
                        cost = 78
                    end
                elseif general:getCurrentHp() < general:getMaxHp() then
                    -- 自身HP未满，但不是残血
                    if damgePercent < 10 then
                        cost = 6
                    elseif damgePercent < 30 then
                        cost = 15
                    elseif damgePercent < 100 then
                        cost = 35
                    else
                        cost = 78
                    end
                end
            elseif table.indexof(MagicMappingInfo.AllNonStatusAttackMagics, magicId) then
                if damgePercent < 10 then
                    cost = 1
                elseif damgePercent < 30 then
                    cost = 10
                elseif damgePercent < 100 then
                    cost = 30
                else
                    cost = 78
                end
            end
        end

        return cost
    end

    local getFuZhuMagicCost = function(general, mainTarget, targets, magicId)
        local cost = 0
        local target = mainTarget
        local magicConfig = InfoUtil.getMagicConfig(magicId)
        local hitrate = GeneralUtils.calcMagicHitrate(general, target, magicConfig)
        local damgeInfo = GeneralUtils.calcMagicDamge(general, target, magicConfig)
        if magicId == "谍报" and general:getCurrentMp() <= general:getMaxMp() * 0.2 and target:getCurrentMp() > 0 then
            cost = 20 -- 自身MP小于等于总MP的20%，且目标有MP时才会使用。
        elseif magicId == "封咒" and target:getArmyCategory() == "wen" and hitrate >= 60 and (not target:isFengZhou()) then
            cost = 22 -- 目标是文官，且命中率大于等于60%时才会使用
        elseif magicId == "谎报" and hitrate >= 35 and (not target:isHunLuan()) then
            cost = 30 -- 命中率大于等于35%时才会使用
        elseif magicId == "谎言" and hitrate >= 35 and (not target:isHunLuan()) then
            if #targets == 1 then
                cost = 26 -- 谎言 单体 26
            else
                cost = 26 + 4 + 3 * #targets -- 谎言 26+(4+3*N) 对中心目标的命中率大于等于35%时才会使用
            end
        elseif magicId == "觉醒" or magicId == "大觉醒" then
            -- 若目标同时中多种异常状态，则取优先值最高的一种，而不是叠加
            local tempCosts = {}
            if target:isHunLuan() then
                table.insert(tempCosts, 40)
            end

            if target:isFengZhou() then
                if target:getArmyCategory() == "wen" then
                    table.insert(tempCosts, 35) -- 目标是文官 35
                else
                    table.insert(tempCosts, 5) -- 非文官5
                end
            end

            if target:isDingShen() then
                if target:getAiType() == "被动出击" or target:getAiType() == "坚守原地" then
                    table.insert(tempCosts, 5) -- 目标的AI类型是一、三
                else
                    table.insert(tempCosts, 30) -- 目标的AI类型是二、四、五、六、七
                end
            end

            if target:isZhongDu() then
                table.insert(tempCosts, 5)
            end

            if #tempCosts > 0 then
                cost = math.max(tempCosts)
            end

            if #targets == 1 then
                if magicId == "大觉醒" then
                    cost = cost - 4 -- 大觉醒 X-4 目标是单体状态，X时觉醒对应的价值
                end
            else
                cost = cost + 3 * #targets -- 大觉醒 X+3*N 目标是连体状态，N时目标连着的人数
            end
        elseif magicId == "回归" and target:getAiType() ~= "坚守原地" then
            cost = 3 -- 目标的AI类型不能是坚守原地
        end

        return cost
    end

    local getHealMagicCost = function(general, mainTarget, targets, magicId)
        local cost = 0
        local target = mainTarget
        local magicConfig = InfoUtil.getMagicConfig(magicId)
        local damgeInfo = GeneralUtils.calcMagicDamge(general, target, magicConfig)
        if magicId == "小补给" and target:isInjury() then
            cost = 50 -- 小补给 50 目标残血
        elseif magicId == "大补给" and target:isInjury() then
            cost = 55 -- 大补给 55 目标残血
        elseif magicId == "输送" and target:isInjury() then
            cost = 60 -- 输送 60 目标残血
        elseif magicId == "援军" or magicId == "援队" and target:isInjury() then
            if #targets == 1 then
                cost = 46 -- 援队援军 46 目标残血，单体状态
            else
                cost = 50 + 5 * #targets -- 援队援军 50+5＊N 目标残血，连体状态，N是目标连着的HP小于等于60%的人数
            end
        elseif magicId == "建言" then
            local isWuCondition = (target:getArmyCategory() == "wu") and target:isCanUseMpReplaceHp()
            if (target:getArmyCategory() == "wen" or isWuCondition) and target:getCurrentMp() <= target:getMaxMp() * 0.2 then
                cost = 12 -- 建言 12 目标是文官和穿龙鳞铠的武将，且MP小于等于20%
            end
        end

        return cost
    end

    local index = 0
    local targets = targetInfo.targets
    if table.indexof(MagicMappingInfo.AllAttackMagics, magicId) then
        index = 1 -- 攻击策略
        if #targets >= 1 then
            cost = getAttackMagicCost(general, targetInfo.mainTarget, magicId)
            if #targets == 1 then
                if table.indexof(MagicMappingInfo.AllMultiAttackMagics, magicId) then
                    cost = cost - 4 -- 群伤策略 X-4 目标是单体状态，X是对应的单体策略的价值
                end
            else
                cost = cost + 4 * #targets -- 群伤策略 X+4*N 目标是连体状态，N是目标连着的人数
            end
        end
    elseif table.indexof(MagicMappingInfo.AllHealMagics, magicId) then
        index = 2 -- 补给策略
        cost = getHealMagicCost(general, targetInfo.mainTarget, targets, magicId)
    elseif table.indexof(MagicMappingInfo.AllFuZhuMagics, magicId) then
        index = 3 -- 辅助和妨碍策略
        cost = getFuZhuMagicCost(general, targetInfo.mainTarget, targets, magicId)
    end

    if DEBUG_SHOW_AI_UTILS then
        printInfo("%s策略对%s的价值为:%d", magicId, targetInfo.mainTarget:getName(), cost)
    end

    return {magicId = magicId, cost = cost, index = index, targetInfo = targetInfo}
end

AiUtils.getNewMagicCost = function(general, magicId)
    local magicCosts = {}
    local targetInfos = general:newGetMagicAllHitTargets(magicId)
    table.walk(targetInfos, function(targetInfo)
        table.insert(magicCosts, AiUtils.getSingleMagicCost(general, magicId, targetInfo))
    end)

    -- 遍历找cost最高的一个策略，如果策略cost相同，则攻击策略>补给策略>辅助和妨碍策略
    table.sort(magicCosts, function(l, r)
        if l.cost == r.cost then
            return l.index < r.index
        end

        return l.cost > r.cost
    end)

    return magicCosts[1] or {cost = 0}
end

return AiUtils