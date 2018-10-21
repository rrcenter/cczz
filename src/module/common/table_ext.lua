--[[
    table的一些扩展
--]]

--[[
用法:
    这里额外支持nextCallback中添加一个index传入
    t = {1, 2, 3, 4, 5}
    table.oneByOne(t, function(v, nextCallback)
        print(v)
        nextCallback()
    end, function()
        print("over")
    end)
--]]
table.oneByOne = function(t, callback, finalCallback)
    if #t <= 0 then
        if finalCallback then
            finalCallback()
        end
        return
    end

    local stepCallback
    stepCallback = function(index, t)
        if index <= #t then
            callback(t[index], function()
                stepCallback(index + 1, t)
            end, index)
        elseif finalCallback then
            finalCallback()
        end
    end

    stepCallback(1, t)
end

-- 同table.oneByOne，区别为key-value版本
table.oneByOneForMap = function(t, callback, finalCallback)
    local newT = {}
    for k, v in pairs(t) do
        table.insert(newT, v)
    end

    table.oneByOne(newT, callback, finalCallback)
end

--[[
用法:
    t = {1, 2, 3, 4, 5, 6}
    table.walkAll(t, function(v, nextCallback)
        print(v)
        nextCallback()
    end, function()
        print("over")
    end)
--]]
table.walkAll = function(t, callback, finalCallback)
    local hasDone = 0
    for _, v in ipairs(t) do
        callback(v, function()
            hasDone = hasDone + 1
            if hasDone >= #t then
                finalCallback = finalCallback or function() end
                finalCallback()
            end
        end)
    end
end

--[[
用法:
    和table.indexof的区别在于可以提供一个比较函数，只需要为true，就不再往后比较
    t = {1, 2, 3, 2, 55}
    local index = table.findIf(t, function(v)
        return v == 55
    end)
--]]
table.findIf = function(t, callback)
    local findIndex = nil
    for i, v in ipairs(t) do
        if callback(v, i) then
            findIndex = i
            break
        end
    end

    return findIndex, t[findIndex]
end

-- 用法同table.findIf，区别为key-value版本
table.findIfForMap = function(t, callback)
    local newT = {}
    for k, v in pairs(t) do
        table.insert(newT, v)
    end

    return table.findIf(newT, callback)
end

-- 累加所有表中的数据，允许传入一个回调针对每一项做额外处理
table.addAllValues = function(t, callback)
    local result = 0
    for _, v in pairs(t) do
        if callback then
            result = result + callback(v)
        else
            result = result + v
        end
    end

    return result
end

-- 同上，处理乘法而已
table.multAllValues = function(t, callback)
    local result = 1
    for _, v in pairs(t) do
        if callback then
            result = result * callback(v)
        else
            result = result * v
        end
    end

    return result
end

-- 判断是否为table
isTable = function(t)
    return type(t) == "table"
end

-- desciption 输出内容前的描述，默认为"table"
-- nesting 嵌套层次，默认为20
-- 返回table，存储需要打印table的每行信息
-- 之所以不进行table.concat，是因为quick打印的时候有前缀信息，会不美观
table.getTableStr = function(tb, tbDeep, funcSaveItem)
    if type(tb) ~= "table" then
        return
    end

    tbDeep =  tbDeep or 20
    local curDeep = 1
    local tbCache = {}
    local function save_table(tbData)
        -- 存储当前层table
        if type(tbData) ~= "table"  then
            print("Error", "存储类型必须为table:", tb, path, tbDeep)
            return
        end

        if tbCache[tbData] then
            print("Error", "无法继续存储，table中包含循环引用，", tb, path, tbDeep)
            return
        end

        tbCache[tbData] = true
        local k, v
        curDeep = curDeep + 1
        if curDeep > tbDeep then
            print("Error", "待存储table超过可允许的table深度", tb, path, tbDeep)
            curDeep = curDeep - 1
            return
        end

        local tab = string.rep(" ", (curDeep - 1) * 4)
        local str = "{\n"

        -- 调整table存储顺序，按照key排序
        local keys_num = {}
        local keys_str = {}
        for k, v in pairs(tbData) do
            if type(k) == "number" then
                table.insert(keys_num, k)
            elseif type(k) == "string" then
                table.insert(keys_str, k)
            end
        end
        table.sort(keys_str)
        table.sort(keys_num)

        local keys = {}
        for i, k in ipairs(keys_num) do
            table.insert(keys, k)
        end
        for i, k in ipairs(keys_str) do
            table.insert(keys, k)
        end
        for k, v in pairs(tbData) do
            if type(k) ~= "number" and type(k) ~= "string" then
                table.insert(keys, k)
            end
        end

        -- 保存调整后的table
        local i
        for i, k in ipairs(keys) do
            local arg, value
            if type(k) == "number" then
                arg = string.format("[%d]", k) -- 认为key一定是整数
            elseif type(k) == "string" then
                arg = string.format("[\"%s\"]", string.gsub(k, "\\", "\\\\"))
            elseif type(k) == "boolean" then
                value = tostring(k)
            end

            v = tbData[k]
            if type(v) == "number" then
                value = string.format("%d", v) -- 这里我需要将所有的value都调整为整数
            elseif type(v) == "string" then
                value = string.format("\"%s\"", string.gsub(v, "\\", "\\\\"))
            elseif type(v) == "table" then
                value = save_table(v)
            elseif type(v) == "boolean" then
                value = tostring(v)
            end

            if arg and value then
                item_str = funcSaveItem and funcSaveItem(tab, arg, value) or string.format("%s%s = %s,\n", tab, arg, value)
                str = str .. item_str
            end
        end

        curDeep = curDeep - 1
        local tab = string.rep(" ", (curDeep - 1) * 4)
        tbCache[tbData] = false

        return str .. tab .. "}"
    end

    local tbStr = save_table(tb)
    return tbStr
end

table.save = function(tb, path)
    local tableContent = "local SaveDatas = " .. table.getTableStr(tb) .. "\nreturn SaveDatas"
    io.writefile(path, tableContent)
end