--[[
    R剧本角色
--]]

local RPlotRoleInfo = import(".r_role_info")

local ANIMATION_PREFIX = "ccz/plotchar/"
local ROLE_WIDTH       = 48
local ROLE_HEIGHT      = 64
local TILE_SIZE        = 30

local RPlotRole = class("RPlotRole", function()
    return display.newNode()
end)

RPlotRole.ctor = function(self, roleName, col, row, dir, parent)
    if RPlotRoleInfo[roleName] then
        self.roleInfo = RPlotRoleInfo[roleName]
    else
        self.roleInfo = RPlotRoleInfo[string.gsub(roleName, "[%d]+", "")]
    end

    self.roleName = roleName
    self.resId    = self.roleInfo.res * 2
    self.head     = self.roleInfo.head
    self.row      = row
    self.col      = col
    self.dir      = dir or "up"

    if dir then
        self:initAnimation()
        self:initBatch()
        self:showCurSprite(0)
    end

    self:addTo(parent)
end

RPlotRole.getHead = function(self)
    return self.head
end

RPlotRole.setHead = function(self, head)
    self.head = head
end

RPlotRole.move = function(self, col, row, callback)
    callback = callback or function() end

    if row == self.row and col == self.col then
        callback()
        return
    end

    local colOffset = col - self.col
    local rowOffset = row - self.row

    local curX, curY = self:getPosition()
    local x = curX + 8 * colOffset - 8 * rowOffset
    local y = curY - 4 * colOffset - 4 * rowOffset


    if self.row > row or self.col > col then
        animationName = "move_up"
    end

    if self.row > row then
        self.dir = "up"
    elseif self.row < row then
        self.dir = "down"
    elseif self.col > col then
        self.dir = "left"
    else
        self.dir = "right"
    end

    self.animation:stop()

    local isFlip = (self.dir == "left" or self.dir == "right") and true or false
    local animationName = (self.dir == "down" or self.dir == "right") and "move_down" or "move_up"
    local animationCache = display.getAnimationCache(self.roleName .. animationName)
    self.animation:playAnimationForever(animationCache)
    self.animation:flipX(isFlip)
    self.animation:show()

    self.sprites[1]:hide()
    self.sprites[2]:hide()

    self.row, self.col = row, col
    local time = cc.pGetDistance(cc.p(curX, curY), cc.p(x, y)) / TILE_SIZE * 0.1
    self:moveTo(time, x, y)
    self:performWithDelay(callback, time)
end

RPlotRole.disappear = function(self, callback)
    self:performWithDelay(function()
        self:removeSelf()
        callback()
    end, 0.2)
end

RPlotRole.playAction = function(self, actionId, callback, dir)
    self.dir = dir or self.dir
    actionId = (actionId > -1) and actionId or nil
    self:showCurSprite(actionId)
    callback()
end

RPlotRole.say = function(self, name, content, callback)
    local _, chatIcon = self:getCurSprite()
    chatIcon:show()

    local realName = string.gsub(name, "[%d]+", "")
    local isLeft = (self.dir == "left" or self.dir == "down")
    local isBottom = (self.dir == "down" or self.dir == "right")
    ChatDialogUtils.showDialog(self:getHead(), realName, content, isLeft, isBottom, function()
        chatIcon:hide()
        callback()
    end)
end

RPlotRole.makeChoices = function(self, choices, finalCallback)
    local _, chatIcon = self:getCurSprite()
    chatIcon:show()

    local isLeft = (self.dir == "left" or self.dir == "down")
    local isBottom = (self.dir == "down" or self.dir == "right")
    ChatDialogUtils.showChoiceDialog(self:getHead(), self.roleName, nil, choices, isLeft, isBottom, finalCallback)
end

RPlotRole.initAnimation = function(self)
    self.animationCaches = {}

    local getAnimation = function(resId, animationName, startIndex, endIndex)
        local frames = {}
        for index = startIndex, endIndex do
            local frame = cc.SpriteFrame:create(ANIMATION_PREFIX .. resId .. ".png", cc.rect(0, index * ROLE_HEIGHT, ROLE_WIDTH, ROLE_HEIGHT))
            frames[#frames + 1] = frame
        end

        local animation = display.newAnimation(frames, 0.1) -- 0.1秒播放1帧
        ResMgr.addAnimationCache(animationName, animation)

        return animationName
    end

    self.animationCaches[#self.animationCaches + 1] = getAnimation(self.resId, self.roleName .. "move_down", 1, 2)
    self.animationCaches[#self.animationCaches + 1] = getAnimation(self.resId + 1, self.roleName .. "move_up", 1, 2)

    self.animation = display.newSprite()
    self.animation:addTo(self)
    self.animation:hide()
end

RPlotRole.initBatch = function(self)
    local batcheDown = display.newBatchNode(ANIMATION_PREFIX .. self.resId .. ".png")
    local batcheUp = display.newBatchNode(ANIMATION_PREFIX .. (self.resId + 1) .. ".png")

    self.sprites = {}
    self.sprites[1] = cc.Sprite:createWithTexture(batcheDown:getTexture())
    self.sprites[1]:hide()
    self.sprites[1]:addTo(self)

    self.sprites[2] = cc.Sprite:createWithTexture(batcheUp:getTexture())
    self.sprites[2]:hide()
    self.sprites[2]:addTo(self)

    self.downChatIcon = display.newSprite("ccz/chat/down.png")
    self.downChatIcon:align(display.LEFT_TOP, ROLE_WIDTH, ROLE_HEIGHT)
    self.downChatIcon:hide()
    self.downChatIcon:setGlobalZOrder(100)
    self.downChatIcon:addTo(self.sprites[1])

    self.upChatIcon = display.newSprite("ccz/chat/up.png")
    self.upChatIcon:align(display.RIGHT_TOP, 0, ROLE_HEIGHT)
    self.upChatIcon:hide()
    self.upChatIcon:setGlobalZOrder(100)
    self.upChatIcon:addTo(self.sprites[2])
end

RPlotRole.getCurSprite = function(self, dir)
    dir = dir or self.dir

    self.animation:stop()
    self.animation:hide()

    self.downChatIcon:hide()
    self.upChatIcon:hide()

    if not dir then
        if self.sprites[1]:isVisible() then
            return self.sprites[1], self.downChatIcon
        else
            return self.sprites[2], self.upChatIcon
        end
    end

    local curSprite, chatIcon
    if dir == "up" or dir == "left" then
        curSprite = self.sprites[2]
        self.sprites[1]:hide()
        chatIcon = self.upChatIcon
    else
        curSprite = self.sprites[1]
        self.sprites[2]:hide()
        chatIcon = self.downChatIcon
    end

    curSprite:flipX(self:isNeedFlip(dir))
    curSprite:show()

    return curSprite, chatIcon
end

RPlotRole.showCurSprite = function(self, actionId)
    self.actionId = actionId or self.actionId

    local curSprite = self:getCurSprite()
    curSprite:setTextureRect(cc.rect(0, self.actionId * ROLE_HEIGHT, ROLE_WIDTH, ROLE_HEIGHT))
    return curSprite
end

RPlotRole.isNeedFlip = function(self, dir)
    return (dir == "left") or (dir == "right")
end

RPlotRole.onExit = function(self)
    printInfo("动画卸载")

    table.walk(self.animationCaches, function(v)
        ResMgr.removeAnimationCache(v)
    end)
end

RPlotRole.addPressedPlot = function(self, plot)
    self.pressedPlot = plot
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

RPlotRole.onTouch = function(self, event)
    EventMgr.triggerEvent(EventConst.ROLE_PRESSED_PLOT, self.pressedPlot)
end

return RPlotRole