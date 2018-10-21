--[[
    富文本控件，参考来源：http://www.cocoachina.com/bbs/read.php?tid-218977.html
--]]

local ChineseSize = 3 -- 修正宽度缺陷(范围:3~4)

local RichLabel = class("RichLabel", function()
    return display.newNode()
end)

RichLabel.ctor = function(self, param)
    param = param or {}
    param.str = param.str or "传入的字符为nil"
    param.font = param.font or "Microsoft Yahei"
    param.fontSize = param.fontSize or 14
    param.rowWidth = param.rowWidth or 280
    param.rowSpace = param.rowSpace or -4

    local textTab = self:initData(param.str, param.font, param.fontSize, param.rowWidth)
    self:setContentSize(cc.size(1, 1)) -- richlabel统一节点且不影响其它

    local ptab, copyVar = self:tabAddtext(textTab)

    local ocWidth   = 0 -- 当前占宽
    local ocRow     = 1 -- 当前行
    local ocHeight  = 0 -- 当前高度
    local btn, useWidth, useHeight = 0, 0, 0

    self.btns = {}
    for _, v in pairs(copyVar) do
        local params = {}
        table.merge(params, v)

        -- 计算实际渲染宽度
        if params.row == ocRow then
            ocWidth = ocWidth + useWidth
        else
            ocRow = params.row
            ocWidth = 0
            -- 计算实际渲染高度
            ocHeight = ocHeight + useHeight + param.rowSpace -- 修正高度间距
        end

        local maxsize  = params.size
        local byteSize = math.floor((maxsize + 2) / ChineseSize)
        params.width   = byteSize * params.breadth -- 控件宽度
        params.height  = maxsize -- 控件高度
        params.x       = ocWidth -- 控件x坐标
        params.y       = -ocHeight -- 控件y坐标
        params.scene   = self

        btn, useWidth, useHeight = self:tabCreateButton(params)
        table.insert(self.btns, btn)
    end

    self:setNodeEventEnabled(true)
end

-- 初始化数据
RichLabel.initData = function(self, str, font, fontSize, rowWidth)
    local tab = self:parseString(str, {font = font, size = fontSize})
    local var = {
        tab = tab, -- 文本字符
        width = rowWidth, -- 指定宽度
    }

    return var
end

-- 获取一个格式化后的浮点数
local function strFormatToNumber(number, num)
    local s = "%." .. num .. "f"
    return tonumber(string.format(s, number))
end

-- 全角 半角
RichLabel.accountTextLen = function(self, str, tsize)
    local list = self:tabCutText(str)
    local aLen = 0

    for _, v in pairs(list) do
        -- 懒得写解析方法了
        local a = string.len(v)
        local label = display.newTTFLabel({text = v, size = tsize})
        a = tsize / (label:getContentSize().width)

        local b = strFormatToNumber(ChineseSize / a, 4)
        aLen = aLen + b
    end

    return aLen
end

RichLabel.addDataToRenderTab = function(self, copyVar, tab, text, index, current)
    local tag               = #copyVar + 1
    copyVar[tag]            = {}
    table.merge(copyVar[tag], tab)
    copyVar[tag].text       = text
    copyVar[tag].index      = index
    copyVar[tag].row        = current
    copyVar[tag].breadth    = self:accountTextLen(text, tab.size)
    copyVar[tag].tag        = tag -- 唯一下标
end

RichLabel.tabAddtext = function(self, var)
    local allTab  = {}
    local copyVar = {}
    local useLen  = 0
    local str     = ""
    local current = 1

    for ktb, tab in ipairs(var.tab) do
        local txtTab, member = self:tabCutText(tab.text)
        local num = math.floor((var.width) / math.ceil((tab.size + 2) / ChineseSize))

        if useLen > 0 then
            local remain = num - useLen
            local txtLen = self:accountTextLen(tab.text, tab.size)
            if txtLen <= remain then
                allTab[current] = allTab[current] .. tab.text
                self:addDataToRenderTab(copyVar, tab, tab.text, useLen + 1, current)
                useLen = useLen + txtLen
                txtTab = {}
            else
                local cTag = 0
                local mstr = ""
                local sIndex = useLen + 1
                for k, element in pairs(txtTab) do
                    local sLen = self:accountTextLen(element, tab.size)
                    if (useLen + sLen) <= num then
                        useLen = useLen + sLen
                        cTag = k
                        mstr = mstr .. element
                    else
                        if string.len(mstr) > 0 then
                            allTab[current] = allTab[current] .. mstr
                            self:addDataToRenderTab(copyVar, tab, mstr, sIndex, current)
                        end
                        current = current + 1
                        useLen = 0
                        str = ""
                        break
                    end
                end

                for i = 1, cTag do
                    table.remove(txtTab, 1)
                end
            end
        end

        -- 填充字符
        local maxRow = math.ceil(member / num)
        for k, element in pairs(txtTab) do
            local sLen = self:accountTextLen(element, tab.size)
            if element ~= "\n" and (useLen + sLen) <= num then
                useLen = useLen + sLen
                str = str .. element
            else
                allTab[current] = str
                self:addDataToRenderTab(copyVar, tab, str, 1, current)
                current = current + 1
                useLen = sLen

                str = (element == "\n") and "" or element
            end

            if k == #txtTab then
                if useLen <= num then
                    allTab[current] = str
                    self:addDataToRenderTab(copyVar, tab, str, 1, current)
                end
            end
        end
    end

    return allTab, copyVar
end

-- 拆分出单个字符
RichLabel.tabCutText = function(self, str)
    local list = {}
    local len = string.len(str)
    local i = 1
    while i <= len do
        local c = string.byte(str, i)
        local shift = 1
        if 0 < c and c <= 127 then
            shift = 1
        elseif (192 <= c and c <= 223) then
            shift = 2
        elseif (224 <= c and c <= 239) then
            shift = 3
        elseif (240 <= c and c <= 247) then
            shift = 4
        end

        local char = string.sub(str, i, i + shift - 1)
        table.insert(list, char)

        i = i + shift
    end

    return list, len
end

RichLabel.tabCreateButton = function(self, params)
    local btn = cc.ui.UIPushButton.new("ccz/chat/richLabelBg.png", {scale9 = true})
        :setButtonSize(params.width, params.height)
        :setButtonLabel("normal", display.newTTFLabel({
            text  = params.text,
            size  = params.size,
            color = params.color,
            font  = params.font,
        }))
        :onButtonPressed(function(event)
            event.target:getButtonLabel("normal"):setPosition(cc.p(0, 0))
        end)
        :onButtonClicked(function(event)
            event.target:getButtonLabel("normal"):setPosition(cc.p(0, 0))
            if self.callback then
                self.callback(event.target, params)
            end
        end)
        :onButtonRelease(function(event)
            event.target:getButtonLabel("normal"):setPosition(cc.p(0, 0))
        end)
        :align(display.LEFT_TOP, params.x, params.y)
        :addTo(params.scene)
    btn:setButtonLabelAlignment(display.TOP_LEFT)

    local normalLab = btn:getButtonLabel("normal")
    normalLab:setPosition(cc.p(0, 0))
    local useWidth = normalLab:getBoundingBox().width
    local useHeight = normalLab:getBoundingBox().height
    if params.image then
        self:imageManage(btn, params, useWidth)
    end

    return btn, useWidth, useHeight
end

-- 图片标签处理
RichLabel.imageManage = function(self, object, params, useWidth)
    local image = display.newSprite(params.image, 0, -4)
    image:setScaleX(useWidth / image:getContentSize().width)
    image:setScaleY(params.size / image:getContentSize().height)
    image:setAnchorPoint(cc.p(0, 1))
    object:addChild(image, 1)
    object:setButtonLabelString("normal", "")

    local moveUp = cc.MoveBy:create(0.5, cc.p(0, 2))
    local moveDown = cc.MoveBy:create(0.5, cc.p(0, -2))
    image:runAction(cc.RepeatForever:create(transition.sequence({moveUp, moveDown})))
    object.imageSprite = image
end

-- 解析输入的文本
RichLabel.parseString = function(self, str, param)
    local clumpheadTab = {} -- 标签头
    for w in string.gfind(str, "%b[]") do
        if  string.sub(w, 2, 2) ~= "/" then -- 去尾
            table.insert(clumpheadTab, w)
        end
    end

    -- 解析标签
    local totalTab = {}
    for _, ns in pairs(clumpheadTab) do
        local tab = {}
        local tStr

        -- 第一个等号前为块标签名
        string.gsub(ns, string.sub(ns, 2, #ns - 1), function(w)
            local n = string.find(w, "=")
            if n then
                local temTab = string.split(w, " ") -- 支持标签内嵌
                for k, pstr in pairs(temTab) do
                    local temtab1 = string.split(pstr, "=")

                    local pname = temtab1[1]
                    if k == 1 then
                        tStr = pname -- 标签头
                    end

                    local js = temtab1[2]
                    local p = string.find(js, "[^%d.]")
                    if not p then
                        js = tonumber(js)
                    end

                    if pname == "color" then
                        -- 解析16进制颜色rgb值
                        local getTextColor = function(str)
                            if string.len(str) == 6 then
                                local r = tonumber("0x" .. string.sub(str, 1, 2))
                                local g = tonumber("0x" .. string.sub(str, 3, 4))
                                local b = tonumber("0x" .. string.sub(str, 5, 6))

                                return cc.c3b(r, g, b)
                            end

                            return display.COLOR_WHITE
                        end

                        tab[pname] = getTextColor(temtab1[2])
                    else
                        tab[pname] = js
                    end
                end
            end
        end)

        if tStr then
            -- 取出文本
            local beginFind, endFind = string.find(str, "%[%/" .. tStr .. "%]")
            local endNumber = beginFind - 1
            local gs = string.sub(str, #ns + 1, endNumber)
            if string.find(gs, "%[") then
                tab["text"] = gs
            else
                string.gsub(str, gs, function(w)
                    tab["text"] = w
                end)
            end

            -- 截掉已经解析的字符
            str = string.sub(str, endFind + 1, #str)
            if param then
                -- 未指定number则自动生成
                if not tab.number then
                    param.number = k
                end
                table.merge(tab, param)
            end

            table.insert(totalTab, tab)
        end
    end

    -- 普通格式label显示
    if table.nums(clumpheadTab) == 0 then
        local ptab = {}
        ptab.text = str
        if param then
            param.number = 1
            table.merge(ptab, param)
        end

        table.insert(totalTab, ptab)
    end

    return totalTab
end

-- 设置监听函数
RichLabel.setClilckEventListener = function(self, callback)
    self.callback = callback
end

RichLabel.startFadeOut = function(self, time)
    time = time or 0.4
    table.walk(self.btns, function(btn)
        btn:opacity(0)
        btn:fadeIn(time)
    end)
end

RichLabel.stopFadeOut = function(self)
    table.walk(self.btns, function(btn)
        btn:opacity(255)
        btn:stop()
    end)
end

RichLabel.onExit = function(self)
    self:stopFadeOut()
end

return RichLabel
