--[[
    管理所有武将data，所有地方的武将数据从此处来
--]]

local GeneralData       = import(".general_data")
local GeneralBattleData = import(".general_battle_data")

local GeneralDataMgr = class("GeneralDataMgr")

GeneralDataMgr._init = function()
    GeneralDataMgr.players = {}
    GeneralDataMgr.generalDatas = {}
    GeneralDataMgr.generalIds = {}
    GeneralDataMgr.generalBattleDatas = {}
end

GeneralDataMgr.regGeneralData = function(uid, side, data)
    GeneralDataMgr.generalDatas[uid] = GeneralDataMgr.generalDatas[uid] or GeneralData.new(uid, side, data)
    if side == "player" and not table.indexof(GeneralDataMgr.generalIds, uid) then
        table.insert(GeneralDataMgr.generalIds, uid)
    end
    return GeneralDataMgr.generalDatas[uid]
end

GeneralDataMgr.unregGeneralData = function(uid, side)
    assert(false, "unregGeneralData undo")
end

GeneralDataMgr.isExisted = function(uid)
    -- printInfo("武将(%s)：%s", uid, GeneralDataMgr.generalDatas[uid] and "存在" or "不存在")
    return GeneralDataMgr.generalDatas[uid]
end

GeneralDataMgr.getProp = function(uid, propName)
    if not GeneralDataMgr.isExisted(uid) then
        printInfo("不允许查询一个不存在的玩家武将(%s)的属性(%s)", uid, propName)
        return
    end

    return GeneralDataMgr.generalDatas[uid]:getProp(propName)
end

GeneralDataMgr.getEquip = function(uid, equipType, side)
    if not GeneralDataMgr.isExisted(uid) then
        printInfo("不允许查询一个不存在的玩家武将(%s)的装备(%s)", uid, equipType)
        return
    end

    return GeneralDataMgr.generalDatas[uid]:getEquip(equipType)
end

-- 更新武将武器，同时刷新武将受武器影响的基础属性，返回原来的装备信息
GeneralDataMgr.changeEquip = function(uid, equipType, id, level, exp)
    if not GeneralDataMgr.isExisted(uid) then
        printInfo("不允许改变一个不存在的玩家武将(%s)的装备(%s)", uid, equipType)
        return
    end

    return GeneralDataMgr.generalDatas[uid]:changeEquip(equipType, id, level, exp)
end

GeneralDataMgr.getAllGeneralIds = function(side)
    return GeneralDataMgr.generalIds
end

GeneralDataMgr.getCaocaoLevel = function()
    printInfo("当前曹操等级为：", GeneralDataMgr.getProp("曹操", GeneralDataConst.PROP_LEVEL))
    return GeneralDataMgr.getProp("曹操", GeneralDataConst.PROP_LEVEL)
end

-- 新加入武将等级 = 我方现有N个人的等级总和/ N ，N最大为15，若我方大于15人，则取等级最高的15个人来计算
GeneralDataMgr.getNewGeneralLevel = function()
    if #GeneralDataMgr.generalIds == 0 then
        return 1
    end

    local levelList = {}
    for _, generalId in ipairs(GeneralDataMgr.generalIds) do
        table.insert(levelList, GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_LEVEL))
    end

    table.sort(levelList, function(l, r)
        return l > r
    end)

    local totalLevels = 0
    for i = 1, #levelList do
        if i <= 15 then
            totalLevels = totalLevels + levelList[i]
        else
            break
        end
    end

    printInfo("共%d武将，总等级为:%d，平均等级为:%d", math.min(#levelList, 15), totalLevels, math.floor(totalLevels / math.min(#levelList, 15)))

    return math.floor(totalLevels / math.min(#levelList, 15))
end

GeneralDataMgr.getAllGeneralSaveData = function(side)
    local saveDataList = {}
    table.walk(GeneralDataMgr.generalIds, function(uid)
        local generalData = GeneralDataMgr.generalDatas[uid]
        table.insert(saveDataList, generalData:getSaveData())
    end)

    return saveDataList
end

GeneralDataMgr.getGeneralSaveData = function(uid)
    return GeneralDataMgr.generalDatas[uid]:getSaveData()
end

GeneralDataMgr.unregAllGeneralDatas = function()
    GeneralDataMgr.generalDatas = {}
end

----------------------------------------------------------------------
GeneralDataMgr.regGeneralBattleData = function(uid, side, data)
    GeneralDataMgr.regGeneralData(uid, side, data)
    GeneralDataMgr.generalBattleDatas[uid] = GeneralDataMgr.generalBattleDatas[uid] or GeneralBattleData.new(uid, side, data)
    return GeneralDataMgr.generalBattleDatas[uid]
end

GeneralDataMgr.unregGeneralBattleData = function(uid, side)
    assert(false, "unregGeneralBattleData undo")
end

GeneralDataMgr.unregAllGeneralBattleDatas = function()
    table.walk(GeneralDataMgr.generalDatas, function(generalData, uid)
        if generalData:getSide() ~= "player" then
            GeneralDataMgr.generalDatas[uid] = nil
        end
    end)

    GeneralDataMgr.generalBattleDatas = {}
end

GeneralDataMgr.getGeneralBattleDatas = function(side)
    local sideBattleDatas = {}
    table.walk(GeneralDataMgr.generalBattleDatas, function(battleData, uid)
        if battleData:getSide() == side then
            table.insert(sideBattleDatas, {uid = uid, side = side, data = battleData})
        end
    end)
    return sideBattleDatas
end

--[[
    敌人平均等级，为去掉我方出场人员N个最高等级和N个最等级，以剩下的人员平均等级为基准
    N的算法：N = 我方出场人数/4
--]]
GeneralDataMgr.getEnemyLevel = function()
    local levelList = {}
    table.walk(GeneralDataMgr.getGeneralBattleDatas("player"), function(battleData)
        table.insert(levelList, GeneralDataMgr.getProp(battleData.uid, GeneralDataConst.PROP_LEVEL))
    end)

    local N = math.floor(#levelList / 4)
    if N > 0 then
        table.sort(levelList, function(l, r)
            return l > r
        end)

        for i = 1, N do
            table.remove(levelList, 1)
            table.remove(levelList)
        end
    end

    local totalLevels = table.addAllValues(levelList)
    printInfo("此战敌人基准等级为：%d", math.floor(totalLevels / #levelList))
    return math.floor(totalLevels / #levelList)
end

GeneralDataMgr.getAllGeneralBattleSaveData = function(side, isAutoSaving)
    local saveDataList = {}
    table.walk(GeneralDataMgr.getGeneralBattleDatas(side), function(battleData)
        local saveData = battleData.data:getSaveData()
        if side ~= "player" then
            table.merge(saveData, GeneralDataMgr.getGeneralSaveData(battleData.uid))
        end

        -- 自动保存是在我军刷新行动之前处理的，所以需要在这里强制重置一下
        if isAutoSaving and side == "player" then
            saveData.isActionDone = false
        end

        table.insert(saveDataList, saveData)
    end)

    return saveDataList
end

GeneralDataMgr._init()

return GeneralDataMgr