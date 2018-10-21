--[[
    S剧本界面
--]]

local LoadingUI = import(".loading_ui")
local WEATHER_MAPPING = {
    ["晴"]   = "qing",
    ["阴"]   = "yin",
    ["雨"]   = "yu",
    ["豪雨"] = "haoyu",
    ["雪"]   = "xue",
}

local SPlotUI = class("SPlotUI", function()
    return cc.uiloader:load("ccz/ui/SPlotUI.csb")
end)

SPlotUI.ctor = function(self)
    self.res = "ccz/weather/weather"
    ResMgr.addSpriteFrames(self.res)

    self:initUI()
    self:initTouchEvent()

    self:setNodeEventEnabled(true)
    self:hide()
end

SPlotUI.onEnter = function(self)
    self.handlers = {
        [EventConst.SHOW_WEATHER] = handler(self, self.showWeather),
        [EventConst.SPLOT_UI_ENABLED] = handler(self, self.enabled),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

SPlotUI.onExit = function(self)
    ResMgr.removeSpriteFramesWithFile(self.res)

    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil
end

SPlotUI.initUI = function(self)
    self.panel             = UIHelper.seekNodeByName(self, "Panel")
    self.saveButton        = UIHelper.seekNodeByName(self, "SaveButton")
    self.loadButton        = UIHelper.seekNodeByName(self, "LoadButton")
    self.quickDialogButton = UIHelper.seekNodeByName(self, "QuickDialogCheckBox")
    self.weatherAnimation  = UIHelper.seekNodeByName(self, "WeatherNode")
    self.weatherAnimation:opacity(170)

    self.panel:setSwallowTouches(false)
    self:pos(display.cx, self.panel:getContentSize().height / 2)
end

SPlotUI.initTouchEvent = function(self)
    UIHelper.buttonRegister(self.saveButton, function()
        printInfo("弹出保存界面，直接就生成一个固定的文件SaveData[3]来保存")
        EventMgr.triggerEvent(EventConst.SAVE_DATA)
    end)

    UIHelper.buttonRegister(self.loadButton, function()
        printInfo("弹出载入进度界面")
        local loadingUI = LoadingUI.new()
        loadingUI:addTo(self:getParent(), 1000)
    end)

    self.quickDialogButton:addEventListener(function(checkbox, eventType)
        if eventType == 1 then
            UserConfig:setBoolForKey("QuickDialog", false)
        else
            UserConfig:setBoolForKey("QuickDialog", true)
        end
    end)
end

SPlotUI.showWeather = function(self)
    local weather = WEATHER_MAPPING[GameData.getWeather()]
    local frames = display.newFrames(weather .. "_%d.png", 1, 4)
    local animation = display.newAnimation(frames, 0.1)
    self.weatherAnimation:stop()
    self.weatherAnimation:playAnimationForever(animation)
end

SPlotUI.show = function(self)
    self:showWeather()
    self:setVisible(true)
end

SPlotUI.enabled = function(self, isEnabled)
    UIHelper.buttonEnabled(self.loadButton, isEnabled)
    UIHelper.buttonEnabled(self.saveButton, isEnabled)
end

return SPlotUI