--[[
    A*算法-为Ai做了点处理，允许传入移动节点的cost值，这个目前简单测试时正确的
    其他同a_star，这里移除掉了八方向相关代码
    如目的地为(1, 4) -> (1, 1)
    cost值：
        1 3 3 1
        1 1 1 1

    选择线路为(1, 4)->(2, 4)->(2, 3)->(2, 2)->(2, 1)->(1, 1)

    cost值：
        1 3 3 1
        2 1 1 1
    同上

    cost值：
        1 3 3 1
        3 1 1 1
    选择路线为(1, 4)->(1, 3)->(1, 2)->(1, 1)
--]]


-- 行走的4个方向
local four_dir = {
    {1, 0},
    {0, 1},
    {0, -1},
    {-1, 0},
}

local AStar = {}

-- 地图、起始点、终点
AStar.init = function(self, map, startPoint, endPoint)
    self.startPoint = startPoint
    self.endPoint   = endPoint
    self.map        = map
    self.cost       = 10 -- 单位花费
    self.diag       = 1.4 -- 对角线长， 根号2 一位小数
    self.open_list  = {}
    self.close_list = {}
    self.mapRows    = #map
    self.mapCols    = #map[1]
end

-- 搜索路径 ,核心代码
AStar.searchPath = function(self)
    -- 验证终点是否为阻挡，如果为阻挡，则直接返回空路径
    if self.map[self.endPoint.row][self.endPoint.col].isBlock then
        printInfo("(%d, %d) 是阻挡！！！无法寻路", self.endPoint.row, self.endPoint.col)
        return nil
    end

    -- 把第一节点加入 open_list中
    local startNode = {}
    startNode.row = self.startPoint.row
    startNode.col = self.startPoint.col
    startNode.g = 0
    startNode.h = 0
    startNode.f = 0
    table.insert(self.open_list, startNode)

    -- 检查边界、障碍点
    local check = function(row, col)
        if 1 <= row and row <= self.mapRows and 1 <= col and col <= self.mapCols then
            if self.map[row][col].isNonBlock or (row == self.endPoint.row and col == self.endPoint.col) then
                return true
            end
        end

        return false
    end

    local dir = four_dir
    while #self.open_list > 0 do
        local node = self:getMinNode()
        if node.row == self.endPoint.row and node.col == self.endPoint.col then
            -- 找到路径
            return self:buildPath(node)
        end

        for i = 1, #dir do
            local row = node.row + dir[i][1]
            local col = node.col + dir[i][2]
            if check(row, col) then
                local curNode = self:getFGH(node, row, col, (row ~= node.row and col ~= node.col))
                local openNode, openIndex = self:nodeInOpenList(row, col)
                local closeNode, closeIndex = self:nodeInCloseList(row, col)

                if not openNode and not closeNode then
                    -- 不在OPEN表和CLOSE表中
                    -- 添加特定节点到 open list
                    table.insert(self.open_list, curNode)
                elseif openNode then
                    -- 在OPEN表
                    if openNode.f > curNode.f then
                        -- 更新OPEN表中的估价值
                        self.open_list[openIndex] = curNode
                    end
                else
                    -- 在CLOSE表中
                    if closeNode.f > curNode.f then
                        table.insert(self.open_list, curNode)
                        table.remove(self.close_list, closeIndex)
                    end
                end
            end
        end

        -- 节点放入到 close list 里面
        table.insert(self.close_list, node)
    end

    -- 不存在路径
    return nil
end

-- 获取 f ,g ,h, 最后参数是否对角线走
AStar.getFGH = function(self, father, row, col, isdiag)
    local node = {}
    local cost = self.cost * self.map[row][col].cost
    node.father = father
    node.row = row
    node.col = col
    node.g = father.g + cost
    -- 估计值h
    node.h = self:manhattan(row, col)
    node.f = node.g + node.h  -- f = g + h

    return node
end

-- 判断节点是否已经存在 open list 里面
AStar.nodeInOpenList = function(self, row, col)
    for i = 1, #self.open_list do
        local node = self.open_list[i]
        if node.row == row and node.col == col then
            return node, i   -- 返回节点和下标
        end
    end

    return nil
end

-- 判断节点是否已经存在 close list 里面
AStar.nodeInCloseList = function(self, row, col)
    for i = 1, #self.close_list do
        local node = self.close_list[i]
        if node.row == row and node.col == col then
            return node, i
        end
    end

    return nil
end

-- 在open_list中找到最佳点,并删除
AStar.getMinNode = function(self)
    if #self.open_list < 1 then
        return nil
    end

    local min_node = self.open_list[1]
    local min_i = 1
    for i,v in ipairs(self.open_list) do
        if min_node.f > v.f then
            min_node = v
            min_i = i
        end
    end

    table.remove(self.open_list, min_i)
    return min_node
end

-- 计算路径
AStar.buildPath = function(self, node)
    local path = {}
    local sumCost = node.f -- 路径的总花费
    while node do
        path[#path + 1] = {row = node.row, col = node.col}
        node = node.father
    end

    return path, sumCost
end

-- 估价h函数
-- 曼哈顿估价法（用于不能对角行走）
AStar.manhattan = function(self, row, col)
    local h = math.abs(row - self.endPoint.row) + math.abs(col - self.endPoint.col)
    return h * self.cost
end

return AStar
