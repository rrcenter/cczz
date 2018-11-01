--[[
    读档UI
--]]

local LoadingUI = class("LoadUI", function()
    return cc.uiloader:load("ccz/ui/LoadingUI.csb")
end)

LoadingUI.ctor = function(self, callback)
    self.callback = callback or function() end
    self:initUI()
end

LoadingUI.initUI = function(self)
    self:pos(display.cx, display.cy)
    self.rootNode = UIHelper.seekNodeByName(self, "Root")

    local initSingleSaving = function(index)
        local descLabel       = UIHelper.seekNodeByName(self, "DescLabel" .. index)
        local titleLabel      = UIHelper.seekNodeByName(self, "TitleLabel" .. index)
        local savingNameLabel = UIHelper.seekNodeByName(self, "SavingNameLabel" .. index)
        local levelLabel      = UIHelper.seekNodeByName(self, "LevelLabel" .. index)
        local saveButton      = UIHelper.seekNodeByName(self, "SavingButton" .. index)

        local saveData = GameData.getSaveData(index)
        if saveData then
            titleLabel:setString(saveData.plotTitle)
            levelLabel:setString("Lv." .. saveData.generalList[1].level)
            savingNameLabel:setString(saveData.savingName)
        else
            descLabel:hide()
            titleLabel:hide()
            savingNameLabel:hide()
            levelLabel:hide()
        end

        UIHelper.buttonRegister(saveButton, function()
            if saveData then
                EventMgr.triggerEvent(EventConst.LOAD_DATA, index)
                GameData.setNoClearBattleInfo(true)
                self:enterGame()
            else
                TipUtils.showTip("暂无存档")
            end
        end)
    end

    initSingleSaving(1)
    initSingleSaving(2)
    initSingleSaving(3)

    UIHelper.buttonRegisterByName(self, "CloseButton", function()
        self.callback()
        self:removeSelf()
    end)
end

LoadingUI.enterGame = function(self)
    printInfo("正在切换场景，进入MainScene")
    local newScene = require("app.scenes.MainScene").new()
    display.replaceScene(newScene)
end

return LoadingUI