--[[
    地图辅助类
        地图从左上角开始计算，即左上角为(1, 1)
--]]
local CURRENT_MODULE_NAME = ...

local MapUtils = {}

MapUtils.initLevel = function(mapId)
    local tiledMap       = ccexp.TMXTiledMap:create("ccz/tmx/" .. mapId)
    MapUtils.rows        = tiledMap:getMapSize().height
    MapUtils.cols        = tiledMap:getMapSize().width
    MapUtils.blockWidth  = tiledMap:getTileSize().width
    MapUtils.blockHeight = tiledMap:getTileSize().height
    MapUtils.mapWidth    = MapUtils.cols * MapUtils.blockWidth
    MapUtils.mapHeight   = MapUtils.rows * MapUtils.blockHeight
    MapUtils.smallRes    = "ccz/tmx/" .. tiledMap:getProperty("SmallMap")
    MapUtils.bigRes      = "ccz/tmx/" .. mapId

    MapUtils.data = {}
    table.walk(MapTileInfo, function(tileInfo)
        local layer = tiledMap:getLayer(tileInfo.name)
        if not layer then
            return
        end

        local layerSize = layer:getLayerSize()
        for row = 0, layerSize.height - 1 do
            for col = 0, layerSize.width - 1 do
                if layer:getTileAt(cc.p(col, row)) then
                    MapUtils.data[row * layerSize.width + col + 1] = tileInfo.name
                end
            end
        end
    end)

    MapUtils.mapBeginPoses = {enemyAIBegin = {}, friendAIBegin = {}, playerBegin = {}}
    table.walk(tiledMap:getObjectGroups(), function(group)
        local mapPoses = MapUtils.mapBeginPoses[group:getGroupName()]
        if mapPoses then
            for i, pos in ipairs(group:getObjects()) do
                local row = (MapUtils.mapHeight - pos.y) / pos.height
                local col = pos.x / pos.width + 1
                mapPoses[tonumber(pos.name) + 1] = {row = row, col = col, dir = pos.orientation}
            end
        end
    end)

    printInfo("清理一些缓存变量，消除读档时的影响")
    MapUtils.currentGeneral = nil
    MapUtils.generalMap = nil

end

-- 大地图资源
MapUtils.getBackgroundRes = function()
    return MapUtils.bigRes
end

-- 小地图资源
MapUtils.getBackgroundSmallRes = function()
    return MapUtils.smallRes
end

MapUtils.getRows = function()
    return MapUtils.rows
end

MapUtils.getCols = function()
    return MapUtils.cols
end

MapUtils.getMapWidth = function()
    return MapUtils.mapWidth or display.width
end

MapUtils.getMapHeight = function()
    return MapUtils.mapHeight or display.height
end

-- 传入一个行列值，获取该方块的左下角坐标
MapUtils.getPosByRowAndCol = function(row, col)
    return (col - 1) * MapUtils.blockWidth, (MapUtils.rows - row) * MapUtils.blockHeight
end

-- 传入一个坐标点，获取该点所在的方块的行列
MapUtils.getRowAndColByPos = function(x, y)
    local row = math.floor(y / MapUtils.blockHeight) + 1
    local col = math.floor(x / MapUtils.blockWidth) + 1
    return row, col
end

-- 传入一个行列值，获取其对应的touch点
MapUtils.getTouchPosByRowAndCol = function(row, col, mapBg)
    local x, y = MapUtils.getPosByRowAndCol(row, col)
    return MapUtils.getTouchPosByMapPos(x, y, mapBg)
end

-- 传入一个touch的点，需要准换一下，才能成为地图点，才能直接被使用
MapUtils.getRowAndColByTouchPos = function(x, y, mapBg)
    -- 转换以后的坐标点，是以左下角为原点的，而游戏里面是以左上角为原点的，所以这里需要转换一下
    local p = mapBg:convertToNodeSpace(cc.p(x, y))
    p.y = MapUtils.getMapHeight() - p.y

    if DEBUG_MAP_VIEW_INFO then
        printInfo("点中的实际坐标：(%d, %d)", x, y)
        printInfo("转换后实际坐标：(%d, %d)", p.x, p.y)
    end

    return MapUtils.getRowAndColByPos(p.x, p.y)
end

-- 将地图点转换为对应屏幕的touch点
MapUtils.getTouchPosByMapPos = function(x, y, mapBg)
    local realPoint = mapBg:convertToWorldSpace(cc.p(x, y))
    if DEBUG_MAP_VIEW_INFO then
        printInfo("地图上的点是%f, %f, 实际的点是：%f, %f", x, y, realPoint.x, realPoint.y)
    end
    return realPoint.x, realPoint.y
end

-- 将touch点转为地图点
MapUtils.getMapPosByTouchPos = function(x, y, mapBg)
    local p = mapBg:convertToNodeSpace(cc.p(x, y))
    p.y = MapUtils.getMapHeight() - p.y
    return p.x, p.y
end

-- 传入一个地图点，获取该点位于屏幕上的那个区域
-- 目前就4个区域，左上，左下，右上，右下
-- 返回一对bool变量，isLeft和isBottom
MapUtils.getMapAreaByMapPos = function(x, y, mapBg)
    local touchX, touchY = MapUtils.getTouchPosByMapPos(x, y, mapBg)
    local isLeft = touchX < display.cx
    local isBottom = touchY < display.cy
    return isLeft, isBottom
end

-- 基本同上，不过这个判断比较简单，只需要touch点即可
MapUtils.getMapAreaByTouchPos = function(x, y)
    local isLeft = x < display.cx
    local isBottom = y < display.cy
    return isLeft, isBottom
end

-- 传入一个坐标点，获取该点所在的方块的左下角坐标
MapUtils.getPosByPos = function(x, y)
    local row, col = MapUtils.getRowAndColByPos(x, y)
    return MapUtils.getPosByRowAndCol(row, col)
end

-- 传入任意坐标点，获取该点方块的信息
MapUtils.getTileInfoByPos = function(x, y)
    local row, col = MapUtils.getRowAndColByPos(x, y)
    return MapUtils.getTileInfo(row, col)
end

-- 传入任意坐标点，获取该点方块的名字
MapUtils.getTileNameByPos = function(x, y)
    return MapUtils.getTileInfoByPos(x, y).name
end

-- 传入行列值，获取该方块的类型
MapUtils.getTileName = function(row, col)
    return MapUtils.data[(row - 1) * MapUtils.cols + col]
end

-- 设置指定方块的类型，并返回原方块类型
MapUtils.setTileType = function(row, col, tileType)
    local oldTileType = MapUtils.data[(row - 1) * MapUtils.cols + col]
    MapUtils.data[(row - 1) * MapUtils.cols + col] = tileType
    return oldTileType
end

-- 传入行列值，获取该方块的信息
MapUtils.getTileInfo = function(row, col)
    return MapTileInfo[MapUtils.getTileName(row, col)]
end

-- 传入行列值，获取该方块附加的站在方块上的额外贴图，无则返回""
MapUtils.getTileMark = function(row, col)
    local tileInfo = MapUtils.getTileInfo(row, col)
    return tileInfo.extraRes or ""
end

-- 传入行列值和背景图的当前坐标，来获取该方块在当前屏幕上真正的包围盒（左下角为锚点）
MapUtils.getRealTileBox = function(row, col, mapBg)
    local realPoint = mapBg:convertToWorldSpace(cc.p(MapUtils.getPosByRowAndCol(row, col)))
    return cc.rect(realPoint.x, realPoint.y, MapUtils.blockWidth, MapUtils.blockHeight)
end

-- 判断指定位置是否为恢复地形
MapUtils.isRecoverTile = function(row, col)
    return MapUtils.getTileInfo(row, col).isRecoverTile
end

-- 改变指定方块的类型
MapUtils.changeTileType = function(row, col, newTileType)
    local oldTileType = MapUtils.setTileType(row, col, newTileType)
    if oldTileType == newTileType then
        if DEBUG_MAP_VIEW_INFO then
            printInfo("相同方块(%d, %d)类型，不需要修改", row, col)
        end
    end
end

-- 添加指定方块处的武将
MapUtils.addGeneral = function(general)
    MapUtils.generalMap = MapUtils.generalMap or {}
    table.insert(MapUtils.generalMap, general)
end

-- 传入指定坐标，获取该处武将
MapUtils.getGeneralByRowAndCol = function(row, col)
    MapUtils.generalMap = MapUtils.generalMap or {}
    for _, general in ipairs(MapUtils.generalMap) do
        if general:isVisible() and general:isAlive() and general:getRow() == row and general:getCol() == col then
            return general
        end
    end
end

-- 判断指定脚本武将是否存活
MapUtils.isGeneralAlive = function(side, scriptIndex)
    for _, general in ipairs(MapUtils.generalMap) do
        if general:getSide() == side and general:getScriptIndex() == scriptIndex then
            return general:isAlive()
        end
    end
end

-- 传入阵营获取相对应的武将
MapUtils.getGeneralsBySide = function(sides)
    if not isTable(sides) then
        sides = {sides}
    end

    local targets = {}
    for _, general in ipairs(MapUtils.generalMap) do
        if general:isVisible() and general:isAlive() and table.indexof(sides, general:getSide()) then
            table.insert(targets, general)
        end
    end
    return targets
end

-- 判断友军是否存在
MapUtils.hasFriendsGenerals = function()
    for _, general in ipairs(MapUtils.generalMap) do
        if general:isFriend() and general:isVisible() then
            return true
        end
    end

    return false
end

-- 获取指定范围内的阵营武将
MapUtils.getRangeGeneralsBySide = function(col1, row1, col2, row2, sides)
    local targets = {}
    table.walk(MapUtils.generalMap, function(general)
        if general:isVisible() and general:isAlive() and table.indexof(sides, general:getSide()) then
            if math.isInRange(general:getCol(), col1, col2) and math.isInRange(general:getRow(), row1, row2) then
                table.insert(targets, general)
            end
        end
    end)

    return targets
end

-- 获取所有玩家武将 ignoreVisible为忽略visible属性，默认为false
MapUtils.getAllPlayersGeneral = function(ignoreVisible)
    local targets = {}
    table.walk(MapUtils.generalMap, function(general)
        if general:isPlayer() and (ignoreVisible or general:isVisible()) and general:isAlive() then
            table.insert(targets, general)
        end
    end)

    return targets
end

-- 获取所有友军武将 ignoreVisible为忽略visible属性，默认为false
MapUtils.getAllFriendsGeneral = function(ignoreVisible)
    local targets = {}
    table.walk(MapUtils.generalMap, function(general)
        if general:isFriend() and (ignoreVisible or general:isVisible()) and general:isAlive() then
            table.insert(targets, general)
        end
    end)

    return targets
end

-- 获取所有敌军武将 ignoreVisible为忽略visible属性，默认为false
MapUtils.getAllEnemiesGeneral = function(ignoreVisible)
    local targets = {}
    table.walk(MapUtils.generalMap, function(general)
        if general:isEnemy() and (ignoreVisible or general:isVisible()) and general:isAlive() then
            table.insert(targets, general)
        end
    end)

    return targets
end

-- 获取所有敌对敌人
MapUtils.getAllOppositeGenerals = function(general)
    local targets = {}
    if general:isPlayer() or general:isFriend() then
        table.walk(MapUtils.generalMap, function(general)
            if general:isEnemy() and general:isVisible() and general:isAlive() then
                table.insert(targets, general)
            end
        end)
    else
        table.walk(MapUtils.generalMap, function(general)
            if (general:isPlayer() or general:isFriend()) and general:isVisible() and general:isAlive() then
                table.insert(targets, general)
            end
        end)
    end

    return targets
end

-- 获取所有友军和自己的部队
MapUtils.getAllPlayerAndFriendGenerals = function(general)
    local targets = {}
    if general:isPlayer() or general:isFriend() then
        table.walk(MapUtils.generalMap, function(general)
            if (general:isPlayer() or general:isFriend()) and general:isVisible() and general:isAlive() then
                table.insert(targets, general)
            end
        end)
    else
        table.walk(MapUtils.generalMap, function(general)
            if general:isEnemy() and general:isVisible() and general:isAlive() then
                table.insert(targets, general)
            end
        end)
    end

    return targets
end

-- 获取所有武将，不分敌我
MapUtils.getAllGenerals = function()
    local targets = {}
    table.walk(MapUtils.generalMap, function(general)
        if general:isVisible() and general:isAlive() then
            table.insert(targets, general)
        end
    end)
    return targets
end

-- 根据scriptIndex获取玩家武将
MapUtils.getGeneralByScriptIndex = function(scriptIndex)
    for _, target in pairs(MapUtils.generalMap) do
        if target:isPlayer() and target:isAlive() and target:getScriptIndex() == scriptIndex then
            return target
        end
    end
end

-- 根据scriptIndex获取玩家阵亡武将
MapUtils.getDieGeneralByScriptIndex = function(scriptIndex)
    for _, target in pairs(MapUtils.generalMap) do
        if target:isPlayer() and target:isDie() and target:getScriptIndex() == scriptIndex then
            return target
        end
    end
end

-- ignoreDie默认为false，表示得到的武将为存活武将，为true表示不考虑武将死亡状态
MapUtils.getGeneralById = function(uid, ignoreDie)
    for _, target in pairs(MapUtils.generalMap) do
        if target:getId() == uid then
            if ignoreDie or target:isAlive() then
                return target
            end

            return
        end
    end
end

-- 获取第一个我方非隐藏武将
MapUtils.getFirstVisiblePlayer = function()
    for _, target in ipairs(MapUtils.generalMap) do
        if target:isPlayer() and target:isVisible() then
            return target
        end
    end
end

-- 通过id获取阵亡武将
MapUtils.getDieGeneralById = function(uid)
    for _, target in pairs(MapUtils.generalMap) do
        if target:getId() == uid then
            if target:isDie() then
                return target
            end

            return
        end
    end
end

-- 根据传入行列计算方向，这里方向为四方向，表示这一对行列中，必须有一个行或列是相等的
MapUtils.calcDirection = function(fromRow, fromCol, toRow, toCol, defaultDir)
    if fromRow == toRow and fromCol == toCol then
        return defaultDir
    end

    if fromRow == toRow then
        if fromCol > toCol then
            return "left"
        else
            return "right"
        end
    elseif fromCol == toCol then
        if fromRow > toRow then
            return "up"
        else
            return "down"
        end
    else
        if fromRow > toRow then
            return "up"
        elseif fromRow < toRow then
            return "down"
        elseif fromCol > toCol then
            return "left"
        else
            return "right"
        end
    end
end

-- 返回与传入方向相反的方向
MapUtils.getOppositeDir = function(dir)
    local oppsiteDirs = {
        ["left"]  = "right",
        ["right"] = "left",
        ["up"]    = "down",
        ["down"]  = "up",
    }
    return oppsiteDirs[dir]
end

-- 传入指定武将，获取其对应的地图阻挡信息(目前Ai中使用)
MapUtils.getMapBlocksByGeneral = function(general)
    local blockMap = {}
    for row = 1, MapUtils.getRows() do
        blockMap[row] = {}

        for col = 1, MapUtils.getCols() do
            blockMap[row][col] = {}

            local target = MapUtils.getGeneralByRowAndCol(row, col)
            if target and target:isOpponent(general) then
                blockMap[row][col].isBlock    = true
                blockMap[row][col].isNonBlock = false
                blockMap[row][col].cost       = LimitValueInfo.Max_Movement_Cost
            else
                local tileInfo                = MapUtils.getTileInfo(row, col)
                blockMap[row][col].isBlock    = tileInfo.isCannotMove and true or false
                blockMap[row][col].isNonBlock = not blockMap[row][col].isBlock
                blockMap[row][col].cost       = general:getTileMovementCost(tileInfo.name)
            end
        end
    end

    return blockMap
end

-- 获取地图上设置好的三方阵营的坐标点和朝向
MapUtils.getBeginPosBySideAndScriptIndex = function(side, scriptIndex)
    local SIDE_MAP = {
        player = "playerBegin",
        enemy  = "enemyAIBegin",
        friend = "friendAIBegin",
    }

    local pos = MapUtils.mapBeginPoses[SIDE_MAP[side]][scriptIndex]
    return pos.row, pos.col, pos.dir
end

-- 设置当前武将
MapUtils.setCurrentGeneral = function(general)
    MapUtils.currentGeneral = general
end

-- 获取当前武将
MapUtils.getCurrentGeneral = function()
    return MapUtils.currentGeneral
end

-- 判断该地形是否支持该策略
MapUtils.isSupportMagicTile = function(magicId, row, col)
    local magicConfig = InfoUtil.getMagicConfig(magicId)
    assert(magicConfig, "策略错误，不是有效的策略:" .. magicId)

    local limit = magicConfig.limit
    if limit and limit.tiles then
        for _, tile in ipairs(limit.tiles) do
            local tileInfo = MapUtils.getTileInfo(row, col)
            if not tileInfo[tile .. "Support"] then
                return false
            end
        end
    end

    return true
end

return MapUtils