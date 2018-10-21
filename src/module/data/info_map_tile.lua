
-- 导表工具自动生成

local MapTileInfo = {
    ["关隘"] = {
        ["curePercent"] = 20,
        ["fireSupport"] = 1,
        ["isRecoverTile"] = 1,
        ["name"] = "关隘",
        ["res"] = "RecoverTile_Pass",
    },
    ["兵营"] = {
        ["curePercent"] = 20,
        ["fireSupport"] = 1,
        ["isRecoverTile"] = 1,
        ["name"] = "兵营",
        ["res"] = "RecoverTile_Barrack",
    },
    ["地下"] = {
        ["name"] = "地下",
        ["res"] = "NormalMoveTile_Underground",
    },
    ["城内"] = {
        ["fireSupport"] = 1,
        ["name"] = "城内",
        ["res"] = "NormalMoveTile_City",
    },
    ["城墙"] = {
        ["isCannotMove"] = 1,
        ["name"] = "城墙",
        ["res"] = "NonMoveTile_Wall",
    },
    ["城池"] = {
        ["curePercent"] = 25,
        ["fireSupport"] = 1,
        ["isRecoverTile"] = 1,
        ["name"] = "城池",
        ["res"] = "RecoverTile_City",
    },
    ["城门"] = {
        ["isCannotMove"] = 1,
        ["name"] = "城门",
        ["res"] = "NonMoveTile_CityGate",
    },
    ["大河"] = {
        ["extraRes"] = "boat",
        ["name"] = "大河",
        ["res"] = "NormalMoveTile_River",
        ["waterSupport"] = 1,
        ["windSupport"] = 1,
    },
    ["宝物库"] = {
        ["curePercent"] = 10,
        ["fireSupport"] = 1,
        ["isRecoverTile"] = 1,
        ["name"] = "宝物库",
        ["res"] = "RecoverTile_Treasure",
    },
    ["小河"] = {
        ["isCannotMove"] = 1,
        ["name"] = "小河",
        ["res"] = "NonMoveTile_Brook",
    },
    ["山地"] = {
        ["mountainSupport"] = 1,
        ["name"] = "山地",
        ["res"] = "NormalMoveTile_Mountain",
        ["windSupport"] = 1,
    },
    ["山崖"] = {
        ["isCannotMove"] = 1,
        ["name"] = "山崖",
        ["res"] = "NonMoveTile_Cliff",
    },
    ["岩山"] = {
        ["isCannotMove"] = 1,
        ["name"] = "岩山",
        ["res"] = "NonMoveTile_Rock",
    },
    ["平原"] = {
        ["fireSupport"] = 1,
        ["name"] = "平原",
        ["res"] = "NormalMoveTile_Plain",
        ["windSupport"] = 1,
    },
    ["护城河"] = {
        ["isCannotMove"] = 1,
        ["name"] = "护城河",
        ["res"] = "NonMoveTile_CityRiver",
    },
    ["村庄"] = {
        ["curePercent"] = 15,
        ["fireSupport"] = 1,
        ["isRecoverTile"] = 1,
        ["name"] = "村庄",
        ["res"] = "RecoverTile_Village",
    },
    ["栅栏"] = {
        ["isCannotMove"] = 1,
        ["name"] = "栅栏",
        ["res"] = "NonMoveTile_Fences",
    },
    ["树林"] = {
        ["fireSupport"] = 1,
        ["name"] = "树林",
        ["res"] = "NormalMoveTile_Forest",
    },
    ["桥梁"] = {
        ["fireSupport"] = 1,
        ["name"] = "桥梁",
        ["res"] = "NormalMoveTile_Bridge",
        ["waterSupport"] = 1,
        ["windSupport"] = 1,
    },
    ["民居"] = {
        ["fireSupport"] = 1,
        ["name"] = "民居",
        ["res"] = "NormalMoveTile_Houses",
    },
    ["水池"] = {
        ["isCannotMove"] = 1,
        ["name"] = "水池",
        ["res"] = "NonMoveTile_Pool",
    },
    ["池塘"] = {
        ["isCannotMove"] = 1,
        ["name"] = "池塘",
        ["res"] = "NonMoveTile_Pond",
    },
    ["沼泽"] = {
        ["name"] = "沼泽",
        ["res"] = "NormalMoveTile_Swamp",
        ["waterSupport"] = 1,
        ["windSupport"] = 1,
    },
    ["浅滩"] = {
        ["name"] = "浅滩",
        ["res"] = "NormalMoveTile_Shoal",
        ["waterSupport"] = 1,
        ["windSupport"] = 1,
    },
    ["火"] = {
        ["isCannotMove"] = 1,
        ["name"] = "火",
        ["res"] = "NonMoveTile_Fire",
    },
    ["祭坛"] = {
        ["isCannotMove"] = 1,
        ["name"] = "祭坛",
        ["res"] = "NonMoveTile_Alta",
    },
    ["船"] = {
        ["isCannotMove"] = 1,
        ["name"] = "船",
        ["res"] = "NonMoveTile_Boat",
    },
    ["草原"] = {
        ["fireSupport"] = 1,
        ["name"] = "草原",
        ["res"] = "NormalMoveTile_Prairie",
        ["windSupport"] = 1,
    },
    ["荒地"] = {
        ["mountainSupport"] = 1,
        ["name"] = "荒地",
        ["res"] = "NormalMoveTile_Wasteland",
        ["windSupport"] = 1,
    },
    ["起火船"] = {
        ["isCannotMove"] = 1,
        ["name"] = "起火船",
        ["res"] = "NonMoveTile_Boat",
    },
    ["雪原"] = {
        ["name"] = "雪原",
        ["res"] = "NormalMoveTile_Snowfields",
        ["waterSupport"] = 1,
        ["windSupport"] = 1,
    },
    ["鹿砦"] = {
        ["curePercent"] = 25,
        ["fireSupport"] = 1,
        ["isRecoverTile"] = 1,
        ["name"] = "鹿砦",
        ["res"] = "RecoverTile_Abatis",
    },
}

return MapTileInfo
