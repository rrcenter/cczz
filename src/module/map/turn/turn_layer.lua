--[[
    回合阶段
        其实进入每个阶段前，可以结算上一个阶段中每个武将的回合末结算(不过目前不需要)
        这里目前只处理回合前结算
--]]

local AiMgr         = import("...ai.ai_mgr")

local FriendTurn    = 1
local EnemyTurn     = 2
local PlayerTurn    = 3
local FontSize      = 72
local FontSmallSize = 36
local PlayerColor   = FontRedColor
local FriendColor   = FontOrangeColor
local EnemyColor    = FontBlueColor
local AliveTime     = 0.8

local TurnLayer = class("TurnLayer", function()
    return display.newColorLayer(LayerLightBlackColor)
end)

-- rounds表示回合数，turn表示该那方执行回合
TurnLayer.ctor = function(self, rounds, turn)
    if not turn then
        if MapUtils.hasFriendsGenerals() then
            turn = FriendTurn
        else
            turn = EnemyTurn
        end
    end

    printInfo("正在执行第%d回合，%d阶段", rounds, turn)
    self:initCommonUI()
    if turn == PlayerTurn then
        self:initPlayerTurn(rounds)
    elseif turn == FriendTurn then
        self:initFriendTurn(rounds)
    elseif turn == EnemyTurn then
        self:initEnemyTurn(rounds)
    end

    EventMgr.triggerEvent(EventConst.ADD_NONTOUCH_LAYER, "turn layer start")
    self:performWithDelay(function()
        EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, "turn layer end")
        self:removeSelf()

        if turn == FriendTurn then
            self:friendTurnBegin(rounds, turn)
        elseif turn == EnemyTurn then
            self:enemyTurnBegin(rounds, turn)
        elseif turn == PlayerTurn then
            self:playerTurnBegin(rounds, turn)
        end
    end, AliveTime)

    self:addTo(display.getRunningScene())
end

TurnLayer.initCommonUI = function(self)
    local nameLabel = cc.ui.UILabel.new({text = "名字", size = FontSize, font = FontName})
    nameLabel:align(display.CENTER, display.cx, display.cy)
    nameLabel:addTo(self)
    self.nameLabel = nameLabel
end

TurnLayer.initPlayerTurn = function(self, rounds)
    self.nameLabel:setString("我军阶段")

    local turnLabel = cc.ui.UILabel.new({text = "第" .. rounds .. "回合", size = FontSmallSize, font = FontName})
    turnLabel:align(display.CENTER, display.cx, display.cy - FontSize)
    turnLabel:addTo(self)

    if device.platform ~= "windows" and device.platform ~= "mac" then
        self.nameLabel:enableOutline(PlayerColor, 2)
        turnLabel:enableOutline(PlayerColor, 2)
    else
        self.nameLabel:setColor(PlayerColor)
        turnLabel:setColor(PlayerColor)
    end
end

TurnLayer.initFriendTurn = function(self, rounds)
    self.nameLabel:setString("友军阶段")
    if device.platform ~= "windows" and device.platform ~= "mac" then
        self.nameLabel:enableOutline(FriendColor, 2)
    else
        self.nameLabel:setColor(FriendColor)
    end
end

TurnLayer.initEnemyTurn = function(self, rounds)
    self.nameLabel:setString("敌军阶段")
    if device.platform ~= "windows" and device.platform ~= "mac" then
        self.nameLabel:enableOutline(EnemyColor, 2)
    else
        self.nameLabel:setColor(EnemyColor)
    end
end

TurnLayer.playerTurnBegin = function(self, rounds, turn)
    local turnBeginCallback = function()
        local generals = MapUtils.getAllPlayersGeneral()
        if #generals > 0 then
            table.oneByOne(generals, function(general, nextCallback)
                general:turnBegin(nextCallback)
            end, function()
                EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, "Player阶段")
                EventMgr.triggerEvent(EventConst.REFRESH_GENERALS, generals)
            end)
        else
            printInfo("我方无战斗人员，这里可能是剧情模式，直接跳转到友方回合（如果友方也没有，这里一定是出问题了）")
            TurnLayer.new(rounds + 1, FriendTurn)
        end
    end

    GameData.setCurSide("我军阶段")
    EventMgr.triggerEvent(EventConst.PLOT_CHECK_CONDTION, turnBeginCallback)
end

TurnLayer.friendTurnBegin = function(self, rounds, turn)
    local turnBeginCallback = function()
        local generals = MapUtils.getAllFriendsGeneral()
        table.oneByOne(generals, function(general, nextCallback)
            general:turnBegin(nextCallback)
        end, function()
            AiMgr.run(generals, "friend", function()
                TurnLayer.new(rounds, turn + 1)
            end)
        end)
    end


    GameData.setCurSide("友军阶段")
    EventMgr.triggerEvent(EventConst.PLOT_CHECK_CONDTION, turnBeginCallback)
end

TurnLayer.enemyTurnBegin = function(self, rounds, turn)
    local turnBeginCallback = function()
        local generals = MapUtils.getAllEnemiesGeneral()
        table.oneByOne(generals, function(general, nextCallback)
            general:turnBegin(nextCallback)
        end, function()
            AiMgr.run(generals, "enemy", function()
                TurnLayer.new(rounds + 1, turn + 1)
            end)
        end)
    end

    GameData.setCurSide("敌军阶段")
    EventMgr.triggerEvent(EventConst.PLOT_CHECK_CONDTION, turnBeginCallback)
end

return TurnLayer