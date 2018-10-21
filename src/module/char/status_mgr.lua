--[[
    状态管理器(也可以是buffer管理器)，每个武将身上有一个，针对自身的状态进行管理
--]]

local Magic = import(".magic")
local Status = import(".status")

local StatusMgr = class("StatusMgr")

StatusMgr.ctor = function(self, general)
    self.general = general
    self.statuses = {}
end

-- 判断是否已经存在此状态
StatusMgr.hasStatus = function(self, statusId)
    if self.statuses[statusId] then
        return true
    end

    return table.findIfForMap(self.statuses, function(status)
        return status:hasSubStatus(statusId)
    end)
end

StatusMgr.addStatus = function(self, statusId, aliveRounds)
    if self:hasStatus(statusId) then
        return
    end

    local status = Status.new(self.general, statusId, aliveRounds)
    status:takeEffect()
    self.statuses[statusId] = status
end

StatusMgr.removeStatus = function(self, statusId)
    if self:hasStatus(statusId) then
        self.statuses[statusId]:remove()
        self.statuses[statusId] = nil
    end
end

StatusMgr.getAnimationConfig = function(self, statusId)
    local status = self.statuses[statusId] or Status.new(self.general, statusId)
    return status:getAnimation()
end

StatusMgr.getStatusDesc = function(self)
    if table.nums(self.statuses) == 0 then
        return "正常"
    end

    local statusText = ""
    table.walk(self.statuses, function(status)
        statusText = statusText .. " " .. status:getName()
    end)
    statusText = string.ltrim(statusText)
    return statusText
end

StatusMgr.getAllStatuses = function(self)
    return self.statuses
end

-- 获取状态中对属性的影响数值
StatusMgr.getProp = function(self, propName)
    local propValue = 0
    table.walk(self.statuses, function(status)
        propValue = propValue + status:getProp(propName)
    end)

    return propValue
end

StatusMgr.getSaveData = function(self)
    local saveData = {}
    table.walk(self.statuses, function(status)
        table.insert(saveData, status:getSaveData())
    end)
    return saveData
end

return StatusMgr