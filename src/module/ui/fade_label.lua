--[[
    这个可以逐字符闪现，原理是每个字符都是一个label，会很耗
    目前仅用在R剧本SceneDialog中
--]]

local FadeLabel = class("FadeLabel", function()
    return display.newNode()
end)

-- 播放状态 1 表示未开始 2 表示播放中 3 表示已经播放完毕
local STATUS_START   = 1
local STATUS_PLAYING = 2
local STATUS_END     = 3

-- 创建方法
--[[
    local params = {
        fontName = "Arial",
        fontSize = 30,
        fontColor = cc.c3b(255, 0, 0),
        dimensions = cc.size(300, 200),
        callbacks = {[1] = function() print("touch it") end}
        text = "[fontColor=f75d85 fontSize=20 callback=1]hello world[/fontColor]",
    }

    text 目前支持参数
        文字
        fontName  : font name
        fontSize  : number
        fontColor : 十六进制

        图片
        image : "xxx.png"
        scale : number
--]]

FadeLabel.ctor = function(self, params)
    self.labelStatus = STATUS_START

    self:init_(params)
    self:setNodeEventEnabled(true)
end

FadeLabel.onExit = function(self)
    table.walk(self.sprites, function(sprite)
        sprite:stop()
    end)
end

-- 设置text
FadeLabel.setString = function(self, text)
    if self.text == text then
        return
    end

    if self.text then
        -- 删除之前的string
        self.sprites = nil
        self.containLayer:removeAllChildren()
    end

    self.labelStatus = STATUS_START -- 未开始
    self:stopFrameEvent()

    self.text = text

    -- 转化好的数组
    local parseArray = self:parseString_(text)
    -- 将字符串拆分成一个个字符
    self:formatString_(parseArray)
    -- 创建精灵
    self.sprites = self:createSprite_(parseArray)

    self:adjustPosition_()
end

-- 设置尺寸
FadeLabel.setDimensions = function(self, dimensions)
    self.containLayer:setContentSize(dimensions)
    self.dimensions = dimensions

    self:adjustPosition_()
end

-- 获得label尺寸
FadeLabel.getLabelSize = function(self)
    local width = self.maxWidth or 0
    local height = self.maxHeight or 0

    return cc.size(width, height)
end

-- 是否在播放动画
FadeLabel.isRunningAmim = function(self)
    return (self.labelStatus == STATUS_PLAYING)
end

-- 强制停止播放动画
FadeLabel.playEnded = function(self)
    printInfo("play ended")
    self:stopFrameEvent()

    self.labelStatus = STATUS_END
    for i, sprite in ipairs(self.sprites) do
        sprite:stopActionByTag(99)
        sprite:opacity(255)
    end
end

-- 播放fade in 动画
FadeLabel.playFadeInAnim = function(self, wordPerSecond, callback)
    callback = callback or function() end

    local sprites = self.sprites
    if sprites then
        if self.labelStatus == STATUS_PLAYING then
            -- 上一个动画播放中
            self:playEnded()
        end

        self.labelStatus = STATUS_PLAYING -- 播放中

        -- 默认每秒15个字
        wordPerSecond = wordPerSecond or 15
        local delay = 1 / wordPerSecond
        local curTime = 0
        local totalNum = #sprites
        if totalNum == 0 then
            -- 播放完毕
            self.labelStatus = STATUS_END
            self:playEnded()
            callback()
            return
        end

        for i, sprite in ipairs(sprites) do
            sprite:opacity(0)
        end

        local totalTime = totalNum * delay
        local curIntIndex = 1
        local updatePosition = function(dt)
            curTime = curTime + dt

            -- 这个类似动作里面的update的time参数
            local time = curTime / totalTime
            local fIndex = (totalNum - 1) * time + 1 -- 从1开始
            local index = math.floor(fIndex)
            if index >= totalNum then
                -- 最后一个点
                self.labelStatus = STATUS_END
                self:stopFrameEvent()

                if UserConfig:getBoolForKey("QuickDialog", true) then
                    self:performWithDelay(callback, 0.4)
                end

                return
            end

            if index >= curIntIndex then
                for i = curIntIndex, index do
                    local sprite = sprites[i]
                    if sprite then
                        local action = cc.FadeIn:create(0.2)
                        action:setTag(99)
                        sprite:runAction(action)
                    else
                        printInfo("Error: sprite not exist")
                    end
                end

                curIntIndex = index + 1
            end
        end

        self:stopFrameEvent()
        self:startFrameEvent(updatePosition)
    end
end

FadeLabel.stopFrameEvent = function(self)
    self:removeNodeEventListenersByEvent(cc.NODE_ENTER_FRAME_EVENT)
    self:unscheduleUpdate()
end

FadeLabel.startFrameEvent = function(self, callback, finalCallback)
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, callback)
    self:scheduleUpdate()
end

FadeLabel.init_ = function(self, params)
    -- 装文字和图片精灵
    local containLayer  = display.newNode()
    self:addChild(containLayer)

    self.fontName       = params.fontName or FONT -- 默认字体
    self.fontSize       = params.fontSize or FONTSIZE -- 默认大小
    self.fontColor      = params.fontColor or display.COLOR_WHITE -- 默认白色
    self.dimensions     = params.dimensions or cc.size(0, 0) -- 默认无限扩展，即沿着x轴往右扩展
    self.callbacks      = params.callbacks or {} -- 默认没有回调函数
    self.containLayer   = containLayer

    self:setString(params.text)
end

-- 获得每个精灵的尺寸
FadeLabel.getSizeOfSprites_ = function(self, sprites)
    local widthArr = {} -- 宽度数组
    local heightArr = {} -- 高度数组

    -- 精灵的尺寸
    for i, sprite in ipairs(sprites) do
        local rect = sprite:getBoundingBox()
        widthArr[i] = rect.width
        heightArr[i] = rect.height
    end

    return widthArr, heightArr
end

-- 获得每个精灵的位置
FadeLabel.getPointOfSprite_ = function(self, widthArr, heightArr, dimensions)
    local totalWidth = dimensions.width

    local maxWidth = 0
    local maxHeight = 0

    -- 从左往右，从上往下拓展
    local curX = 0 -- 当前x坐标偏移
    local curIndexX = 1 -- 当前横轴index
    local curIndexY = 1 -- 当前纵轴index

    local pointArrX = {} -- 每个精灵的x坐标
    local rowIndexArr = {} -- 行数组，以行为index储存精灵组
    local indexArrY = {} -- 每个精灵的行index

    -- 计算宽度，并自动换行
    for i, spriteWidth in ipairs(widthArr) do
        local nextX = curX + spriteWidth
        local pointX
        local rowIndex = curIndexY

        -- 添加\n换行的支持，否则换行符就仅仅只是一个不可见的符号，起不到作用
        local isNewLine = false
        if self.sprites[i].isLabel and self.sprites[i]:getString() == "\n" then
            isNewLine = true
        end

        local halfWidth = spriteWidth * 0.5
        if isNewLine or (nextX > totalWidth and totalWidth ~= 0) then -- 超出界限了
            pointX = halfWidth
            if curIndexX == 1 then
                -- 当前是第一个，重置x
                curX = 0
            else
                -- 不是第一个，当前行已经不足容纳
                rowIndex = curIndexY + 1
                curX = spriteWidth
            end

            curIndexX = 1 -- x坐标重置
            curIndexY = curIndexY + 1 -- y坐标自增
        else
            pointX = curX + halfWidth -- 精灵坐标x
            curX = pointX + halfWidth -- 精灵最右侧坐标
            curIndexX = curIndexX + 1
        end
        pointArrX[i] = pointX -- 保存每个精灵的x坐标

        indexArrY[i] = rowIndex -- 保存每个精灵的行

        local tmpIndexArr = rowIndexArr[rowIndex]
        if not tmpIndexArr then -- 没有就创建
            tmpIndexArr = {}
            rowIndexArr[rowIndex] = tmpIndexArr
        end
        tmpIndexArr[#tmpIndexArr + 1] = i -- 保存相同行对应的精灵

        if curX > maxWidth then
            maxWidth = curX
        end
    end

    local curY = 0
    local rowHeightArr = {} -- 每一行的y坐标

    -- 计算每一行的高度
    for i, rowInfo in ipairs(rowIndexArr) do
        local rowHeight = 0
        for j, index in ipairs(rowInfo) do -- 计算最高的精灵
            local height = heightArr[index]
            if height > rowHeight then
                rowHeight = height
            end
        end
        local pointY = curY + rowHeight * 0.5 -- 当前行所有精灵的y坐标（正数，未取反）
        rowHeightArr[#rowHeightArr + 1] = - pointY -- 从左往右，从上到下扩展，所以是负数
        curY = curY + rowHeight -- 当前行的边缘坐标（正数）

        if curY > maxHeight then
            maxHeight = curY
        end
    end

    self.maxWidth = maxWidth
    self.maxHeight = maxHeight

    local pointArrY = {}
    local spriteNum = #widthArr
    for i = 1, spriteNum do
        local indexY = indexArrY[i] -- y坐标是先读取精灵的行，然后再找出该行对应的坐标
        local pointY = rowHeightArr[indexY]
        pointArrY[i] = pointY
    end

    return pointArrX, pointArrY
end

-- 调整位置（设置文字和尺寸都会触发此方法）
FadeLabel.adjustPosition_ = function(self)
    local sprites = self.sprites
    if not sprites then
        return
    end

    -- 获得每个精灵的宽度和高度
    local widthArr, heightArr = self:getSizeOfSprites_(sprites)
    -- 获得每个精灵的坐标
    local pointArrX, pointArrY = self:getPointOfSprite_(widthArr, heightArr, self.dimensions)

    for i, sprite in ipairs(sprites) do
        sprite:setPosition(pointArrX[i], pointArrY[i])
    end
end

-- 创建精灵
FadeLabel.createSprite_ = function(self, parseArray)
    local sprites = {}

    for i, dic in ipairs(parseArray) do
        local textArr = dic.textArray
        if #textArr > 0 then
            -- 创建文字
            local fontName = dic.fontName or self.fontName
            local fontSize = dic.fontSize or self.fontSize
            local fontColor = dic.fontColor or self.fontColor
            for j, word in ipairs(textArr) do
                local label = cc.LabelTTF:create(word, fontName, fontSize)
                label.isLabel = true
                label:setColor(fontColor)
                sprites[#sprites + 1] = label
                self.containLayer:addChild(label)

                if dic.callback and #self.callbacks ~= 0 and self.callbacks[dic.callback] then
                    -- 添加点击回调
                    label:setTouchEnabled(true)
                    label:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                        self.callbacks[dic.callback]()
                    end)
                end
            end
        elseif dic.image then
            local sprite = display.newSprite(dic.image)
            sprite:setScale(dic.scale or 1)
            sprites[#sprites + 1] = sprite
            self.containLayer:addChild(sprite)

            if dic.callback and #self.callbacks ~= 0 and self.callbacks[dic.callback] then
                -- 添加点击回调
                sprite:setTouchEnabled(true)
                sprite:addNodeEventListener(cc.NODE_TOUCH_EVENT, function(event)
                    self.callbacks[dic.callback]()
                end)
            end
        else
            error("not define")
        end
    end

    return sprites
end

-- 将字符串转换成一个个字符
FadeLabel.formatString_ = function(self, parseArray)
    for i, dic in ipairs(parseArray) do
        local text = dic.text
        if text then
            local textArr = self:stringToChar_(text)
            dic.textArray = textArr
        end
    end
end

-- 文字解析，按照顺序转换成数组，每个数组对应特定的标签
FadeLabel.parseString_ = function(self, str)
    local clumpheadTab = {} -- 标签头
    -- 作用，取出所有格式为[xxxx]的标签头
    for w in string.gfind(str, "%b[]") do
        if  string.sub(w, 2, 2) ~= "/" then
            -- 去尾
            table.insert(clumpheadTab, w)
        end
    end

    -- 解析标签
    local totalTab = {}
    for k, ns in pairs(clumpheadTab) do
        local tab = {}
        local tStr
        -- 第一个等号前为块标签名
        string.gsub(ns, string.sub(ns, 2, #ns-1), function (w)
            local n = string.find(w, "=")
            if n then
                local temTab = self:stringSplit_(w, " ") -- 支持标签内嵌
                for k, pstr in pairs(temTab) do
                    local temtab1 = self:stringSplit_(pstr, "=")
                    local pname = temtab1[1]

                    if k == 1 then
                        -- 标签头
                        tStr = pname
                    end

                    local js = temtab1[2]
                    local p = string.find(js, "[^%d.]")
                    if not p then
                        js = tonumber(js)
                    end

                    local switchState = {
                        -- 目前只是颜色需要转换
                        ["fontColor"] = function()
                            -- 颜色直接传递temtab1[2]，js如果是0的情况下，颜色就会错误
                            tab["fontColor"] = self:convertColor_(temtab1[2])
                        end,
                    }

                    -- 存在switch
                    local fSwitch = switchState[pname]
                    if fSwitch then
                        fSwitch()
                    else
                        -- 没有枚举
                        tab[pname] = js
                    end
                end
            end
        end)

        if tStr then
            -- 取出文本
            local beginFind, endFind = string.find(str, "%[%/" .. tStr .. "%]")
            local endNumber = beginFind - 1
            local gs = string.sub(str, #ns+1, endNumber)
            if string.find(gs, "%[") then
                tab["text"] = gs
            else
                string.gsub(str, gs, function (w)
                    tab["text"] = w
                end)
            end
            -- 截掉已经解析的字符
            str = string.sub(str, endFind + 1, #str)
            table.insert(totalTab, tab)
        end
    end

    -- 普通格式label显示
    if table.nums(clumpheadTab) == 0 then
        local ptab = {}
        ptab.text = str
        table.insert(totalTab, ptab)
    end

    return totalTab
end

-- 解析16进制颜色rgb值
FadeLabel.convertColor_ = function(self, xStr)
    local function toTen(v)
        return tonumber("0x" .. v)
    end

    local b = string.sub(xStr, -2, -1)
    local g = string.sub(xStr, -4, -3)
    local r = string.sub(xStr, -6, -5)

    local red = toTen(r) or self.fontColor.r
    local green = toTen(g) or self.fontColor.g
    local blue = toTen(b) or self.fontColor.b

    return cc.c3b(red, green, blue)
end

-- string.split()
FadeLabel.stringSplit_ = function(self, str, flag)
    local tab = {}
    while true do
        local n = string.find(str, flag)
        if n then
            local first = string.sub(str, 1, n - 1)
            str = string.sub(str, n + 1, #str)
            table.insert(tab, first)
        else
            table.insert(tab, str)
            break
        end
    end
    return tab
end

-- 拆分出单个字符
FadeLabel.stringToChar_ = function(self, str)
    local list = {}
    local len = string.len(str)
    local i = 1
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if c > 0 and c <= 127 then
            shift = 1
        elseif (c >= 192 and c <= 223) then
            shift = 2
        elseif (c >= 224 and c <= 239) then
            shift = 3
        elseif (c >= 240 and c <= 247) then
            shift = 4
        end

        local char = string.sub(str, i, i + shift - 1)
        i = i + shift
        table.insert(list, char)
    end

    return list, len
end

return FadeLabel