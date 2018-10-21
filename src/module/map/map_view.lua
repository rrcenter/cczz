--[[
    目前假定这里用来绘制大地图
    1、无缩放显示整个地图
    2、方块大小也固定，看是多大，目前48*48
    3、点中方块，如果方块上有其他物体，则显示其信息，没有，则显示其方块的地形信息
    4、每个地形块会对兵种能力有不同的加成或者削弱
    5、每个地形块存在阻挡信息（如城墙不可穿越），部分地形块尽可通过部分兵种（有吗？）
    6、地形块需要的移动力不同
    7、部分地形块具有恢复能力（村庄）
--]]

local General           = import("..char.general")
local Magic             = import("..char.magic")
local Dialog            = import("..studio_ui.dialog")
local TileView          = import(".tile.map_tile_view")
local Fire              = import(".tile.fire")
local Obstacle          = import(".tile.obstacle")
local SmallView         = import(".map_small_view")
local MoveRangeLayer    = import(".move.move_range_layer")
local AttackRangeLayer  = import(".attack.attack_range_layer")
local AttackPreviewView = import(".attack.attack_preview_view")
local MagicRangeLayer   = import(".magic.magic_range_layer")
local MagicPreviewView  = import(".magic.magic_preview_view")
local MagicMenu         = import(".magic.magic_menu")
local ItemMenu          = import(".item.item_menu")
local ItemRangeLayer    = import(".item.item_range_layer")
local GeneralMenu       = import(".general.general_menu")
local GeneralTileView   = import(".general.general_tile_view")
local GeneralHurtView   = import(".general.general_hurt_view")
local PlayerHurtView    = import(".general.player_hurt_view")
local TurnLayer         = import(".turn.turn_layer")
local PkView            = import(".pk.pk_view")

local MapView = class("MapView", function()
    return display.newNode()
end)

-- battleInfo中记录战斗地图，extraData用于读档时记录的地图的viewPosition和障碍物信息
MapView.ctor = function(self, battleInfo, extraData)
    MapUtils.initLevel(battleInfo.mapId)

    self:initBackground()
    self:initSelectBox()
    self:initTileView()
    self:initGenerals()
    self:initGeneralMenu()
    self:initMagicMenu()
    self:initItemMenu()
    self:initGeneralTileView()
    self:initAttackPreviewView()
    self:initMagicPreviewView()
    self:initSmallView()
    self:initEnemyHurtView()
    self:initPlayerHurtView()
    self:initExtraData(extraData)
    self:initDialog()

    self:setNodeEventEnabled(true)
end

MapView.onEnter = function(self)
    printInfo("进入MapView，准备注册事件")

    self.handlers = {
        [EventConst.MOVE_MAP_VIEW]                      = handler(self, self.moveMapView),
        [EventConst.MOVE_TO_NODE]                       = handler(self, self.moveToNode),
        [EventConst.MOVE_TO_POS]                        = handler(self, self.moveToPos),
        [EventConst.HIDE_ALL_VIEW]                      = handler(self, self.hideAllView),
        [EventConst.GENERAL_SHOW_MOVE_RANGE]            = handler(self, self.showGeneralMoveRange),
        [EventConst.GENERAL_HIDE_MOVE_RANGE]            = handler(self, self.hideGeneralMoveRange),
        [EventConst.GENERAL_MOVE]                       = handler(self, self.generalMove),
        [EventConst.GENERAL_AI_MOVE]                    = handler(self, self.generalAiMove),
        [EventConst.GENERAL_DIE]                        = handler(self, self.generalDie),
        [EventConst.GENERAL_SHOW_MENU]                  = handler(self, self.showGeneralMenu),
        [EventConst.GENERAL_SHOW_TILE_VIEW]             = handler(self, self.showGeneralTileView),
        [EventConst.GENERAL_SHOW_ATTACK_RANGE]          = handler(self, self.showAttackRange),
        [EventConst.GENERAL_HIDE_ATTACK_RANGE]          = handler(self, self.hideAttackRange),
        [EventConst.GENERAL_SHOW_MAGIC_MENU]            = handler(self, self.showMagicMenu),
        [EventConst.GENERAL_SHOW_MAGIC_RANGE]           = handler(self, self.showMagicRange),
        [EventConst.GENERAL_HIDE_MAGIC_RANGE]           = handler(self, self.hideMagicRange),
        [EventConst.GENERAL_SHOW_ITEM_MENU]             = handler(self, self.showItemMenu),
        [EventConst.GENERAL_SHOW_ITEM_RANGE]            = handler(self, self.showItemRange),
        [EventConst.GENERAL_HIDE_ITEM_RANGE]            = handler(self, self.hideItemRange),
        [EventConst.GENERAL_ACTION_CANCEL]              = handler(self, self.generalMenuCancel),
        [EventConst.GENERAL_ACTION_CANCEL_NO_ANIMATION] = handler(self, self.generalMenuCancelNoAnimation),
        [EventConst.GENERAL_ACTION_STOP]                = handler(self, self.generalMenuStop),
        [EventConst.GENERAL_ACTION_DONE]                = handler(self, self.generalActionDone),
        [EventConst.SHOW_ATTACK_PREVIEW]                = handler(self, self.showAttackPreviewView),
        [EventConst.HIDE_ATTACK_PREVIEW]                = handler(self, self.hideAttackPreviewView),
        [EventConst.SHOW_MAGIC_PREVIEW]                 = handler(self, self.showMagicPreviewView),
        [EventConst.HIDE_MAGIC_PREVIEW]                 = handler(self, self.hideMagicPreviewView),
        [EventConst.SHOW_HURT_VIEW]                     = handler(self, self.showHurtView),
        [EventConst.HIDE_ENEMY_HURT_VIEW]               = handler(self, self.hideEnemyHurtView),
        [EventConst.HIDE_PLAYER_HURT_VIEW]              = handler(self, self.hidePlayerHurtView),
        [EventConst.ADD_NONTOUCH_LAYER]                 = handler(self, self.addNonTouchLayer),
        [EventConst.REMOVE_NONTOUCH_LAYER]              = handler(self, self.removeNonTouchLayer),
        [EventConst.REFRESH_ALL_GENERALS]               = handler(self, self.refreshAllGenerals),
        [EventConst.REFRESH_GENERALS]                   = handler(self, self.refreshGenerals),
        [EventConst.HIGHLIGHT_RANGE]                    = handler(self, self.highlightRange),
        [EventConst.HIGHLIGHT_GENERAL]                  = handler(self, self.highlightGeneral),
        [EventConst.CHAT_DIALOG]                        = handler(self, self.chatDialog),
        [EventConst.PLOT_SHOW_DIALOG]                   = handler(self, self.plotShowDialog),
        [EventConst.PLOT_GENERAL_ACTION]                = handler(self, self.plotGeneralAction),
        [EventConst.PLOT_SHOW_GENERAL_ATTACK]           = handler(self, self.plotShowGeneralAttack),
        [EventConst.PLOT_SHOW_GENERAL]                  = handler(self, self.plotShowGeneral),
        [EventConst.PLOT_SHOW_GENERAL_MOVE]             = handler(self, self.plotShowGeneralMove),
        [EventConst.PLOT_SHOW_GENERAL_ACTION_DONE]      = handler(self, self.plotShowGeneralActionDone),
        [EventConst.PLOT_SKIP_PLAYER_TURN]              = handler(self, self.plotSkipPlayerTurn),
        [EventConst.PLOT_ADD_FIRE]                      = handler(self, self.plotAddFire),
        [EventConst.PLOT_SHOW_SPECIAL_ANIMATION]        = handler(self, self.plotShowSpecialAnimation),
        [EventConst.PLOT_ADD_STATUS]                    = handler(self, self.plotAddStatus),
        [EventConst.PLOT_ADD_ITEM]                      = handler(self, self.plotAddItem),
        [EventConst.PLOT_FACE_TO_FACE]                  = handler(self, self.plotFaceToFace),
        [EventConst.PLOT_CHANGE_AI]                     = handler(self, self.plotChangeAI),
        [EventConst.PLOT_RANGE_CHANGE_AI]               = handler(self, self.plotRangeChangeAI),
        [EventConst.PLOT_GENERAL_STATUS_CHANGE]         = handler(self, self.plotGeneralStatusChange),
        [EventConst.PLOT_GENERAL_RETREAT]               = handler(self, self.plotGeneralRetreat),
        [EventConst.PLOT_RANGE_RETREAT]                 = handler(self, self.plotRangeRetreat),
        [EventConst.PLOT_RANGE_CHANGE_STATUS]           = handler(self, self.plotRangeChangeStatus),
        [EventConst.PLOT_ALL_GENERALS_RECOVER]          = handler(self, self.plotAllGeneralsRecover),
        [EventConst.PLOT_GENERAL_DISAPPEAR]             = handler(self, self.plotGeneralDisappear),
        [EventConst.PLOT_GENERALS_DISAPPEAR]            = handler(self, self.plotGeneralsDisappear),
        [EventConst.PLOT_GENERAL_INIT_EQUIP]            = handler(self, self.plotGeneralInitEquip),
        [EventConst.PLOT_GENERAL_ADD_LEVEL]             = handler(self, self.plotGeneralAddLevel),
        [EventConst.PLOT_GENERAL_REBORN]                = handler(self, self.plotGeneralReborn),
        [EventConst.PLOT_SHOW_CHOICES]                  = handler(self, self.plotShowChoices),
        [EventConst.PLOT_PLAYER_INIT]                   = handler(self, self.plotPlayerInit),
        [EventConst.PLOT_SHOW_PLAYER_RETREATWORDS]      = handler(self, self.plotShowPlayerRetreatWords),
        [EventConst.PLOT_ADD_OBSTACLE]                  = handler(self, self.plotAddObstacle),
        [EventConst.PK_SHOW_VIEW]                       = handler(self, self.pkShowView),
        [EventConst.BATTLE_START_PLOT_DONE]             = handler(self, self.battleStartPlotDone),
        [EventConst.PLOT_OVER]                          = handler(self, self.plotOver),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

MapView.onExit = function(self)
    printInfo("离开MapView，准备反注册事件")

    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    EventMgr.dumpAllEvents()

    self.handlers = nil
end

-- 添加一个遮罩层，保证执行某些动作时，屏幕不可点击
MapView.addNonTouchLayer = function(self, fromType)
    if not self.nonTouchLayer then
        self.nonTouchLayer = TouchLayer.new()
        self.nonTouchLayer:addTo(self)
        self.nonTouchLayer.count = 1
        self.touchNode:setTouchEnabled(false)
    else
        self.nonTouchLayer.count = self.nonTouchLayer.count + 1
    end

    if fromType then
        printInfo("正在执行:%s，需要产生误点击遮罩", fromType)
    end
    printInfo("添加误点击遮罩:%d", self.nonTouchLayer.count)
    EventMgr.triggerEvent(EventConst.SPLOT_UI_ENABLED, false)
end

MapView.removeNonTouchLayer = function(self, fromType)
    if not self.nonTouchLayer then
        return
    end

    if fromType then
        printInfo("%s执行完毕，需要移除误点击遮罩", fromType)
    end
    printInfo("移除误点击遮罩:%d", self.nonTouchLayer.count - 1)

    self.nonTouchLayer.count = self.nonTouchLayer.count - 1
    if self.nonTouchLayer.count == 0 then
        self.touchNode:setTouchEnabled(true)
        self.nonTouchLayer:removeSelf()
        self.nonTouchLayer = nil

        EventMgr.triggerEvent(EventConst.SPLOT_UI_ENABLED, true)
    end
end

MapView.initBackground = function(self)
    local touchNode = TouchNode.new()
    touchNode.onLongClick = function(touchNode, event)
        self:onLongClick(event)
    end
    touchNode.onClick = function(touchNode, event)
        self:onClick(event, touchNode:isTouchMoved())
    end
    touchNode.onDoubleClick = function(touchNode, event)
        self:onDoubleClick(event)
    end
    self.touchNode = touchNode

    local bg = ccexp.TMXTiledMap:create(MapUtils.getBackgroundRes())
    bg:align(display.LEFT_TOP, 0, display.height)
    bg:addTo(touchNode)
    self.bg = bg

    local scrollView = cc.ui.UIScrollView.new({
        direction = cc.ui.UIScrollView.DIRECTION_BOTH,
        viewRect = cc.rect(0, 0, display.width, display.height),
    })
    scrollView:addScrollNode(touchNode)
    scrollView:setBounceable(false)
    scrollView:addTo(self)
    self.scrollView = scrollView
end

-- focusAdjust为true表示强制修正地图，也就是超出边界范围时也会修正，默认为false
MapView.moveMapView = function(self, xOffset, yOffset, focusAdjust)
    local x, y = self.touchNode:getPosition()
    x = x + xOffset
    y = y + yOffset

    if focusAdjust then
        if x > 0 then
            x = 0
        elseif x < display.width - MapUtils.getMapWidth() then
            x = display.width - MapUtils.getMapWidth()
        end

        if y < 0 then
            y = 0
        elseif y > MapUtils.getMapHeight() - display.height then
            y = MapUtils.getMapHeight() - display.height
        end
    else
        if x > 0 or x < display.width - MapUtils.getMapWidth() then
            x = x - xOffset
        end

        if y < 0 or y > MapUtils.getMapHeight() - display.height then
            y = y - yOffset
        end
    end


    self.touchNode:pos(x, y)
end

-- 判断指定坐标(相当于是touch坐标)是否接近地图显示边缘，用于辅助判断是否需要移动地图
MapView.isCloseToMapBoundry = function(self, x, y)
    local bw, bh = MapConst.BLOCK_WIDTH, MapConst.BLOCK_HEIGHT
    local xOffset = math.limitValue(x, bw, display.width - bw, nil, -bw, 0)
    local yOffset = math.limitValue(y, bh, display.height - bh, nil, -bh, 0)

    local row, col = MapUtils.getRowAndColByTouchPos(x, y, self.bg)
    if row == 1 or row == MapUtils.getRows() then
        yOffset = 0
    end

    if col == 1 then--or col == MapUtils.getCols() then
        xOffset = 0
    end

    if xOffset ~= 0 or yOffset ~= 0 then
        printInfo("接近了地图显示边缘，需要矫正移动%d, %d", xOffset, yOffset)
        return true, xOffset, yOffset
    end

    return false, 0, 0
end

-- 地图移动到指定node去，以该node为圆心，如果是边界则移动到边界去
MapView.moveToNode = function(self, node)
    local x, y = node:getPosition()
    local realX, realY = MapUtils.getTouchPosByMapPos(x, y, self.bg)
    if self:isCloseToMapBoundry(realX, realY) then
        local xOffset, yOffset = display.width / 2 - realX, display.height / 2 - realY
        self:moveMapView(xOffset, yOffset, true)
    end
end

-- 地图移动到指定行列处，基本同moveToNode
MapView.moveToPos = function(self, col, row)
    local realX, realY = MapUtils.getTouchPosByRowAndCol(row, col, self.bg)
    if self:isCloseToMapBoundry(realX, realY) then
        local xOffset, yOffset = display.width / 2 - realX, display.height / 2 - realY
        self:moveMapView(xOffset, yOffset, true)
    end
end

MapView.onClick = function(self, event, isMoved)
    -- 如果攻击范围或策略攻击显示，点中其他区域，则显示武将菜单
    local isMagicRangeShow = self.magicRangeLayer and self.magicRangeLayer:isVisible()
    local isAttactkRangeShow = self.attackRangeLayer and self.attackRangeLayer:isVisible()
    local isItemRangeShow = self.itemRangeLayer and self.itemRangeLayer:isVisible()
    if isMagicRangeShow or isAttackRangeShow or isItemRangeShow then
        self:showGeneralMenu(MapUtils.getCurrentGeneral())
        return
    end

    if MapUtils.getCurrentGeneral() then
        -- 当有选中武将时，允许移动，因为某些武将的移动范围可能大于整个屏幕
        -- 如果锁定整个屏幕的touch，则会导致无法移动到超出范围的格子里
        if event.name == "ended" then
            if isMoved then
                return
            end

            if self.attackRangeLayer then
                -- 如果当前是攻击层存在，则点击非攻击区域，则再次显示战斗菜单
                self:showGeneralMenu(MapUtils.getCurrentGeneral())
            elseif self.moveRangeLayer then
                -- 如果当前是移动层存在，则点击不可移动区域，则相当于重置touch武将
                self:hideAllView()
                self:clearTouchGeneral()
            end
        end
    else
        -- 背景层的点击仅仅响应地图说明界面，无需接受后续事件处理
        self:showTileView(event.x, event.y)
    end

    return true
end

MapView.onLongClick = function(self, event)
    if self.touchNode:isTouchMoved() then
        return
    end

    printInfo("MapView长按处理")
    self:hideAllView()
    -- Dialog.new("是否结束本回合", {
    --     buttonLeftText = "是",
    --     buttonLeftCallback = handler(self, self.refreshAllGenerals),
    --     buttonRightText = "否",
    -- }):addTo(self)
end

MapView.onDoubleClick = function(self, event)
    printInfo("MapView中双击处理")
    if MapUtils.getCurrentGeneral() then
        printInfo("当前已存在需要执行任务的武将%s，不接受回合对话框响应", MapUtils.getCurrentGeneral():getName())
        return
    end

    if self.dialog then
        self.dialog:show()
        printInfo("结束回合对话框已经存在，直接返回")
        return
    end

    self:hideAllView()
    self:initDialog(true)
end

-- cocos studio第一次加载特别慢，之后就会有缓存，因此这里第一次预加载，已缓解之后的压力
MapView.initDialog = function(self, isShow)
    self.dialog = Dialog.new("是否结束本回合", {
        buttonLeftText = "是",
        buttonLeftCallback = function()
            self.dialog = nil
            TurnLayer.new(GameData.getCurRound())
            self:addNonTouchLayer("回合对话框中添加遮罩")
        end,
        buttonRightText = "否",
        buttonRightCallback = function()
            self.dialog = nil
        end
    })
    self.dialog:addTo(self)
    self.dialog:setVisible(isShow)
end

MapView.refreshAllGenerals = function(self)
    self:hideAllView()
    self:clearTouchGeneral()

    self:refreshGenerals(MapUtils.getAllPlayersGeneral())
    self:refreshGenerals(MapUtils.getAllFriendsGeneral())
    self:refreshGenerals(MapUtils.getAllEnemiesGeneral())
end

MapView.refreshGenerals = function(self, generalList)
    table.walk(generalList, function(general)
        if general:isVisible() then
            printInfo("%s-%s武将回合重置", general:getSide(), general:getName())
            general:refreshAction()
        end
    end)
end

-- 初始化选中框
MapView.initSelectBox = function(self)
    local selectBoxNode = display.newSprite("ccz/map/box/select_box.png")
    selectBoxNode:align(display.LEFT_BOTTOM)
    selectBoxNode:addTo(self.bg, MapViewConst.ZORDER_SELECT_BOX)
    selectBoxNode:hide()
    self.selectBoxNode = selectBoxNode
end

MapView.showSelectBox = function(self, x, y)
    self.selectBoxNode:pos(x, y)
    self.selectBoxNode:show()
end

MapView.hideSelectBox = function(self)
    self.selectBoxNode:hide()
end

-- 初始化默认的地形介绍界面，默认隐藏，如果以后出现效率，在lazyInit
MapView.initTileView = function(self)
    local tileView = TileView.new()
    tileView:hide()
    tileView:addTo(self.bg, MapViewConst.ZORDER_MAP_TILE_VIEW)

    self.tileView = tileView
end

MapView.showTileView = function(self, x, y)
    -- 这步操作是因为在武将回合结束以后，再次点击武将，会直接关闭所有界面，如果之前此界面出现过
    -- 但是被关闭掉，会造成这里下次点击时，无法弹出地形介绍界面，所以这里预先判断下
    -- 如果界面本身隐藏，则touchRow/Col也无存在价值
    if not self.tileView:isVisible() then
        self.touchTileRow, self.touchTileCol = nil, nil
    end

    TipUtils.hide() -- 必须这样，否则可能会在截图时，截取到提示框内容
    self:hideAllView()

    -- 为了地图边缘方块能完全显示，需要到边缘方块进行坐标调整，不然截图时，会出现错误数据
    local isClosed, xOffset, yOffset = self:isCloseToMapBoundry(x, y)
    if isClosed then
        self.scrollView:scrollBy(xOffset, yOffset)
    end

    local row, col = MapUtils.getRowAndColByTouchPos(x, y, self.bg)
    printInfo("%d, %d, %s", row, col, MapUtils.getTileName(row, col))
    if self.touchTileRow == row and self.touchTileCol == col then
        self.touchTileRow, self.touchTileCol = nil, nil
        return
    end

    -- 这个用于地形介绍界面出现在左边还是右边，上边还是下边
    local isLeft, isBottom = MapUtils.getMapAreaByTouchPos(x, y)
    local tileRow  = isBottom and row or (row + 1)
    local tileCol  = isLeft and (col + 1) or (col - 3)
    local tileBox  = MapUtils.getRealTileBox(row, col, self.bg)
    local tileInfo = MapUtils.getTileInfo(row, col)

    self.tileView:initFromTile(tileInfo, tileBox)
    self.tileView:pos(MapUtils.getPosByRowAndCol(tileRow, tileCol))
    self.tileView:show()

    -- 添加此延时函数，仅仅为了当前帧不出现红色遮罩，这样截屏函数，就不会截取到红色
    -- 利用此全局计时器，在下一帧中现实选中框
    scheduler.performWithDelayGlobal(function()
        self:showSelectBox(MapUtils.getPosByRowAndCol(row, col))
    end, 0)

    self.touchTileRow = row
    self.touchTileCol = col
end

MapView.hideTileView = function(self, row, col)
    self.tileView:hide()
end

MapView.initGeneralMenu = function(self)
    local generalMenu = GeneralMenu.new()
    generalMenu:hide()
    generalMenu:addTo(self.bg, MapViewConst.ZORDER_GENERAL_MENU)

    self.generalMenu = generalMenu
end

MapView.showGeneralMenu = function(self, general)
    printInfo("MapView战斗菜单显示")
    self:hideAllView()

    -- 出现武将战斗菜单时显示选中框
    local generalPos = {general:getPosition()}
    self:showSelectBox(generalPos[1], generalPos[2])

    local row, col = general:getRow(), general:getCol()
    local isLeft, isBottom = MapUtils.getMapAreaByMapPos(generalPos[1], generalPos[2], self.bg)
    local tileRow = isBottom and row or (row + 2)
    local tileCol = isLeft and (col + 1) or (col - 2)

    self.generalMenu:pos(MapUtils.getPosByRowAndCol(tileRow, tileCol))
    self.generalMenu:show()
end

MapView.hideGeneralMenu = function(self)
    self.generalMenu:hide()
end

MapView.initGenerals = function(self)
    local sides = {"player", "friend", "enemy"}
    table.walk(sides, function(side)
        for i, dataInfo in ipairs(GeneralDataMgr.getGeneralBattleDatas(side)) do
            self:addGeneral(dataInfo, side)
        end
    end)
end

MapView.addGeneral = function(self, dataInfo, side)
    local general = General.new(dataInfo.uid, side, dataInfo.data)
    general:addTo(self.bg, MapViewConst.ZORDER_GENERAL)
    MapUtils.addGeneral(general)

    if not dataInfo.data:getRow() then
        local row, col, dir = MapUtils.getBeginPosBySideAndScriptIndex(side, dataInfo.data:getScriptIndex() + 1)
        general:setRowAndCol(row, col)
        general:stand(dir)
    end

    return general
end

MapView.generalDie = function(self, general)
    self:hideAllView()
    self:clearTouchGeneral()
end

MapView.showGeneralMoveRange = function(self, general)
    self:hideAllView()

    -- 显示一个选中框
    self:showSelectBox(general:getPosition())

    local moveRange, mapBlock = general:getMoveRange()
    self.moveRangeLayer = MoveRangeLayer.new(general, moveRange)
    self.moveRangeLayer:addTo(self.bg, MapViewConst.ZORDER_MOVE_LAYER)
    self.mapBlock = mapBlock -- 记录的是点击武将在整个地图上的阻挡信息
    return mapBlock
end

MapView.hideGeneralMoveRange = function(self)
    if self.moveRangeLayer then
        self.moveRangeLayer:removeSelf()
        self.moveRangeLayer = nil
    end
end

MapView.showAttackRange = function(self, general)
    self:hideAllView()

    self.attackRangeLayer = AttackRangeLayer.new(general)
    self.attackRangeLayer:addTo(self.bg, MapViewConst.ZORDER_ATTACK_LAYER)
end

MapView.hideAttackRange = function(self)
    if self.attackRangeLayer then
        self.attackRangeLayer:removeSelf()
        self.attackRangeLayer = nil
    end
end

MapView.initItemMenu = function(self)
    local itemMenu = ItemMenu.new()
    itemMenu:hide()
    itemMenu:addTo(self.bg, MapViewConst.ZORDER_ITEM_MENU)

    self.itemMenu = itemMenu
end

MapView.showItemMenu = function(self, general)
    self:hideAllView()

    self.itemMenu:initFromGeneral(general)
    self.itemMenu:pos(self.bg)
    self.itemMenu:show()
end

MapView.hideItemMenu = function(self)
    self.itemMenu:hide()
end

MapView.showItemRange = function(self, general, itemId)
    self:hideAllView()

    self.itemRangeLayer = ItemRangeLayer.new(general, itemId)
    self.itemRangeLayer:addTo(self.bg, MapViewConst.ZORDER_ITEM_LAYER)
end

MapView.hideItemRange = function(self)
    if self.itemRangeLayer then
        self.itemRangeLayer:removeSelf()
        self.itemRangeLayer = nil
    end
end

MapView.initMagicMenu = function(self)
    local magicMenu = MagicMenu.new()
    magicMenu:hide()
    magicMenu:addTo(self.bg, MapViewConst.ZORDER_MAGIC_MENU)

    self.magicMenu = magicMenu
end

MapView.showMagicMenu = function(self, general)
    self:hideAllView()

    self.magicMenu:initFromGeneral(general)
    self.magicMenu:pos(self.bg)
    self.magicMenu:show()
end

MapView.hideMagicMenu = function(self)
    self.magicMenu:hide()
end

MapView.showMagicRange = function(self, general, magicConfig)
    self:hideAllView()

    self.magicRangeLayer = MagicRangeLayer.new(general, magicConfig)
    self.magicRangeLayer:addTo(self.bg, MapViewConst.ZORDER_MAGIC_LAYER)
end

MapView.hideMagicRange = function(self)
    if self.magicRangeLayer then
        self.magicRangeLayer:removeSelf()
        self.magicRangeLayer = nil
    end
end

MapView.generalMove = function(self, general, toRow, toCol)
    local fromRow = general:getRow()
    local fromCol = general:getCol()
    printInfo("武将:%s, 将要从(%d, %d)移动到(%d, %d)", general:getName(), fromRow, fromCol, toRow, toCol)

    -- 移动时，隐藏所有选中框，这里其实省了很多事，可以避免处理moveBox显示层级高于武将的问题
    self:hideAllView()

    self.movePath = SearchPathUtils.getAPath(self.mapBlock, fromRow, fromCol, toRow, toCol)
    general:move(self.movePath, function()
        printInfo("显示战斗菜单")
        self:showGeneralMenu(general)
    end)
end

MapView.generalAiMove = function(self, general, toRow, toCol, callback)
    local fromRow = general:getRow()
    local fromCol = general:getCol()
    printInfo("武将:%s, 将要从(%d, %d)移动到(%d, %d)", general:getName(), fromRow, fromCol, toRow, toCol)

    if fromRow == toRow and fromCol == toCol then
        callback()
        return
    end

    -- Ai时显示 moveRange 0.4秒再进行移动
    local mapBlock = self:showGeneralMoveRange(general)
    self:performWithDelay(function()
        self:hideAllView()

        self.movePath = SearchPathUtils.getAPath(mapBlock, fromRow, fromCol, toRow, toCol)
        general:move(self.movePath, function()
            self.movePath = nil
            callback()
        end)
    end, LONG_ANIMATION_TIME)
end

MapView.initGeneralTileView = function(self)
    local generalTileView = GeneralTileView.new()
    generalTileView:hide()
    generalTileView:addTo(self.bg, MapViewConst.ZORDER_GENERAL_TILE_VIEW)

    self.generalTileView = generalTileView
end

MapView.showGeneralTileView = function(self, general, row, col, isLeft, isBottom)
    self:hideAllView()

    printInfo("%s显示其所在地形的相关信息", general:getName())

    self:showSelectBox(general:getPosition())

    local tileRow = isBottom and row or (row + 1)
    local tileCol = isLeft and (col + 1) or (col - 4)

    self.generalTileView:initFromGeneral(general)
    self.generalTileView:pos(MapUtils.getPosByRowAndCol(tileRow, tileCol))
    self.generalTileView:show()
end

MapView.hideGeneralTileView = function(self)
    self.generalTileView:hide()
end

MapView.initAttackPreviewView = function(self)
    local attackPreviewView = AttackPreviewView.new()
    attackPreviewView:hide()
    attackPreviewView:addTo(self.bg, MapViewConst.ZORDER_ATTACK_PREVIEW_VIEW)

    self.attackPreviewView = attackPreviewView
end

MapView.showAttackPreviewView = function(self, general, target)
    -- 出现武将战斗菜单时显示选中框
    local targetPos = {target:getPosition()}
    self:showSelectBox(targetPos[1], targetPos[2])

    local row, col = target:getRow(), target:getCol()
    local isLeft, isBottom = MapUtils.getMapAreaByMapPos(targetPos[1], targetPos[2], self.bg)
    local tileRow = isBottom and row or (row + 1)
    local tileCol = isLeft and (col + 1) or (col - 4)

    self.attackPreviewView:initFromGeneral(general, target)
    self.attackPreviewView:pos(MapUtils.getPosByRowAndCol(tileRow, tileCol))
    self.attackPreviewView:show()
end

MapView.hideAttackPreviewView = function(self)
    -- 如果攻击预览窗口显示，隐藏时，还需要隐藏选中框
    if self.attackPreviewView:isVisible() then
        self:hideSelectBox()
        self.attackPreviewView:hide()
    end
end

MapView.initMagicPreviewView = function(self)
    local magicPreviewView = MagicPreviewView.new()
    magicPreviewView:hide()
    magicPreviewView:addTo(self.bg, MapViewConst.ZORDER_MAGIC_PREVIEW_VIEW)

    self.magicPreviewView = magicPreviewView
end

MapView.showMagicPreviewView = function(self, general, target, magicConfig)
    -- 出现武将战斗菜单时显示选中框
    local targetPos = {target:getPosition()}
    self:showSelectBox(targetPos[1], targetPos[2])

    local row, col = target:getRow(), target:getCol()
    local isLeft, isBottom = MapUtils.getMapAreaByMapPos(targetPos[1], targetPos[2], self.bg)
    local tileRow = isBottom and row or (row + 1)
    local tileCol = isLeft and (col + 1) or (col - 4)

    self.magicPreviewView:initFromGeneral(general, target, magicConfig)
    self.magicPreviewView:pos(MapUtils.getPosByRowAndCol(tileRow, tileCol))
    self.magicPreviewView:show()
end

MapView.hideMagicPreviewView = function(self)
    if self.magicPreviewView:isVisible() then
        self:hideSelectBox()
        self.magicPreviewView:hide()
    end
end

MapView.initSmallView = function(self)
    local smallView = SmallView.new()
    smallView:align(display.LEFT_TOP, display.width, display.height)
    smallView:addTo(self)
    smallView:initWithGeneralList(MapUtils.getAllPlayersGeneral(true), MapUtils.getAllFriendsGeneral(true), MapUtils.getAllEnemiesGeneral(true))
    smallView:hide()
    self.smallView = smallView
end

MapView.showHurtView = function(self, hurters, attacker, isHurt, finalCallback)
    if not isHurt then
        -- 进攻结算
        if attacker.general:isPlayer() then
            self:showPlayerHurtView(1, hurters, attacker, isHurt, finalCallback)
        else
            self:showEnemyHurtView(1, hurters, attacker, isHurt, finalCallback)
        end
    elseif #hurters > 0 then
        if hurters[1].general:isPlayer() then
            self:showPlayerHurtView(1, hurters, attacker, isHurt, finalCallback)
        else
            self:showEnemyHurtView(1, hurters, attacker, isHurt, finalCallback)
        end
    elseif finalCallback then
        finalCallback()
    end
end

MapView.initEnemyHurtView = function(self)
    local enemyHurtView = GeneralHurtView.new()
    enemyHurtView:hide()
    enemyHurtView:addTo(self.bg, MapViewConst.ZORDER_HURT_VIEW)

    self.enemyHurtView = enemyHurtView
end

MapView.showEnemyHurtView = function(self, index, hurters, attacker, isHurt, finalCallback)
    if index <= #hurters or not isHurt then
        local general = isHurt and hurters[index].general or attacker.general
        local hpDamge = isHurt and hurters[index].hpDamge or attacker.hpDamge
        local mpDamge = isHurt and hurters[index].mpDamge or attacker.mpDamge
        local targetPos = {general:getPosition()}
        self:showSelectBox(targetPos[1], targetPos[2])

        self:moveToNode(general)

        local row, col = general:getRow(), general:getCol()
        local isLeft, isBottom = MapUtils.getMapAreaByMapPos(targetPos[1], targetPos[2], self.bg)
        local tileRow = isBottom and row or (row + 1)
        local tileCol = isLeft and (col + 1) or (col - 4)

        self.enemyHurtView:initFromGeneral(general, hpDamge, mpDamge, function()
            if isHurt then
                if hurters[index + 1] and hurters[index + 1].general:isPlayer() then
                    self:showPlayerHurtView(index + 1, hurters, attacker, isHurt, finalCallback)
                else
                    self:showEnemyHurtView(index + 1, hurters, attacker, isHurt, finalCallback)
                end
            elseif finalCallback then
                finalCallback()
            end
        end)
        self.enemyHurtView:pos(MapUtils.getPosByRowAndCol(tileRow, tileCol))
        self.enemyHurtView:show()
    elseif finalCallback then
        finalCallback()
    end
end

MapView.hideEnemyHurtView = function(self)
    self.enemyHurtView:hide()
end

MapView.initPlayerHurtView = function(self)
    local playerHurtView = PlayerHurtView.new()
    playerHurtView:hide()
    playerHurtView:addTo(self.bg, MapViewConst.ZORDER_HURT_VIEW)

    self.playerHurtView = playerHurtView
end

-- isHurt为true，表明玩家是hurters，属于受伤结算，仅需要结算防具exp，hp和mp
-- isHurt为false，表明玩家是attacker，属于进攻结算，需要结算武器exp，武将exp，hp和mp
MapView.showPlayerHurtView = function(self, index, hurters, attacker, isHurt, finalCallback)
    if index <= #hurters or not isHurt then
        local general   = isHurt and hurters[index].general or attacker.general
        local hpDamge   = isHurt and hurters[index].hpDamge or attacker.hpDamge
        local mpDamge   = isHurt and hurters[index].mpDamge or attacker.mpDamge
        local exp       = isHurt and 0 or attacker.exp
        local wuqiExp   = isHurt and 0 or attacker.wuqiExp
        local fangjuExp = isHurt and hurters[index].fangjuExp or (attacker.fangjuExp or 0)

        local targetPos = {general:getPosition()}
        self:showSelectBox(targetPos[1], targetPos[2])

        self:moveToNode(general)

        local row, col = general:getRow(), general:getCol()
        local isLeft, isBottom = MapUtils.getMapAreaByMapPos(targetPos[1], targetPos[2], self.bg)
        local tileRow = isBottom and row or (row + 2)
        local tileCol = isLeft and (col + 1) or (col - 4)

        self.playerHurtView:initFromGeneral(general, hpDamge, mpDamge, exp, wuqiExp, fangjuExp, function()
            if isHurt then
                if hurters[index + 1] and hurters[index + 1].general:isPlayer() then
                    self:showPlayerHurtView(index + 1, hurters, attacker, isHurt, finalCallback)
                else
                    self:showEnemyHurtView(index + 1, hurters, attacker, isHurt, finalCallback)
                end
            elseif finalCallback then
                finalCallback()
            end
        end)
        self.playerHurtView:pos(MapUtils.getPosByRowAndCol(tileRow, tileCol))
        self.playerHurtView:show()
    elseif finalCallback then
        finalCallback()
    end
end

MapView.hidePlayerHurtView = function(self)
    self.playerHurtView:hide()
end

MapView.hideAllView = function(self)
    self:hideSelectBox()
    self:hideTileView()
    self:hideGeneralMenu()
    self:hideGeneralMoveRange()
    self:hideAttackRange()
    self:hideMagicRange()
    self:hideItemRange()
    self:hideAttackPreviewView()
    self:hideMagicPreviewView()
    self:hideGeneralTileView()
    self:hideMagicMenu()
    self:hideItemMenu()
end

MapView.clearTouchGeneral = function(self)
    MapUtils.setCurrentGeneral(nil)
    self.movePath = nil
    self.mapBlock = nil
end

-- 武将行动结束，如果我方无可行动武将，自动弹出回合提示框
MapView.generalActionDone = function(self, general)
    if GameData.getCurSide() == "我军阶段" then
        local hasCanActionGeneral = table.findIf(MapUtils.getAllPlayersGeneral(), function(g)
            return g:isVisible() and g:isAlive() and g:canDoAction()
        end)

        if not hasCanActionGeneral then
            printInfo("无可行动武将，自动弹出回合结束框")
            self:onDoubleClick()
        end
    end
end

-- 战斗菜单－待命，武将变暗，且设置自己不可单击，依旧接受双击和长按处理
MapView.generalMenuStop = function(self, general)
    self:hideAllView()
    self.movePath = nil
    self.mapBlock = nil

    general:makeActionDone()
end

-- 战斗菜单－取消，这里武将直接返回原来地方
MapView.generalMenuCancel = function(self, general)
    self:hideAllView()

    if not self.movePath then
        MapUtils.setCurrentGeneral(nil)
        return
    end

    local movePath = {}
    for i = #self.movePath, 1, -1 do
        table.insert(movePath, self.movePath[i])
    end
    general:move(movePath, function()
        -- 隐藏所有界面，设置点击武将为nil，设置movePath为nil，一切还原
        self:hideAllView()
        MapUtils.setCurrentGeneral(nil)
        self.movePath = nil

        -- 还原以后，恢复站立姿态
        general:stand()
    end)
end

-- 战斗菜单－取消，这里武将直接返回原来地方，不过这里没有移动动画而已
MapView.generalMenuCancelNoAnimation = function(self, general)
    self:hideAllView()

    general:moveCancel()

    if self.movePath then
        self.movePath = nil
    end

    MapUtils.setCurrentGeneral(nil)
end

-- isSort为true表示返回的targets按行列坐标由小到大排序
MapView.getGeneralsByRange = function(self, sides, col1, row1, col2, row2, isSort)
    local targets = {}
    table.walk(MapUtils.getGeneralsBySide(sides), function(target)
        if target:isVisible() and target:isAlive() and math.isInRange(target:getCol(), col1, col2) and math.isInRange(target:getRow(), row1, row2) then
            table.insert(targets, target)
        end
    end)

    if isSort then
        table.sort(targets, function(l, r)
            local lIndex = l:getRow() * MapUtils.cols + l:getCol()
            local rIndex = r:getRow() * MapUtils.cols + r:getCol()
            return lIndex < rIndex
        end)
    end

    return targets
end

-- 高亮地图块
MapView.highlightRange = function(self, col1, row1, col2, row2, callback)
    local middleCol = math.floor((col1 + col2) / 2)
    local middleRow = math.floor((row1 + row2) / 2)
    self:moveToPos(middleCol, middleRow)

    local boxes = {}
    for col = col1, col2 do
        for row = row1, row2 do
            local target = MapUtils.getGeneralByRowAndCol(row, col)
            if target then
                box = target:addColorBox(LightBlueColor)
            else
                local x, y = MapUtils.getPosByRowAndCol(row, col)
                box = display.newRect(MapViewConst.TILE_RECT, {fillColor = LightBlueColor, borderWidth = 0})
                box:align(display.LEFT_BOTTOM, x, y)
                box:addTo(self.bg, MapViewConst.ZORDER_OBSTACLE)
            end

            box:runAction(cca.blink(LONG_ANIMATION_TIME, 5))
            table.insert(boxes, box)
        end
    end

    self:performWithDelay(function()
        table.walk(boxes, function(box)
            box:removeSelf()
        end)
        callback()
    end, LONG_ANIMATION_TIME)
end

MapView.highlightGeneral = function(self, uid, callback)
    local target = MapUtils.getGeneralById(uid)
    if target then
        local row, col = target:getRow(), target:getCol()
        self:highlightRange(col, row, col, row, callback)
    else
        callback()
    end
end

-- 聊天对话，这里会计算target的位置，决定对话和头像出现的地方
MapView.chatDialog = function(self, target, content, callback)
    self:moveToNode(target)

    local targetPos        = {target:getPosition()}
    local isLeft, isBottom = MapUtils.getMapAreaByMapPos(targetPos[1], targetPos[2], self.bg)
    local chatRow, chatCol = isBottom and (target:getRow() - 1) or (target:getRow() + 2), target:getCol() + 1
    local pos              = cc.p(MapUtils.getTouchPosByRowAndCol(chatRow, chatCol, self.bg))

    ChatDialogUtils.showSPlotDialog(target, isLeft, content, callback, pos)
end

MapView.plotShowDialog = function(self, uid, content, callback)
    local target = MapUtils.getGeneralById(uid, true)
    if target then
        self:chatDialog(target, content, callback)
    else
        TipUtils.showTip(string.format("%s:%s", uid, content), nil, callback)
    end
end

MapView.plotGeneralAction = function(self, uid, action, dir, callback)
    local target = MapUtils.getGeneralById(uid)
    if target then
        target:showAnimation(action, dir, callback)
    else
        callback()
    end
end

MapView.plotShowGeneralAttack = function(self, side, scriptIndex, targetSide, targetScriptIndex, dir, callback)
    local attacker = MapUtils.getGeneralByScriptIndex(side, scriptIndex)
    local hurter = MapUtils.getGeneralByScriptIndex(targetSide, targetScriptIndex)
    attacker:showPlotAttack(hurter, dir, callback)
end

MapView.plotShowGeneral = function(self, uid, callback)
    local target
    if type(uid) == "string" then
        target = MapUtils.getGeneralById(uid)
    else
        target = MapUtils.getGeneralByScriptIndex(uid)
    end

    if target then
        self:moveToNode(target)
        self:performWithDelay(function()
            EventMgr.triggerEvent(EventConst.GENERAL_SMALLMAP_SHOW, target, true) -- 通知小地图绘制
            target:setHide(false)
            callback()
        end, SHORT_ANIMATION_TIME)
    else
        callback()
    end
end

MapView.plotShowGeneralMove = function(self, uid, dir, toCol, toRow, callback)
    local target
    if type(uid) == "string" then
        target = MapUtils.getGeneralById(uid)
    else
        target = MapUtils.getGeneralByScriptIndex(uid)
    end

    if target and (target:getRow() ~= toRow or target:getCol() ~= toCol) then
        local blockMap = MapUtils.getMapBlocksByGeneral(target)
        local movePath = SearchPathUtils.getAiAPath(blockMap, target:getRow(), target:getCol(), toRow, toCol, true)
        target:move(movePath, function()
            self:plotGeneralAction(uid, "stand", dir, callback)
        end, true)
    else
        callback()
    end
end

MapView.plotShowGeneralActionDone = function(self, side, scriptIndex, callback)
    local target = MapUtils.getGeneralByScriptIndex(side, scriptIndex)
    target:makeActionDone(callback)
end

MapView.plotSkipPlayerTurn = function(self, curRound, callback)
    TurnLayer.new(curRound)
end

MapView.plotAddFire = function(self, col, row, callback)
    local fire = Fire.new()
    fire:align(display.LEFT_BOTTOM, MapUtils.getPosByRowAndCol(row, col))
    fire:addTo(self.bg, MapViewConst.ZORDER_FIRE)

    MapUtils.changeTileType(row, col, "火")

    self:moveToNode(fire)
    self:performWithDelay(callback, SHORT_ANIMATION_TIME)

    self.fires = self.fires or {}
    table.insert(self.fires, {row = row, col = col})
end

MapView.plotShowSpecialAnimation = function(self, animation, fromCol, fromRow, toCol, toRow, callback)
    -- 目前仅处理朱雀的特殊动画
    local specialAnimationConfig = {res = "Mcall05", action = "Mcall05", startIndex = 1, frameLen = 30}
    local tempZOrder = 100
    local fromX, fromY = MapUtils.getPosByRowAndCol(fromRow, fromCol)
    local toX, toY = MapUtils.getPosByRowAndCol(toRow, toCol)
    self:moveToPos(math.floor((fromCol + toCol) / 2), math.floor((fromRow + toRow) / 2))

    local spAnimation = Magic.new(specialAnimationConfig, callback)
    spAnimation:pos(fromX, fromY)
    spAnimation:addTo(self.bg, tempZOrder)
    spAnimation:moveTo(0.2, toX, toY)
end

MapView.plotAddStatus = function(self, statusId, targets, callback)
    if targets == "allEnemies" then
        targets = MapUtils.getAllEnemiesGeneral()
        -- 目标排序，行列号从低到高排
        table.sort(targets, function(l, r)
            local lIndex = l:getRow() * MapUtils.cols + l:getCol()
            local rIndex = r:getRow() * MapUtils.cols + r:getCol()
            return lIndex < rIndex
        end)
    end

    table.oneByOne(targets, function(target, nextCallback)
        target:addStatus(statusId, nextCallback)
    end, callback)
end

MapView.plotAddItem = function(self, itemId, itemLevel, callback)
    GameData.addItem(itemId)

    local target = MapUtils.getCurrentGeneral() or MapUtils.getGeneralByScriptIndex(1)
    local itemConfig = InfoUtil.getItemConfig(itemId)
    TipUtils2.showTip(string.format("获得了\"%s\"", itemConfig.name), display.COLOR_GREEN)

    local itemIcon = display.newSprite(InfoUtil.getItemPath(itemConfig.icon, itemConfig.type))
    itemIcon:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, MapConst.BLOCK_HEIGHT / 2)
    itemIcon:addTo(target, 100)

    itemIcon:runAction(cca.seq({cca.scaleTo(LONG_ANIMATION_TIME, 1.2), cca.cb(function()
        itemIcon:removeSelf()
    end)}))

    callback()
end

MapView.plotFaceToFace = function(self, uid1, uid2, callback)
    local target1 = MapUtils.getGeneralById(uid1)
    local target2 = MapUtils.getGeneralById(uid2)
    local dir1 = MapUtils.calcDirection(target1:getRow(), target1:getCol(), target2:getRow(), target2:getCol())
    local dir2 = MapUtils.getOppositeDir(dir1)

    assert(dir1 and dir2, "有问题，面对面的两个武将一定是可以存在的")
    target1:stand(dir1)
    target2:stand(dir2)
    callback()
end

-- 武将ai变更 武将id ai类型 ai指定攻击目标 ai指定位置(列 行)
MapView.plotChangeAI = function(self, uid, aiType, fixTargetId, fixCol, fixRow, callback)
    local target = MapUtils.getGeneralById(uid)
    if target then
        local aiArgs = {target = MapUtils.getGeneralById(fixTargetId), fixRow = fixRow, fixCol = fixCol}
        target:setAiType(aiType, aiArgs)
    end
    callback()
end

-- 范围内武将ai改变 阵营 范围 ai类型 ai额外参数
MapView.plotRangeChangeAI = function(self, sides, col1, row1, col2, row2, aiType, fixTargetId, fixCol, fixRow, callback)
    local aiArgs = {target = MapUtils.getGeneralById(fixTargetId), fixRow = fixRow, fixCol = fixCol}
    local targets = MapUtils.getRangeGeneralsBySide(col1, row1, col2, row2, sides)
    table.oneByOne(targets, function(target, nextCallback)
        target:setAiType(aiType, aiArgs)
        nextCallback()
    end, callback)
end

-- 要改变的数值 如何改变 异常状态 HP减少量 MP减少量
MapView.plotGeneralStatusChange = function(self, uid, changeProp, changeWay, status, hpSub, mpSub, callback)
    local target
    if type(uid) == "string" then
        target = MapUtils.getDieGeneralById(uid)
    else
        target = MapUtils.getDieGeneralByScriptIndex(uid)
    end

    if target then
        if mpSub ~= 0 then
            target:subMp(mpSub)
        end

        if hpSub ~= 0 then
            target:subHp(hpSub)
            target:stand()
        end

        local statusCallback = function()
            if statusId ~= "无" then
                target:addStatus(statusId, nextCallback)
            else
                nextCallback()
            end
        end

        if changeProp ~= "无" then
            printInfo("%s添加状态：%s", target:getName(), changeProp .. changeWay)
            target:addStatus(changeProp .. changeWay, statusCallback)
        else
            statusCallback()
        end
    else
        callback()
    end
end

MapView.plotRangeChangeStatus = function(self, sides, col1, row1, col2, row2, changeProp, changeWay, statusId, hpSub, mpSub, callback)
    local targets = self:getGeneralsByRange(sides, col1, row1, col2, row2, true)
    table.oneByOne(targets, function(target, nextCallback)
        if mpSub ~= 0 then
            target:subMp(mpSub)
        end

        if hpSub ~= 0 then
            target:subHp(hpSub)
            target:stand()
        end

        local statusCallback = function()
            if statusId ~= "无" then
                target:addStatus(statusId, nextCallback)
            else
                nextCallback()
            end
        end

        if changeProp ~= "无" then
            printInfo("%s添加状态：%s", target:getName(), changeProp .. changeWay)
            target:addStatus(changeProp .. changeWay, statusCallback)
        else
            statusCallback()
        end
    end, callback)
end

MapView.plotGeneralRetreat = function(self, uid, isDead, callback)
    local target = MapUtils.getGeneralById(uid, true)
    if target then
        target:showAnimation(isDead and "dieForever" or "die", nil, callback)
    else
        callback()
    end
end

MapView.plotRangeRetreat = function(self, sides, col1, row1, col2, row2, isDead, callback)
    local targets = self:getGeneralsByRange(sides, col1, row1, col2, row2, true)
    table.oneByOne(targets, function(target, nextCallback)
        if isDead then
            target:showAnimation("die", nil, nextCallback)
        else
            target:retreat(nextCallback)
        end
    end, callback)
end

MapView.plotAllGeneralsRecover = function(self, callback)
    table.walk(MapUtils.getAllGenerals(), function(target)
        target:subHp(-100000)
        target:stand()
    end)

    self:refreshAllGenerals()
    self:performWithDelay(callback, 0.3)
end

MapView.plotGeneralDisappear = function(self, uid, callback)
    local target = MapUtils.getGeneralById(uid)
    if target then
        target:retreat(callback)
    else
        callback()
    end
end

MapView.plotGeneralsDisappear = function(self, sides, col1, row1, col2, row2, callback)
    local targets = MapUtils.getRangeGeneralsBySide(col1, row1, col2, row2, sides)
    table.oneByOne(targets, function(target, nextCallback)
        target:retreat(nextCallback)
    end, callback)
end

MapView.plotGeneralInitEquip = function(self, uid, wuqiId, wuqiLevel, fangjuId, fangjuLevel, shipingId, callback)
    local target = MapUtils.getGeneralById(uid)
    if target then
        target:initEquips(wuqiId, wuqiLevel, 0, fangjuId, fangjuLevel, 0, shipingId)
    end

    callback()
end

MapView.plotGeneralAddLevel = function(self, uid, levels, callback)
    local target = MapUtils.getGeneralById(uid)
    if target then
        target:levelUp(levels, nil, false)
    end

    callback()
end

MapView.plotShowChoices = function(self, uid, choices, callback)
    local target = MapUtils.getGeneralById(uid)
    assert(target, "目标不存在，无法进行选择框" .. uid)
    ChatDialogUtils.showChoiceDialog(target:getHeadIcon(), target:getName(), nil, choices, nil, nil, callback)
end

MapView.plotPlayerInit = function(self, uid, col, row, dir, isHide, callback)
    local target = MapUtils.getGeneralByScriptIndex(uid)
    if target then
        target:setRowAndCol(row, col)
        target:stand(dir)
        target:setHide(isHide)
    end

    callback()
end

MapView.plotShowPlayerRetreatWords = function(self, uid, isShowWords, callback)
    local target = MapUtils.getGeneralById(uid)
    if target then
        target:setShowRetreatWords(isShowWords)
    end

    callback()
end

MapView.plotGeneralReborn = function(self, uid, col, row, dir, callback)
    local target
    if type(uid) == "string" then
        target = MapUtils.getDieGeneralById(uid)
    else
        target = MapUtils.getDieGeneralByScriptIndex(uid)
    end

    if target then
        target:setRowAndCol(row, col)
        target:reborn(dir, callback)
    else
        callback()
    end
end

MapView.plotAddObstacle = function(self, obstacleName, isAdd, tileType, col, row, isDelay, callback)
    self.obstacles = self.obstacles or {}
    if isAdd then
        local obstacle = Obstacle.new(obstacleName)
        obstacle:align(display.LEFT_BOTTOM, MapUtils.getPosByRowAndCol(row, col))
        obstacle:addTo(self.bg, MapViewConst.ZORDER_OBSTACLE)

        table.insert(self.obstacles, {obstacle, row, col})

        MapUtils.changeTileType(row, col, obstacle:getType())

        if isDelay then
            self:moveToNode(obstacle)
            self:performWithDelay(callback, SHORT_ANIMATION_TIME)
        else
            callback()
        end
    else
        for i, obstacle in pairs(self.obstacles) do
            if obstacle[1]:getName() == obstacleName and obstacle[2] == row and obstacle[3] == col then
                self.obstacles[i] = nil

                self:moveToNode(obstacle[1])
                obstacle[1]:runAction(cca.blink(MIDDLE_ANIMATION_TIME, 5))
                self:performWithDelay(function()
                    obstacle[1]:removeSelf()
                    callback()
                end, MIDDLE_ANIMATION_TIME)

                break
            end
        end
    end
end

MapView.pkShowView = function(self, callback)
    PkView.new(callback)
end

MapView.battleStartPlotDone = function(self)
    -- 开场剧情结束，才弹出小地图
    self.smallView:showEffect()

    if self.hasLoadExtraData then
        return
    end

    -- 移动到我方第一个非隐藏武将处
    local firstPlayer = MapUtils.getFirstVisiblePlayer()
    if firstPlayer then
        self:moveToNode(MapUtils.getFirstVisiblePlayer())
    end
end

--[[
    地图的position
    火信息
    战场障碍物信息
--]]
MapView.getSaveData = function(self)
    local saveData = {}
    printInfo("保存地图信息，viewPosition:%d, %d", self.touchNode:getPosition())
    saveData.viewPosition = cc.p(self.touchNode:getPosition())

    printInfo("保存地图火信息")
    saveData.fires = self.fires or {}

    printInfo("保存地图障碍物信")
    saveData.obstacles = {}
    if self.obstacles then
        table.walk(self.obstacles, function(obstacleInfo)
            local obstacle, row, col = obstacleInfo[1], obstacleInfo[2], obstacleInfo[3]
            table.insert(saveData.obstacles, {name = obstacle:getName(), row = row, col = col})
        end)
    end

    return saveData
end

-- 用于读档时初始化getSaveData中的信息
MapView.initExtraData = function(self, extraData)
    if table.nums(extraData) == 0 then
        printInfo("无额外数据需要设置")
        self:addNonTouchLayer("MapView初始化，添加遮罩")
        return
    end

    printInfo("设置地图额外信息，ViewPosition:%d, %d", extraData.viewPosition.x, extraData.viewPosition.y)
    self.touchNode:pos(extraData.viewPosition.x, extraData.viewPosition.y)

    table.walk(extraData.fires, function(fireInfo)
        printInfo("设置地图额外信息，火:%d, %d", fireInfo.row, fireInfo.col)
        local fire = Fire.new()
        fire:align(display.LEFT_BOTTOM, MapUtils.getPosByRowAndCol(fireInfo.row, fireInfo.col))
        fire:addTo(self.bg, MapViewConst.ZORDER_FIRE)
        MapUtils.changeTileType(fireInfo.row, fireInfo.col, "火")
    end)
    self.fires = extraData.fires

    self.obstacles = {}
    table.walk(extraData.obstacles, function(obstacleInfo)
        printInfo("设置地图额外信息，障碍物:%s, %d, %d", obstacleInfo.name, obstacleInfo.row, obstacleInfo.col)
        local obstacle = Obstacle.new(obstacleInfo.name)
        obstacle:align(display.LEFT_BOTTOM, MapUtils.getPosByRowAndCol(obstacleInfo.row, obstacleInfo.col))
        obstacle:addTo(self.bg, MapViewConst.ZORDER_OBSTACLE)
        MapUtils.changeTileType(obstacleInfo.row, obstacleInfo.col, obstacle:getType())

        table.insert(self.obstacles, {obstacle, obstacleInfo.row, obstacleInfo.col})
    end)

    self.hasLoadExtraData = true
end

MapView.plotOver = function(self)
    self:hideAllView()
    self.touchNode:setTouchEnabled(false)
    self.smallView:hideEffect()
end

return MapView