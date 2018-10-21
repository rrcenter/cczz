--[[
    R剧本执行器
--]]

local CURRENT_MODULE_NAME = ...
local ANIMATION_TIME      = 0.2

local RRoleInfo     = import(".r_role_info")
local RPlotRole     = import(".r_plot_role")
local RPlotConst    = import(".r_plot_const")
local RPlotRoleInfo = import(".r_role_info")
local RPlotUI       = import("..studio_ui.r_plot_ui")

local RPlotRunner = class("RPlotRunner", function()
    return display.newNode()
end)

RPlotRunner.ctor = function(self, rplotIndex)
    ResMgr.init()

    self.roles = {} -- 记录所有rolePlay产生的角色
    self.heads = {} -- 记录所有headPortraitPlay产生的头像
    self.plotIndex = rplotIndex

    self:initMapGrid()
    self:initEventHandler()
    self:initUI()
    self:setNodeEventEnabled(true)
end

RPlotRunner.run = function(self)
    local rPlotInfo = import("..data.rplot.r_plot" .. self.plotIndex, CURRENT_MODULE_NAME)
    self:runScenes(rPlotInfo, GameData.getSkipSceneCounts())
end

RPlotRunner.initEventHandler = function(self)
    self.handlers = {
        [EventConst.ROLE_PRESSED_PLOT]  = handler(self, self.runPlot),
        [EventConst.FIGHT_PRESSED_PLOT] = handler(self, self.runFightPressPlot),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

RPlotRunner.initUI = function(self)
    self.ui = RPlotUI.new()
    self.ui:addTo(self, 100)
end

RPlotRunner.onExit = function(self)
    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil

    EventMgr.triggerEvent(EventConst.PLOT_OVER)
end

-- 初始化那些需要合并的连续命令
RPlotRunner.unionCmds = function(self, plotInfo)
    local unionSignleCmd = function(cmdName)
        local newSection = {}
        local continueCmds = {}

        for i, action in ipairs(plotInfo) do
            if action.cmd == cmdName then
                table.insert(continueCmds, action)
            elseif action.cmd ~= cmdName and #continueCmds > 0 then
                local combinationCmd = {}
                combinationCmd.cmd = continueCmds[1].cmd
                combinationCmd.args = {}
                for _, v in ipairs(continueCmds) do
                    table.insert(combinationCmd.args, v.args)
                end
                table.insert(newSection, combinationCmd)
                continueCmds = {}

                table.insert(newSection, action)
            else
                table.insert(newSection, action)
            end
        end

        plotInfo = newSection
    end

    if RPLOT_UNION_ROLEMOVE then
        unionSignleCmd("RoleMove")
    end

    if RPLOT_UNION_SCENE_DIALOG then
        unionSignleCmd("SceneDialog")
    end

    return plotInfo
end

-- 计算菱形网格，这里暂时写死，地图实际大小为640*400，菱形顶点设置为地图中心以上高几百个像素处
RPlotRunner.initMapGrid = function(self)
    local ZeroPoint = cc.p(340, 620)
    local size = {w = 8, h = 4}
    local grid = {}
    local len = 100
    for row = 0, len do
        grid[row] = {}
        for col = 0, len do
            grid[row][col] = cc.p(ZeroPoint.x - (col - row) * size.w, ZeroPoint.y - (col + row) * size.h)
        end
    end

    self.gridLen = len
    self.grid    = grid
end

RPlotRunner.runScenes = function(self, plot, skipSceneCounts)
    skipSceneCounts = skipSceneCounts or 0
    table.oneByOne(plot, function(scene, nextCallback, sceneIndex)
        EventMgr.triggerEvent(EventConst.UPDATE_SCENE_INDEX, sceneIndex)

        if sceneIndex < skipSceneCounts then
            printInfo("略过第%d个Scene", sceneIndex)
            nextCallback()
        else
            printInfo("正在执行第%d个Scene", sceneIndex)
            self:runSections(scene, nextCallback)
        end
    end, function()
        printInfo("所有的Scene执行完毕")

        if not self.isShowMenu then
            printInfo("没有出兵等按钮，直接跳转到战斗部分:%s", self.plotIndex)
            EventMgr.triggerEvent(EventConst.NEXT_PLOT, "s", self.plotIndex, self.playerList)
        end
    end)
end

RPlotRunner.runSections = function(self, scene, callback)
    table.oneByOne(scene, function(section, nextCallback, sectionIndex)
        EventMgr.triggerEvent(EventConst.UPDATE_SECTION_INDEX, sectionIndex)

        printInfo("正在执行第%d个Section", sectionIndex)
        self:runPlot(section, nextCallback)
    end, function()
        if self.isHookPlot then
            printInfo("需要hook在该剧情，点击出兵按钮以后，才允许继续下面的剧情Scene")
            self.ui:setFinalCallback(callback)
        elseif callback then
            callback()
        end
    end)
end

RPlotRunner.runPlot = function(self, plot, callback)
    printInfo("开始执行剧情")

    local curPlot = self:unionCmds(plot)
    table.oneByOne(curPlot, function(action, nextCallback, plotIndex)
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
                cmdHandler(self, action.args, nextCallback, curPlot, plotIndex)
            else
                local conditionHandler = self["condition" .. action.cmd]
                if conditionHandler then
                    local isSuccess = conditionHandler(self, action.args, plot, plotIndex)
                    if isSuccess then
                        nextCallback()
                    else
                        printInfo("该事件检测失败(%s)，直接执行最终回调处理", action.cmd)
                        callback()
                    end
                else
                    printInfo("尚未实现该命令(%s)，直接执行最终回调处理", action.cmd)
                    callback()
                end
            end
        end
    end, function()
        printInfo("剧情结束")
        if callback then
            callback()
        end
    end)
end

RPlotRunner.runFightPressPlot = function(self, plot, playerList, callback)
    self.isHookPlot = nil
    self.playerList = playerList
    self:runPlot(plot, callback)
end

RPlotRunner.showDebugGrid = function(self, bg)
    local len = self.gridLen
    for i = 0, len do
        local point1 = {self.grid[0][i].x, self.grid[0][i].y}
        local point2 = {self.grid[len][i].x, self.grid[len][i].y}
        display.newLine({point1, point2}, {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0), borderWidth = 1}):addTo(self.bg, 2)

        local point3 = {self.grid[i][0].x, self.grid[i][0].y}
        local point4 = {self.grid[i][len].x, self.grid[i][len].y}
        display.newLine({point3, point4}, {borderColor = cc.c4f(1.0, 0.0, 0.0, 1.0), borderWidth = 1}):addTo(self.bg, 2)
    end
end

RPlotRunner.clearPlotObjs = function(self)
    -- 一旦切换场景，清空之前赋值处理
    if self.roles then
        table.walk(self.roles, function(role)
            role:removeSelf()
        end)
    end

    if self.heads then
        table.walk(self.heads, function(head)
            head:removeSelf()
        end)
    end

    self.roles = {} -- 记录所有rolePlay产生的角色
    self.heads = {} -- 记录所有headPortraitPlay产生的头像

    if self.bg then
        self.bg:removeSelf()
        self.bg = nil
    end
end

-- 创建背景 参数:背景底图的路径
RPlotRunner.cmdLoadBackground = function(self, args, callback)
    self:clearPlotObjs()

    local mapId = string.sub(args[1], 6)
    self.bg = display.newSprite("ccz/tmx/rmap/" .. args[1] .. ".jpg"):addTo(self)
    self.bg:center()
    self.mapSize = self.bg:getContentSize()
    self.bg:setScale(display.width / self.mapSize.width, display.height / self.mapSize.height)
    callback()

    if DEBUG_SHOW_RPLOT_GRID then
        self:showDebugGrid(self.bg)
    end
end

-- 武将出现 横坐标 纵坐标 朝向 武将序号 动作形态
RPlotRunner.cmdRolePlay = function(self, args, callback)
    local roleName, col, row, dir, roleId, actionId = args[1], args[2], args[3], args[4], args[5], args[6]
    local pos = self.grid[col][row]
    local role = RPlotRole.new(roleName, col, row, dir, self.bg)
    role:pos(pos.x, pos.y)

    if self.roles[roleId] then
        self.roles[roleId]:removeSelf()
    end
    self.roles[roleId] = role

    role:playAction(actionId, callback)
end

-- 武将移动 {武将序号 朝向 横坐标 纵坐标}多个
RPlotRunner.cmdRoleMove = function(self, args, callback)
    local walkDoneCount = 0
    local onWalkDone = function()
        walkDoneCount = walkDoneCount + 1
        if walkDoneCount >= #args then
            callback()
        end
    end

    table.walk(args, function(arg)
        local roleId, dir, col, row = arg[1], arg[2], arg[3], arg[4]
        local role = self.roles[roleId]
        if role then
            role:move(col, row, function()
                role:playAction(0, onWalkDone, dir)
            end)
        else
            printInfo("该角色(%s)不存在，无法移动！", roleId)
            onWalkDone()
        end
    end)
end

-- 角色消失 参数:角色id
RPlotRunner.cmdRoleDisappear = function(self, args, callback)
    local role = self.roles[args[1]]
    if role then
        role:disappear(function()
            self.roles[args[1]] = nil
            callback()
        end)
    else
        printInfo("该角色(%s)不存在，无法消失！", args[1])
        callback()
    end
end

-- 头像出现 参数:对应头像 坐标 头像id
RPlotRunner.cmdHeadPortraitPlay = function(self, args, callback)
    local roleName, x, y, headId = args[1], args[2], args[3], args[4]
    x, y = x, self.mapSize.height - y

    if not RPlotRoleInfo[roleName] then
        roleName = string.gsub(roleName, "[%d]+", "")
    end
    local headPath = RPlotRoleInfo[roleName].head
    local head = display.newSprite(headPath, x, y):addTo(self.bg)
    head:opacity(0)
    head:align(display.LEFT_TOP)
    head:fadeIn(ANIMATION_TIME)
    head:performWithDelay(callback, ANIMATION_TIME)

    if self.heads[headId] then
        self.heads[headId]:removeSelf()
    end
    self.heads[headId] = head
end

-- 头像移动 参数:头像id 坐标
RPlotRunner.cmdHeadPortraitMove = function(self, args, callback)
    local headId, x, y = args[1], args[2], args[3]
    x, y = x, self.mapSize.height - y

    local head = self.heads[headId]
    if head then
        head:moveTo(ANIMATION_TIME, x, y)
        head:performWithDelay(callback, ANIMATION_TIME)
    else
        printInfo("该头像(%d)不存在，无法移动", headId)
        callback()
    end
end

-- 头像消失 参数:头像id
RPlotRunner.cmdHeadPortraitDisappear = function(self, args, callback)
    local head = self.heads[args[1]]
    if head then
        head:fadeOut(ANIMATION_TIME)
        head:performWithDelay(function()
            head:removeSelf()
            self.heads[args[1]] = nil
            callback()
        end, ANIMATION_TIME)
    else
        printInfo("该头像(%d)不存在，无法移动", headId)
        callback()
    end
end

-- 剧本介绍 参数:半透明遮罩大字显示
RPlotRunner.cmdSceneIntroduce = function(self, args, callback)
    if RPLOT_QUICK_TEST then
        callback()
        return
    end

    local layer = display.newColorLayer(LayerLightBlackColor)
    local label1 = cc.ui.UILabel.new({text = args[1], size = FontSuperSize, font = FontName})
    label1:align(display.CENTER, display.cx, display.height * 0.75)
    label1:addTo(layer)

    local label2 = cc.ui.UILabel.new({text = args[2], size = FontSuperSize, font = FontName})
    label2:align(display.CENTER, display.cx, display.height * 0.45)
    label2:addTo(layer)

    layer:addTo(self)

    local time = ANIMATION_TIME * 2
    layer:performWithDelay(function()
        layer:removeSelf()
        callback()
    end, time)
end

-- 剧本提示 参数
RPlotRunner.cmdTip = function(self, args, callback)
    TipUtils.showTip(args[1], FontBlueColor, callback)
end

-- 角色对话 参数:角色名字 对话内容
RPlotRunner.cmdDialog = function(self, args, callback)
    if RPLOT_QUICK_TEST then
        callback()
        return
    end

    local handleSingleDialog = function(dialogInfo, dialogCallback)
        local roleId, name, content = dialogInfo[1], dialogInfo[1], dialogInfo[2]
        local role = self.roles[roleId]
        if role then
            role:say(name, content, dialogCallback)
        else
            printInfo("该角色(%s)不存在，无法进行对话！", dialogInfo[1])
            dialogCallback()
        end
    end

    if RPLOT_UNION_DIALOG then
        -- 这里就是将多个对话合并到一个命令中处理
        table.oneByOne(args, function(arg, nextCallback)
            handleSingleDialog(arg, nextCallback)
        end, callback)
    else
        handleSingleDialog(args, callback)
    end
end

-- 角色选择 武将id 选择内容
RPlotRunner.cmdChoiceDialog = function(self, args, callback, plot, plotIndex)
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

            callback()
        end
        table.insert(choices, choiceInfo)
    end

    local role = self.roles[args[1]]
    if role then
        role:makeChoices(choices)
    else
        printInfo("该角色(%s)不存在，无法进行选择！", args[1])
        callback()
    end
end

-- 武将动作 武将序号 动作形态
RPlotRunner.cmdRoleAction = function(self, args, callback)
    local roleId, actionId = args[1], args[2]
    local role = self.roles[roleId]
    if role then
        role:playAction(actionId, callback)
    else
        printInfo("该角色(%s)不存在，无法播放剧本动作", roleId)
        callback()
    end
end

-- 武将转向 武将序号 动作形态 朝向
RPlotRunner.cmdRoleChangeDirection = function(self, args, callback)
    local roleId, dir, actionId = args[1], args[2], args[3]
    local role = self.roles[roleId]
    if role then
        role:playAction(actionId, callback, dir)
    else
        printInfo("该角色(%s)不存在，无法播放剧本动作", roleId)
        callback()
    end
end

-- R剧本武将形象改变 武将序号 形象Id
RPlotRunner.cmdRoleChange = function(self, args, callback)
    local roleId, resId = args[1], args[2]
    RRoleInfo[roleId].red = math.floor(resId / 2)
    callback()
end

-- 忠奸度设置 设定方式(增加 较少 设置) 数值
RPlotRunner.cmdAddCareerism = function(self, args, callback)
    -- 当增加或减少时需要通知界面更新
    if args[1] == "=" then
        GameData.setCareerism(args[2])
        callback()
    elseif args[1] == "+" then
        EventMgr.triggerEvent(EventConst.PLOT_ADD_CAREERISM, -args[2], callback)
    else
        EventMgr.triggerEvent(EventConst.PLOT_ADD_CAREERISM, args[2], callback)
    end
end

-- 剧本延迟 十分之一秒
RPlotRunner.cmdDelay = function(self, args, callback)
    if UserConfig:getBoolForKey("QuickDialog", true) then
        self:performWithDelay(callback, MIDDLE_ANIMATION_TIME)
    else
        self:performWithDelay(callback, args[1] / 10)
    end
end

-- 场景对话，场景底部黑色渐隐对话
RPlotRunner.cmdSceneDialog = function(self, args, callback)
    if RPLOT_QUICK_TEST then
        callback()
        return
    end

    -- 这里是由于之前合并了连续的场景对话，所以这里需要这样处理下
    local content = {}
    table.walk(args, function(arg)
        table.insert(content, arg[1])
    end)
    SceneDialogUtils.ShowDialog(table.concat(content, "\n"), callback)
end

-- 菜单处理 是否显示，也就是出兵按钮那一排的按钮
RPlotRunner.cmdShowMenu = function(self, args, callback)
    self.isShowMenu = args[1] -- 用来控制是否最终剧本结束自动跳转到s剧本，如果这里有菜单，则不跳转
    EventMgr.triggerEvent(EventConst.SHOW_PLOT_MENU, args[1])
    callback()
end

RPlotRunner.cmdPlotJump = function(self, args, callback)
    if string.find(args[1], "r_plot") then
        EventMgr.triggerEvent(EventConst.NEXT_PLOT, "r", string.sub(args[1], 7))
    else
        EventMgr.triggerEvent(EventConst.NEXT_PLOT, "s", string.sub(args[1], 7), self.playerList)
    end
end

-- 武将加入或离开 武将序号 加入或离开("add", "level") 等级加成（若超过50则表示减）
RPlotRunner.cmdRoleAddOrLevel = function(self, args, callback)
    local generalId, isAdd, level = args[1], (args[2] == "add"), args[3]
    EventMgr.triggerEvent(EventConst.ADD_PLAYER, generalId, isAdd, level)
    TipUtils.showTip(string.format("%s加入", generalId), nil, callback)
end

-- 武将加入时所带装备 武将序号 武器名称 武器等级 护具名称 护具等级 辅助装备序号
RPlotRunner.cmdAddRoleInfo = function(self, args, callback)
    local generalId, wuqiId, wuqiLevel, fangjuId, fangjuLevel, shipingId = args[1], args[2], args[3], args[4], args[5], args[6]
    EventMgr.triggerEvent(EventConst.SET_PLAYER_EQUIPS, generalId, wuqiId, wuqiLevel, fangjuId, fangjuLevel, shipingId)
    callback()
end

-- 变量赋值 变量名 变量值
RPlotRunner.cmdVarSet = function(self, args, callback)
    GameData.setVar(args[1], args[2])
    callback()
end

-- 播放动画 动画名
RPlotRunner.cmdPlayAnimation = function(self, args, callback)
    printInfo("暂时不支持播放视频")
    callback()
end

-- R剧本事件名称设定 名称
RPlotRunner.cmdRSetTitle = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.SET_PLOT_TITLE, args[1])
    callback()
end

-- R剧本中用来显示场所名 文字内容
RPlotRunner.cmdRShowSceneName = function(self, args, callback)
    EventMgr.triggerEvent(EventConst.SET_SCENE_NAME, args[1])
    callback()
end

-- 音效设定 音效类型6 重复次数
RPlotRunner.cmdPlaySound = function(self, args, callback)
    AudioMgr.playSound(args[1])
    callback()
end

-- CD音轨设定 音轨序号
RPlotRunner.cmdPlayMusic = function(self, args, callback)
    AudioMgr.playMusic(args[1], true)
    callback()
end

-- 武将头像设置 武将头像
RPlotRunner.cmdHeadChange = function(self, args, callback)
    local headInfo = RPlotConst.HEAD_MAPPING[args[1]]
    RRoleInfo[headInfo[1]].head = headInfo[2]
    callback()
end

RPlotRunner.cmdGameWin = function(self, args, callback)
    --!! undo
    callback()
end

-- 获得物品 物品代码 物品等级（0表默认）
RPlotRunner.cmdAddItem = function(self, args, callback)
    GameData.addItem(args[1])
    TipUtils.showTip(string.format("获得了\"%s\"", args[1]), nil, callback)
end

-- 我方出场人员控制 可否控制 最大出场人数（最大15）最低出阵人数 强制出场武将 强制出场武将 强制出场武将 强制出场武将 强制出场武将 强制不出场武将 强制不出场武将 强制不出场武将 强制不出场武将 强制不出场武将
RPlotRunner.cmdFightGeneralsInfo = function(self, args, callback)
    if args[1] then
        local hasCaocao = false
        local playerList = {}
        playerList.maxLimit = args[2]
        playerList.minLimit = args[3]
        for i = 4, #args do
            table.insert(playerList, args[i])

            if string.find(args[i], "曹操") then
                hasCaocao = true
            end
        end

        if not hasCaocao then
            table.insert(playerList, 1, "曹操")
        end

        self.ui:setPlayerList(playerList)
    end

    callback()
end

-- 武将点击测试 武将id
RPlotRunner.cmdRolePressedTest = function(self, args, callback, plot, plotIndex)
    local role = self.roles[args[1]]
    if role then
        role:addPressedPlot(plot[plotIndex + 1])
    else
        assert(false, "无此武将，无法进行武将点击")
    end

    table.remove(plot, plotIndex + 1)
    callback()
end

-- 出兵按钮点击测试
RPlotRunner.cmdFightButtonPressedTest = function(self, args, callback, plot, plotIndex)
    EventMgr.triggerEvent(EventConst.AUTO_SAVE_DATA)

    self.isHookPlot = true
    self.ui:setFightButtonPlot(plot[plotIndex + 1])
    table.remove(plot, plotIndex + 1)
    callback()
end

-- 变量测试 变量名(正数表明检验是否为ture, 负数表明检验是否为nil或false)
RPlotRunner.conditionVarTest = function(self, actionArgs)
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

RPlotRunner._checkTwo = function(self, left, right, equalWay)
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

-- 野心测试
RPlotRunner.conditionCareerismTest = function(self, args, callback)
    return self:_checkTwo(GameData.getCareerism(), args[1], args[2])
end

return RPlotRunner