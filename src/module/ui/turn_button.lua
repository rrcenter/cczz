--[[
测试样例，优化程度很大，而且效果一般
    local btnTurn = TurnButton.new()
    btnTurn:center()
    btnTurn:align(display.CENTER)
    btnTurn:addTo(self)
    end
--]]

local RUNTIME = 0.3 -- 动画运行时间
local A  = 0 -- 椭圆长半径
local Bd = 0 -- 下椭圆短半径
local Bu = 0 -- 上椭圆短半径
local Cx = 0 -- 椭圆中心X坐标
local Cy = 0 -- 椭圆中心Y坐标

local TurnButton = class("TurnButton", function()
    return display.newNode()
end)

TurnButton.ctor = function(self)
    self.posBottom = cc.p(0, 0)
    self.posLeft   = cc.p(-display.width * 0.24, display.height * 0.15)
    self.posTop    = cc.p(0, display.height * 0.24)
    self.posRight  = cc.p(display.width * 0.24, display.height * 0.15)

    A  = self.posBottom.x - self.posLeft.x
    Bu = self.posTop.y - self.posLeft.y
    Bd = self.posLeft.y - self.posBottom.y
    Cx = self.posBottom.x
    Cy = self.posLeft.y

    self.btn1 = display.newSprite("btn.png")
    self.btn1:pos(self.posBottom.x, self.posBottom.y)
    self.btn1:setName("Bottom")
    self.btn1:addTo(self, 4)

    self.btn2 = display.newSprite("btn.png")
    self.btn2:pos(self.posLeft.x, self.posLeft.y)
    self.btn2:scale(0.75)
    self.btn2:opacity(100)
    self.btn2:setName("Left")
    self.btn2:addTo(self, 3)

    self.btn3 = display.newSprite("btn.png")
    self.btn3:pos(self.posTop.x, self.posTop.y)
    self.btn3:scale(0.5)
    self.btn3:opacity(50)
    self.btn3:setName("Top")
    self.btn3:addTo(self, 2)

    self.btn4 = display.newSprite("btn.png")
    self.btn4:pos(self.posRight.x, self.posRight.y)
    self.btn4:scale(0.75)
    self.btn4:opacity(100)
    self.btn4:setName("Right")
    self.btn4:addTo(self, 3)


    self.valid = false -- 先点击有效区域
    self.inValid = false -- 先点击无效区域
    self.firstPos = nil

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

TurnButton.onTouch = function(self, event)
    if event.name == "began" then
        self:onTouchBegan(event)
    elseif event.name == "moved" then
        self:onTouchMoved(event)
    elseif event.name == "ended" then
        self:onTouchEnded(event)
    end

    return true
end

TurnButton.onTouchBegan = function(self, event)
    self.firstPos = cc.p(event.x, event.y)
end

TurnButton.onTouchMoved = function(self, event)
    local movePos = cc.p(event.x, event.y)
    local judgePos = self:convertToNodeSpace(movePos)
    local box = cc.rect(-display.width * 0.5, -display.height * 0.1, display.width, display.height * 0.4)

    if cc.rectContainsPoint(box, judgePos) then
        if not self.valid then
            self.inValid = true
        end
        return
    end

    if not self.m_invalid then
        self.valid = true
    else
        return
    end

    -- 根据滑动方向来运动
    local ratio = math.abs(movePos.x - self.firstPos.x) * 2 / display.width
    if ratio >= 1 then
        return
    end

    self:runSlidedAmt(movePos.x < self.firstPos.x, ratio, math.abs(self.firstPos.x - movePos.x))
end

TurnButton.onTouchEnded = function(self, event)
    if self.inValid then
        self.inValid = false
        return
    end

    local endPos = cc.p(event.x, event.y)
    local delX = endPos.x - self.firstPos.x
    local delY = endPos.y - self.firstPos.y
    
    -- 如果是点击操作
    if math.abs(delX) < 0.0001 and math.abs(delY) < 0.0001 then
        endPos = self:convertToNodeSpace(endPos)
        local box1 = self.btn1:getBoundingBox()
        local box2 = self.btn2:getBoundingBox()
        local box3 = self.btn3:getBoundingBox()
        local box4 = self.btn4:getBoundingBox()

        if cc.rectContainsPoint(box1, endPos) then
            if self.btn1:getLocalZOrder() == 4 then
                print("Btn1 CallBack")
            else
                self:runTouchedAmt(self.btn1)
            end
        elseif cc.rectContainsPoint(box2, endPos) then
            if self.btn2:getLocalZOrder() == 4 then
                print("Btn2 CallBack")
            else
                self:runTouchedAmt(self.btn2)
            end
        elseif cc.rectContainsPoint(box3, endPos) then
            if self.btn3:getLocalZOrder() == 4 then
                print("Btn3 CallBack")
            else
                self:runTouchedAmt(self.btn3)
            end
        elseif cc.rectContainsPoint(box4, endPos) then
            if self.btn4:getLocalZOrder() == 4 then
                print("Btn4 CallBack")
            else
                self:runTouchedAmt(self.btn4)
            end
        end
    else
        -- 滑动操作
        local adjustPos = cc.p(event.x, event.y)
        -- 判断滑动方向
        if adjustPos.x < self.firstPos.x then
            self:runTouchedAmt(self:getChildByName("Right"))
        elseif adjustPos.x > self.firstPos.x then
            self:runTouchedAmt(self:getChildByName("Left"))
        end
    end

    self.valid = false
end

-- 点击按钮之后的动画
TurnButton.runTouchedAmt = function(self, btn)
    local name = btn:getName()
    if name == "Left" then
        btn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 1),
            cca.moveTo(RUNTIME, self.posBottom.x, self.posBottom.y),
            cca.fadeIn(RUNTIME)
        }))
        btn:zorder(4)

        local topBtn = self:getChildByName("Top")
        topBtn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 0.75),
            cca.moveTo(RUNTIME, self.posLeft.x, self.posLeft.y),
            cca.fadeTo(RUNTIME, 100)
        }))
        topBtn:zorder(3)

        local rightBtn = self:getChildByName("Right")
        rightBtn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 0.5),
            cca.moveTo(RUNTIME, self.posTop.x, self.posTop.y),
            cca.fadeTo(RUNTIME, 50)
        }))
        rightBtn:zorder(2)

        local bottomBtn = self:getChildByName("Bottom")
        bottomBtn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 0.75),
            cca.moveTo(RUNTIME, self.posRight.x, self.posRight.y),
            cca.fadeTo(RUNTIME, 100)
        }))
        bottomBtn:zorder(3)

        btn:setName("Bottom")
        topBtn:setName("Left")
        rightBtn:setName("Top")
        bottomBtn:setName("Right")

    elseif name == "Top" then
        btn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 1),
            cca.seq({cca.moveTo(RUNTIME, self.posLeft.x, self.posLeft.y), cca.moveTo(RUNTIME, self.posBottom.x, self.posBottom.y)}),
            cca.fadeIn(RUNTIME)
        }))
        btn:zorder(4)

        local rightBtn = self:getChildByName("Right")
        rightBtn:runAction(cca.spawn({
            cca.seq({cca.scaleTo(RUNTIME, 0.5), cca.scaleTo(RUNTIME, 0.75)}),
            cca.seq({cca.moveTo(RUNTIME, self.posTop.x, self.posTop.y), cca.moveTo(RUNTIME, self.posLeft.x, self.posLeft.y)}),
            cca.seq({cca.fadeTo(RUNTIME, 50), cca.fadeTo(RUNTIME, 100)}),
        }))
        rightBtn:zorder(3)

        local bottomBtn = self:getChildByName("Bottom")
        bottomBtn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 0.5),
            cca.seq({cca.moveTo(RUNTIME, self.posRight.x, self.posRight.y), cca.moveTo(RUNTIME, self.posTop.x, self.posTop.y)}),
            cca.fadeTo(RUNTIME, 50),
        }))
        bottomBtn:zorder(2)

        local leftBtn = self:getChildByName("Left")
        leftBtn:runAction(cca.spawn({
            cca.seq({cca.scaleTo(RUNTIME, 1), cca.scaleTo(RUNTIME, 0.75)}),
            cca.seq({cca.moveTo(RUNTIME, self.posBottom.x, self.posBottom.y), cca.moveTo(RUNTIME, self.posRight.x, self.posRight.y)}),
            cca.seq({cca.fadeIn(RUNTIME), cca.fadeTo(RUNTIME, 100)})
        }))
        leftBtn:zorder(3)

        btn:setName("Bottom")
        leftBtn:setName("Right")
        rightBtn:setName("Left")
        bottomBtn:setName("Top")

    elseif name == "Right" then
        btn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 1),
            cca.moveTo(RUNTIME, self.posBottom.x, self.posBottom.y),
            cca.fadeIn(RUNTIME),
        }))
        btn:zorder(4)

        local topBtn = self:getChildByName("Top")
        topBtn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 0.75),
            cca.moveTo(RUNTIME, self.posRight.x, self.posRight.y),
            cca.fadeTo(RUNTIME, 100)
        }))
        topBtn:zorder(3)

        local leftBtn = self:getChildByName("Left")
        leftBtn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 0.5),
            cca.moveTo(RUNTIME, self.posTop.x, self.posTop.y),
            cca.fadeTo(RUNTIME, 50)
        }))
        leftBtn:zorder(2)

        local bottomBtn = self:getChildByName("Bottom")
        bottomBtn:runAction(cca.spawn({
            cca.scaleTo(RUNTIME, 0.75),
            cca.moveTo(RUNTIME, self.posLeft.x, self.posLeft.y),
            cca.fadeTo(RUNTIME, 100)
        }))
        bottomBtn:zorder(3)

        btn:setName("Bottom")
        topBtn:setName("Right")
        leftBtn:setName("Top")
        bottomBtn:setName("Left")
    end
end

-- 滑动界面的动画
TurnButton.runSlidedAmt = function(self, isLeft, ratio, judgePosX)
    local btnTop    = self:getChildByName("Top");
    local btnLeft   = self:getChildByName("Left");
    local btnRight  = self:getChildByName("Right");
    local btnBottom = self:getChildByName("Bottom");

    local deltPosDown = cc.pSub(self.posRight, self.posBottom)
    local deltPosUp   = cc.pSub(self.posTop, self.posLeft)

    -- 判断是否需要调换Z顺序
    if judgePosX > display.width / 4 then
        btnTop:zorder(3)
        btnLeft:zorder(isLeft and 2 or 4)
        btnRight:zorder(isLeft and 4 or 2)
        btnBottom:zorder(3)
    end
    
    local B1 = isLeft and Bu or Bd -- 判断左边的button沿哪个椭圆运动
    local B2 = isLeft and Bd or Bu -- 判断右边的button沿哪个椭圆运动
    
    local temp = isLeft and (self.posBottom.x - deltPosDown.x * ratio) or (self.posBottom.x + deltPosDown.x * ratio)
    btnBottom:pos(temp, math.sin(-math.acos((temp - Cx) / A)) * Bd + Cy)
    btnBottom:scale(1 - 0.25 * ratio)
    btnBottom:opacity(255 - 155 * ratio)

    temp = isLeft and (self.posLeft.y + deltPosUp.y * ratio) or (self.posLeft.y - deltPosDown.y * ratio)
    btnLeft:pos(-math.cos(math.asin((temp - Cy) / B1)) * A + Cx, temp)
    if isLeft then
        btnLeft:scale(0.75 - 0.25 * ratio)
        btnLeft:opacity(100 - 50 * ratio)
    else
        btnLeft:scale(0.75 + 0.25 * ratio)
        btnLeft:opacity(100 + 155 * ratio)
    end
    
    temp = self.posTop.x + (isLeft and (deltPosUp.x * ratio) or (-1 * deltPosUp.x * ratio))
    btnTop:pos(temp, math.sin(math.acos((temp - Cx) / A)) * Bu + Cy)
    btnTop:scale(0.5 + 0.25 * ratio)
    btnTop:opacity(50 + 50 * ratio)

    temp = self.posRight.y + (isLeft and (-1 * deltPosDown.y * ratio) or (deltPosUp.y * ratio))
    btnRight:pos(math.cos(math.asin((temp - Cy) / B2)) * A + Cx, temp)
    if isLeft then
        btnRight:scale(0.75 + 0.25 * ratio)
        btnRight:opacity(100 + 155 * ratio)
    else
        btnRight:scale(0.75 - 0.25 * ratio)
        btnRight:opacity(100 - 50 * ratio)
    end
end

return TurnButton