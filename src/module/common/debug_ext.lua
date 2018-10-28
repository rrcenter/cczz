--[[
    添加的调试辅助函数
]]

--[[--

输出节点及子节点所构成的节点树

### 用法示例

~~~ lua

dump(dumpNodeTree)

~~~

@param mixed node 根节点

@parma [integer nesting] 输出时的嵌套层级，默认为 3

]]
dumpNodeTree = function(node, nesting)
    if type(nesting) ~= "number" then nesting = 3 end

    local traceback = string.split(debug.traceback("", 2), "\n")
    printInfo("dumpNodeTree from: " .. string.trim(traceback[3]))

    local indent = "  "

    local _getHead = function(nest)
        local head = ""
        for i = 2, nest do
            head = head .. indent
        end
        return head
    end

    local function _dump(node, nest)
        local children = node:getChildren()
        if #children == 0 then
            local indent = "  "
            printInfo("%s[%d]classname:%s, name:%s, zorder:%d", _getHead(nest), nest, node.__cname, node:getName(), node:getLocalZOrder())
        else
            printInfo("%s[%d]classname:%s, name:%s, zorder:%d", _getHead(nest), nest, node.__cname, node:getName(), node:getLocalZOrder())
            if nest >= nesting then
                return
            end
            for i, v in pairs(children) do
                _dump(v, nest + 1)
            end
        end
    end

    _dump(node, 1)
end
