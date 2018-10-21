--[[
    游戏数据
--]]

local GameState    = require("framework.cc.utils.GameState")
local WeatherMgr   = import("..weather.weather_mgr")
local MapView      = import("..map.map_view")

local GameKey      = "3ade12vivcmserjlxkjpqweasz"
local GameEncode   = "cashjkhdfwyeri312n1z1fd41"
local GameSaveName = "save.ccz"

local SavePath = device.writablePath .. "save.lua"
if device.platform == "mac" then
    SavePath = "/Users/zwsatan/Desktop/csdncode/ccz/save.lua"
end

local GameData = {}

GameData.init = function()
    -- 仅仅初始化存档相关数据
    -- GameState.init(function(param)
    --     local returnValue
    --     if param.errorCode then
    --         if param.errorCode == GameState.ERROR_STATE_FILE_NOT_FOUND then
    --             printInfo("没有默认保存文件")
    --         elseif param.errorCode == GameState.ERROR_INVALID_FILE_CONTENTS then
    --             printInfo("取出的文件不是一个table")
    --         elseif param.errorCode == GameState.ERROR_HASH_MISS_MATCH then
    --             printInfo("取出的文件被人为修改过")
    --         else
    --             assert(false, "异常的错误码:" .. param.errorCode)
    --         end
    --     else
    --         if param.name == "save" then
    --             local str = json.encode(param.values)
    --             str = crypto.encryptXXTEA(str, GameEncode)
    --             returnValue = {data = str}
    --         elseif param.name == "load" then
    --             local str = crypto.decryptXXTEA(param.values.data, GameEncode)
    --             returnValue = json.decode(str)
    --         end
    --     end

    --     return returnValue
    -- end, GameSaveName, GameKey)

    -- if io.exists(GameState.getGameStatePath()) then
    --     printInfo("存档信息存在，缓存入GameData")
    --     GameData.saveDatas = GameState.load() or {}
    -- else
    --     printInfo("无任何存档信息")
    --     GameData.saveDatas = {}
    -- end

    if io.exists(SavePath) then
        printInfo("存档信息存在，缓存入GameData")
        GameData.saveDatas = dofile(SavePath)
    else
        printInfo("无任何存档信息")
        GameData.saveDatas = {}
    end
end

GameData.newGame = function()
    printInfo("开始新的游戏，这里重新初始化游戏数据")

    printInfo("重置消耗道具")
    GameData.consumeItems = {}
    printInfo("重置装备")
    GameData.equipItems = {}
    printInfo("重置局部变量(0-255)和全局变量(256-~)")
    GameData.globalVars = {}
    printInfo("重置初始金钱为0")
    GameData.money = 0
    printInfo("重置初始野心为50")
    GameData.careerism = 50
    printInfo("重置当前剧本信息为R剧本00")
    GameData.curPlotInfo = {type = "r", index = "00"}
end

--[[
存档：规定默认就3个存档，1为自动存档，2为R剧本存档，3为S剧本存档
公共数据：
    1、当前进度的全局变量数
    2、当前进行的R剧本index，S剧本index，当前的剧本类型，当前剧本的SceneIndex和SectionIndex（仅对R有效，因为S不考虑这个，不过算是公共的，剧本格式一致）
    3、金钱总数目
    4、野心值
    5、仓库数据：包括消耗物品的数目，和装备的数目（分为总数目和无人装备的数目），（无人装备的装备的等级和经验，有人装备的该数据，在当前角色身上）
    6、宝物图鉴的开启情况，记录那些宝物已经获取
    7、我方武将数据公共信息：武将id，武将等级，武将经验，武器id，武器等级，武器经验，防具id，防具等级，防具经验，饰品id，武将的武力等5个基础属性（会因果子而变化），武将的五围信息（记录表示压级吃果有影响，不记录表示每次自动计算，压果则不再有影响），武将的职业index
    8、当前背景音乐，是否循环

战斗外（R剧本）：
    1、场景名，事件名
    2、R剧本中的局部变量

战斗内（S剧本）：
    1、跳过战斗战前剧情
    2、战场信息，当前回合数，战斗名，胜负条件，战场障碍物信息（秒加，无动画），当前地图的pos
    3、战斗武将信息：不考虑公共数据
        我方武将：加上公共数据，其他数据同下面
        其他武将：武将id，武将等级，武器id，防具id，饰品id，武将buffer（无动画），武将是否行动，当前hp，当前mp，位置，朝向，是否重伤，武将的index，ai类型，ai额外参数，职业index
    4、S剧本中的局部变量
--]]
GameData.save = function(isAutoSaving)
    printInfo("正在保存剧本")

    local saveData = {}
    printInfo("保存消耗道具")
    saveData.consumeItems = GameData.consumeItems
    printInfo("保存商店装备")
    saveData.equipItems = GameData.equipItems
    printInfo("保存商店装备的一个累计数目，此数目仅暂时用作记录装备index")
    saveData.equipCount = GameData.equipIndex
    printInfo("保存局部变量(0-255)和全局变量(256-~)")
    saveData.globalVars = GameData.globalVars
    printInfo("保存初始金钱")
    saveData.money = GameData.money
    printInfo("保存初始野心")
    saveData.careerism = GameData.careerism
    printInfo("保存当前剧本信息")
    saveData.curPlotInfo = GameData.curPlotInfo
    printInfo("保存当前剧本SceneIndex")
    saveData.sceneIndex = GameData.sceneIndex
    printInfo("保存当前剧本SectionIndex")
    saveData.sectionIndex = GameData.sectionIndex
    printInfo("保存当前场景名")
    saveData.sceneName = GameData.sceneName
    printInfo("保存当前事件名")
    saveData.plotTitle = GameData.plotTitle
    printInfo("保存当前背景音乐")
    saveData.curMusic = AudioMgr.getCurMusic()
    printInfo("保存玩家武将列表")
    saveData.generalList = GeneralDataMgr.getAllGeneralSaveData("player")

    if GameData.curPlotInfo.type == "s" then
        printInfo("生成存档名")
        saveData.savingName = string.format("%s 第%d回合", GameData.battleInfo.battleName, GameData.battleInfo.curRound)

        printInfo("保存跳过战前剧情标记")
        saveData.skipBattleStartPlot = true

        printInfo("保存战斗信息")
        saveData.battleInfo = GameData.battleInfo
        saveData.battlePlayersList = GeneralDataMgr.getAllGeneralBattleSaveData("player", isAutoSaving)
        saveData.battleFriendsList = GeneralDataMgr.getAllGeneralBattleSaveData("friend", isAutoSaving)
        saveData.battleEnemiesList = GeneralDataMgr.getAllGeneralBattleSaveData("enemy", isAutoSaving)

        printInfo("保存战斗天气信息")
        saveData.weatherData = GameData.weatherMgr:getSaveData()

        printInfo("保存战斗地图信息")
        saveData.mapData = GameData.mapView:getSaveData()
    else
        printInfo("生成存档名")
        saveData.savingName = GameData.sceneName
    end

    if isAutoSaving then
        GameData.saveDatas[1] = clone(saveData)
    elseif GameData.curPlotInfo.type == "r" then
        GameData.saveDatas[2] = clone(saveData)
    elseif GameData.curPlotInfo.type == "s" then
        GameData.saveDatas[3] = clone(saveData)
    else
        assert(false, "有问题，根本不存在这种存档方式")
    end

    -- GameState.save(GameData.saveDatas)
    table.save(GameData.saveDatas, SavePath)

    printInfo("存储文档完毕")
end

--[[
自动保存：
    1、战斗中，我方存在武将时，每回合开始阶段自动保存一次，即排除第0关我方无武将时，不进行保存
    2、战斗结束后，自动保存一次，这里相当于R剧本的开始
    3、营帐出现时，保存一次
    自动存档，默认为第0个存档
--]]
GameData.autoSave = function()
    printInfo("正在进行自动保存")
    GameData.save(true)
    printInfo("自动保存完毕")
end

GameData.load = function(dataIndex)
    printInfo("正在读取文档:%d", dataIndex)

    -- GameData.saveDatas = GameState.load()
    GameData.saveDatas = dofile(SavePath)
    if GameData.saveDatas then
        printInfo("读取文档数据成功")
        GameData.initSaveData(clone(GameData.saveDatas[dataIndex]))
    else
        printInfo("读取文档数据失败，请检查失败原因！！！")
        printInfo("直接初始化为新游戏的数据")
        GameData.newGame()
    end

    printInfo("读取文档完毕")
    return isLoadSuccess
end

GameData.initSaveData = function(saveData)
    printInfo("正在读取存档数据")

    printInfo("读取消耗道具")
    GameData.consumeItems = saveData.consumeItems
    printInfo("读取商店装备")
    GameData.equipItems = saveData.equipItems
    printInfo("读取装备总index")
    GameData.equipIndex = saveData.equipCount
    printInfo("读取局部变量(0-255)和全局变量(256-~)")
    GameData.globalVars = saveData.globalVars
    printInfo("读取初始金钱")
    GameData.money = saveData.money
    printInfo("读取初始野心")
    GameData.careerism = saveData.careerism
    printInfo("读取当前剧本信息")
    GameData.curPlotInfo = saveData.curPlotInfo
    printInfo("读取玩家武将列表")
    GeneralDataMgr.unregAllGeneralDatas()
    for k,v in pairs(saveData.generalList) do
        GeneralDataMgr.regGeneralData(v.uid, "player", v)
    end

    printInfo("读取当前剧本SceneIndex")
    GameData.sceneIndex = saveData.sceneIndex
    printInfo("读取当前剧本SectionIndex")
    GameData.sectionIndex = saveData.sectionIndex
    printInfo("读取当前场景名")
    GameData.sceneName = saveData.sceneName
    printInfo("读取当前事件名")
    GameData.plotTitle = saveData.plotTitle

    if saveData.curMusic then
        printInfo("读取当前背景音乐")
        AudioMgr.playMusic(saveData.curMusic[1], saveData.curMusic[2])
    end

    GameData.curMusic = saveData.curMusic

    if GameData.curPlotInfo.type == "s" then
        printInfo("设置略过战前剧情标记")
        GameData.skipBattleStartPlot = true
        printInfo("读取战斗信息")
        GameData.battleInfo = saveData.battleInfo
        printInfo("读取战斗武将列表")
        GameData.initBattleList(saveData.battlePlayersList, saveData.battleFriendsList, saveData.battleEnemiesList)
        printInfo("读取战斗天气信息")
        GameData.weatherMgr = WeatherMgr.new(saveData.weatherData.weatherStart, saveData.weatherData.weatherType[1], saveData.weatherData.weathers)
        printInfo("读取战斗地图信息")
        GameData.mapData = saveData.mapData
    end
end

GameData.getSaveData = function(index)
    return GameData.saveDatas[index]
end

GameData.setPlotInfo = function(plotType, plotIndex)
    GameData.curPlotInfo = {type = plotType, index = plotIndex}
end

GameData.getPlotInfo = function()
    return GameData.curPlotInfo or {}
end

GameData.isRPlot = function()
    return GameData.getPlotInfo().type == "r"
end

-- 获取玩家消耗型道具总数目
GameData.getConsumeItemsCount = function()
    return table.addAllValues(GameData.consumeItems)
end

GameData.getAllConsumeItems = function()
    return GameData.consumeItems
end

GameData.getConsumeItemCountById = function(itemId)
    return GameData.consumeItems[itemId] or 0
end

GameData.addItem = function(itemId, count, itemLevel)
    if InfoUtil.isEquipItem(itemId) then
        GameData.equipIndex = GameData.equipIndex or 0
        GameData.equipIndex = GameData.equipIndex + 1 -- 目前用一个只增不减的武将key
        table.insert(GameData.equipItems, {itemId = itemId, level = itemLevel or 1, exp = 0, itemIndex = GameData.equipIndex})
    else
        GameData.consumeItems[itemId] = GameData.consumeItems[itemId] or 0
        GameData.consumeItems[itemId] = GameData.consumeItems[itemId] + (count or 1)
    end
end

GameData.subItem = function(itemId, count, itemIndex)
    if InfoUtil.isEquipItem(itemId) then
        for i, v in ipairs(GameData.equipItems) do
            if v.itemId == itemId and v.itemIndex == itemIndex then
                printInfo("移除装备：%s", v.itemId)
                table.remove(GameData.equipItems, i)
                break
            end
        end
    else
        printInfo("移除道具：%s", itemId)
        GameData.consumeItems[itemId] = GameData.consumeItems[itemId] - (count or 1)
        if GameData.consumeItems[itemId] <= 0 then
            GameData.consumeItems[itemId] = nil
        end
    end
end

GameData.addMoney = function(money)
    GameData.money = GameData.money + money
end

GameData.getMoney = function()
    return GameData.money
end

GameData.setCareerism = function(careerism)
    GameData.careerism = careerism
end

GameData.addCareerism = function(careerism)
    GameData.careerism = GameData.careerism + careerism
end

GameData.getCareerism = function()
    return GameData.careerism
end

-- 添加战利品，extraMoney表示额外可以得到的金钱
GameData.addBattleRewardItems = function(extraMoney, items)
    -- 金钱数 = 曹操等级*100+700
    GameData.battleInfo.rewardMoney = GeneralDataMgr.getCaocaoLevel() * 100 + 700 + extraMoney
    GameData.addMoney(GameData.battleInfo.rewardMoney)

    -- 战后的战利品的等级 = 1+曹操等级/4
    local itemLevel = math.floor(GeneralDataMgr.getCaocaoLevel() / 4) + 1
    GameData.battleInfo.rewardItems = {}
    for _, item in ipairs(items) do
        if item[1] ~= "" then
            GameData.addItem(item[1], 1, itemLevel)
            table.insert(GameData.battleInfo.rewardItems, {itemId = item[1], level = itemLevel + item[2]})
        end
    end
end

-- 获取战斗胜利获得的金钱
GameData.getRewardMoney = function()
    return GameData.battleInfo.rewardMoney
end

-- 获取战斗胜利的宝物
GameData.getRewardItems = function()
    return GameData.battleInfo.rewardItems
end

-- 变量中0-255均为局部变量，由于在战斗中全部放入了全局区内，因此，在S剧本Exit的时候，清理一下
GameData.clearLocalVars = function()
    table.walk(GameData.globalVars, function(_, var)
        if tonumber(string.sub(var, 4)) < 256 then
            GameData.globalVars[var] = nil
        end
    end)
end

-- 已包含局部变量
GameData.setVar = function(var, value)
    GameData.globalVars[var] = value
end

-- 已包含局部变量
GameData.getVar = function(var)
    return GameData.globalVars[var]
end

-- 已包含局部变量
GameData.checkVars = function(trueConditions, falseConditions)
    trueConditions = trueConditions or {}
    falseConditions = falseConditions or {}

    for _, var in ipairs(trueConditions) do
        if not GameData.getVar(var) then
            return false
        end
    end

    for _, var in ipairs(falseConditions) do
        if GameData.getVar(var) then
            return false
        end
    end

    return true
end

-- 初始化战斗信息
GameData.initBattleInfo = function(mapId, maxRounds, battleName, levelAdd, weatherStart, weatherType, playerList, friendList, enemyList)
    GameData.battleInfo = {
        mapId      = mapId,
        maxRounds  = maxRounds,
        battleName = battleName,
        curRound   = 1,
        curSide    = "我军阶段",
        levelAdd   = levelAdd,
    }

    GameData.initBattleList(playerList, friendList, enemyList)

    weatherType = weatherType or {}
    GameData.weatherMgr = WeatherMgr.new(weatherStart, weatherType[1])
end

GameData.initBattleList = function(playerList, friendList, enemyList)
    GeneralDataMgr.unregAllGeneralBattleDatas()

    for i, player in ipairs(playerList) do
        player.scriptIndex = player.scriptIndex or (i - 1)
        GeneralDataMgr.regGeneralBattleData(player.uid, "player", player)
    end

    local enemyBaseLevel = GeneralDataMgr.getEnemyLevel()
    for i, enemy in ipairs(enemyList) do
        enemy.level = enemy.level or math.max(enemyBaseLevel + (enemy.levelAdd or GameData.battleInfo.levelAdd), 1)
        enemy.scriptIndex = enemy.scriptIndex or (i - 1)
        GeneralDataMgr.regGeneralBattleData(enemy.uid, "enemy", enemy)
    end

    for i, friend in ipairs(friendList) do
        friend.level = friend.level or math.max(enemyBaseLevel + (friend.levelAdd or GameData.battleInfo.levelAdd), 1)
        friend.scriptIndex = friend.scriptIndex or (i - 1)
        GeneralDataMgr.regGeneralBattleData(friend.uid, "friend", friend)
    end
end

GameData.initMapView = function()
    GameData.mapView = MapView.new(GameData.battleInfo, GameData.mapData or {})
    GameData.mapView:addTo(display.getRunningScene())

    EventMgr.triggerEvent(EventConst.BATTLE_START)
end

-- 强制设置本回合天气
GameData.setWeather = function(weatherType)
    GameData.weatherMgr:setWeather(GameData.getCurRound(), weatherType)
end

-- 获取本回合天气
GameData.getWeather = function()
    return GameData.weatherMgr:getWeather(GameData.getCurRound())
end

-- 设置当前行动顺序
GameData.setCurSide = function(side)
    GameData.battleInfo.curSide = side
    if side == "我军阶段" then
        GameData.battleInfo.curRound = GameData.battleInfo.curRound + 1
        if #MapUtils.getGeneralsBySide("player") > 0 then
            GameData.autoSave()
        end

        EventMgr.triggerEvent(EventConst.SHOW_WEATHER)
    end
end

-- 获取当前行动顺序
GameData.getCurSide = function()
    return GameData.battleInfo.curSide
end

-- 获取当前回合数
GameData.getCurRound = function()
    return GameData.battleInfo.curRound
end

-- 设置最大回合数
GameData.setMaxRounds = function(maxRounds)
    GameData.battleInfo.maxRounds = maxRounds
end

-- 获取最大回合数
GameData.getMaxRounds = function()
    return GameData.battleInfo.maxRounds
end

-- 设置不清除战场信息，因为在读档时，切换MainScene，会导致load的数据被清除掉，导致战场读取失败
GameData.setNoClearBattleInfo = function(bool)
    GameData.noClearPlot = bool
end

-- 清理R和S剧本相关内容
GameData.plotOver = function()
    printInfo("正在清理剧本相关内容")
    if not GameData.noClearPlot then
        GameData.clearLocalVars()
        GameData.battleInfo   = nil
        GameData.mapData      = nil
        GameData.weatherMgr   = nil
        GameData.sceneName    = nil
        GameData.plotTitle    = nil
        GameData.sceneIndex   = nil
        GameData.sectionIndex = nil

        GeneralDataMgr.unregAllGeneralBattleDatas()
    else
        GameData.noClearPlot = nil
    end
end

GameData.addGeneral = function(uid, isAdd, levelAdd)
    if isAdd then
        local level = GeneralDataMgr.getNewGeneralLevel() + (levelAdd or 0)
        GeneralDataMgr.regGeneralData(uid, "player", {level = level})
    else
        assert(false, "这里需要重构")
        printInfo("武将%s真正离开了", uid)
    end
end

GameData.setPlayerGeneralEquips = function(uid, wuqiId, wuqiLevel, fangjuId, fangjuLevel, shipingId)
    GeneralDataMgr.changeEquip(uid, GeneralDataConst.EQUIP_WUQI, wuqiId, wuqiLevel, 0)
    GeneralDataMgr.changeEquip(uid, GeneralDataConst.EQUIP_FANGJU, fangjuId, fangjuLevel, 0)
    if shipingId ~= "默认装备" then
        GeneralDataMgr.changeEquip(uid, GeneralDataConst.EQUIP_SHIPING, shipingId)
    end
end

GameData.changePlayerEquip = function(uid, equipType, equipId, equipLevel, equipExp, equipIndex)
    local oldEquip = GeneralDataMgr.changeEquip(uid, equipType, equipId, equipLevel, equipExp)

    printInfo("从GameData中移除此武器并添加后者%s->%s", equipIndex, oldEquip:getId() or "无")
    for i, v in ipairs(GameData.equipItems) do
        if v.itemIndex == equipIndex then
            if oldEquip:getId() then
                GameData.equipIndex = GameData.equipIndex + 1
                GameData.equipItems[i] = {itemId = oldEquip:getId(), level = equipLevel, exp = equipExp, itemIndex = GameData.equipIndex}
            else
                table.remove(GameData.equipItems, i)
            end
            break
        end
    end
end

GameData.setSceneName = function(sceneName)
    GameData.sceneName = sceneName
end

GameData.getSceneName = function()
    return GameData.sceneName
end

GameData.setPlotTitle = function(title)
    GameData.plotTitle = title
end

GameData.getPlotTitle = function()
    return GameData.plotTitle
end

GameData.updateSceneIndex = function(sceneIndex)
    GameData.sceneIndex = sceneIndex
end

GameData.updateSectionIndex = function(sectionIndex)
    GameData.sectionIndex = sectionIndex
end

GameData.removeMapView = function()
    if GameData.mapView then
        GameData.mapView:removeSelf()
        GameData.mapView = nil
    end
end

-- 获取需要跳过的场景数目，仅用于R剧本
GameData.getSkipSceneCounts = function()
    if not GameData.sceneIndex then
        return 0
    end

    return GameData.sceneIndex - 1
end

-- 获取跳过战前剧情的标记
GameData.isSkipBattleStartPlot = function()
    return GameData.skipBattleStartPlot
end

-- 重置跳过战前剧情标记
GameData.resetSkipBattleStartPlot = function()
    GameData.skipBattleStartPlot = false
end

-- 返回的是所有闲置的装备，不包括已经装备的，可以指定一个职业的装备
GameData.getAllEquips = function(armyType)
    if not armyType or armyType == "所有兵种" then
        return GameData.equipItems
    end

    local items = {}
    for i, v in ipairs(GameData.equipItems) do
        local equipConfig = InfoUtil.getItemConfig(v.itemId)
        if equipConfig.armyLimits then
            if equipConfig.armyLimits[1] == "所有兵种" then
                table.insert(items, v)
            elseif table.indexof(equipConfig.armyLimits, armyType) then
                table.insert(items, v)
            end
        else
            table.insert(items, v)
        end
    end

    return items
end

-- 获取所有可以买的商店货
GameData.getAllCanBuyShopItems = function()
    local baseLevel = GeneralDataMgr.getNewGeneralLevel() -- 以新加入武将的等级作为商店可以购买装备的基准值

    local items = {}
    for _, itemInfo in ipairs(ShopItemsInfo) do
        if (itemInfo.sellLevel <= baseLevel) and (not itemInfo.limitLevel or itemInfo.limitLevel >= baseLevel) then
            table.insert(items, itemInfo)
        end
    end

    return items
end

-- 获取玩家身上所有可以卖的商店货
GameData.getAllCanSellShopItems = function()
    local items = {}
    for itemId, count in pairs(GameData.consumeItems) do
        if count > 0 then
            table.insert(items, {itemId = itemId, count = count})
        end
    end

    for _, itemInfo in ipairs(GameData.equipItems) do
        local itemConfig = InfoUtil.getItemConfig(itemInfo.itemId)
        if itemConfig.cost then
            table.insert(items, itemInfo)
        end
    end

    return items
end

GameData.init()

EventMgr.registerEvent(EventConst.NEXT_PLOT, GameData.setPlotInfo, EventConst.PRIO_HIGH)
EventMgr.registerEvent(EventConst.PLOT_OVER, GameData.plotOver)
EventMgr.registerEvent(EventConst.ADD_PLAYER, GameData.addGeneral)
EventMgr.registerEvent(EventConst.SET_PLAYER_EQUIPS, GameData.setPlayerGeneralEquips)
EventMgr.registerEvent(EventConst.SET_SCENE_NAME, GameData.setSceneName)
EventMgr.registerEvent(EventConst.SET_PLOT_TITLE, GameData.setPlotTitle)
EventMgr.registerEvent(EventConst.PLOT_ADD_CAREERISM, GameData.addCareerism)
EventMgr.registerEvent(EventConst.UPDATE_SCENE_INDEX, GameData.updateSceneIndex)
EventMgr.registerEvent(EventConst.UPDATE_SECTION_INDEX, GameData.updateSectionIndex)

EventMgr.registerEvent(EventConst.NEW_GAME, GameData.newGame)
EventMgr.registerEvent(EventConst.AUTO_SAVE_DATA, GameData.autoSave)
EventMgr.registerEvent(EventConst.SAVE_DATA, GameData.save)
EventMgr.registerEvent(EventConst.LOAD_DATA, GameData.load)

return GameData