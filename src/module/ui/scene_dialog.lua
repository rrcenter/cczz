--[[
    场景对话框
    黑色半透明底，白色渐显文字
--]]

local ViewWidth  = display.width
local ViewHeight = display.height * 0.25
local AliveTime  = 0.2
local ZORDER     = 1000
local WordsSpeed = 20
local LastDialog = nil

local SceneDialog = class("SceneDialog", function()
    return TouchLayer.new()
end)

SceneDialog.ctor = function(self, content, callback)
    if LastDialog then
        LastDialog:removeSelf()
    end
    LastDialog = self

    local onComplete = function()
        self:hide()
        if callback then
            callback()
        end
    end

    local bgNode = display.newRect(cc.rect(0, 0, ViewWidth, ViewHeight), {fillColor = LightBlackColor, borderColor = LightBlackColor})
    bgNode:addTo(self)

    local dimensions = cc.size(ViewWidth * 0.8, ViewHeight * 0.8)
    local contentLabel = FadeLabel.new({text = content, fontName = FontName, fontSize = FontSize, fontColor = FontWhiteColor, dimensions = dimensions})
    contentLabel:align(display.LEFT_TOP, ViewWidth * 0.1, ViewHeight * 0.9)
    contentLabel:addTo(self)
    contentLabel:playFadeInAnim(WordsSpeed, onComplete)

    self.finalCallback = function()
        if contentLabel:isRunningAmim() then
            contentLabel:playEnded()
            self:performWithDelay(onComplete, AliveTime)
        else
            onComplete()
        end
    end
end

SceneDialog.onTouch = function(self, event)
    self.finalCallback()
end

local SceneDialogUtils = {}

SceneDialogUtils.ShowSingleChat = function(general, isLeft, content, finalCallback, pos, aliveTime)
    -- aliveTime = aliveTime or AliveTime
    -- local sceneDialog = SceneDialog.new(general:getName(), general:getHeadIcon(), isLeft, content, finalCallback)
    -- sceneDialog:addTo(display.getRunningScene(), ZORDER)
    -- sceneDialog:performWithDelay(function()
    --     if finalCallback then
    --         finalCallback()
    --     end

    --     sceneDialog:hide()
    -- end, aliveTime)
end

SceneDialogUtils.ShowDialog = function(content, callback)
    local SceneDialog = SceneDialog.new(content, callback)
    SceneDialog:addTo(display.getRunningScene(), ZORDER)
end

SceneDialogUtils.plotOver = function()
    LastDialog = nil
end

EventMgr.registerEvent(EventConst.PLOT_OVER, SceneDialogUtils.plotOver)

return SceneDialogUtils