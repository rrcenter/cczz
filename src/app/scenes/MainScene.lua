local SPlotRunner = require("module.plot.s_plot_runner")
local RPlotRunner = require("module.plot.r_plot_runner")
local DividedEffect = require("module.effect.divided_effect")

local MainScene = class("MainScene", function()
    return display.newScene("MainScene")
end)

MainScene.ctor = function(self)
    self:initEventHandles()
end

MainScene.initEventHandles = function(self)
    self.handlers = {
        [EventConst.NEXT_PLOT] = handler(self, self.nextPlot),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

MainScene.onEnter = function(self)
    printInfo("正在进入MainScene")

    local plotInfo = GameData.getPlotInfo()
    if plotInfo.type == "r" then
        self.curPlotRunner = RPlotRunner.new(plotInfo.index, self)
    else
        self.curPlotRunner = SPlotRunner.new(plotInfo.index, plotInfo.args, self)
    end
    self.curPlotRunner:addTo(self)
    self.curPlotRunner:run()
end

MainScene.onExit = function(self)
    printInfo("正在离开MainScene")

    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil

    EventMgr.dumpAllEvents()

    GameData.removeMapView()
    EventMgr.triggerEvent(EventConst.SCENE_EXIT)
end

MainScene.nextPlot = function(self, plotType, plotIndex, plotArgs)
    local enterEffect = DividedEffect.new()
    enterEffect:addTo(self, 1000)
    enterEffect:alginToDivided()
    enterEffect:gotoConverged({onComplete = function()
        self.curPlotRunner:removeSelf()
        GameData.removeMapView()

        if plotType == "r" then
            self.curPlotRunner = RPlotRunner.new(plotIndex)
        else
            self.curPlotRunner = SPlotRunner.new(plotIndex, plotArgs)
        end
        self.curPlotRunner:addTo(self)

        enterEffect:gotoDivided({onComplete = function()
            enterEffect:removeSelf()
            self.curPlotRunner:run()
        end})
    end})
end

MainScene.testRPlot = function(self)
    local plotIndex = 1
    local plotName = string.format("%02d", plotIndex)
    local nextRPlotTest
    nextRPlotTest = function()
        printInfo("R剧本%d 执行完毕", plotIndex)

        plotIndex = plotIndex + 1
        if plotIndex < 10 then
            plotName = "0" .. plotIndex
        else
            plotName = plotIndex .. ""
        end

        if plotIndex < 59 then
            printInfo("执行新剧本%d", plotIndex)
            RPlotRunner.new(plotName, nextRPlotTest)
        else
            print("全部播放完毕")
        end
    end

    if self.curPlotRunner then
        self.curPlotRunner:removeSelf()
    end

    self.curPlotRunner = RPlotRunner.new(plotName, nextRPlotTest)
    self.curPlotRunner:addTo(self)
    self.curPlotRunner:run()
end

return MainScene
