--[[
    点击接口类
        实现一个单击，双击，长按和移动处理
        单击和双击区分，通过一个click属性来控制，点击之后，该属性设置为true，然后再设置一个0.25秒点延时
        如果这个时间内，没有再次点击则为单击，再次点击，会判断click状态，为true表示之前点击过，那就应该为双击
        长按处理，则是在按下时，添加一个0.5秒的计时器，如果点击之后释放了，则判断，计时器存在则表示没有执行长按逻辑，关闭计时器，否则表示执行计时器，不执行单双击逻辑
--]]

local TouchNode = class("TouchNode", function()
    return display.newNode()
end)

TouchNode.ctor = function(self)
    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

TouchNode.onTouch = function(self, event)
    if event.name == "began" then
        self.moveCount = 0
        self.longClickHandler = scheduler.performWithDelayGlobal(function()
            self.longClickHandler = nil

            printInfo("长按处理")
            self:onLongClick(event)
        end, LONG_CLICK_TIME)
    elseif event.name == "moved" then
        self.moveCount = self.moveCount + 1
        self:onMoved(event)
    elseif event.name == "ended" then
        if self.longClickHandler then
            -- 表示未执行长按处理，直接关闭长按计时器
            scheduler.unscheduleGlobal(self.longClickHandler)
            self.longClickHandler = nil

            -- 继续判断单双击处理
            if self.click then
                self.click = false

                printInfo("双击处理")
                self:onDoubleClick(event)
            else
                -- 延时0.25秒，如果有再次点击，则是双击处理，否则为单击处理，通过click进行控制
                self.singleTouchHandler = scheduler.performWithDelayGlobal(function()
                    if self.click then
                        self.click = false

                        printInfo("单击处理")
                        self:onClick(event)
                    end
                end, DOUBLE_CLICK_TIME)
                self.click = true
            end
        end
    end

    return true
end

TouchNode.onExit = function(self)
    if self.longClickHandler then
        scheduler.unscheduleGlobal(self.longClickHandler)
        self.longClickHandler = nil
    end

    -- 单点时间太短，出现几率低，不过还是做一下处理
    if self.singleTouchHandler then
       scheduler.unscheduleGlobal(self.singleTouchHandler)
       self.singleTouchHandler = nil
    end
end

TouchNode.onClick = function(self, event)
    printInfo("子类中应该实现单击处理")
end

TouchNode.onDoubleClick = function(self, event)
    printInfo("子类中应该实现双击处理")
end

TouchNode.onLongClick = function(self, event)
    printInfo("子类中应该实现长按处理")
end

TouchNode.onMoved = function(self, event)
    -- printInfo("子类中应该实现移动处理")
end

-- 一轮点击中，若moveCount小于3，视为点击行为
TouchNode.isTouchMoved = function(self)
    return self.moveCount >= 3
end

return TouchNode