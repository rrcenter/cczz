--[[
    火
--]]

local Fire = class("Fire", function()
    return display.newSprite()
end)

Fire.ctor = function(self)
    self.res = "ccz/map/other/fire"
    ResMgr.addSpriteFrames(self.res)

    local frames = display.newFrames("fire_%d.png", 1, 4)
    local animation = display.newAnimation(frames, 0.5 / 4)
    self:playAnimationForever(animation)
    self:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, MapConst.BLOCK_HEIGHT / 2)
    self:setNodeEventEnabled(true)
end

Fire.onExit = function(self)
    ResMgr.removeSpriteFramesWithFile(self.res)
end

return Fire