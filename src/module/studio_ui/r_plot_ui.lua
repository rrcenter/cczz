--[[
    R剧本界面
    --!! 此模块以后需要重构分为上部分，左下和右下部分
--]]

local LoadingUI      = import(".loading_ui")
local EquipUI        = import(".equip_ui")
local ShopUI         = import(".shop_ui")
local FightPrepareUI = import(".fight_prepare_ui")

local RPlotUI = class("RPlotUI", function()
    return display.newNode()
end)

RPlotUI.ctor = function(self)
    self:initUI()
    self:initTouchEvent()
    self:initFrameEvent()
    self:setNodeEventEnabled(true)
end

RPlotUI.initUI = function(self)
    self.topNode           = cc.uiloader:load("ccz/ui/RPlotUI1.csb")
    self.topRootNode       = UIHelper.seekNodeByName(self.topNode, "Root")
    self.sceneNameLabel    = UIHelper.seekNodeByName(self.topNode, "SceneNameLabel")
    self.titleLabel        = UIHelper.seekNodeByName(self.topNode, "TitleLabel")
    self.blueProgress      = UIHelper.seekNodeByName(self.topNode, "BlueLoadingBar")
    self.redProgress       = UIHelper.seekNodeByName(self.topNode, "RedLoadingBar")
    self.quickDialogButton = UIHelper.seekNodeByName(self.topNode, "QuickDialogCheckBox")

    self.bottomNode     = cc.uiloader:load("ccz/ui/RPlotUI2.csb")
    self.bottomRootNode = UIHelper.seekNodeByName(self.bottomNode, "Panel")
    self.fightButton    = UIHelper.seekNodeByName(self.bottomNode, "FightButton")
    self.equipsButton   = UIHelper.seekNodeByName(self.bottomNode, "EquipsButton")
    self.shopButton     = UIHelper.seekNodeByName(self.bottomNode, "ShopButton")
    self.saveButton     = UIHelper.seekNodeByName(self.bottomNode, "SaveButton")
    self.loadButton     = UIHelper.seekNodeByName(self.bottomNode, "LoadButton")

    -- 被触控坑惨了，这个蛋逼玩意，在这里设置事件穿透
    self.topRootNode:setSwallowTouches(false)
    self.topRootNode:align(display.LEFT_TOP, 0, display.height)
    self.topNode:addTo(self)
    self.bottomRootNode:setSwallowTouches(false)
    self.bottomRootNode:align(display.LEFT_BOTTOM, 0, 0)
    self.bottomRootNode:hide()
    self.bottomNode:addTo(self)
    self.quickDialogButton:setSelected(UserConfig:getBoolForKey("QuickDialog", true))

    if GameData.getSceneName() then
        self.sceneNameLabel:setString(GameData.getSceneName())
    end

    if GameData.getPlotTitle() then
        self.titleLabel:setString(GameData.getPlotTitle())
    end

    if GameData.getCareerism() then
        printInfo("设置野心值：%d", GameData.getCareerism())
        self.blueProgress:setPercent(GameData.getCareerism())
    end
end

RPlotUI.initTouchEvent = function(self)
    local buttonRelease = function()
        self:setButtonEnabled(true)
    end

    UIHelper.buttonRegister(self.fightButton, function()
        printInfo("弹出出战选将界面")
        self:setButtonEnabled(false)
        FightPrepareUI.new(self.playerList, buttonRelease):addTo(display.getRunningScene())
    end)

    UIHelper.buttonRegister(self.equipsButton, function()
        printInfo("弹出装备界面")
        self:setButtonEnabled(false)
        EquipUI.new(buttonRelease):addTo(display.getRunningScene())
    end)

    UIHelper.buttonRegister(self.shopButton, function()
        printInfo("弹出购买界面")
        self:setButtonEnabled(false)
        ShopUI.new(buttonRelease):addTo(display.getRunningScene())
    end)

    UIHelper.buttonRegister(self.saveButton, function()
        printInfo("弹出保存界面，直接就生成一个固定的文件SaveData[2]来保存")
        EventMgr.triggerEvent(EventConst.SAVE_DATA)
    end)

    UIHelper.buttonRegister(self.loadButton, function()
        printInfo("弹出载入进度界面")
        self:setButtonEnabled(false)
        LoadingUI.new(buttonRelease):addTo(display.getRunningScene())
    end)

    self.quickDialogButton:addEventListener(function(checkbox, eventType)
        if eventType == 1 then
            UserConfig:setBoolForKey("QuickDialog", false)
        else
            UserConfig:setBoolForKey("QuickDialog", true)
        end
    end)
end

RPlotUI.initFrameEvent = function(self)
    -- 仅仅为了让进度条能平滑移动一下子
    self:addNodeEventListener(cc.NODE_ENTER_FRAME_EVENT, function(dt)
        self.percentValue = self.percentValue - self.percentStep
        self.blueProgress:setPercent(self.blueProgress:getPercent() + self.percentStep)

        if self.percentValue == 0 then
            self:unscheduleUpdate()
            self.percentCallback()
            return
        end
    end)
end

RPlotUI.onEnter = function(self)
    self.handlers = {
        [EventConst.SET_SCENE_NAME]     = handler(self, self.setSceneName),
        [EventConst.SET_PLOT_TITLE]     = handler(self, self.setPlotTitle),
        [EventConst.SHOW_PLOT_MENU]     = handler(self, self.showPlotMenu),
        [EventConst.PLOT_ADD_CAREERISM] = handler(self, self.addCareerism),
        [EventConst.FIGHT_PREPARE_DONE] = handler(self, self.fightPrepareDone),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

RPlotUI.onExit = function(self)
    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil
end

RPlotUI.setButtonEnabled = function(self, isEnabled)
    self.fightButton:setTouchEnabled(isEnabled)
    self.equipsButton:setTouchEnabled(isEnabled)
    self.shopButton:setTouchEnabled(isEnabled)
    self.saveButton:setTouchEnabled(isEnabled)
    self.loadButton:setTouchEnabled(isEnabled)
end

RPlotUI.setSceneName = function(self, sceneName)
    self.sceneNameLabel:setString(sceneName)
end

RPlotUI.setPlotTitle = function(self, title)
    self.titleLabel:setString(title)
end

RPlotUI.showPlotMenu = function(self, isShow)
    self.bottomRootNode:setVisible(isShow)
end

RPlotUI.setFightButtonPlot = function(self, plot)
    self.fightButtonPlot = plot
end

RPlotUI.addCareerism = function(self, value, callback)
    self.percentValue = value
    self.percentStep = (value > 0) and 1 or -1
    self.percentCallback = callback
    self:scheduleUpdate()
end

RPlotUI.setFinalCallback = function(self, callback)
    -- 必定存在，否则会出现不发进行后续剧情的
    self.finalCallback = callback
end

RPlotUI.setPlayerList = function(self, playerList)
    -- 记录出阵最高和最低限制，以及必须出阵的武将
    self.playerList = playerList
end

RPlotUI.getPlayerList = function(self)
    return self.playerList or {}
end

-- 选将结束，准备出战
RPlotUI.fightPrepareDone = function(self, playerList)
    EventMgr.triggerEvent(EventConst.FIGHT_PRESSED_PLOT, self.fightButtonPlot, playerList, self.finalCallback)
end

return RPlotUI