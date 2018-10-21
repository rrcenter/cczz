--[[
    抽离的武将模型，此类，仅存储和数据相关的处理
    prop表示基本能力，武力，智力，敏捷，运气和统率力
    ability表示五围，攻击力，精神力，爆发力，士气和防御力
    战斗外需要记录的数据
        armyType
        professionLevel
        exp
        wuqi = {id, level, exp}
        fangju = {id, level, exp}
        shiping = {id}
        uid
        hp,mp
        level
        attack
        defense
        explode
        mentality
        morale
        minjieAdd -- 只记录因吃果而造成的改变，默认没有则无需记录
        tongshuaiAdd
        wuliAdd
        yunqiAdd
        zhiliAdd

    非玩家所需要的数据：
        armyType
        wuqi = {id}
        fangju = {id}
        shiping = {id}
        uid
        hp,mp
        level
--]]

local Equipment = import("..char.equipment")

local GeneralData = class("GeneralData")

GeneralData.ctor = function(self, uid, side, data)
    printInfo("正在初始化武将模型：%s", uid)

    self:initGeneralConfig(uid)
    self:initArmyConfig()
    self:initProfession(side, data.level, data.professionLevel)
    self:initProps(side, data)
    self:initEquip(GeneralDataConst.EQUIP_WUQI, data.wuqiId, data.wuqiLevel, data.wuqiExp)
    self:initEquip(GeneralDataConst.EQUIP_FANGJU, data.fangjuId, data.fangjuLevel, data.fangjuExp)
    self:initEquip(GeneralDataConst.EQUIP_SHIPING, data.shipingId)

    printInfo("武将模型初始化完成：%s", uid)
end

GeneralData.initGeneralConfig = function(self, uid)
    self.uid, self.gid = uid, uid
    if not InfoUtil.getGeneralConfig(uid) then
        self.gid = string.gsub(uid, "[%d]+", "")
        printInfo("不存在此武将(%s)，去除数字，取其过滤id(%s)", uid, self.gid)
    end

    self.generalConfig = InfoUtil.getGeneralConfig(self.gid)
end

GeneralData.initArmyConfig = function(self)
    self.armyConfig = InfoUtil.getArmyConfig(self:getArmyType())
end

GeneralData.initProfession = function(self, side, level, professionLevel)
    self.level = level or 1

    if professionLevel then
        self.professionLevel = professionLevel
        if self.professionLevel > #self.armyConfig.profession then
            printInfo("职业等级自动修正为该职业最高等级:%d->%d", self.professionLevel, #self.armyConfig.profession)
            self.professionLevel = #self.armyConfig.profession
        end
    else
        if #self.armyConfig.profession == 1 then
            self.professionLevel = 1
        elseif self.level < 15 then
            self.professionLevel = 1
        elseif self.level < 30 then
            self.professionLevel = 2
        else
            self.professionLevel = 3
        end
    end

    self.professionConfig = InfoUtil.getProfessionConfig(self:getProfessionType())
    printInfo("%s设置武将职业为:%s", self:getName(), self:getProfessionName())

    self.res = InfoUtil.getGeneralAnimation(self:getGeneralId(), self:getProfessionType(), side).res
end

GeneralData.initProps = function(self, side, data)
    self.side = side

    if data.hp then
        table.walk(GeneralDataConst.SAVE_DATA_PROPS, function(propName)
            self[propName] = data[propName]
        end)
    else
        -- 玩家HP = 兵种基础HP + HP成长率 * (等级 + 2 * 使用印绶的次数) + 武将加成
        -- 玩家MP = 兵种基础MP + HP成长率 * (等级 + 2 * 使用印绶的次数) + 武将加成
        -- 敌人HP = 兵种基础HP + HP成长率 * (等级 - 1)
        -- 敌人MP = 兵种基础MP + MP成长率 * (等级 - 1)
        local level            = self:getLevel()
        local yinShouUseCounts = self:getProfessionLevel() - 1
        local hpAddRate        = self.generalConfig.hpAddRate or 0
        local mpAddRate        = self.generalConfig.mpAddRate or 0

        if side ~= "player" then
            yinShouUseCounts, hpAddRate, mpAddRate = 0, 0, 0
            level = level -1
        end

        self.hp       = self.armyConfig.baseHp + self.armyConfig.hpAddRate * (level + yinShouUseCounts * 2) + hpAddRate
        self.mp       = self.armyConfig.baseMp + self.armyConfig.mpAddRate * (level + yinShouUseCounts * 2) + mpAddRate
        self.exp      = 0
        self.movement = self.professionConfig.movement

        table.walk(GeneralDataConst.ABILITY_MAPPING, function(propName, abilityName)
            local realRate = self:getRealRate(abilityName)
            self[abilityName] = math.floor(self.generalConfig[propName] / 2) + realRate * level
        end)
    end
end

GeneralData.initEquip = function(self, equipType, id, level, exp)
    if not level or level == 0 then
        level = math.floor(self:getLevel() / 4) + 1
    end

    if not id or id == "默认装备" then
        local defaultIds = self:getDefaultEquipIds(equipType)
        if defaultIds then
            if level <= 3 then
                id = defaultIds[1]
            elseif level <= 6 then
                id = defaultIds[2]
                level = level - 3
            else
                id = defaultIds[3]
                level = math.min(level - 6, 3)
            end
        end
    end

    self.propEquips = self.propEquips or {}
    self[equipType] = Equipment.new(self, id, level, exp)

    if self[equipType]:hasEffectType(EquipEffectInfo.EFFECT_ADD_PROP) then
        local propNames, value, valueType = self[equipType]:getEffectProps()
        table.walk(propNames, function(propName)
            self.propEquips[propName] = self.propEquips[propName] or 0
            if valueType == "percent" then
                self.propEquips[propName] = self.propEquips[propName] + math.floor(self:getProp(propName) * value)
            elseif valueType == "fix" then
                self.propEquips[propName] = self.propEquips[propName] + value
            else
                assert(false, "什么鬼，类型尚未实现:" .. valueType)
            end
        end)
    end

    local propName, value = self[equipType]:getAbility()
    if propName then
        self.propEquips[propName] = self.propEquips[propName] or 0
        self.propEquips[propName] = self.propEquips[propName] + value
    end
end

GeneralData.removeEquip = function(self, equipType)
    if not self[equipType]:isExisted() then
        return Equipment.new()
    end

    local oldEquip = self[equipType]
    self[equipType] = Equipment.new(self)

    if oldEquip:hasEffectType(EquipEffectInfo.EFFECT_ADD_PROP) then
        local propNames, value, valueType = oldEquip:getEffectProps()
        table.walk(propNames, function(propName)
            if valueType == "percent" then
                self.propEquips[propName] = self.propEquips[propName] - math.floor(self:getProp(propName) * value)
            elseif valueType == "fix" then
                self.propEquips[propName] = self.propEquips[propName] - value
            else
                assert(false, "什么鬼，类型尚未实现:" .. valueType)
            end
        end)
    end

    local propName, value = oldEquip:getAbility()
    if propName then
        self.propEquips[propName] = self.propEquips[propName] - value
    end

    return oldEquip
end

GeneralData.changeEquip = function(self, equipType, id, level, exp)
    local oldEquip = self:removeEquip(equipType)
    self:initEquip(equipType, id, level, exp)
    return oldEquip
end

GeneralData.getEquip = function(self, equipType)
    return self[equipType]
end

GeneralData.hasEquip = function(self, equipId)
    return table.findIf(GeneralDataConst.ALL_EQUIP_TYPES, function(equipType)
        if self:getEquip(equipType):getId() == equipId then
            return true
        end
    end)
end

GeneralData.addProp = function(self, propName, value)
    if GeneralDataConst.ADD_PROP_MAPPING[propName] then
        local mappingName = GeneralDataConst.ADD_PROP_MAPPING[propName]
        local abilityName = table.keyof(GeneralDataConst.ABILITY_MAPPING, propName)
        self[mappingName] = self[mappingName] or 0
        self[mappingName] = self[mappingName] + value
        self[abilityName] = self[abilityName] + math.floor(value / 2)
        printInfo("%s 增加 %s %d属性，对应能力 %s 增加%d点", self:getName(), propName, value, abilityName, math.floor(value / 2))
    else
        assert(false, "暂未处理此属性：" .. propName)
    end
end

-- isNoContainerStatus 表示不包含status的影响，默认为false
-- 此处返回的属性值，默认已经算上了装备的影响
GeneralData.getProp = function(self, propName, isNoContainerStatus)
    if GeneralDataConst.ADD_PROP_MAPPING[propName] then
        return self.generalConfig[propName] + (self[GeneralDataConst.ADD_PROP_MAPPING[propName]] or 0)
    elseif GeneralDataConst.ABILITY_RATE_PROPS[propName] then
        return self:getRealRate(propName)
    elseif GeneralDataConst.ARMY_PROPS[propName] then
        return self.armyConfig[propName]
    elseif GeneralDataConst.GENERAL_PROPS[propName] then
        return self.generalConfig[propName]
    elseif GeneralDataConst.PROFESSION_PROPS[propName] then
        return self.professionConfig[propName]
    end

    --!! 临时处理
    propName = string.lower(propName)
    return self[propName] + (self.propEquips[propName] or 0)
end

-- 获取武将部队成长率(S, A, B, C)
GeneralData.getArmyAbilityRate = function(self, abilityName)
    return self.armyConfig[abilityName .. "Rate"]
end

-- 获取基本能力对应的成长率，90~100 = 4，70~88 = 3，50~68 = 2，0~48 = 1。
GeneralData.getBasicAbilityRate = function(self, abilityName)
    local ability = self.generalConfig[GeneralDataConst.ABILITY_MAPPING[abilityName]]
    if ability >= 90 then
        return 4
    elseif ability >= 70 then
        return 3
    elseif ability >= 50 then
        return 2
    end

    return 1
end

-- 实际能力成长率 = (基本能力成长率 + 兵种成长率) / 2
GeneralData.getRealRate = function(self, abilityName)
    local armyRate = self:getArmyAbilityRate(abilityName)
    local basicRate = self:getBasicAbilityRate(abilityName)
    return math.floor((armyRate + basicRate) / 2)
end

GeneralData.getDefaultEquipIds = function(self, equipType)
    if equipType == GeneralDataConst.EQUIP_WUQI then
        return self.armyConfig.defaultWuqiIds
    elseif equipType == GeneralDataConst.EQUIP_FANGJU then
        return self.armyConfig.defaultFangjuIds
    end
end

GeneralData.getName = function(self)
    return self.uid
end

GeneralData.getLevel = function(self)
    return self.level
end

GeneralData.getArmyType = function(self)
    return self.generalConfig.armyType
end

GeneralData.getProfessionType = function(self)
    return self.armyConfig.profession[self.professionLevel]
end

GeneralData.getProfessionName = function(self)
    return self.professionConfig.name
end

GeneralData.getProfessionLevel = function(self)
    return self.professionLevel
end

GeneralData.getId = function(self)
    return self.uid
end

GeneralData.getGeneralId = function(self)
    return self.gid
end

GeneralData.getMaxMp = function(self)
    return self.mp
end

GeneralData.getMaxHp = function(self)
    return self.hp
end

GeneralData.getCurrentExp = function(self)
    return self.exp
end

GeneralData.addExp = function(self, value)
    if self.exp == "Max" then
        return
    end

    local maxExp = GeneralUtils.getPropMaxLimit("exp")
    self.exp = self.exp + value
    if self.exp >= maxExp then
        self.exp = self.exp - maxExp
        if self:getLevel() >= GeneralUtils.getPropMaxLimit("level") then
            self.exp = "Max"
        else
            self:levelUp(1)
        end
    end
end

GeneralData.getSide = function(self)
    return self.side
end

-- 是否为有名武将，不是小兵的都是有名武将
GeneralData.isFamous = function(self)
    return self.generalConfig.isFamous
end

-- 判断是否为远程兵种
GeneralData.isYuanChengArmy = function(self)
    return table.indexof(ArmyMappingInfo["远程兵种"], self:getArmyType())
end

-- 判断是否为攻击型文官
GeneralData.isAttackerMagicerArmy = function(self)
    return table.indexof(ArmyMappingInfo["攻击型文官"], self:getArmyType())
end

-- 判断是否为近战类兵种
GeneralData.isJinZhanArmy = function(self)
    return table.indexof(ArmyMappingInfo["近战兵种"], self:getArmyType())
end

-- 判断是否拥有这种道具特效
GeneralData.hasEquipEffect = function(self, effectType)
    local equips = {}
    table.walk(GeneralDataConst.ALL_EQUIP_TYPES, function(equipType)
        if self[equipType]:hasEffectType(effectType) then
            table.insert(equips, self[equipType])
        end
    end)

    if #equips == 0 then
        return false
    end

    return true, equips
end

GeneralData.levelUp = function(self, levelAdd)
    levelAdd = levelAdd or 1
    self.level = self.level + levelAdd

    -- 五围增加
    table.walk(GeneralDataConst.ABILITY_MAPPING, function(_, abilityName)
        self[abilityName] = self[abilityName] + self:getRealRate(abilityName) * levelAdd
    end)

    -- HP & MP增加上限值
    self.hp = self.hp + self.armyConfig.hpAddRate * levelAdd
    self.mp = self.mp + self.armyConfig.mpAddRate * levelAdd

    local newMagics = self:getAllMagics(self:getLevel() - levelAdd, self:getLevel())
    EventMgr.triggerEvent(EventConst.GENERAL_LEVELUP, self:getId(), 1, newMagics)
end

GeneralData.armyUp = function(self)
    local oldMagics = self:getAllMagics() or {}
    self.professionLevel = self.professionLevel + 1
    self.professionConfig = InfoUtil.getProfessionConfig(self:getProfessionType())
    local nowMagics = self:getAllMagics() or {}

    -- 使用印绶，如果武将有额外的hp或mp成长率
    -- HP = 兵种基础HP + HP成长率 * (等级 + 2* 使用印绶的次数) + 武将加成
    self.hp = self.hp + self.armyConfig.hpAddRate * 2
    self.mp = self.mp + self.armyConfig.mpAddRate * 2

    local newMagics = {}
    for _, magicId in ipairs(nowMagics) do
        if not table.indexof(oldMagics, magicId) then
            table.insert(newMagics, magicId)
        end
    end

    EventMgr.triggerEvent(EventConst.GENERAL_ARMYUP, self:getId(), newMagics)
end

-- 判断武将是否还可以进阶
GeneralData.canArmyUp = function(self)
    local profession = self:getProp(GeneralDataConst.PROP_PROFESSION)
    local professionLevel = self:getProfessionLevel()
    if profession and professionLevel < #profession and professionLevel * 15 <= self:getLevel() then
        return true
    end
end

-- 获取武将的可用策略
GeneralData.getAllMagics = function(self, minLevel, maxLevel)
    local filterMagics = {}
    local magics = self:getProp(GeneralDataConst.PROP_MAGICS)
    if magics then
        minLevel = minLevel or 0
        maxLevel = maxLevel or self:getLevel()

        table.walk(magics, function(magicInfo)
            if minLevel < magicInfo.level and magicInfo.level <= maxLevel then
                table.insert(filterMagics, magicInfo.magic)
            end
        end)
    end

    return filterMagics
end

-- 获取武将mp消耗率，没有特定装备，则默认为1
GeneralData.getMagicCostRate = function(self)
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_MAGIC_MPCOST)
    return hasEffect and equips[1]:getEffectValue() or 1
end

-- 获取武将是否具有突击移动的效果
GeneralData.isCanMoveIgnoreEnemy = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_MOVE_IGNORE_ENEMY)
end

-- 是否具有抵抗暴击的效果
GeneralData.isCanDefenseCritAttack = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_DEFENSE_CRITATTACK)
end

-- 是否具有抵挡二次攻击的效果
GeneralData.isCanDefenseDoubleAttack = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_DEFENSE_DOUBLEATTACK)
end

-- 是否具有反击再反击的效果
GeneralData.isCanAttackBackAgain = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_ATTACK_BACK_AGAIN)
end

-- 是否具有使对手反击无效的效果
GeneralData.isCanMakeNoAttackBack = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_NON_ATTACK_BACK)
end

-- 是否具有引导攻击的效果 counts表明已经引导的攻击次数，默认为0
GeneralData.isCanAttackAgainWhenTargetDie = function(self, counts)
    counts = counts or 0
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_DIE_AGAIN_ATTACK)
    return (hasEffect and equips[1]:getEffectValue() > counts)
end

-- 是否具有必定暴击的效果
GeneralData.isMustCritAttack = function(self)
    -- 如果装备玉玺，暴击率强制为100%
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_MUST_CRITATTACK)
end

-- 是否具有必定抵抗远程攻击的效果
GeneralData.isMustDefenseYuanCheng = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_DEFENSE_YUANCHENG)
end

-- 是否具有用Mp替代Hp的效果
GeneralData.isCanUseMpReplaceHp = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_MP_REPLACE_HP)
end

-- 获取受击武将被攻击时伤害倍率，默认为1
GeneralData.getDefenseAttackDamageRate = function(self)
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
GeneralData.isCanMoveIgnoreTile = function(self)
    return self:hasEquipEffect(EquipEffectInfo.EFFECT_MOVE_IGNORE_TILE)
end

-- 获取经验增加率，默认为1
GeneralData.getAddExpRate = function(self)
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
GeneralData.isCanUseItemWhenHurt = function(self)
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
GeneralData.getUseItemWhenHurt = function(self)
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_WHEN_HURT_USE_ITEM)
    if hasEffect then
        return equips[1]:getEffectValue()
    end
end

-- 获取装备对于物理命中的附加因子(攻击方)，isAttacker用来判断是进攻方还是受击方，默认为false
GeneralData.getItemHitrateFactor = function(self, isAttacker, target)
    local itemEffectType = isAttacker and EquipEffectInfo.EFFECT_ATTACK_HITRATE or EquipEffectInfo.EFFECT_DEFENSE_HITRATE
    local hasEffect, equips = self:hasEquipEffect(itemEffectType)
    if not hasEffect then
        return 0
    end

    return table.addAllValues(equips, function(item)
        return item:getEffectValue()
    end)
end

-- 获取装备对于物理伤害的附加因子
GeneralData.getItemDamgeFactor = function(self, target)
    local hasEffect, equips = self:hasEquipEffect(EquipEffectInfo.EFFECT_ATTACK_DAMGERATE)
    if not hasEffect then
        return 1
    end

    local result = 1
    table.walk(equips, function(item)
        if table.indexof(item.config.effect.armyTypes, target:getArmyType()) then
            result = result * item:getEffectValue()
        end
    end)

    return result
end

-- 获取装备对于策略伤害的附加因子，isAttacker用来判断是进攻方还是受击方，默认为false
GeneralData.getItemMagicFactor = function(self, isAttacker, magicConfig)
    local effectType = isAttacker and EquipEffectInfo.EFFECT_MAGIC_ATTACK_DAMGE or EquipEffectInfo.EFFECT_MAGIC_DEFENSE_DAMGE
    local hasEffect, equips = self:hasEquipEffect(effectType)
    if hasEffect then
        local item = equips[1]
        local magicTypes = item.config.effect.magicTypes
        if magicTypes[1] == "all" then
            return item.config.effect.value
        end

        local result = 1
        table.findIf(magicTypes, function(mt)
            if mt == magicConfig.type then
                result = result * item:getEffectValue()
                return true
            end
        end)

        return result
    end

    return 1
end

-- isAttacker用来判断是进攻方还是受击方，默认为false
GeneralData.getItemMagicHitRate = function(self, isAttacker)
    local effectType = isAttacker and EquipEffectInfo.EFFECT_MAGIC_ATTACK_HITRATE or EquipEffectInfo.EFFECT_MAGIC_DEFENSE_HITRATE
    local hasEffect, equips = self:hasEquipEffect(effectType)
    if hasEffect then
        return table.addAllValues(equips, function(item)
            return item:getEffectValue()
        end)
    end

    return 0
end

-- 获取兵种相克因子，没有指明的相克因子，一律返回1
GeneralData.getArmydamgeFactor = function(self, target)
    local armyDamgeFactor = self:getProp(GeneralDataConst.PROP_ARMYDAMGEFACTOR)
    if not armyDamgeFactor then
        return 1
    end

    return armyDamgeFactor[target:getArmyType()] or 1
end

GeneralData.isMagicHited = function(self, target, magicConfig)
    if Random.isTrigger(GeneralUtils.calcMagicHitrate(self, target, magicConfig)) then
        printInfo("本次策略成功命中")
        return true
    end

    return false
end

-- 判断本次攻击是否命中
GeneralData.isHited = function(self, target)
    if Random.isTrigger(GeneralUtils.calcAttackHitrate(self, target)) then
        printInfo("本次攻击成功命中")
        return true
    end

    return false
end

-- 判断本次是否为暴击
GeneralData.isCrit = function(self, target)
    if Random.isTrigger(GeneralUtils.calcCritrate(self, target)) then
        printInfo("本次攻击为暴击")
        return true
    end

    return false
end

-- 判断本次攻击是否为连击
GeneralData.isDoubleAttack = function(self, target, attackBackCount, doubleAttackCount, dieAgainAttackCount)
    if attackBackCount > 0 then
        printInfo("反击连击必定不中")
        return false
    end

    if doubleAttackCount > 0 then
        printInfo("不可以无限连击")
        return false
    end

    if Random.isTrigger(GeneralUtils.calcDoublerate(self, target)) then
        printInfo("本次攻击为连击")
        return true
    end

    return false
end

--[[
    武将生成保存时的数据表
    武将id，武将等级，武将经验
    防具id，防具等级，防具经验
    饰品id
    player记录:武将的武力等5个基础属性增加值（会因果子而变化）
    player记录:武将的五围信息（记录表示压级吃果有影响，不记录表示每次自动计算，压果则不再有影响）
    武将的职业等级
--]]
GeneralData.getSaveData = function(self)
    local saveData = {}
    table.walk(GeneralDataConst.SAVE_DATA_PROPS, function(propName)
        saveData[propName] = self[propName]
    end)

    saveData.uid = self:getId()
    saveData.professionLevel = self:getProfessionLevel()
    saveData.wuqiId, saveData.wuqiLevel, saveData.wuqiExp = self:getEquip(GeneralDataConst.EQUIP_WUQI):getSaveData()
    saveData.fangjuId, saveData.fangjuLevel, saveData.fangjuExp = self:getEquip(GeneralDataConst.EQUIP_FANGJU):getSaveData()
    saveData.shipingId = self:getEquip(GeneralDataConst.EQUIP_SHIPING):getSaveData()

    return saveData
end

return GeneralData
