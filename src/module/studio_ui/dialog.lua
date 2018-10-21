--[[
    对话框
    用ui编辑器直接撸出来的，比较丑
--]]

local DefaultTitle  = "SLG曹操传"

local Dialog = class("Dialog", function()
    return TouchLayer.new()
end)

Dialog.ctor = function(self, content, params)
    params = params or {}

    local ccsNode = cc.uiloader:load("ccz/ui/Dialog.csb")
    ccsNode:addTo(self)

    local rootNode = UIHelper.seekNodeByName(ccsNode, "Root")
    rootNode:center()
    rootNode:align(display.CENTER)

    local titleLabel = UIHelper.seekNodeByName(ccsNode, "TitleLabel")
    titleLabel:setString(params.title or DefaultTitle)

    local contentLabel = UIHelper.seekNodeByName(ccsNode, "ContentLabel")
    contentLabel:setString(content)

    local leftButton = UIHelper.seekNodeByName(ccsNode, "LeftButton")
    if params.buttonLeftText then
        leftButton:setTitleText(params.buttonLeftText)
        UIHelper.buttonRegister(leftButton, function()
            if params.buttonLeftCallback then
                params.buttonLeftCallback()
            end

            self:removeSelf()
        end)
    else
        leftButton:hide()
    end

    local middleButton = UIHelper.seekNodeByName(ccsNode, "MiddleButton")
    if params.buttonMiddleText then
        middleButton:setTitleText(params.buttonMiddleText)
        UIHelper.buttonRegister(middleButton, function()
            if params.buttonMiddleCallback then
                params.buttonMiddleCallback()
            end

            self:removeSelf()
        end)
    else
        middleButton:hide()
    end

    local rightButton = UIHelper.seekNodeByName(ccsNode, "RightButton")
    if params.buttonRightText then
        rightButton:setTitleText(params.buttonRightText)
        UIHelper.buttonRegister(rightButton, function()
            if params.buttonRightCallback then
                params.buttonRightCallback()
            end

            self:removeSelf()
        end)
    else
        rightButton:hide()
    end
end

Dialog.onTouch = function(self, event)
    printInfo("点中了对话框无效区域，不响应操作")
end

return Dialog