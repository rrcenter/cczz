--[[
    武将辅助工具类
        提供针对武将各种属性的计算
--]]

local GeneralUtils = {}

--[[
    经验值到达100 就可以升一级 你打级越高的人升级越快 反之 你的人级高了打级低的经验加的就少
    1、攻击反击同级别敌人得经验8，每低一级少得经验1，最少得经验1，每高一级多得经验2
    2、如果击退敌人，则在第1条的基础上乘4
    3、如果击退过关条件的敌人，则在第2条的基础上再乘2。
       如官渡的袁绍是过关条件的敌人，即击退他就过关，击退的话按第3条计算；但白马的袁绍就不是，击退的话按第2条计算。
    4、反击伤害是攻击伤害的八成，但经验和攻击是一样的。
       致命一击是普通攻击伤害的150%，但经验一样。
       连击经验也是一样的。
       被格档虽然不造成伤害，但得到的经验是一样的。
    5、如果一次攻击击到多个敌人（蛇矛或者重炮车或者霹雳车有可能，但方天画戟的引导攻击是两次攻击），根据攻击每个人获得的经验，取最大经验的一个，而不是所有经验的和
--]]
GeneralUtils.calcExp = function(attacker, targetsInfo)
    local exps = {}
    table.walk(targetsInfo, function(targetInfo)
        local exp = 8
        local levelOffset = attacker:getLevel() - targetInfo.general:getLevel()
        if levelOffset >= 0 then
            exp = math.max(exp - levelOffset, 1)
        else
            exp = exp - levelOffset * 2
        end

        if targetInfo.general:isDie() then
            exp = exp * 4
            if targetInfo.general:isKeyGeneral() then
                exp = exp * 2
            end
        end

        table.insert(exps, exp)
    end)

    table.sort(exps, function(l, r)
        return l > r
    end)

    local finalExp = math.floor(exps[1] * attacker:getAddExpRate())
    if DEBUG_SHOW_DAMGEINFO then
        printInfo("最终攻击得到的经验值为：%d", finalExp)
    end
    return finalExp
end

--[[
１攻击
    文官攻击武器不得经验
    武将攻击命中同级敌人或更高武器经验得3,
    武将攻击命中等级比自己低的敌人武器经验得2,
    武将攻击被格挡武器得经验1
    武将一次攻击多个敌人，计算从每个敌人所得武器经验,取最大的一个，而不是取和
    武将连击经验不是取和，而是取经验大的那次
2策略
    武将用计武器不得经验
    文官计策命中同级人物（无论敌我）或更高武器经验得3,变天计也是３
    文官计策命中等级比自己低的人武器经验得2,
    文官计策失败武器经验照样得
    文官一次策略施给多个人，计算从每个人所得武器经验,取最大的一个，而不是取和
--]]
GeneralUtils.calcWuqiExp = function(attacker, targetsInfo, isMagic)
    if isMagic and attacker:getArmyCategory() == "wu" then
        return 0
    elseif not isMagic and attacker:getArmyCategory() == "wen" then
        return 0
    end

    local exps = {}
    table.walk(targetsInfo, function(targetInfo)
        if targetInfo.isHited then
            if attacker:getLevel() <= targetInfo.general:getLevel() then
                table.insert(exps, 3)
            else
                table.insert(exps, 2)
            end
        else
            table.insert(exps, 1)
        end
    end)

    table.sort(exps, function(l, r)
        return l > r
    end)

    return exps[1]
end

--[[
二护具
１攻击
    被同级敌人或更高攻击命中护具得经验４
    被等级比自己低敌人攻击命中护具得经验３
    格挡攻击得经验１
    被连击两次分开计算求和

２计策
    被同级敌人或更高策略命中护具得经验４
    被等级被自己低的人策略命中护具得经验３
    闪避策略护具不得经验
--]]
GeneralUtils.calcFangjuExp = function(hurter, attacker, isMagic, isHited)
    if isHited then
        if hurter:getLevel() > attacker:getLevel() then
            return 3
        else
            return 4
        end
    elseif isMagic then
        return 0
    else
        return 1
    end
end

--[[
    HP恢复只跟施计方的精神力以及补给策略的种类有关
    施计方精神力为x，现在公式由magicConfig提供
    小补给、援队：理论HP恢复量= x/10 + 40，实际恢复量有0~10的浮动
    大补给、援军、输送、白虎：理论HP恢复量= x/2 + 70，实际恢复量有0~10的浮动
--]]
GeneralUtils._calcEstimatedMagicHeal = function(magicer, target, magicConfig)
    return magicConfig.run(magicConfig, magicer, target)
end

--[[
    计算策略预估伤害值（攻击性策略）
    设施计方等级为lv，施计方精神力为x，受计方精神力为y，策略对兵种附加因子为A，装备附加因子为B(B1为进攻方，B2为受击方)，策略伤害系数C
    那么策略理论伤害值: z=[(x-y)/3+lv+25]*A*B1*B2*C
--]]
GeneralUtils._calcEstimatedMagicDamge = function(magicer, target, magicConfig)
    local lv = magicer:getLevel()
    local x = magicer:getProp("Mentality")
    local y = target:getProp("Mentality")
    local A = target:getArmyMagicFactor()
    local B1 = magicer:getItemMagicFactor(true, magicConfig)
    local B2 = target:getItemMagicFactor(false, magicConfig)
    local C = magicer:getMagicDamageFactor(magicConfig)
    local z = math.floor(((x - y) / 3 + lv + 25) * A * B1 * B2 * C)
    z = math.max(z, 1)

    if not magicConfig.damgeFactor then
        z = 0
    end

    return z
end

GeneralUtils.calcMagicDamge = function(magicer, target, magicConfig)
    local damgeInfo = {}
    if magicConfig.hurtType == "subHp" then
        local damge                          = GeneralUtils._calcEstimatedMagicDamge(magicer, target, magicConfig)
        local damgeLimit                     = math.min(damge, target:getCurrentHp()) -- 预估伤害上限
        local randomDamge                    = math.random(-2, 4) -- 实际伤害值z还有-2~4的浮动
        local normalDamge                    = math.max(damge + randomDamge, 1) -- 普通伤害
        local normalDamgeLimit               = math.min(normalDamge, target:getCurrentHp()) -- 普通伤害上限

        damgeInfo.type                       = "hp"
        damgeInfo.estimatedDamge             = damge
        damgeInfo.estimatedDamgePercent      = math.floor(damge / target:getMaxHp() * 100)
        damgeInfo.estimatedDamgeLimit        = damgeLimit
        damgeInfo.estimatedDamgePercentLimit = math.floor(damgeLimit / target:getMaxHp() * 100)
        damgeInfo.normalDamge                = normalDamge
        damgeInfo.normalDamgePercent         = math.floor(normalDamge / target:getMaxHp() * 100)
        damgeInfo.normalDamgeLimit           = normalDamgeLimit
        damgeInfo.normalDamgePercentLimit    = math.floor(normalDamgeLimit / target:getMaxHp() * 100)

    elseif magicConfig.hurtType == "addHp" then
        local targetHp                       = target:getCurrentHp()
        local targetMaxHp                    = target:getMaxHp()
        local targetNeedHp                   = targetMaxHp - targetHp
        local damge                          = GeneralUtils._calcEstimatedMagicHeal(magicer, target, magicConfig)
        local damgeLimit                     = math.min(damge, targetNeedHp) -- 预估治疗上限
        local randomDamge                    = math.random(0, 10) -- 实际加血值z也是有0~10的浮动。
        local normalDamge                    = damge + randomDamge -- 普通治疗
        local normalDamgeLimit               = math.min(normalDamge, targetNeedHp) -- 普通治疗上限

        damgeInfo.type                       = "hp"
        damgeInfo.estimatedDamge             = -damge
        damgeInfo.estimatedDamgePercent      = math.floor(damge / target:getMaxHp() * 100)
        damgeInfo.estimatedDamgeLimit        = -damgeLimit
        damgeInfo.estimatedDamgePercentLimit = math.floor(damgeLimit / target:getMaxHp() * 100)
        damgeInfo.normalDamge                = -normalDamge
        damgeInfo.normalDamgePercent         = math.floor(normalDamge / target:getMaxHp() * 100)
        damgeInfo.normalDamgeLimit           = -normalDamgeLimit
        damgeInfo.normalDamgePercentLimit    = math.floor(normalDamgeLimit / target:getMaxHp() * 100)

    elseif magicConfig.hurtType == "subMp" then
        local damge                          = magicConfig.run(magicConfig, magicer, target)
        local damgeLimit                     = math.min(damge, target:getCurrentMp()) -- 预估伤害上限
        local randomDamge                    = math.random(-2, 4) -- 实际伤害值z还有-2~4的浮动
        local normalDamge                    = math.max(damge + randomDamge, 1) -- 普通伤害
        local normalDamgeLimit               = math.min(normalDamge, target:getCurrentMp()) -- 普通伤害上限

        damgeInfo.type                       = "mp"
        damgeInfo.estimatedDamge             = damge
        damgeInfo.estimatedDamgePercent      = math.floor(damge / target:getMaxMp() * 100)
        damgeInfo.estimatedDamgeLimit        = damgeLimit
        damgeInfo.estimatedDamgePercentLimit = math.floor(damgeLimit / target:getMaxMp() * 100)
        damgeInfo.normalDamge                = normalDamge
        damgeInfo.normalDamgePercent         = math.floor(normalDamge / target:getMaxMp() * 100)
        damgeInfo.normalDamgeLimit           = normalDamgeLimit
        damgeInfo.normalDamgePercentLimit    = math.floor(normalDamgeLimit / target:getMaxMp() * 100)

    elseif magicConfig.hurtType == "addMp" then
        local targetMp                       = target:getCurrentMp()
        local targetMaxMp                    = target:getMaxMp()
        local targetNeedMp                   = targetMaxMp - targetMp
        local damge                          = magicConfig.run(magicConfig, magicer, target)
        local damgeLimit                     = math.min(damge, targetNeedMp) -- 预估补充MP上限
        local normalDamge                    = math.max(damge, 1) -- MP补充值
        local normalDamgeLimit               = math.min(normalDamge, targetNeedMp) -- MP补充值上限

        damgeInfo.type                       = "mp"
        damgeInfo.estimatedDamge             = -damge
        damgeInfo.estimatedDamgePercent      = math.floor(damge / target:getMaxMp() * 100)
        damgeInfo.estimatedDamgeLimit        = -damgeLimit
        damgeInfo.estimatedDamgePercentLimit = math.floor(damgeLimit / target:getMaxMp() * 100)
        damgeInfo.normalDamge                = -normalDamge
        damgeInfo.normalDamgePercent         = math.floor(normalDamge / target:getMaxMp() * 100)
        damgeInfo.normalDamgeLimit           = -normalDamgeLimit
        damgeInfo.normalDamgePercentLimit    = math.floor(normalDamgeLimit / target:getMaxMp() * 100)

    elseif magicConfig.hurtType == "status" then
    elseif magicConfig.hurtType == "refreshAction" then
    elseif magicConfig.hurtType == "addHpRemoveStatus" then
    end

    if DEBUG_SHOW_DAMGEINFO then
        dump(damgeInfo)
    end

    return damgeInfo
end

--[[
    设（施计方精神力+士气）/（受计方精神力+士气）为x，原始策略命中率为y，实际策略命中率为r，装备附加因子为A，策略命中系数B
    原始公式与物理命中率一样
    当x≥2时，y=1
    当1≤x<2时，y=0.1x + 0.8
    当1/2≤x<1时，y=0.6x + 0.3
    当1/3≤x<1/2时，y=0.9x
    当x<1/3时，y=0.3

    实际策略命中率 r 还要考虑装备附加因子以及策略命中系数
    r = B*（y+A），先计算括号内的数，若y+A>1则按1计，再进行其余计算。
    由于y+A不超过1，那么实际策略命中率 r 最高也只能是B，也就是策略本身的命中系数，这就限制了七星剑的作用。
    受计方若被混乱，策略命中率强制为1，但海啸和晕眩除外，依然按正常情况计算。
    当过关条件为击退某一个敌人时，海啸和晕眩对他的命中率强制为0，若条件是击退两个及两个以上的敌人，则按正常情况计算。
--]]
GeneralUtils.calcMagicHitrate = function(magicer, target, magicConfig)
    local x = (magicer:getProp("Mentality") + magicer:getProp("Morale")) / (target:getProp("Mentality") + magicer:getProp("Morale"))
    local y = 0.3
    if x >= 2 then
        y = 1
    elseif 1 <= x and x < 2 then
        y = 0.1 * x + 0.8
    elseif 0.5 <= x and x < 1 then
        y = 0.6 * x + 0.3
    elseif 0.3 <= x and x < 0.5 then
        y = 0.9 * x
    end

    local r = math.min(y + magicer:getItemMagicHitRate(true) - target:getItemMagicHitRate(false), 1)
    r = r * (magicConfig.hitrateFactor or 1)
    r = magicConfig.forceHit and 1 or r -- 策略强制命中

    -- 受计方若被混乱，策略命中率强制为1，但海啸和晕眩除外，依然按正常情况计算。
    if target:isHunLuan() and (not magicConfig.ignoreHunLuan) then
        r = 1
    end

    -- 当过关条件为击退某一个敌人时，海啸和晕眩对他的命中率强制为0，若条件是击退两个及两个以上的敌人，则按正常情况计算。
    if target:isKeyGeneral() and magicConfig.keyGeneralHit then
        r = r * magicConfig.keyGeneralHit
    end

    if DEBUG_SHOW_DAMGEINFO then
        printInfo("%s对%s的策略命中率为%d", magicer:getName(), target:getName(), r * 100)
    end

    return math.floor(r * 100)
end

--[[
    获取预估伤害值
    设攻方等级为lv，攻方攻击力为x，所处地形能力因子为a，守方防御力为y，所处地形能力因子为b，兵种相克因子为A，装备附加因子为B
    那么普通攻击的理论伤害值：z=[(x*a-y*b)/2+lv+25]*A*B
--]]
GeneralUtils._calcEstimatedAttackDamge = function(attacker, target)
    local lv = attacker:getLevel()
    local a = attacker:getTileAddition() / 100
    local x = attacker:getProp("Attack")
    local y = target:getProp("Defense")
    local b = target:getTileAddition() / 100
    local A = attacker:getArmydamgeFactor(target)
    local B = attacker:getItemDamgeFactor(target)
    local z = math.floor(((x * a - y * b) / 2 + lv + 25) * A * B)
    z = math.max(z, 1)

    -- 获取受击武将的伤害减免率
    z = z * target:getDefenseAttackDamageRate()

    return z
end

GeneralUtils.calcAttackDamge = function(attacker, target)
    local damge       = GeneralUtils._calcEstimatedAttackDamge(attacker, target) -- 预估伤害
    local damgeLimit  = math.min(damge, target:getCurrentHp()) -- 预估伤害上限
    local randomDamge = math.random(-2, 4) -- 实际伤害值z还有-2~4的浮动
    local normalDamge = math.max(damge + randomDamge, 1) -- 普通伤害
    local critDamge   = math.max(math.floor(damge * 1.5) + randomDamge, 1) -- 暴击伤害

    -- 判断有无龙鳞甲那样用mp换血的装备
    local isMpHurt = false
    local mpNormalDamge, mpCritDamge, mpLimit
    if target:isCanUseMpReplaceHp() and target:getCurrentMp() > 0 then
        isMpHurt = true
        mpLimit       = math.min(damge, target:getCurrentMp())
        mpNormalDamge = math.min(normalDamge, target:getCurrentMp())
        mpCritDamge   = math.min(critDamge, target:getCurrentMp())
    end

    normalDamge = math.max(normalDamge, 1)
    critDamge = math.max(critDamge, 1)

    local normalDamgeLimit = math.min(normalDamge, target:getCurrentHp())
    local critDamgeLimit = math.min(critDamge, target:getCurrentHp())

    local damgeInfo = {}
    if isMpHurt then
        damgeInfo.type                       = "mp"
        damgeInfo.estimatedDamge             = damge
        damgeInfo.estimatedDamgePercent      = math.floor(damge / target:getMaxMp() * 100)
        damgeInfo.estimatedDamgeLimit        = mpLimit
        damgeInfo.estimatedDamgePercentLimit = math.floor(mpLimit / target:getMaxMp() * 100)
        damgeInfo.normalDamge                = normalDamge
        damgeInfo.critDamge                  = critDamge
        damgeInfo.normalDamgePercent         = math.floor(normalDamge / target:getMaxMp() * 100)
        damgeInfo.critDamgePercent           = math.floor(critDamge / target:getMaxMp() * 100)
        damgeInfo.normalDamgeLimit           = mpNormalDamge
        damgeInfo.critDamgeLimit             = mpCritDamge
        damgeInfo.normalDamgePercentLimit    = math.floor(mpNormalDamge / target:getMaxMp() * 100)
        damgeInfo.critDamgePercentLimit      = math.floor(mpCritDamge / target:getMaxMp() * 100)
    else
        damgeInfo.type                       = "hp"
        damgeInfo.estimatedDamge             = damge
        damgeInfo.estimatedDamgePercent      = math.floor(damge / target:getMaxHp() * 100)
        damgeInfo.estimatedDamgeLimit        = damgeLimit
        damgeInfo.estimatedDamgePercentLimit = math.floor(damgeLimit / target:getMaxHp() * 100)
        damgeInfo.normalDamge                = normalDamge
        damgeInfo.critDamge                  = critDamge
        damgeInfo.normalDamgePercent         = math.floor(normalDamge / target:getMaxHp() * 100)
        damgeInfo.critDamgePercent           = math.floor(critDamge / target:getMaxHp() * 100)
        damgeInfo.normalDamgeLimit           = normalDamgeLimit
        damgeInfo.critDamgeLimit             = critDamgeLimit
        damgeInfo.normalDamgePercentLimit    = math.floor(normalDamgeLimit / target:getMaxHp() * 100)
        damgeInfo.critDamgePercentLimit      = math.floor(critDamgeLimit / target:getMaxHp() * 100)
    end

    if DEBUG_SHOW_DAMGEINFO then
        dump(damgeInfo)
    end

    return damgeInfo
end

--[[
    设攻方爆发力与守方爆发力的比值为x，原始命中率为y，实际命中率为r，装备附加因子分为辅助命中率因子A和辅助攻击防御因子B
    物理命中率
        当 x≥2 时，        y = 1
        当 1≤x<2 时，      y = 0.1x + 0.8
        当 1/2≤x<1 时，    y = 0.6x + 0.3
        当 1/3≤x<1/2 时，  y = 0.9x
        当 x<1/3 时，      y = 0.3

    实际命中率 r 还要考虑装备的附加因子，r = (y + A) + B
    为什么要加个括号呢，因为计算的时候首先计算括号中的数，如果大于1则按1计，然后再加上B（注意B是负数）。
    守方若被混乱，命中率强制为1。
    远程部队对镜铠的命中率强制为0，暴击对黄金铠的命中率强制为0，连击中的第二击对连环铠的命中率强制为0，均不受混乱影响。
    格挡率 = 1 - 命中率

    我们可以看到，在x = 1/2这个点有个突跃，就是说当你的爆发力是敌人的两倍以上时，对方对你的命中率会大幅下降，可以考虑下如何利用古锭刀和飞龙道袍的10点爆发力。
    如果没有任何装备辅助，命中率最低是30%，而且不可能在45%和60%之间。
--]]
GeneralUtils.calcAttackHitrate = function(attacker, target)
    local x = attacker:getProp("Explode") / target:getProp("Explode")
    local y = 0.3 -- 默认最低的命中率为0.3
    if x >= 2 then
        y = 1
    elseif 1 <= x and x < 2 then
        y = 0.1 * x + 0.8
    elseif 0.5 <= x and x < 1 then
        y = 0.6 * x + 0.3
    elseif 0.33 <= x and x < 0.5 then
        y = 0.9 * x
    end

    local A = attacker:getItemHitrateFactor(true)
    r = y + A
    r = math.min(r, 1)

    local B = target:getItemHitrateFactor(false)
    r = r - B
    r = math.max(r, 0)

    -- 目标被混乱，强制命中率为1
    if target:isHunLuan() then
        r = 1
    end

    -- 远程兵种对防御远程攻击的特效，命中率为0
    if attacker:isYuanChengArmy() and target:isMustDefenseYuanCheng() then
        r = 0
    end

    if DEBUG_SHOW_DAMGEINFO then
        printInfo("%s对%s的攻击命中率为%d", attacker:getName(), target:getName(), r * 100)
    end
    return math.floor(r * 100)
end

--[[
    获取暴击率

    设攻方士气与守方士气的比值为x，暴击率为y
    公式与双击率一样
    当 x≥3 时，  y = 1；
    当 2≤x<3 时，y = 0.8x - 1.4；
    当 1≤x<2 时，y = 0.18x - 0.16；
    当 x<1 时，  y = 0.02

    若装备玉玺，暴击率强制为100%
--]]
GeneralUtils.calcCritrate = function(attacker, target)
    local x = attacker:getProp("Morale") / target:getProp("Morale")
    local z = 0.02 -- 默认最低的命中率为0.02
    if x >= 3 then
        z = 1
    elseif 2 <= x and x < 3 then
        z = 0.8 * x - 1.4
    elseif 1 <= x and x < 2 then
        z = 0.18 * x - 0.16
    end

    if attacker:isMustCritAttack() then
        z = 1
    end

    if DEBUG_SHOW_DAMGEINFO then
        printInfo("%s对%s的攻击暴击率为%d", attacker:getName(), target:getName(), z * 100)
    end
    return math.floor(z * 100)
end

--[[
    获取连击率

    当 x≥3 时，  z = 1；
    当 2≤x<3 时，z = 0.8x - 1.4；
    当 1≤x<2 时，z = 0.18x - 0.16；
    当 x<1 时，  z = 0.02


    这里虽然没有突跃，但x>2时，连击率会增加得很快，对爆发力接近敌人两倍的典韦来说，练兵和钝兵的作用就很大了。
--]]
GeneralUtils.calcDoublerate = function(attacker, target)
    local x = attacker:getProp("Explode") / target:getProp("Explode")
    local z = 0.02 -- 默认最低的命中率为0.02
    if x >= 3 then
        z = 1
    elseif 2 <= x and x < 3 then
        z = 0.8 * x - 1.4
    elseif 1 <= x and x < 2 then
        z = 0.18 * x - 0.16
    end

    if DEBUG_SHOW_DAMGEINFO then
        printInfo("%s对%s的攻击连击率为%d", attacker:getName(), target:getName(), z * 100)
    end
    return math.floor(z * 100)
end

-- 返回对应属性的上限限制值
GeneralUtils.getPropMaxLimit = function(prop)
    local PROP_MAX_LIMIT_MAPPINGS = {
        level     = 50,
        attack    = 500,
        mentality = 500,
        morale    = 500,
        defense   = 500,
        explode   = 500,
        exp       = 100,
    }

    return PROP_MAX_LIMIT_MAPPINGS[string.lower(prop)]
end

return GeneralUtils