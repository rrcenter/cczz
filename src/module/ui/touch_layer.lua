--[[
    主要是由于display.newLayer的大小是winSize
    而背景图其实比这大，无法截取整个地图点击，因此扩展一个layer来处理
--]]

local TouchLayer = class("TouchLayer", function()
    return display.newNode()
end)

TouchLayer.ctor = function(self)
    self:size(MapUtils.getMapWidth(), MapUtils.getMapHeight())

    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
        self:onTouch(event)
    end)
end

TouchLayer.onTouch = function(self, event)
    -- printInfo("子类应该自行实现自己的onTouch事件")
end

return TouchLayer