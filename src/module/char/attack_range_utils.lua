--[[
    攻击类型工具类，这里各种攻击范围的计算
        未做优化处理，通过if条件的修改可以减少很多判断，暂不处理
--]]

local AttackTypeCircle = {}

-- 仅用于此类型中是否存在某个行列值
local tableContains = function(t, value)
    return table.findIf(t, function(v)
        return v.row == value.row and v.col == value.col
    end)
end

-- 仅用于此类型中删除某个特定值，一般就是自己啦
local tableRmove = function(t, row, col)
    for i, v in ipairs(t) do
        if v.row == row and v.col == col then
            table.remove(t, i)
        end
    end

    return t
end

-- 仅用于此类型，在t1表中，过滤所有t2内容
local tableFilterTable = function(t1, t2)
    local result = {}
    for _, v1 in ipairs(t1) do
        if not tableContains(t2, v1) then
            table.insert(result, {row = v1.row, col = v1.col})
        end
    end

    return result
end

-- 判断行是否在地图区域内
local checkRowValid = function(row)
    return 1 <= row and row <= MapUtils.getRows()
end

-- 判断列是否在地图区域内
local checkColValid = function(col)
    return 1 <= col and col <= MapUtils.getCols()
end

-- 判断行列是否均在地图区域内
local checkRowAndColValid = function(row, col)
    return checkRowValid(row) and checkColValid(col)
end

-- 获取自身单点范围，用于治疗自己或者是霸气等策略
local getSelfRange = function(row, col)
    return {row = row, col = col}
end

-- 获取全屏攻击范围
local getAllRange = function(row, col)
    local range = {}
    for r = 1, MapUtils.getRows() do
        for c = 1, MapUtils.getCols() do
            table.insert(range, {row = r, col = c})
        end
    end

    tableRmove(range, row, col)

    return range
end

-- 获取直线型范围，没有斜角的
local getLineRange = function(row, col, srcRow, srcCol, length)
    if length <= 0 then
        return {}
    end

    local range = {}
    for r = row - length, row + length do
        if checkRowValid(r) then
            table.insert(range, {row = r, col = col})
        end
    end

    for c = col - length, col + length do
        if checkColValid(c) then
            table.insert(range, {row = row, col = c})
        end
    end

    tableRmove(range, row, col)
    return range
end

-- 单直线攻击范围，需要提供一个原坐标来参考方向，好缺德直线
local getSingleLineRange = function(row, col, srcRow, srcCol, length)
    if length <= 0 then
        return {}
    end

    local rowOffset = 0
    if row > srcRow then
        rowOffset = 1
    elseif row < srcRow then
        rowOffset = -1
    end

    local colOffset = 0
    if col > srcCol then
        colOffset = 1
    elseif col < srcCol then
        colOffset = -1
    end

    if row == srcRow and col == srcCol then
        -- 如果目标就是自己，那么就默认向下
        rowOffset = 1
    end

    local range = {}
    for i = 1, length - 1 do
        if checkRowAndColValid(row + rowOffset * i, col + colOffset * i) then
            table.insert(range, {row = row + rowOffset * i, col = col + colOffset * i})
        end
    end

    return range
end

-- 获取间隔直线型，就是跳过自身与startLength之间的直线范围
local getIntervalLineRange = function(row, col, srcRow, srcCol, startLength, endLength)
    if startLength >= endLength then
        return {}
    end

    local startRange = getLineRange(row, col, srcRow, srcCol, startLength)
    local endRange = getLineRange(row, col, srcRow, srcCol, endLength)
    local range = tableFilterTable(endRange, startRange)
    return range
end

-- 获取正方形攻击范围
local getRectRange = function(row, col, srcRow, srcCol, length)
    local range = {}
    for r = row - length, row + length do
        for c = col - length, col + length do
            if checkRowAndColValid(r, c) then
                table.insert(range, {row = r, col = c})
            end
        end
    end

    tableRmove(range, row, col)
    return range
end

-- 获取一个圆形范围
local getCircleRange = function(row, col, srcRow, srcCol, radius)
    if radius <= 0 then
        return {}
    end

    local range = {}
    for r = row - radius, row + radius do
        for c = col - radius, col + radius do
            if checkRowAndColValid(r, c) then
                if (math.abs(r - row) + math.abs(c - col)) <= radius then
                    table.insert(range, {row = r, col = c})
                end
            end
        end
    end

    tableRmove(range, row, col)
    return range
end

-- 获取一个间隔圆形范围
local getIntervalCircleRange = function(row, col, srcRow, srcCol, startRadius, endRaius)
    if startRadius >= endRaius then
        return {}
    end

    local startRange = getCircleRange(row, col, srcRow, srcCol, startRadius)
    local endRange = getCircleRange(row, col, srcRow, srcCol, endRaius)
    local range = tableFilterTable(endRange, startRange)
    return range
end

local AttackRangeUtils = {}

-- 函数映射
AttackRangeUtils.self           = getSelfRange
AttackRangeUtils.all            = getAllRange
AttackRangeUtils.line           = getLineRange
AttackRangeUtils.intervalLine   = getIntervalLineRange
AttackRangeUtils.rect           = getRectRange
AttackRangeUtils.circle         = getCircleRange
AttackRangeUtils.intervalCircle = getIntervalCircleRange
AttackRangeUtils.singleLine     = getSingleLineRange

-- args目前最多2个参数
-- row和col为指定目标坐标，srcRow和srcCol为攻击方或施计方的坐标
AttackRangeUtils.getAttackRange = function(rangeId, row, col, srcRow, srcCol)
    local config = InfoUtil.getRangeConfig(rangeId)
    local args   = config.args or {}
    local range  = AttackRangeUtils[config.rangeType](row, col, srcRow, srcCol, args[1], args[2])
    table.insert(range, {row = row, col = col}) -- 在这里添加，包含自己作为攻击单位，主要是为了防止前面多次添加
    return range
end

return AttackRangeUtils