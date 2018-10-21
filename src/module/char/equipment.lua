--[[
    装备类：武器，防具和饰品
--]]

local Equipment = class("Equipment")

Equipment.ctor = function(self, general, id, level, exp)
    self.general = general
    self.id      = id
    self.config  = InfoUtil.getItemConfig(id)
    self.level   = level
    self.exp     = exp or 0

    if self.config then
        self.addAbility = self.config.addAbility
    end
end

Equipment.isExisted = function(self)
    return self.config
end

Equipment.getConfig = function(self)
    return self.config
end

Equipment.getId = function(self)
    return self.id
end

Equipment.getLevel = function(self)
    if not self:isExisted() or self:isShiping() then
        return
    end

    if self.level >= self:getMaxLevel() then
        self.level = self:getMaxLevel()
    end
    return self.level
end

Equipment.getMaxLevel = function(self)
    if self:isExisted() then
        return self.config.maxLevel
    end
end

Equipment.getExp = function(self)
    return self.exp
end

Equipment.getMaxExp = function(self)
    if self:isExisted() then
        return self.config.maxExp
    end
end

Equipment.getExpPercent = function(self)
    if self:isExisted() then
        if self:getExp() == "Max" then
            return 100
        else
            return self:getExp() / self:getMaxExp() * 100
        end
    end
end

Equipment.getName = function(self)
    if self:isExisted() then
        return self.config.name
    end
end

Equipment.getIcon = function(self)
    if self:isExisted() then
        return self.config.icon
    end
end

Equipment.getDesc = function(self)
    if self:isExisted() then
        return self.config.desc
    end
end

Equipment.getEffectDesc = function(self)
    if self:isExisted() then
        return self.config.effectDesc
    end
end

Equipment.isShiping = function(self)
    if self:isExisted() then
        return self.config.type == "辅助"
    end
end

Equipment.isWuqi = function(self)
    if self:isExisted() then
        return self.config.type == "武器"
    end
end

Equipment.isFangju = function(self)
    if self:isExisted() then
        return self.config.type == "防具"
    end
end

Equipment.getAbility = function(self)
    if self:isExisted() and not self:isShiping() then
        local value = (self:getLevel() - 1) * self.addAbility.addtionValue + self.addAbility.baseValue
        return string.lower(self.addAbility.abilityName), value
    end
end

Equipment.getAbilityDesc = function(self)
    local prop, value = self:getAbility()
    if prop then
        return PropMappingInfo[prop] .. "+" .. value
    end
end

Equipment.getEffectProps = function(self)
    local effect = self.config.effect
    if effect and effect.props then
        return effect.props, effect.value, effect.valueType
    end

    return {}
end

Equipment.addExp = function(self, exp)
    if self:isExisted() and self.exp ~= "Max" then
        self.exp = self.exp + exp
        if self.exp >= 100 then
            if self:getLevel() < self:getMaxLevel() then
                self.exp = self.exp - 100
                self:levelUp()
            else
                self.exp = "Max"
            end
        end
    end

    return self.exp
end

Equipment.levelUp = function(self)
    self.level = self.level + 1
    -- 弹框显示装备升级
    local tipText = string.format("%s的%s升到了%d级", self.general:getName(), self:getName(), self:getLevel())
    TipUtils.showTip(tipText, display.COLOR_BLACK)
end

-- 装备是否具有特殊效果
Equipment.hasEffect = function(self)
    if self:isExisted() and self.config.effect then
        return true
    end

    return false
end

-- 装备是否具有指定的特殊效果
Equipment.hasEffectType = function(self, effectType)
    if not self:hasEffect() then
        return false
    end

    local effectTypes = self.config.effect.type
    if type(effectTypes) == "table" then
        return table.findIf(effectTypes, function(et)
            return et == effectType.value
        end)
    elseif effectTypes == effectType.value then
        return true
    else
        return false
    end
end

-- 获取装备的特殊效果值
Equipment.getEffectValue = function(self)
    if self:hasEffect() then
        return self.config.effect.value, self.config.effect.valueType
    end
end

-- 获取装备类型名
Equipment.getTypeName = function(self)
    if self:isExisted() then
        return self.config.detailType
    end

    return "迷"
end

Equipment.getSaveData = function(self)
    if self:isExisted() then
        return self:getId(), self:getLevel(), self:getExp()
    end
end

return Equipment