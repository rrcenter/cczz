--[[
    导入所有的公共数据
--]]

-- 自动导表得到
EquipEffectInfo   = import(".info_equip_effect")
ShopItemsInfo     = import(".info_shop_items")
MapTileInfo       = import(".info_map_tile")

-- 目前以下还是手撸的，逐步替换为自动导表
LimitValueInfo  = import(".info_limit_value")

-- 临时产生的映射表
ArmyMappingInfo   = import(".info_army_mapping")
PropMappingInfo   = import(".info_prop_mapping")
MagicMappingInfo  = import(".info_magic_mapping")
StatusMappingInfo = import(".info_status_mapping")

InfoUtil = import(".info_util")