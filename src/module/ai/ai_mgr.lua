--[[
    Ai管理器
--]]

-- 加载具体的Ai类
local AiBeiDongChuji        = import(".ai_beidongchuji")
local AiZhuDongChuji        = import(".ai_zhudongchuji")
local AiJianShouYuanDi      = import(".ai_jianshouyuandi")
local AiGongJiWuJiang       = import(".ai_gongjiwujiang")
local AiDaoDaZhiDingDiDian  = import(".ai_daodazhidingdidian")
local AiGenSuiWuJiang       = import(".ai_gensuiwujiang")
local AiTaoZhiZhiDingDiDian = import(".ai_taozhizhidingdidian")

local NormalAttack          = import("..char.normal_attack")
local MagicAttack           = import("..char.magic_attack")

local AI_CLASSES = {
    ["被动出击"]  = AiBeiDongChuji,
    ["主动出击"]  = AiZhuDongChuji,
    ["坚守原地"]  = AiJianShouYuanDi,
    ["攻击武将"]  = AiGongJiWuJiang,
    ["到指定点"]  = AiDaoDaZhiDingDiDian,
    ["跟随武将"]  = AiGenSuiWuJiang,
    ["逃至指定点"] = AiTaoZhiZhiDingDiDian,
}

local AiMgr = {}
AiMgr.aiCaches = {} -- 用来缓存所有的ai类，避免多次生成

AiMgr.run = function(generalList, side, callback)
    EventMgr.triggerEvent(EventConst.ADD_NONTOUCH_LAYER, "Ai Run Start")

    printInfo("准备执行 %s 阵营的ai", side)
    local allGenerals = {}
    table.merge(allGenerals, generalList)
    -- 1、排列武将的行动顺序
    allGenerals = AiMgr._sortMoveQueue(allGenerals)

    -- 2、遍历武将，根据ai类型，执行ai计算
    table.oneByOneForMap(allGenerals, function(general, nextCallback)
        if AiMgr.isBattleDone then
            return
        end

        printInfo("当前执行%s阵营的%s武将的ai:%s", side, general:getName(), general:getAiType())
        MapUtils.setCurrentGeneral(general) -- 设置当前武将
        EventMgr.triggerEvent(EventConst.MOVE_TO_NODE, general)

        local aiType = general:getAiType()
        local actionCmds = AiMgr.runAi(general, aiType)
        assert(#actionCmds > 0, "ai产生的指令有问题")
        AiMgr.doCmds(general, 1, actionCmds, nextCallback)

    end, function()
        EventMgr.triggerEvent(EventConst.REMOVE_NONTOUCH_LAYER, "Ai Run End")

        printInfo("本轮回合结束，本阵营武将行动重置")
        MapUtils.setCurrentGeneral(nil) -- 重置当前武将

        -- 延时加载是因为makeActionDone有一个动画效果，不执行完马上重置，会导致武将颜色加深
        scheduler.performWithDelayGlobal(function()
            EventMgr.triggerEvent(EventConst.REFRESH_GENERALS, allGenerals)
            callback()
        end, 0.2)
    end)
end

--[[
    排列武将的行动顺序
    恢复地形 > 残血状态 > 攻击型法师 > 远程类 > 近战类 > 风水士类。
--]]
AiMgr._sortMoveQueue = function(allGenerals)
    local getCost = function(general)
        local cost
        if general:isInRecoverTile() then
            cost = 1
        elseif general:isInjury() then
            cost = 2
        elseif general:isAttackerMagicerArmy() then
            cost = 3
        elseif general:isYuanChengArmy() then
            cost = 4
        elseif general:isJinZhanArmy() then
            cost = 5
        else
            cost = 6
        end
        return cost
    end

    table.sort(allGenerals, function(l, r)
        local costL = getCost(l)
        local costR = getCost(r)
        if costL == costR then
            return l:getScriptIndex() < r:getScriptIndex()
        end

        return costL < costR
    end)

    return allGenerals
end

--[[
    每个aiType经过计算，得到是一组行动命令，准确说就四种类型，而且组合方式仅有4种
    CMD_MOVE, CMD_ATTACK, CMD_MAGIC, CMD_NONE
    {CMD_MOVE}或{CMD_MOVE, CMD_ATTACK}或{CMD_MOVE, CMD_MAGIC}或{CMD_NONE}
    然后执行actionCmds即可
--]]
AiMgr.runAi = function(general, aiType)
    if not AiMgr.aiCaches[aiType] then
        -- lazy_init来生成实际的ai，然后进行计算
        AiMgr.aiCaches[aiType] = AI_CLASSES[aiType].new()
    end

    -- 检验武将是否可以行动，如混乱状态则不可行动
    if not general:canDoAction() then
        return {AiUtils.genNoneCmd()}
    end


    local ai = AiMgr.aiCaches[aiType]
    ai:setGeneral(general)
    return ai:run()
end

AiMgr.doCmds = function(general, index, actionCmds, callback)
    local actionCmd = actionCmds[index] or {}
    if actionCmd.cmd == "attack" then
        NormalAttack.new(actionCmd.attacker, actionCmd.mainTarget, actionCmd.targets, callback)
    elseif actionCmd.cmd == "magic" then
        MagicAttack.new(actionCmd.magicer, actionCmd.magicConfig, actionCmd.mainTarget, actionCmd.targets, callback)
    elseif actionCmd.cmd == "move" then
        EventMgr.triggerEvent(EventConst.GENERAL_AI_MOVE, actionCmd.mover, actionCmd.moveRow, actionCmd.moveCol, function()
            AiMgr.doCmds(general, index + 1, actionCmds, callback)
        end)
    else
        general:makeActionDone(callback)
    end
end

AiMgr.battleOver = function()
    AiMgr.isBattleDone = true
end

AiMgr.battleStart = function()
    AiMgr.isBattleDone = false
end

EventMgr.registerEvent(EventConst.BATTLE_OVER, AiMgr.battleOver)
EventMgr.registerEvent(EventConst.BATTLE_START, AiMgr.battleStart)

return AiMgr