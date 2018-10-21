--[[
    单挑武将，其实主要处理一些动画即可
    isCrit Se36 or Se35
    move采用职业音效
    格挡     = Se31
    命中     = Se30
    暴击的话 = Se32
    正常     = Se08
    举起武器 = Se08
    防御     = Se08
    被攻击   = Se08
    攻击预备 = Se08
    攻击     = Se07
    两次攻击 = Se07
    喘气     = Se08
    晕倒     = Se08
    撤退     = Se08
--]]

local Animation = require("module.char.animation")

local FIX_SCALE = 1.5
local LONG_DISCTANCE = 48 * FIX_SCALE

local PkGeneral = class("PkGeneral", function()
    return display.newNode()
end)

PkGeneral.ctor = function(self, generalId, dir)
    local general = MapUtils.getGeneralById(generalId)
    local animation = Animation.new()
    animation:align(display.CENTER)
    animation:loadAnimation(general:getAnimationConfig())
    animation:addTo(self)
    self.animation = animation

    self.name      = general:getName()
    self.headIcon  = general:getHeadIcon()
    self.generalId = generalId
    self.dir       = dir
    self.isLeft    = (dir == "left")

    self:opacity(0)
    self:scale(FIX_SCALE)
    self:setCascadeOpacityEnabled(true)
    self:showAnimation("无")
end

PkGeneral.getOffset = function(self)
    return LONG_DISCTANCE
end

PkGeneral.getName = function(self)
    return self.name
end

PkGeneral.getHeadIcon = function(self)
    return self.headIcon
end

PkGeneral.showAnimation = function(self, action, callback)
    callback = callback or function() end

    if action == "后退" then
        self:moveMiddleDistance(false, callback)

    elseif action == "小步后退" then
        self:moveShortDistance(false, callback)

    elseif action == "前移" then
        self:moveMiddleDistance(true, callback)

    elseif action == "小步前移" then
        self:moveShortDistance(true, callback)

    elseif action == "后转" then
        self:reserveDir()
        callback()

    elseif action == "防御" then
        self.animation:playAction("defense_" .. self.dir, {callback = callback})

    elseif action == "二次攻击" then
        self:showAnimation("攻击", function()
            self:showAnimation("攻击", callback)
        end)

    elseif action == "无" then
        self.animation:playAction("stand_" .. self.dir, {callback = callback})

    elseif action == "晕倒" then
        self.animation:playAction("dead", {isLoop = true})
        self:performWithDelay(callback, MIDDLE_ANIMATION_TIME)

    elseif action == "喘气" then
        self.animation:playAction("dead", {isLoop = true})
        self:performWithDelay(callback, LONG_ANIMATION_TIME)

    elseif action == "攻击预备" then
        self.animation:displayFrame("attack", self.dir, 0)
        callback()

    elseif action == "攻击" then
        self.animation:playAction("attack_" .. self.dir, {callback = callback})

    elseif action == "撤退" then
        self:hide(callback)

    elseif action == "格挡" then
        self:highlight()
        self.animation:playAction("defense_" .. self.dir, {callback = callback})

    elseif action == "格档后退" then
        self:highlight()
        self.animation:playAction("defense_" .. self.dir)
        self:moveMiddleDistance(false, callback)

    elseif action == "闪躲绕前" then
        self:setVisible(false)
        self:moveLongDistance(true, function()
            self:reserveDir()
            self:setVisible(true)
            callback()
        end)

    elseif action == "命中" then
        self:highlight()
        self:moveShortDistance(false, function()
            self.animation:playAction("hurt")
            self:performWithDelay(callback, MIDDLE_ANIMATION_TIME)
        end)

    elseif action == "原地攻击" then
        self:moveShortDistance(true, function()
            self:showAnimation("攻击", callback)
        end)

    elseif action == "移动攻击" then
        self:moveLongDistance(true, function()
            self:showAnimation("攻击", callback)
        end)

    elseif action == "互相冲锋" then
        local delatX = self:getPositionX() - display.cx
        self:highlight()
        self:move(true, delatX, function()
            self:move(true, LONG_DISCTANCE * 3 - delatX, callback)
        end)

    elseif action == "死亡" then
        self.animation:displayFrame("dead", nil, 1)
        self.animation:setFilter(filter.newFilter("GRAY"))
        callback()

    else
        assert(false, "动作尚未实现：" .. action)
    end
end

PkGeneral.show = function(self, callback)
    self:opacity(0)
    self:fadeIn(LONG_ANIMATION_TIME)
    self:performWithDelay(callback, LONG_ANIMATION_TIME + SHORT_ANIMATION_TIME)
end

PkGeneral.hide = function(self, callback)
    self:opacity(255)
    self:fadeOut(LONG_ANIMATION_TIME)
    self:performWithDelay(callback, LONG_ANIMATION_TIME)
end

PkGeneral.highlight = function(self)
    self.animation:setFilter(filter.newFilter("EXPOSURE", {4}))
    self:performWithDelay(function()
        self.animation:clearFilter()
    end, SHORT_ANIMATION_TIME)
end

PkGeneral.getMoveDistance = function(self, isFront, distance)
    if self.dir == "left" then
        return isFront and -distance or distance
    elseif self.dir == "right" then
        return isFront and distance or -distance
    else
        assert(false, "错误的方向: " .. self.dir)
    end
end

PkGeneral.move = function(self, isFront, distance, callback)
    self.animation:playAction("move_" .. self.dir, {isLoop = true})
    self:moveBy(MIDDLE_ANIMATION_TIME, self:getMoveDistance(isFront, distance), 0)
    if callback then
        self:performWithDelay(callback, MIDDLE_ANIMATION_TIME)
    end
end

PkGeneral.moveLongDistance = function(self, isFront, callback)
    self:move(isFront, LONG_DISCTANCE * 2, callback)
end

PkGeneral.moveMiddleDistance = function(self, isFront, callback)
    self:move(isFront, LONG_DISCTANCE, callback)
end

PkGeneral.moveShortDistance = function(self, isFront, callback)
    self:move(isFront, LONG_DISCTANCE / 2, callback)
end

PkGeneral.reserveDir = function(self)
    if self.dir == "left" then
        self.dir = "right"
    else
        self.dir = "left"
    end

    self.animation:flipX(self.dir == "right")
end

return PkGeneral