--[[
    动画类
        目前有以下几种动作：
        move       = 移动
        attack     = 攻击
        hurt       = 受击
        dead       = 死亡和濒临受伤
        stand      = 站立
        excitation = 激励(例如某些加成技能释放以后)
        defense    = 格挡

        所有动作没有向右的方向，一律flip左方向
--]]

local AnimationDuration = 0.4

local Animation = class("Animation", function()
    return display.newSprite(nil, nil, nil, {class = cc.FilteredSpriteWithOne})
end)

Animation.ctor = function(self)
    self:setNodeEventEnabled(true)
end

Animation.loadAnimation = function(self, animationConfig)
    self.name = animationConfig.res
    self.res  = animationConfig.prefix .. animationConfig.res

    ResMgr.addSpriteFrames(self.res)

    self.animationCaches = {}
    for _, action in pairs(animationConfig.actions) do
        local animationName = string.format("%s_%s", self.name, action.name)
        --!! startIndex兼容图片命名不是从0开始的，目前应该只有dead
        local frames = display.newFrames(animationName .. "_%d.png", action.startIndex or 0, action.frameLen)
        local animation = display.newAnimation(frames, AnimationDuration / action.frameLen)
        ResMgr.addAnimationCache(animationName, animation)

        table.insert(self.animationCaches, animationName)
    end

    if DEBUG == 2 then
        local debugRect = display.newRect(cc.rect(1, 1, 46, 46), {borderColor = WhiteColor})
        self:addChild(debugRect, 100)
    end
end

Animation.onExit = function(self)
    table.walk(self.animationCaches, function(v)
        ResMgr.removeAnimationCache(v)
    end)

    ResMgr.removeSpriteFramesWithFile(self.res)
end

Animation.playAction = function(self, action, params)
    -- 与判断一下，避免执行重复的动作
    if self.curAction == action then
        if params and params.callback then
            params.callback()
        end
        return
    end

    self:stop()

    local isFlip = false
    if string.find(action, "right") then
        action = string.gsub(action, "right", "left")
        isFlip = true
    end

    params = params or {}
    local animation = display.getAnimationCache(self.name .. "_" .. action)
    if params.isLoop then
        self:playForever(animation, params.delay)
    else
        self:playAnimationOnce(animation, params.removeWhenFinished, params.callback, params.delay)
    end

    self:flipX(isFlip)

    self.curAction = action
end

Animation.displayFrame = function(self, action, dir, index)
    local isFlip = false
    if dir == "right" then
        dir = "left"
        isFlip = true
    end

    local imageName
    if dir then
        imageName = string.format("%s_%s_%s_%d.png", self.name, action, dir, index)
    else
        imageName = string.format("%s_%s_%d.png", self.name, action, index)
    end

    self:setSpriteFrame(display.newSpriteFrame(imageName))
    self:flipX(isFlip)
end

return Animation