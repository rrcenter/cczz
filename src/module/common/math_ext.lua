--[[
    math的一些扩展
--]]

--[[
    传入一个数字和上下限，返回这个区间内的值
    超过这个区间，可以指定上下限的返回值，未指定则返回上下限值
    也可以设置一个区间内返回的值，未设置，则返回传入值
--]]
math.limitValue = function(value, leftBoundry, rightBoundry, leftReturnValue, rightReturnValue, defaultReturnValue)
    if value <= leftBoundry then
        return leftReturnValue or leftBoundry
    elseif value >= rightBoundry then
        return rightReturnValue or rightBoundry
    end

    return defaultReturnValue or value
end

-- 传入一个数字和区间，判断该数字是否在区间内, isContainBoundry用来表示左右区间是否为闭区间，默认为true
math.isInRange = function(value, leftBoundry, rightBoundry, isContainBoundry)
    isContainBoundry = (isContainBoundry == nil) and true or isContainBoundry
    if leftBoundry > rightBoundry then
        leftBoundry, rightBoundry = rightBoundry, leftBoundry
    end

    assert(leftBoundry and rightBoundry, "左右区间必须同时存在")
    if isContainBoundry then
        return leftBoundry <= value and value <= rightBoundry
    else
        return leftBoundry < value and value < rightBoundry
    end
end