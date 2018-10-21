--[[
    错误信息显示面板
        这是一个ScrollView专门用来显示错误信息
--]]

local ErrorPanel = class("ErrorPanel", function()
    return display.newColorLayer(cc.c4b(20, 20, 20, 100))
end)

ErrorPanel.ctor = function(self, errorMessage, traceback)
    if DEBUG ~= 1 then
        -- 非debug模式不出现
        return
    end

    self.uiNode = cc.uiloader:load("ccz/ui/ErrorUI.csb")
    self.uiNode:addTo(self)

    self.rootNode = UIHelper.seekNodeByName(self.uiNode, "Root")
    self.rootNode:center()

    local errorContent = errorMessage .. "\n" .. tostring(traceback)
    self.errorContentLabel = UIHelper.seekNodeByName(self.uiNode, "ErrorLabel")
    self.errorContentLabel:setString(errorContent)

    UIHelper.buttonRegisterByName(self.uiNode, "CloseButton", function()
        -- 游戏直接退出
        app:exit()
    end)

    self:addTo(display.getRunningScene(), 99999)
end

return ErrorPanel