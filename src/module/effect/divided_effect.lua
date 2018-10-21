--[[
    几个不规则图片分离和聚合的特效
    local enterEffect = DividedEffect.new()
    self:addChild(enterEffect)

    enterEffect:alginToDivided()
    enterEffect:gotoConverged({onComplete = function()
        enterEffect:gotoDivided()
    end})
--]]

local DividedEffectConst = {}
DividedEffectConst.RES_PATH       = "ccz/effect/transit_pic"
DividedEffectConst.RES_URL_LEFT   = "#transit_left.png"
DividedEffectConst.RES_URL_BOTTOM = "#transit_bottom.png"
DividedEffectConst.RES_URL_UP     = "#transit_up.png"

DividedEffectConst.QUIT_EFFECT_TIME  = 0.5
DividedEffectConst.QUIT_TIME         = 0.5
DividedEffectConst.ENTER_EFFECT_TIME = 0.5
DividedEffectConst.ENTER_TIME        = 0.5
DividedEffectConst.ENTER_DELAY_TIME  = 0.1

local DividedEffect = class("DividedEffect", function()
    return display.newNode()
end)

DividedEffect.ctor = function(self)
    self:init()
    self:setNodeEventEnabled(true)
end

DividedEffect.init = function(self)
    -- 预先加载图片
    ResMgr.addSpriteFrames(DividedEffectConst.RES_PATH, ".pvr.ccz")

    self.pictureLeft = display.newSprite(DividedEffectConst.RES_URL_LEFT)
    self:addChild(self.pictureLeft)

    self.pictureBottom = display.newSprite(DividedEffectConst.RES_URL_BOTTOM)
    self:addChild(self.pictureBottom)

    self.pictureUp =  display.newSprite(DividedEffectConst.RES_URL_UP)
    self:addChild(self.pictureUp)

    local size = self.pictureUp:getContentSize()
    self.scaleX = display.width / size.width
    self.scaleY = display.height / size.height

    if self.scaleX > 1 then
        self.pictureLeft:setScaleX(self.scaleX)
        self.pictureUp:setScaleX(self.scaleX)
        self.pictureBottom:setScaleX(self.scaleX)
    end

    if self.scaleY > 1 then
        self.pictureLeft:setScaleY(self.scaleY)
        self.pictureUp:setScaleY(self.scaleY)
        self.pictureBottom:setScaleY(self.scaleY)
    end
end

DividedEffect.onExit = function(self)
    ResMgr.removeSpriteFramesWithFile(DividedEffectConst.RES_PATH, ".pvr.ccz")
end

-- 分开状态
DividedEffect.alginToDivided = function(self)
    self.pictureLeft:setPosition(cc.p(-display.cx, display.cy))
    self.pictureUp:setPosition(cc.p(display.cx, 3 * display.cy))
    self.pictureBottom:setPosition(cc.p(display.cx, -display.cy))
end

-- 聚合状态
DividedEffect.alginToConverged = function(self)
    self.pictureLeft:setPosition(cc.p(display.cx, display.cy))
    self.pictureUp:setPosition(cc.p(display.cx, display.cy))
    self.pictureBottom:setPosition(cc.p(display.cx, display.cy))
end

DividedEffect.gotoConverged = function(self, params)
    params = params or {}
    local onComplete = params.onComplete or function() end
    local needEffect = params.needEffect or true -- 默认播放聚合特效

    local actionLeft   = cca.moveTo(DividedEffectConst.QUIT_EFFECT_TIME, display.cx, display.cy)
    local actionUp     = cca.moveTo(DividedEffectConst.QUIT_EFFECT_TIME, display.cx, display.cy)
    local actionBottom = cca.moveTo(DividedEffectConst.QUIT_EFFECT_TIME, display.cx, display.cy)
    local actionEnd    = cca.cb(onComplete)

    if needEffect then
        self.pictureUp:runAction(actionUp)
        self.pictureLeft:runAction(actionLeft)
        self.pictureBottom:runAction(actionBottom)
        self.pictureBottom:runAction(transition.sequence({actionBottom, cca.delay(DividedEffectConst.ENTER_DELAY_TIME), actionEnd}) )
    else
        onComplete()
    end
end

DividedEffect.gotoDivided = function(self, params)
    params = params or {}
    local onComplete = params.onComplete or function() end

    local actionLeft   = cca.moveTo(DividedEffectConst.ENTER_EFFECT_TIME, -display.cx, display.cy)
    local actionUp     = cca.moveTo(DividedEffectConst.ENTER_EFFECT_TIME, display.cx, 3 * display.cy)
    local actionBottom = cca.moveTo(DividedEffectConst.ENTER_EFFECT_TIME, display.cx, -display.cy)
    local actionEnd    = cca.cb(onComplete)

    self.pictureUp:runAction(actionUp)
    self.pictureLeft:runAction(actionLeft)
    self.pictureBottom:runAction(actionBottom)
    self.pictureBottom:runAction(transition.sequence({actionBottom, cca.delay(DividedEffectConst.ENTER_DELAY_TIME), actionEnd}))
end

return DividedEffect