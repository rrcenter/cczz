--[[
    概率判断
--]]

local Random = {}

-- 目前仅支持1和100的这两种类型的概率
Random.isTrigger = function(triggerRate)
    if triggerRate < 0 then
        printError("触发几率不可能为负数")
        return
    end

    if triggerRate < 1 then
        print("!!!!!!!!!!!!!!!!移除所有小于1的百分比", triggerRate)
        dump(debug.traceback(2))
    end

    printInfo("命中几率为:%d", triggerRate)
    if triggerRate < 1 then
        return math.random() < triggerRate
    elseif triggerRate <= 100 then
        return math.random(99) < triggerRate
    end

    return false
end

-- 返回1-指定区间的一个随机数
Random.getNumber = function(maxLimit)
    for i = 1, maxLimit * 3 do
        math.random(maxLimit) -- 增加随机几率
    end
    return math.random(maxLimit)
end

return Random