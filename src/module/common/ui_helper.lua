--[[
    为蛋逼CocosStudio补充的辅助接口
--]]

local UIHelper = {}

UIHelper.seekNodeByName = function(root, name)
    if not root then
        return
    end

    if root:getName() == name then
        return root
    end

    for _, subWidget in pairs(root:getChildren()) do
        if subWidget then
            local node = UIHelper.seekNodeByName(subWidget, name)
            if node then
                return node
            end
        end
    end
end

UIHelper.seekNodeByTag = function(root, tag)
    if not root then
        return
    end

    if root:getTag() == tag then
        return root
    end

    for _, subWidget in pairs(root:getChildren()) do
        if subWidget then
            local node = UIHelper.seekNodeByTag(subWidget, tag)
            if node then
                return node
            end
        end
    end
end

UIHelper.buttonRegister = function(button, callback)
    if button.setPressedActionEnabled then
        button:setPressedActionEnabled(true)
    end

    button:addTouchEventListener(function(button, eventType)
        if eventType == cc.EventCode.ENDED then
            callback()
        end
    end)
end

UIHelper.buttonRegisterByName = function(root, buttonName, callback)
    local button = UIHelper.seekNodeByName(root, buttonName)
    if button then
        UIHelper.buttonRegister(button, callback)
    else
        printInfo("不存在此按钮：%s", buttonName)
    end
end

UIHelper.buttonEnabled = function(button, enabled)
    button:setEnabled(enabled)
    button:setBright(enabled)
    button:setTouchEnabled(enabled)
end

return UIHelper