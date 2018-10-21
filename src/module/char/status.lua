--[[
    状态表
--]]

local Status = class("Status")

Status.ctor = function(self, general, statusId, aliveRounds)
    self.general     = general
    self.uid         = general:getId()
    self.statusId    = statusId
    self.config      = InfoUtil.getStatusConfig(statusId)
    self.aliveRounds = aliveRounds or 0
    self.lastRounds  = self.config.lastRounds or 0
end

Status.getIcon = function(self)
    return InfoUtil.getStatusIcon(self.statusId)
end

Status.getName = function(self)
    return self.config.name
end

Status.getId = function(self)
    return self.statusId
end

Status.getAnimation = function(self)
    return self.config.animationConfig
end

Status.getAliveRounds = function(self)
    return self.aliveRounds
end

Status.hasSubStatus = function(self, subStatusId)
    if self.config.subStatuses then
        return table.indexof(self.config.subStatuses, subStatusId)
    end

    return false
end

Status.turnBegin = function(self)
    self.aliveRounds = self.aliveRounds + 1
end

-- 超过buffer持续回合，可以判断是否可以移除了
Status.canRemove = function(self)
    if self.aliveRounds > self.lastRounds then
        if self.config.removeFunc then
            local removeRate = self.config.removeFunc(self, self.general)
            return Random.isTrigger(removeRate)
        else
            return Random.isTrigger(0.5)
        end
    end

    return false
end

Status.takeEffect = function(self)
    self.props = {}
    local handleProps = function(statusConfig)
        if statusConfig.influenceProps then
            local prop = statusConfig.influenceProps[GeneralDataMgr.getProp(self.uid, GeneralDataConst.PROP_ARMYCATEGORY)]
            if prop.valueType == "fix" then
                self.props[prop.name] = prop.value
            elseif prop.valueType == "percent" then
                self.props[prop.name] = GeneralDataMgr.getProp(self.uid, prop.name) * prop.value
            else
                assert(false, "什么鬼，类型暂未处理:" .. prop.valueType)
            end

            if statusConfig.type == "subProp" then
                self.props[prop.name] = -self.props[prop.name]
            end
        end
    end

    if not self.general:hasStatus(self.statusId) then
        if self.config.subStatuses then
            table.walk(self.config.subStatuses, function(subStatusId)
                if not self.general:hasStatus(subStatusId) then
                    handleProps(InfoUtil.getStatusConfig(subStatusId))
                end
            end)
        else
            handleProps(self.config)
        end
    end
end

Status.remove = function(self)
    self.props = {}
end

-- 查询此状态是否有对此属性数值的增减
Status.getProp = function(self, propName)
    return self.props[propName] or 0
end

Status.getSaveData = function(self)
    return {id = self:getId(), aliveRounds = self:getAliveRounds()}
end

return Status