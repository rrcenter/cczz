--[[
    S剧本执行器
--]]

local CURRENT_MODULE_NAME = ...
local SPlotUI = import("..studio_ui.s_plot_ui")

local SPlotRunner = class("SPlotRunner", function()
    return display.newNode()
end)

SPlotRunner.ctor = function(self, splotIndex, playerList)
    ResMgr.init()

    self.playerList = playerList
    self.nextPlotIndex = tonumber(splotIndex) + 1
    self:setNodeEventEnabled(true)

    local sPlotInfo = import("..data.splot.s_plot" .. splotIndex, CURRENT_MODULE_NAME)
    self:initEventHandles()
    self:initUI()
    self:initBattlePrepareInfo(sPlotInfo.battlePrepare)
    self:initBattleConditionInfo(sPlotInfo.battleMiddlePlot)
    self:initBattleEndInfo(sPlotInfo.battleEndPlot)

    self.battleStartPlot = sPlotInfo.battleStartPlot
end

SPlotRunner.run = function(self)
    if GameData.isSkipBattleStartPlot() then
        printInfo("此为读取存的数据，跳过战前剧情")
        GameData.resetSkipBattleStartPlot()
        self:checkConditions(function()
            EventMgr.triggerEvent(EventConst.BATTLE_START_PLOT_DONE)
            EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, "战前剧情结束，移除")
        end)
    else
        printInfo("播放战前剧情")
        self:runPlot(self.battleStartPlot, function()
            printInfo("战前剧情播放完毕，进行第一次主动检查战中剧情")
            self:checkConditions(function()
                printInfo("第一次主动检查战中剧情结束")

                EventMgr.triggerEvent(EventConst.BATTLE_START_PLOT_DONE)
                EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, "战前剧情结束，移除")

                if #MapUtils.getGeneralsBySide("player") == 0 then
                    printInfo("开场剧情中无我方部队，则直接跳过我方回合")
                    EventMgr.triggerEvent(EventConst.PLOT_SKIP_PLAYER_TURN, GameData.getCurRound())
                else
                    EventMgr.triggerEvent(EventConst.AUTO_SAVE_DATA)
                end
            end)
        end)
    end
end

SPlotRunner.onExit = function(self)
    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil

    EventMgr.triggerEvent(EventConst.PLOT_OVER)
end

SPlotRunner.initEventHandles = function(self)
    self.handlers = {
        [EventConst.PLOT_CHECK_CONDTION] = handler(self, self.checkConditions),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

SPlotRunner.initBattlePrepareInfo = function(self, battlePrepare)
    if not GameData.isSkipBattleStartPlot() then
        local playerList = self.playerList or battlePrepare.playerGeneralList
        local friendList = battlePrepare.friendGeneralList or {} -- 其中友军可以不存在的
        local enemyList = battlePrepare.enemyGeneralList
        GameData.initBattleInfo(battlePrepare.mapId, battlePrepare.maxRounds, battlePrepare.battleName, battlePrepare.levelAdd, battlePrepare.weatherStart, battlePrepare.weatherType, playerList, friendList, enemyList)
    else
        self.ui:show()
    end

    GameData.initMapView()
end

SPlotRunner.initBattleConditionInfo = function(self, battleConditonPlot)
    self.conditonPlot = {}
    self.conditionVarTestPlot = {}

    table.walk(battleConditonPlot, function(plot)
        if plot[1].cmd == "VarTest" then
            table.insert(self.conditionVarTestPlot, plot)
        else
            table.insert(self.conditonPlot, plot)
        end
    end)
end

SPlotRunner.initBattleEndInfo = function(self, battleEndPlot)
    self.battleEndPlot = battleEndPlot or {}
end

SPlotRunner.initUI = function(self)
    self.ui = SPlotUI.new()
    self.ui:addTo(self, 100)
end

SPlotRunner.runEndPlot = function(self)
    self:runPlot(self.battleEndPlot, function()
        printInfo("执行S结束剧本完毕，正在准备执行R剧本")
        EventMgr.triggerEvent(EventConst.NEXT_PLOT, "r", string.format("%02d", self.nextPlotIndex))
    end)
end

SPlotRunner.runPlot = function(self, plot, callback)
    local onPlotComplete = function()
        EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, "战中检测剧情")

        if self.isBattleOver then
            printInfo("S剧本战斗结束")
            self.isBattleOver = nil -- 不清除，会导致这里EndPlot无法执行到callback
        elseif callback then
            callback()
        end
    end

    EventMgr.triggerEvent(EventConst.ADD_NONTOUCH_LAYER, "战中检测剧情")

    table.oneByOne(plot, function(action, nextCallback, plotIndex)
        if #action > 0 then
            -- 记录当前子事件的父事件，用于else中向前判断
            action.parentPlot = plot
            action.parentPlotIndex = plotIndex
            self:runPlot(action, nextCallback)
        else
            local cmdHandler = self["cmd" .. action.cmd]
            if cmdHandler then
                local argsString = ""
                for _, v in ipairs(action.args or {}) do
                    argsString = argsString .. " " .. tostring(v)
                end
                printInfo("执行命令：%s, 参数：%s", action.cmd, argsString)
                cmdHandler(self, action.args, nextCallback, plot, plotIndex)
            else
                local conditionHandler = self["condition" .. action.cmd]
                if conditionHandler then
                    local isSuccess = conditionHandler(self, action.args, plot, plotIndex)
                    if isSuccess then
                        nextCallback()
                    else
                        printInfo("该事件检测失败(%s)，直接执行最终回调处理", action.cmd)
                        onPlotComplete()
                    end
                else
                    printInfo("尚未实现该命令(%s)，直接执行最终回调处理", action.cmd)
                    onPlotComplete()
                end
            end
        end
    end, onPlotComplete)
end

-- 武将状态变更 武将id 要改变的数值 如何改变 异常状态 HP减少量
SPlotRunner.cmdGeneralStatusChange = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_STATUS_CHANGE, args[1], args[2], args[3], args[4], args[5], args[6], callback)
end

-- CD音轨设定 音轨序号
SPlotRunner.cmdPlayMusic = function(self, args, callback)
    AudioMgr.playMusic(args[1], true)
    callback()
end

-- 音效设定 音效类型 重复次数
SPlotRunner.cmdPlaySound = function(self, args, callback)
    AudioMgr.playSound(args[1])
    callback()
end

-- 对话 武将id 对话内容
SPlotRunner.cmdDialog = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_SHOW_DIALOG, args[1], args[2], callback)
end

-- 剧本延迟 二十分之一秒
SPlotRunner.cmdDelay = function(self, args, callback)
    if UserConfig:getBoolForKey("QuickDialog", true) then
        self:performWithDelay(callback, MIDDLE_ANIMATION_TIME)
    else
        self:performWithDelay(callback, args[1] / 20)
    end
end

-- 战场动作设定 武将id 武将动作
SPlotRunner.cmdGeneralAction = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_ACTION, args[1], args[2], "", callback)
end

-- 战场撤退 武将id 是否死亡
SPlotRunner.cmdGeneralRetreat = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_RETREAT, args[1], args[2], callback)
end

-- 武将面对面 武将1id 武将2id
SPlotRunner.cmdFaceToFace = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_FACE_TO_FACE, args[1], args[2], callback)
end

-- 武将改变方向 武将id 方向
SPlotRunner.cmdGeneralChangeDirection = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_ACTION, args[1], "move", args[2], callback)
end

-- 胜利失败条件 胜利失败条件内容
SPlotRunner.cmdBattleWinCondition = function(self, args, callback)
    self.winConditions = string.split(args[1], "\n")
    callback()
end

-- 变量赋值 变量名 变量值
SPlotRunner.cmdVarSet = function(self, args, callback)
    GameData.setVar(args[1], args[2])
    callback()
end

-- 战斗菜单显示
SPlotRunner.cmdShowMenu = function(self, args, callback)
    self.ui:show()
    callback()
end

-- 隐藏武将出现 武将id
SPlotRunner.cmdGeneralShow = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_SHOW_GENERAL, args[1], callback)
end

-- 武将移动 武将id 方向 col row
SPlotRunner.cmdRoleMove = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_SHOW_GENERAL_MOVE, args[1], args[2], args[3], args[4], callback)
end

-- 放火 横坐标 纵坐标
SPlotRunner.cmdAddFire = function(self, args, callback)
    -- 如果是在战场开场动画中则不延迟，全部火直接加载好
    EventMgr.triggerEvent(EventConst.PLOT_ADD_FIRE, args[1], args[2], callback)
end

-- 特殊动画 为朱雀做的特殊的处理，这里是有一个开始位置移动到一个位置去，事实上，可以完全居中显示即可
SPlotRunner.cmdSpecialAnimation = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_SHOW_SPECIAL_ANIMATION, args[1], args[2], args[3], args[4], args[5], callback)
end

-- 指定范围内的武将状态变更 武将阵营 范围(列1 行1 列2 行2) 要改变的数值 如何改变 异常状态 HP减少量
SPlotRunner.cmdRangeGeneralsStatusChange = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_RANGE_CHANGE_STATUS, args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], callback)
end

-- 武将方针变更 武将id ai类型 ai指定攻击目标 ai指定位置(列 行)
SPlotRunner.cmdGeneralAiChange = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_CHANGE_AI, args[1], args[2], args[3], args[4], args[5], callback)
end

-- 显示玩家武将 玩家武将剧本id
SPlotRunner.cmdPlayerGeneralShow = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_SHOW_GENERAL, args[1], callback)
end

-- 战场大字显示 显示内容
SPlotRunner.cmdShowBattleWinCondition = function(self, args, callback)
    local BattleCondition = import("..battle.battle_condition_layer", CURRENT_MODULE_NAME)
    BattleCondition.new(args[1], GameData.getMaxRounds(), callback)
end

-- 战场高亮人物 武将id
SPlotRunner.cmdHighlightGeneral = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.HIGHLIGHT_GENERAL, args[1], callback)
end

-- 获得物品 物品代码 物品等级（0表默认）
SPlotRunner.cmdAddItem = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_ADD_ITEM, args[1], args[2], callback)
end

-- 战场撤退 阵营 范围 撤退还是死亡
SPlotRunner.cmdRangeGeneralsRetreat = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_RANGE_RETREAT, args[1], args[2], args[3], args[4], args[5], args[6], callback)
end

-- 战场上所有人恢复未行动状态（同时HPMP恢复满）
SPlotRunner.cmdAllGeneralsRecover = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_ALL_GENERALS_RECOVER, callback)
end

-- 额外战利品信息 金钱 宝物 宝物等级 宝物 宝物等级 宝物 宝物等级 是否为结局
SPlotRunner.cmdBattleExtraItems = function(self, args, callback)
    self.ui:hide()

    local BattleWinUI = import("..studio_ui.battle_win_ui", CURRENT_MODULE_NAME)
    if args[8] then
        assert(false, "游戏结局，暂不处理")
    else
        GameData.addBattleRewardItems(args[1], {{args[2], args[3]}, {args[4], args[5]}, {args[6], args[7]}})
        BattleWinUI.new(function()
            self:runEndPlot()
        end):addTo(self)

        callback()
    end
end

-- Tip弹框
SPlotRunner.cmdTip = function(self, args, callback)
    TipUtils.showTip(args[1], FontBlueColor, callback)
end

-- 战斗失败界面
SPlotRunner.cmdBattleLose = function(self, args, callback)
    local BattleLose = import("..battle.battle_lose_layer", CURRENT_MODULE_NAME)
    BattleLose.new(callback)
end

-- 设置战斗结束标志
SPlotRunner.cmdBattleOver = function(self, args, callback)
    -- 这里需要继续执行几个命令，所以在这里设置战斗结束标记，然后在runPlot的最终callback中终止s剧本解析
    self.isBattleOver = true
    EventMgr.triggerEvent(EventConst.BATTLE_OVER)
    callback()
end

-- 剧本跳转 跳过的剧本
SPlotRunner.cmdPlotJump = function(self, args, callback)
    self.nextPlotIndex = args[1]
    callback()
end

-- 武将移动 我方武将出场顺序 横坐标 纵坐标 朝向
SPlotRunner.cmdPlayerGeneralMove = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_SHOW_GENERAL_MOVE, args[1], args[4], args[2], args[3], callback)
end

-- 范围内武将ai改变 阵营 范围 ai类型 ai额外参数
SPlotRunner.cmdRangeGeneralsAiChange = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_RANGE_CHANGE_AI, args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], callback)
end

-- 武将消失 武将id
SPlotRunner.cmdRoleDisappear = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_DISAPPEAR, args[1], callback)
end

-- 单挑开始 武将1id 武将2id
SPlotRunner.cmdPkPrepare = function(self, args, callback)
    -- 首先加载出单挑界面
    EventMgr.triggerEvent(EventConst.PK_SHOW_VIEW, function()
        EventMgr.triggerEvent(EventConst.PK_PREPARE, args[1], args[2], callback)
    end)
end

-- 战场障碍物设置 障碍物 设置障碍物（0设置，1取消）地形1 横坐标 纵坐标 是否延迟
SPlotRunner.cmdAddObstacle = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_ADD_OBSTACLE, args[1], args[2], args[3], args[4], args[5], args[6] or false, callback)
end

-- 战场地点高亮显示 左上角横坐标 左上角纵坐标 右下角横坐标 右下角纵坐标 是否在战斗中（此参数未用到）
SPlotRunner.cmdHighlightRange = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.HIGHLIGHT_RANGE, args[1], args[2], args[3], args[4], callback)
end

-- 最大回合数设定 设定方式 回合数
SPlotRunner.cmdRoundsSet = function(self, args, callback)
    GameData.setMaxRounds(args[1])
    callback()
end

-- 战场复活 武将id 列 行 朝向
SPlotRunner.cmdGeneralReborn = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_REBORN, args[1], args[2], args[3], args[4], callback)
end

-- 战场复活 玩家武将index 列 行 朝向
SPlotRunner.cmdPlayerGeneralReborn = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_REBORN, args[1], args[2], args[3], args[4], callback)
end

-- 武将升级 武将id 等级上升数
SPlotRunner.cmdGeneralAddLevel = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_ADD_LEVEL, args[1], args[2], callback)
end

-- 野心设置 设置方式 设置数值
SPlotRunner.cmdAddCareerism = function(self, args, callback)
    if args[1] == "=" then
        GameData.setCareerism(args[2])
    elseif args[1] == "+" then
        EventMgr.triggerEvent(EventConst.PLOT_ADD_CAREERISM, -args[2])
    else
        EventMgr.triggerEvent(EventConst.PLOT_ADD_CAREERISM, args[2])
    end
    callback()
end

-- 金钱设置 正数或负数
SPlotRunner.cmdAddMoney = function(self, args, callback)
    GameData.addMoney(args[1])
    callback()
end

-- 个人装备设定 武将id 武器 武器等级（0表默认） 护具 护具等级（0表默认） 辅助装备
SPlotRunner.cmdGeneralEquipsSet = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_INIT_EQUIP, args[1], args[2], args[3], args[4], args[5], args[6], callback)
end

-- 我军出场设定 武将index 列 行 朝向 是否隐藏
SPlotRunner.cmdPlayerGeneralInit = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_PLAYER_INIT, args[1], args[2], args[3], args[4], args[5], callback)
end

-- 武将状态变更 玩家武将index 要改变的数值 如何改变 异常状态 HP减少量
SPlotRunner.cmdPlayerGeneralStatusChange = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERAL_STATUS_CHANGE, args[1], args[2], args[3], args[4], args[5], args[6], callback)
end

-- 视角中心变化 横坐标 纵坐标
SPlotRunner.cmdMoveToPos = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.MOVE_TO_POS, args[1], args[2])
    callback()
end

-- 我方撤退语录是否显示 武将id 是否显示
SPlotRunner.cmdShowPlayerRetreatWords = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_SHOW_PLAYER_RETREATWORDS, args[1], args[2], callback)
end

--!! 结局设定 结局设定（0红，1金，2蓝）
SPlotRunner.cmdGameWin = function(self, args, callback)
    callback()
end

-- 单挑武将出场 出场武将id 是否是左边武将 武将说的话 动作
SPlotRunner.cmdPkGeneralShow = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PK_GENERAL_SHOW, args[1], args[2], args[3], callback)
end

-- 单挑显示"胜 负"字样
SPlotRunner.cmdPkShowStart = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PK_SHOW_START, callback)
end

-- 单挑时动作 是否是左边武将 动作
SPlotRunner.cmdPkGeneralAction = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PK_GENERAL_ACTION, args[1], args[2], callback)
end

-- 单挑时说话 是否是左边武将 说话内容 是否延时
SPlotRunner.cmdPkShowDialog = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PK_SHOW_DIALOG, args[1], args[2], args[3], callback)
end

-- 单挑攻击 攻击方 单挑攻击方式 攻击是否没命中
SPlotRunner.cmdPkGeneralAttack = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PK_GENERAL_ATTACK, args[1], args[2], args[3], callback)
end

-- 单挑攻击 攻击方 单挑攻击方式 是否是致命一击攻击
SPlotRunner.cmdPkGeneralAttack2 = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PK_GENERAL_ATTACK2, args[1], args[2], args[3], callback)
end

-- 单挑阵亡 是否是左边武将
SPlotRunner.cmdPkGeneralDie = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PK_GENERAL_DIE, args[1], callback)
end

-- 单挑结束
SPlotRunner.cmdPkOver = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PK_OVER, callback)
end

-- 选择框 武将id 选择内容表
SPlotRunner.cmdChoiceDialog = function(self, args, callback, plot, plotIndex)
    local choices = {}
    for i, v in ipairs(args[2]) do
        local choiceInfo = {}
        choiceInfo[1] = i .. "、" .. v
        choiceInfo[2] = function()
            -- 目前仅处理2个选择和3个选择的
            if #args[2] == 2 then
                if i == 1 then
                    table.remove(plot, plotIndex + 2)
                else
                    table.remove(plot, plotIndex + 1)
                end
            elseif #args[2] == 3 then
                if i == 1 then
                    table.remove(plot, plotIndex + 2)
                    table.remove(plot, plotIndex + 2)
                elseif i == 2 then
                    table.remove(plot, plotIndex + 1)
                    table.remove(plot, plotIndex + 2)
                else
                    table.remove(plot, plotIndex + 1)
                    table.remove(plot, plotIndex + 1)
                end
            else
                assert(false, "尚未处理3个选择以上的内容")
            end
        end
        table.insert(choices, choiceInfo)
    end

    EventMgr.triggerEvent(EventConst.PLOT_SHOW_CHOICES, args[1], choices, callback)
end

-- 范围内武将消失 阵营 范围
SPlotRunner.cmdGeneralsDisappear = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.PLOT_GENERALS_DISAPPEAR, args[1], args[2], args[3], args[4], args[5], callback)
end

-- 检查所有的战中条件测试
SPlotRunner.checkConditions = function(self, callback)
    Profiler.checkStart("SPlotRunner.checkConditions")

    table.oneByOne(self.conditonPlot, function(plot, nextCallback)
        table.oneByOne(plot, function(action, nextCallback2, plotIndex)
            if #action > 0 then
                -- 记录当前子事件的父事件，用于else中向前判断
                action.parentPlot = plot
                action.parentPlotIndex = plotIndex
                self:runPlot(action, nextCallback2)
            else
                printInfo("检查所有的战中条件测试:%s:%d", action.cmd, plotIndex)
                local conditionHandler = self["condition" .. action.cmd]
                if conditionHandler and conditionHandler(self, action.args, plot, plotIndex) then
                    nextCallback2()
                else
                    nextCallback()
                end
            end
        end, nextCallback)
    end, function()
        printInfo("检查条件测试")
        -- 专门检查只有条件测试的事件
        table.oneByOne(self.conditionVarTestPlot, function(plot, nextCallback)
            table.oneByOne(plot, function(action, nextCallback2, plotIndex)
                if #action > 0 then
                    -- 记录当前子事件的父事件，用于else中向前判断
                    action.parentPlot = plot
                    action.parentPlotIndex = plotIndex
                    self:runPlot(action, nextCallback2)
                else
                    local conditionHandler = self["condition" .. action.cmd]
                    if conditionHandler and conditionHandler(self, action.args, plot, plotIndex) then
                        nextCallback2()
                    else
                        nextCallback()
                    end
                end
            end, nextCallback)
        end, function()
            printInfo("checkConditions检测完毕")
            Profiler.checkEnd()
            callback()
        end)
    end)
end

SPlotRunner._checkTwo = function(self, left, right, equalWay)
    if equalWay == "=" then
        return (left == right)
    elseif equalWay == "<" then
        return left < right
    elseif equalWay == ">=" then
        return left >= right
    else
        assert(false, "undo .. " .. equalWay)
    end
end

-- 回合测试 回合数 关系，行动顺序
SPlotRunner.conditionRoundsTest = function(self, actionArgs)
    return self:_checkTwo(GameData.getCurRound(), actionArgs[1], actionArgs[2])
end

-- 行动顺序测试 行动顺序
SPlotRunner.conditionSideTest = function(self, actionArgs)
    return GameData.getCurSide() == actionArgs[1]
end

-- 武将进入指定地点测试 阵营 横坐标 纵坐标
SPlotRunner.conditionEnterTileTest = function(self, actionArgs)
    local targets = MapUtils.getGeneralsBySide(actionArgs[1])
    for _, target in ipairs(targets) do
        if target:getCol() == actionArgs[2] and target:getRow() == actionArgs[3] then
            return true
        end
    end
end

-- 武将相邻测试 武将1id 武将2id(或阵营) 是否要求在攻击范围内
SPlotRunner.conditionGeneralMeetTest = function(self, actionArgs)
    local target = MapUtils.getGeneralById(actionArgs[1])
    if target and target:isAlive() then
        local aroundTargets = actionArgs[3] and target:getAttackTargets() or target:getAroundTargets()
        if type(actionArgs[2]) == "table" then
            return table.findIf(aroundTargets, function(general)
                return table.indexof(actionArgs[2], general:getSide())
            end)
        else
            return table.findIf(aroundTargets, function(general)
                return general:getId() == actionArgs[2]
            end)
        end
    end
end

-- 武将状态测试 武将id 要测试的参数 与这个数字比较 比较关系
SPlotRunner.conditionGeneralPropTest = function(self, actionArgs)
    local target = MapUtils.getGeneralById(actionArgs[1], true)
    if target then
        if actionArgs[2] == "HPCur" then
            return self:_checkTwo(target:getCurrentHp(), actionArgs[3], actionArgs[4])
        else
            assert(false, "undo " .. actionArgs[2])
        end
    end
end

-- 武将进入指定区域测试 阵营 左上角横坐标 左上角纵坐标 右下角横坐标 右下角纵坐标
SPlotRunner.conditionEnterRangeTest = function(self, actionArgs)
    local sides, col1, row1, col2, row2 = actionArgs[1], actionArgs[2], actionArgs[3], actionArgs[4], actionArgs[5]
    local targets = MapUtils.getGeneralsBySide(actionArgs[1])
    for _, target in ipairs(targets) do
        if math.isInRange(target:getCol(), col1, col2) and math.isInRange(target:getRow(), row1, row2) then
            return true
        end
    end
end

-- 战场人数测试 归属 人数 关系 测试范围 左上角横坐标 左上角纵坐标 右下角横坐标 右下角纵坐标
SPlotRunner.conditionGeneralCountsTest = function(self, actionArgs)
    local sides, counts, equalWay = actionArgs[1], actionArgs[2], actionArgs[3]
    if actionArgs[4] == "整个战场" then
        local targets = MapUtils.getGeneralsBySide(sides)
        return self:_checkTwo(#targets, counts, equalWay)
    elseif actionArgs[4] == "指定区域" then
        local col1, row1, col2, row2 = actionArgs[5], actionArgs[6], actionArgs[7], actionArgs[8]
        local targets = MapUtils.getRangeGeneralsBySide(col1, row1, col2, row2, sides)
        return self:_checkTwo(#targets, counts, equalWay)
    else
        assert(false, "undo " .. actionArgs[4])
    end
end

-- 变量测试 变量名(正数表明检验是否为ture, 负数表明检验是否为nil或false)
SPlotRunner.conditionVarTest = function(self, actionArgs)
    local isSuccess = GameData.checkVars(actionArgs[1].trueConditions, actionArgs[1].falseConditions)
    local varString = ""
    if actionArgs[1].trueConditions then
        varString = table.concat(actionArgs[1].trueConditions, ",")
    end
    if actionArgs[1].falseConditions then
        varString = varString .. "|" .. table.concat(actionArgs[1].falseConditions, ",")
    end
    printInfo("变量测试(%s)为%s", varString, isSuccess and "true" or "false")

    return isSuccess
end

-- else命令，用于执行vartest为false的事件
SPlotRunner.conditionElse = function(self, actionArgs, plot, plotIndex)
    local prevCmd = plot.parentPlot[plot.parentPlotIndex - 1][1]
    assert(prevCmd.cmd == "VarTest", "Else的父事件的上一个命令必定是VarTest")
    return not self:conditionVarTest(prevCmd.args)
end

-- 战斗胜利测试，固定测试，判断所有敌人是否已死亡
SPlotRunner.conditionBattleWinTest = function(self, actionArgs)
    return #MapUtils.getAllEnemiesGeneral() == 0
end

-- 战斗失败测试，仅需检测玩家武将是否存活
SPlotRunner.conditionBattleLoseTest = function(self, actionArgs)
    printInfo("战斗失败测试检测:%s", MapUtils.isGeneralAlive("player", 0) and "false" or "true")
    return not MapUtils.isGeneralAlive("player", 0)
end

-- 忠奸度测试 与这个数值比较 比较关系
SPlotRunner.conditionCareerismTest = function(self, actionArgs)
    return self:_checkTwo(GameData.getCareerism(), actionArgs[1], actionArgs[2])
end

-- 金钱测试 与这个数值比较 比较关系
SPlotRunner.conditionMoneyTest = function(self, actionArgs)
    return self:_checkTwo(GameData.getMoney(), actionArgs[1], actionArgs[2])
end

return SPlotRunner