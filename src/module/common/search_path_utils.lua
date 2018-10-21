--[[
    寻路辅助函数
--]]

AStar = import(".a_star")
AiAStar = import(".ai_a_star")

local SearchPathUtils = {}

SearchPathUtils.getAPath = function(map, fromRow, fromCol, toRow, toCol)
    local startPoint = {row = fromRow, col = fromCol}
    local endPoint   = {row = toRow, col = toCol}

    -- 直接使用4方向处理
    AStar:init(map, startPoint, endPoint, true)
    local path = AStar:searchPath()
    if not path or #path == 1 then
        return nil
    end

    -- 得到的路径其实需要反转一下才是从起始到终点
    local resultPath = {}
    for i, v in ipairs(path) do
        resultPath[#path - i + 1] = v
    end

    return resultPath
end

-- needAdjustPath，是否需要调整path逆序成起点到终点，默认为false
SearchPathUtils.getAiAPath = function(map, fromRow, fromCol, toRow, toCol, needAdjustPath)
    local startPoint = {row = fromRow, col = fromCol}
    local endPoint   = {row = toRow, col = toCol}

    -- Ai A*仅处理4方向
    AiAStar:init(map, startPoint, endPoint)
    local path, pathCost = AiAStar:searchPath()
    if not path or #path == 1 then
        return nil
    end

    if needAdjustPath then
        local resultPath = {}
        for i, v in ipairs(path) do
            resultPath[#path - i + 1] = v
        end
        return resultPath, pathCost
    end

    return path, pathCost
end

return SearchPathUtils