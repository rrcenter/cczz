--[[
    策略类
--]]

local MagicDuration = 0.4

local Magic = class("Magic", function()
    return display.newSprite()
end)

Magic.ctor = function(self, animationConfig, callback)
    --!! 暂时写在这里
    self.res = "ccz/magic/animation/" .. animationConfig.res
    ResMgr.addSpriteFrames(self.res)

    local action = animationConfig.action or animationConfig.res
    local frames = display.newFrames(action .. "_%d.png", animationConfig.startIndex or 0, animationConfig.frameLen)
    local animationTime = (animationConfig.frameLen / 15 * MagicDuration) / animationConfig.frameLen
    local animation = display.newAnimation(frames, animationTime)
    self:playAnimationOnce(animation, true, function()
        if callback then
            callback()
        end

        self:removeSelf()
    end)
    self:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, MapConst.BLOCK_HEIGHT / 2)
    self:setNodeEventEnabled(true)
end

Magic.onExit = function(self)
    printInfo("策略动画卸载")
    ResMgr.removeSpriteFramesWithFile(self.res)
end

return Magic