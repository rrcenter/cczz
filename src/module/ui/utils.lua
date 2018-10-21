--[[
    提供一些UI辅助借口
--]]

local UIUtils = {}

-- 屏幕截图，传入一个任意矩形，来截获屏幕某块区域
-- sp如果没有传入，则在这里构造一个sprite来返回，否则直接设置这个sp为截取内容
UIUtils.captureScreen = function(rect, sp)
    -- 截取整个屏幕，然后在从中截取出指定的矩形区域
    local render = cc.RenderTexture:create(display.width, display.height)
    render:beginWithClear(0, 0, 0, 1)
    display.getRunningScene():visit()
    render:endToLua()

    local texture = render:getSprite():getTexture()
    sp = sp or display.newSprite()
    sp:setTextureRect(rect)
    sp:setTexture(texture)
    sp:flipY(true)
    return sp
end

return UIUtils