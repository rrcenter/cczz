--[[
    提供一些数据的辅助接口
--]]

local MagicInfo         = import(".info_magic")
local StatusInfo        = import(".info_status")
local RangeInfo         = import(".info_range")
local GeneralInfo       = import(".info_general")
local GeneralActionInfo = import(".info_general_action")
local ArmyInfo          = import(".info_army")
local ProfessionInfo    = import(".info_profession")
local EquipTypeInfo     = import(".info_equip_type")
local ItemTypeInfo      = import(".info_item_type")
local ResPathInfo       = import(".info_res_path")

local InfoUtil = {}

InfoUtil.getPath = function(path, type)
    if not path then
        return path
    end

    local pathInfo = ResPathInfo[type]
    if pathInfo then
        return (pathInfo.prefix or "") .. path .. (pathInfo.postfix or "")
    end

    return path
end

InfoUtil.getItemPath = function(path, itemType)
    if itemType == "消耗品" then
        return InfoUtil.getPath(path, "item")
    else
        return InfoUtil.getPath(path, "equip")
    end
end

InfoUtil.getItemConfig = function(itemId)
    return ItemTypeInfo[itemId] or EquipTypeInfo[itemId]
end

InfoUtil.isEquipItem = function(itemId)
    return EquipTypeInfo[itemId]
end

InfoUtil.getMagicConfig = function(magicId)
    return MagicInfo[magicId]
end

InfoUtil.getMagicIcon = function(magicId)
    local magicConfig = InfoUtil.getMagicConfig(magicId)
    if magicConfig then
        return InfoUtil.getPath(magicConfig.icon, "magicIcon")
    else
        printInfo("无此技能图片：%s", magicId)
    end
end

InfoUtil.getStatusConfig = function(statusId)
    return StatusInfo[statusId]
end

InfoUtil.getStatusIcon = function(statusId)
    local statusConfig = InfoUtil.getStatusConfig(statusId)
    if statusConfig then
        return InfoUtil.getPath(statusConfig.icon, "statusIcon")
    else
        printInfo("无此状态的图标：%s", statusId)
    end
end

InfoUtil.getRangeConfig = function(rangeId)
    return RangeInfo[rangeId]
end

InfoUtil.getRangeIcon = function(rangeId)
    local rangeConfig = InfoUtil.getRangeConfig(rangeId)
    if rangeConfig then
        return InfoUtil.getPath(rangeConfig.icon, "rangeIcon")
    else
        printInfo("无此攻击范围的图标：%s", rangeId)
    end
end

InfoUtil.getArmyConfig = function(armyId)
    return ArmyInfo[armyId]
end

InfoUtil.getProfessionLevel = function(armyType, professionId)
    local armyConfig = InfoUtil.getArmyConfig(armyType)
    return table.indexof(armyConfig.profession, professionId)
end

InfoUtil.getProfessionConfig = function(professionId)
    return ProfessionInfo[professionId]
end

InfoUtil.getGeneralConfig = function(generalId)
    return GeneralInfo[generalId]
end

InfoUtil.getGeneralAnimation = function(generalId, professionId, side)
    local generalConfig    = InfoUtil.getGeneralConfig(generalId)
    local professionLevel  = InfoUtil.getProfessionLevel(generalConfig.armyType, professionId)
    local professionConfig = InfoUtil.getProfessionConfig(professionId)
    -- 优先使用武将本身的动画资源，无则使用职业动画
    local res = generalConfig.animation and generalConfig.animation[professionLevel] or professionConfig.animation[side]
    return {prefix = "ccz/char/", actions = GeneralActionInfo, res = res}
end

return InfoUtil