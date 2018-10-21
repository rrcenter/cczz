--[[
    聊天对话框
        最多允许3行
        出现聊天选择时：第一行为说明文字，二三行为聊天选择
        可以指定位置，如果不指定，则默认居中出现
--]]

local ViewWidth  = MapConst.BLOCK_WIDTH * 8
local ViewHeight = MapConst.BLOCK_HEIGHT * 2
local XOFFSET    = MapConst.BLOCK_WIDTH * 0.25
local ResPrefix  = "ccz/chat/"
local AliveTime  = 0.4
local ZORDER     = 1000

--[[
    用来记录上一个对话框实例，然后在新实例产生前，移除前一个
    这样是因为直接NeedTouch这类对话框的finalCallback中移除，会产生一个bug，造成程序崩溃，暂未查明原因
    没有维持一个实例产生对话框，纯粹因为直接生成简单，偷懒导致
--]]
local LastDialog = nil

local ChatDialog = class("ChatDialog", function()
    return TouchLayer.new()
end)

ChatDialog.ctor = function(self, name, headIcon, isLeft, content, callback, choices)
    if LastDialog then
        LastDialog:removeSelf()
    end
    LastDialog = self

    local bgNode = display.newTilesSprite(ResPrefix .. "chat_bg.png", cc.rect(0, 0, ViewWidth, ViewHeight))
    bgNode:align(display.CENTER, display.cx, display.cy)
    bgNode:addTo(self)
    self.bgNode = bgNode

    local headIcon = display.newSprite(headIcon)
    headIcon:addTo(bgNode)

    local ContentSize = cc.size(ViewWidth - headIcon:getContentSize().width - 10, ViewHeight)
    local contentNode = display.newNode()
    contentNode:size(ContentSize.width, ContentSize.height)
    contentNode:addTo(bgNode)

    if isLeft then
        headIcon:align(display.LEFT_CENTER, 10, ViewHeight / 2)
        contentNode:align(display.LEFT_BOTTOM, ViewWidth - ContentSize.width + 10, 0)
    else
        headIcon:align(display.RIGHT_CENTER, ViewWidth - 10, ViewHeight / 2)
        contentNode:align(display.LEFT_BOTTOM, 0, 0)
    end

    local nameLabel = display.newTTFLabel({text = name, size = FontSize, font = FontName, color = FontBlueColor})
    nameLabel:align(display.LEFT_TOP, 10, ViewHeight - 5)
    nameLabel:addTo(contentNode)

    local chatBgLeft = display.newSprite(ResPrefix .. "left_boundary.png")
    chatBgLeft:align(display.LEFT_TOP, 10, nameLabel:getPositionY() - FontSize - 3)
    chatBgLeft:addTo(contentNode)

    local chatBgMiddle = display.newScale9Sprite(ResPrefix .. "middle.png", 0, 0, cc.size(ContentSize.width * 0.8, chatBgLeft:getContentSize().height))
    chatBgMiddle:align(display.LEFT_TOP, chatBgLeft:getPositionX() + chatBgLeft:getContentSize().width, chatBgLeft:getPositionY())
    chatBgMiddle:addTo(contentNode)

    local chatBgRight = display.newSprite(ResPrefix .. "right_boundary.png")
    chatBgRight:align(display.LEFT_TOP, chatBgMiddle:getPositionX() + chatBgMiddle:getContentSize().width, chatBgLeft:getPositionY())
    chatBgRight:addTo(contentNode)

    if isLeft then
        local leftArrow = display.newSprite(ResPrefix .. "left_arrow.png")
        leftArrow:align(display.RIGHT_CENTER, chatBgLeft:getPositionX(), ContentSize.height / 3)
        leftArrow:addTo(contentNode)
    else
        local rightArrow = display.newSprite(ResPrefix .. "right_arrow.png")
        rightArrow:align(display.LEFT_CENTER, chatBgRight:getPositionX() + chatBgRight:getContentSize().width, ContentSize.height / 3)
        rightArrow:addTo(contentNode)
    end

    if content then
        local str = string.format("[color=000000]%s[/color]", content)
        local contentLabel = RichLabel.new({str = str, font = FontName, fontSize = FontSize - 3, rowSpace = 0})
        contentLabel:align(display.LEFT_TOP, 0, chatBgMiddle:getContentSize().height * 0.9)
        contentLabel:addTo(chatBgMiddle)
        contentLabel:startFadeOut()
    end

    self.finalCallback = function()
        self:hide()

        if callback then
            callback()
        end
    end

    if choices then
        self.bgNode:scale(1.5)
        self.hasChoices = true

        local createChoice = function(color, choiceContent, choiceCallback, y)
            local choiceStr = string.format("[color=%s number=100]    %s[/color]", color, choiceContent)
            local choiceLabel = RichLabel.new({str = choiceStr, font = FontName, fontSize = FontSize - 3, rowSpace = 0})
            choiceLabel:align(display.LEFT_TOP, 0, y)
            choiceLabel:addTo(chatBgMiddle)
            choiceLabel:setClilckEventListener(function(button, params)
                if params.number == 100 then
                    choiceCallback()
                    self.finalCallback()
                end
            end)
            choiceLabel:startFadeOut()

            return choiceLabel, choiceLabel:getPositionY()
        end

        local choiceY = chatBgMiddle:getContentSize().height - FontSize * 0.5
        if #choices == 3 then
            choiceY = chatBgMiddle:getContentSize().height - FontSize * 0.25
        end

        for i = 1, #choices do
            _, choiceY = createChoice("0000FF", choices[i][1], choices[i][2], choiceY)
            choiceY = choiceY - FontSize * 1.2
        end
    end
end

ChatDialog.onTouch = function(self, event)
    if not self.hasChoices then
        self.finalCallback()
    end
end

ChatDialog.realign = function(self, anchor, x, y)
    self.bgNode:align(anchor, x, y)
end

local ChatDialogUtils = {}

--[[
    ShowChatDialog({
        {name = g:getName(), headIcon = g:getHeadIcon(), isLeft = true, content = "1111"},
        {name = g:getName(), headIcon = g:getHeadIcon(), isLeft = false, content = "2222"},
        {name = g:getName(), headIcon = g:getHeadIcon(), isLeft = false, content = "3333", choices = {
            {"1.我认怂", function() print("1111") end}, {"2.我认怂", function() print("2222") end}
        }},
        {name = g:getName(), headIcon = g:getHeadIcon(), isLeft = true, content = "4444"},
    }, self, function() print("oveer") end)
--]]
ChatDialogUtils.ShowChatDialog = function(chats, parent, finalCallback)
    table.oneByOne(chats, function(chat, nextCallback)
        ChatDialog.new(chat.name, chat.headIcon, chat.isLeft, chat.content, function()
            callback(index + 1, chats)
        end, chat.choices):addTo(parent)
    end, finalCallback)
end

-- 服务于S剧本
local showSingleChat = function(general, isLeft, content, finalCallback, pos, aliveTime)
    aliveTime = aliveTime or AliveTime
    local chatDialog = ChatDialog.new(general:getName(), general:getHeadIcon(), isLeft, content, finalCallback)
    chatDialog:addTo(display.getRunningScene(), ZORDER)
    chatDialog:performWithDelay(function()
        if finalCallback then
            finalCallback()
        end

        chatDialog:hide()
    end, aliveTime)

    if pos then
        chatDialog:realign(display.RIGHT_BOTTOM, math.max(pos.x, ViewWidth + XOFFSET), pos.y)
    end
end

-- 服务于S剧本
local showSingleChatNeedTouch = function(general, isLeft, content, finalCallback, pos)
    local chatDialog = ChatDialog.new(general:getName(), general:getHeadIcon(), isLeft, content, finalCallback)
    chatDialog:addTo(display.getRunningScene(), ZORDER)

    if pos then
        chatDialog:realign(display.RIGHT_BOTTOM, math.max(pos.x, ViewWidth + XOFFSET), pos.y)
    end
end

-- 服务于S剧本
ChatDialogUtils.showSPlotDialog = function(general, isLeft, content, finalCallback, pos, aliveTime)
    if UserConfig:getBoolForKey("QuickDialog", true) then
        showSingleChat(general, isLeft, content, finalCallback, pos, aliveTime)
    else
        showSingleChatNeedTouch(general, isLeft, content, finalCallback, pos)
    end
end

-- 服务于R剧本
local adjustPosForRPlot = function(chatDialog, isLeft, isBottom)
    if isLeft and isBottom then
        chatDialog:realign(display.LEFT_BOTTOM, 10, 10)
    elseif isLeft and not isBottom then
        chatDialog:realign(display.LEFT_TOP, 10, display.height - 10)
    elseif not isLeft and isBottom then
        chatDialog:realign(display.RIGHT_BOTTOM, display.width - 10, 10)
    else
        chatDialog:realign(display.RIGHT_TOP, display.width - 10, display.height - 10)
    end
end

local showSingleChatForRPlot = function(head, name, content, isLeft, isBottom, finalCallback, aliveTime)
    aliveTime = aliveTime or AliveTime
    local chatDialog = ChatDialog.new(name, head, isLeft, content, finalCallback)
    chatDialog:addTo(display.getRunningScene(), ZORDER)
    chatDialog:performWithDelay(function()
        if finalCallback then
            finalCallback()
        end

        chatDialog:hide()
    end, aliveTime)

    adjustPosForRPlot(chatDialog, isLeft, isBottom)
end

local showSingleChatNeedTouchForRPlot = function(head, name, content, isLeft, isBottom, finalCallback)
    local chatDialog = ChatDialog.new(name, head, isLeft, content, finalCallback)
    chatDialog:addTo(display.getRunningScene(), ZORDER)

    adjustPosForRPlot(chatDialog, isLeft, isBottom)
end

-- 服务于R剧本
ChatDialogUtils.showDialog = function(head, name, content, isLeft, isBottom, finalCallback)
    if UserConfig:getBoolForKey("QuickDialog", true) then
        showSingleChatForRPlot(head, name, content, isLeft, isBottom, finalCallback)
    else
        showSingleChatNeedTouchForRPlot(head, name, content, isLeft, isBottom, finalCallback)
    end
end

-- 显示选择对话框，目前最好只支持最多3个选择，虽然可以传入更多，但是位置没有针对超过3个选择的调整
ChatDialogUtils.showChoiceDialog = function(head, name, content, choices, isLeft, isBottom, finalCallback)
    local chatDialog = ChatDialog.new(name, head, isLeft, content, finalCallback, choices)
    chatDialog:addTo(display.getRunningScene(), ZORDER)
end

ChatDialogUtils.plotOver = function()
    LastDialog = nil
end

EventMgr.registerEvent(EventConst.PLOT_OVER, ChatDialogUtils.plotOver)

return ChatDialogUtils