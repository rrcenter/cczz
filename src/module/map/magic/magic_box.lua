--[[
    真正的策略攻击显示框
--]]

local MagicInfoView = import(".magic_info_view")

local MagicBox = class("MagicBox", function()
    local node = display.newNode()
    node:size(MapConst.BLOCK_WIDTH, MapConst.BLOCK_HEIGHT)
    node:align(display.LEFT_BOTTOM)
    return node
end)

MagicBox.ctor = function(self, general, magicConfig, row, col)
    local color = LightRedColor
    if magicConfig.type == "good" then
        color = LightBlueColor
        self.isFriendMagic = true -- 有益策略
    end

    -- 如果这个指定的行列已经存在武将，则不添加rectNode，因为这样会挡住武将
    -- 目前的解决方案为，如果该区域有武将，则武将自己添加一个红色边框，在此节点onExit时，移除掉该武将的box
    local target = MapUtils.getGeneralByRowAndCol(row, col)
    if target then
        if self.isFriendMagic then
            self.magicBox = target:addColorBox(color)
        elseif target ~= general then
            self.magicBox = target:addColorBox(color)
        end
        self.hurtBloodBar = target:addMagicHurtBloodBar(general, magicConfig)
    else
        display.newRect(MapViewConst.TILE_RECT, {fillColor = color, borderWidth = 0}):addTo(self)
    end

    self.general = general
    self.magicConfig = magicConfig
    self.row = row
    self.col = col

    self:setNodeEventEnabled(true)
    self:setTouchEnabled(true)
    self:addNodeEventListener(cc.NODE_TOUCH_EVENT, handler(self, self.onTouch))
end

MagicBox.onExit = function(self)
    if self.magicBox then
        self.magicBox:removeSelf()
        self.magicBox = nil
    end

    -- 一定要处理，不然可能节点已经消失了，但是回调还是会执行过来
    if self.longClickHandler then
        scheduler.unscheduleGlobal(self.longClickHandler)
        self.longClickHandler = nil
    end

    if self.hurtBloodBar then
        self.hurtBloodBar:removeSelf()
        self.hurtBloodBar = nil
    end
end

MagicBox.onTouch = function(self, event)
    if event.name == "began" then
        self.moveCount = 0
        self.longClickHandler = scheduler.performWithDelayGlobal(function()
            self.longClickHandler = nil
            self:onLongClicked(event)
        end, LONG_CLICK_TIME)
    elseif event.name == "moved" then
        self.moveCount = self.moveCount + 1
        self:onMoved(event)
    elseif event.name == "ended" then
        if self.moveCount < 3 then
            if self.longClickHandler then
                -- 表示未执行长按处理，直接关闭长按计时器
                scheduler.unscheduleGlobal(self.longClickHandler)
                self.longClickHandler = nil

                self:onClicked(event)
            end
        end
    end

    return true
end

MagicBox.onLongClicked = function(self, event)
    local target = MapUtils.getGeneralByRowAndCol(self.row, self.col)
    if target then
        if self.isFriendMagic then
            if target:isPlayer() or target:isFriend() then
                printInfo("这是一个增益策略%s", self.magicConfig.name)
                EventMgr.triggerEvent(EventConst.TOUCH_MAGIC_BOX, target:getRow(), target:getCol())
                EventMgr.triggerEvent(EventConst.SHOW_MAGIC_PREVIEW, self.general, target, self.magicConfig)
            else
                TipUtils.showTip("此技能不能用于敌方部队。")
            end
        else
            if target:isEnemy() then
                EventMgr.triggerEvent(EventConst.TOUCH_MAGIC_BOX, target:getRow(), target:getCol())
                EventMgr.triggerEvent(EventConst.SHOW_MAGIC_PREVIEW, self.general, target, self.magicConfig)
            else
                TipUtils.showTip("不能攻击己方部队。")
            end
        end
    else
        printInfo("该攻击区域无武将，点击无效哦~，直接返回战斗菜单")
        EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MENU, self.general)
    end
end

MagicBox.onClicked = function(self, event)
    if not MapUtils.getGeneralByRowAndCol(self.row, self.col) then
        EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MENU, self.general)
        return
    end

    local target = MapUtils.getGeneralByRowAndCol(self.row, self.col)
    if (not self.isFriendMagic) and (target == self.general) then
        TipUtils.showTip("不能攻击己方部队。")
        return
    elseif self.isFriendMagic and target and target:isEnemy() then
        TipUtils.showTip("此技能不能用于敌方部队。")
        return
    end

    if not MapUtils.isSupportMagicTile(self.magicConfig.name, self.row, self.col) then
        TipUtils.showTip(string.format("该地形无法施展%s", self.magicConfig.name))
        return
    end

    local targets = {}
    if self.magicConfig.hitRangeType then
        local magicHitRange = AttackRangeUtils.getAttackRange(self.magicConfig.hitRangeType, self.row, self.col, self.general:getRow(), self.general:getCol())
        for _, v in pairs(magicHitRange) do
            if MapUtils.isSupportMagicTile(self.magicConfig.name, target:getRow(), target:getCol()) then
                local target = MapUtils.getGeneralByRowAndCol(v.row, v.col)
                if target then
                    if self.isFriendMagic then
                        if target:isPlayer() or target:isFriend() then
                            table.insert(targets, target)
                        end
                    else
                        if target:isEnemy() then
                            table.insert(targets, target)
                        end
                    end
                end
            end
        end
    else
        local target = MapUtils.getGeneralByRowAndCol(self.row, self.col)
        if target then
            if self.isFriendMagic then
                if target:isPlayer() or target:isFriend() then
                    table.insert(targets, target)
                end
            else
                if target:isEnemy() then
                    table.insert(targets, target)
                end
            end
        end
    end

    if #targets > 0 then
        local target = MapUtils.getGeneralByRowAndCol(self.row, self.col)
        self.general:magic(self.magicConfig, target, targets)

        EventMgr.triggerEvent(EventConst.GENERAL_HIDE_MAGIC_RANGE)
        EventMgr.triggerEvent(EventConst.HIDE_MAGIC_PREVIEW)
        return
    end

    EventMgr.triggerEvent(EventConst.GENERAL_SHOW_MENU, self.general)
end

MagicBox.onMoved = function(self, event)
    local xOffset = event.x - event.prevX
    local yOffset = event.y - event.prevY
    EventMgr.triggerEvent(EventConst.MOVE_MAP_VIEW, xOffset, yOffset)
end

return MagicBox