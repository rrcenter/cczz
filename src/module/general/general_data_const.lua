--[[
    武将数据常量
--]]

local GeneralDataConst = {}

GeneralDataConst.PROP_WULI             = "wuli"
GeneralDataConst.PROP_ZHILI            = "zhili"
GeneralDataConst.PROP_MINJIE           = "minjie"
GeneralDataConst.PROP_YUNQI            = "yunqi"
GeneralDataConst.PROP_TONGSHUAI        = "tongshuai"
GeneralDataConst.PROP_WULI_ADD         = "wuliAdd"
GeneralDataConst.PROP_ZHILI_ADD        = "zhiliAdd"
GeneralDataConst.PROP_MINJIE_ADD       = "minjieAdd"
GeneralDataConst.PROP_YUNQI_ADD        = "yunqiAdd"
GeneralDataConst.PROP_TONGSHUAI_ADD    = "tongshuaiAdd"
GeneralDataConst.PROP_ARMYCATEGORY     = "armyCategory"
GeneralDataConst.PROP_ATTACKRATE       = "attackRate"
GeneralDataConst.PROP_DEFENSERATE      = "defenseRate"
GeneralDataConst.PROP_EXPLODERATE      = "explodeRate"
GeneralDataConst.PROP_MENTALITYRATE    = "mentalityRate"
GeneralDataConst.PROP_MORALERATE       = "moraleRate"
GeneralDataConst.PROP_ATTACK           = "attack"
GeneralDataConst.PROP_EXPLODE          = "explode"
GeneralDataConst.PROP_MENTALITY        = "mentality"
GeneralDataConst.PROP_DEFENSE          = "defense"
GeneralDataConst.PROP_MORALE           = "morale"
GeneralDataConst.PROP_MOVEMENT         = "movement"
GeneralDataConst.PROP_HPMAX            = "hp"
GeneralDataConst.PROP_MPMAX            = "mp"
GeneralDataConst.PROP_HPCUR            = "hpCur"
GeneralDataConst.PROP_MPCUR            = "mpCur"
GeneralDataConst.PROP_EXP              = "exp"
GeneralDataConst.PROP_LEVEL            = "level"
GeneralDataConst.PROP_RES              = "res"
GeneralDataConst.PROP_RETREATWORDS     = "retreatWords"
GeneralDataConst.PROP_CRITWORDS        = "critWords"
GeneralDataConst.PROP_HEAD             = "head"
GeneralDataConst.PROP_FUNDESC          = "funDesc"
GeneralDataConst.PROP_DESC             = "desc"
GeneralDataConst.PROP_ARMYNAME         = "name"
GeneralDataConst.PROP_WALKSOUND        = "walkSound"
GeneralDataConst.PROP_PROFESSION       = "profession"
GeneralDataConst.PROP_TILEADDITION     = "tileAddition"
GeneralDataConst.PROP_MAGICFACTOR      = "magicFactor"
GeneralDataConst.PROP_TURNBEGIN        = "trunBegin"
GeneralDataConst.PROP_OUTSTATUS        = "outStatus"
GeneralDataConst.PROP_OUTSTATUSRATE    = "outStatusRate"
GeneralDataConst.PROP_MOVEMENTCOST     = "movementCost"
GeneralDataConst.PROP_MAGICDAMGEFACTOR = "magicDamgeFactor"
GeneralDataConst.PROP_ATTACKRANGETYPE  = "attackRangeType"
GeneralDataConst.PROP_HITRANGETYPE     = "hitRangeType"
GeneralDataConst.PROP_MAGICS           = "magics"
GeneralDataConst.PROP_PROFESSIONDESC   = "desc"
GeneralDataConst.PROP_NAME             = "name"
GeneralDataConst.PROP_ARMYTYPE         = "armyType"
GeneralDataConst.PROP_ARMYDAMGEFACTOR  = "armyDamgeFactor"

GeneralDataConst.EQUIP_WUQI    = "wuqi"
GeneralDataConst.EQUIP_FANGJU  = "fangju"
GeneralDataConst.EQUIP_SHIPING = "shiping"

GeneralDataConst.SAVE_DATA_PROPS = {
    GeneralDataConst.PROP_WULI_ADD,
    GeneralDataConst.PROP_ZHILI_ADD,
    GeneralDataConst.PROP_MINJIE_ADD,
    GeneralDataConst.PROP_YUNQI_ADD,
    GeneralDataConst.PROP_TONGSHUAI_ADD,
    GeneralDataConst.PROP_ATTACK,
    GeneralDataConst.PROP_EXPLODE,
    GeneralDataConst.PROP_MENTALITY,
    GeneralDataConst.PROP_DEFENSE,
    GeneralDataConst.PROP_MORALE,
    GeneralDataConst.PROP_MOVEMENT,
    GeneralDataConst.PROP_HPMAX,
    GeneralDataConst.PROP_MPMAX,
    GeneralDataConst.PROP_LEVEL,
    GeneralDataConst.PROP_MOVEMENT,
    GeneralDataConst.PROP_EXP,
}

GeneralDataConst.ABILITY_RATE_PROPS = {
    [GeneralDataConst.PROP_ATTACKRATE]    = true,
    [GeneralDataConst.PROP_DEFENSERATE]   = true,
    [GeneralDataConst.PROP_EXPLODERATE]   = true,
    [GeneralDataConst.PROP_MENTALITYRATE] = true,
    [GeneralDataConst.PROP_MORALERATE]    = true,
}

GeneralDataConst.ARMY_PROPS = {
    [GeneralDataConst.PROP_ARMYCATEGORY]     = true,
    [GeneralDataConst.PROP_WALKSOUND]        = true,
    [GeneralDataConst.PROP_PROFESSION]       = true,
    [GeneralDataConst.PROP_TILEADDITION]     = true,
    [GeneralDataConst.PROP_MAGICFACTOR]      = true,
    [GeneralDataConst.PROP_MAGICDAMGEFACTOR] = true,
    [GeneralDataConst.PROP_TURNBEGIN]        = true,
    [GeneralDataConst.PROP_OUTSTATUS]        = true,
    [GeneralDataConst.PROP_OUTSTATUSRATE]    = true,
    [GeneralDataConst.PROP_MOVEMENTCOST]     = true,
    [GeneralDataConst.PROP_ARMYNAME]         = true,
}

GeneralDataConst.PROFESSION_PROPS = {
    [GeneralDataConst.PROP_ATTACKRANGETYPE] = true,
    [GeneralDataConst.PROP_HITRANGETYPE]    = true,
    [GeneralDataConst.PROP_MAGICS]          = true,
    [GeneralDataConst.PROP_PROFESSIONDESC]  = true,
    [GeneralDataConst.PROP_ARMYDAMGEFACTOR] = true,
    [GeneralDataConst.PROP_MOVEMENT]        = true,
}

GeneralDataConst.GENERAL_PROPS = {
    [GeneralDataConst.PROP_RETREATWORDS] = true,
    [GeneralDataConst.PROP_CRITWORDS]    = true,
    [GeneralDataConst.PROP_HEAD]         = true,
    [GeneralDataConst.PROP_FUNDESC]      = true,
    [GeneralDataConst.PROP_DESC]         = true,
    [GeneralDataConst.PROP_ARMYTYPE]     = true,
    [GeneralDataConst.PROP_NAME]         = true,
}

GeneralDataConst.ABILITY_MAPPING = {
    [GeneralDataConst.PROP_ATTACK]    = GeneralDataConst.PROP_WULI,
    [GeneralDataConst.PROP_EXPLODE]   = GeneralDataConst.PROP_ZHILI,
    [GeneralDataConst.PROP_MENTALITY] = GeneralDataConst.PROP_MINJIE,
    [GeneralDataConst.PROP_DEFENSE]   = GeneralDataConst.PROP_YUNQI,
    [GeneralDataConst.PROP_MORALE]    = GeneralDataConst.PROP_TONGSHUAI,
}

GeneralDataConst.ADD_PROP_MAPPING = {
    [GeneralDataConst.PROP_WULI]      = GeneralDataConst.PROP_WULI_ADD,
    [GeneralDataConst.PROP_ZHILI]     = GeneralDataConst.PROP_ZHILI_ADD,
    [GeneralDataConst.PROP_MINJIE]    = GeneralDataConst.PROP_MINJIE_ADD,
    [GeneralDataConst.PROP_YUNQI]     = GeneralDataConst.PROP_YUNQI_ADD,
    [GeneralDataConst.PROP_TONGSHUAI] = GeneralDataConst.PROP_TONGSHUAI_ADD,
}

GeneralDataConst.ALL_EQUIP_TYPES = {
    GeneralDataConst.EQUIP_WUQI,
    GeneralDataConst.EQUIP_FANGJU,
    GeneralDataConst.EQUIP_SHIPING,
}

return GeneralDataConst