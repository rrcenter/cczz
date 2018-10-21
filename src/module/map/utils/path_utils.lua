--[[
    移动范围的处理
--]]

local PathUtils = {}

PathUtils.init = function()
    PathUtils.path      = {} -- 记录玩家实际可走的方块
    PathUtils.enemyCost = {} -- 记录敌人占据的方格的代价值
    PathUtils.map       = {} -- 用来记录整个地图信息，其实这个会简单些，主要是为了移动时作为一个阻挡表来使用

    for row = 1, MapUtils.getRows() do
        PathUtils.map[row] = {}
        for col = 1, MapUtils.getCols() do
            -- 默认所有方块都是阻挡，只有人物可走的方块为非阻挡方块
            PathUtils.map[row][col] = {row = row, col = col, isBlock = true}
        end
    end
end

-- 将map调整称为0，1用于a*寻路计算
PathUtils.adjustMap = function()
    local newMap = {}
    for row = 1, MapUtils.getRows() do
        newMap[row] = {}
        for col = 1, MapUtils.getCols() do
            -- 默认所有方块都是阻挡，只有人物可走的方块为非阻挡方块
            newMap[row][col] = PathUtils.map[row][col].isBlock and 1 or 0
        end
    end

    return newMap
end

PathUtils.setPathAll = function(row, col, value)
    local index = string.format("%d-%d", row, col)
    local enemyCost = PathUtils.enemyCost[index]
    if enemyCost and enemyCost ~= "all" and enemyCost >= 200 then
        return
    end

    if value == -1 then
        PathUtils.enemyCost[index] = "all"
        return
    end

    PathUtils.enemyCost[index] = value
end

-- 返回的第一个参数表示武将的移动范围，第二个参数是根据当前地图生成的阻挡信息
PathUtils.makePath = function(general, playerList, friendList, enemyList)
    playerList = playerList or MapUtils.getAllPlayersGeneral()
    friendList = friendList or MapUtils.getAllFriendsGeneral()
    enemyList  = enemyList or MapUtils.getAllEnemiesGeneral()

    PathUtils.init()

    local setOpponentCost = function(target)
        if target:isVisible() then
            PathUtils.enemyCost[target:getRow() .. "-" .. target:getCol()] = 255

            -- 突击移动效果，敌人影响效果归一化
            local moveCost = general:isCanMoveIgnoreEnemy() and 1 or -1

            PathUtils.setPathAll(target:getRow() + 1, target:getCol(), moveCost)
            PathUtils.setPathAll(target:getRow() - 1, target:getCol(), moveCost)
            PathUtils.setPathAll(target:getRow(), target:getCol() + 1, moveCost)
            PathUtils.setPathAll(target:getRow(), target:getCol() - 1, moveCost)
        end
    end

    if general:isPlayer() or general:isFriend() then
        table.walk(enemyList, setOpponentCost)
    elseif general:isEnemy() then
        table.walk(friendList, setOpponentCost)
        table.walk(playerList, setOpponentCost)
    end

    local startPoint = PathUtils.map[general:getRow()][general:getCol()]
    startPoint.movement = general:getProp(GeneralDataConst.PROP_MOVEMENT) + 1 -- 获取行动力
    PathUtils.loopPath(startPoint, general)

    return PathUtils.path, PathUtils.adjustMap()
end

PathUtils.loopPath = function(point, general)
    if point.movement <= 0 then
        return
    end

    if not point.isChecked then
        table.insert(PathUtils.path, point)
        point.isChecked = true
        PathUtils.map[point.row][point.col].isBlock = false
    end

    local checkList = {}
    if point.row > 1 then
        table.insert(checkList, PathUtils.map[point.row - 1][point.col])
    end
    if point.col > 1 then
        table.insert(checkList, PathUtils.map[point.row][point.col - 1])
    end
    if point.row < MapUtils.getRows() then
        table.insert(checkList, PathUtils.map[point.row + 1][point.col])
    end
    if point.col < MapUtils.getCols() then
        table.insert(checkList, PathUtils.map[point.row][point.col + 1])
    end

    for _, v in ipairs(checkList) do
        if not v.movement then
            v.movement = 0
        end

        if not (v.isChecked and v.movement >= point.movement) then
            local tileName = MapUtils.getTileName(v.row, v.col)
            local cost     = general:getTileMovementCost(tileName) -- 获取指定地形的消耗行动力（针对兵种不一样，这个数值这里不同）
            local index    = string.format("%d-%d", v.row, v.col)
            if PathUtils.enemyCost[index] and PathUtils.enemyCost[index] ~= "all" then
                cost = cost + PathUtils.enemyCost[index]
            end

            v.movement = point.movement - cost
            if PathUtils.enemyCost[index] == "all" and v.movement > 1 then
                v.movement = 1
            end

            PathUtils.loopPath(v, general)
        end
    end
end

return PathUtils