
-- 导表工具自动生成

local StatusInfo = {
    ["中毒"] = {
        ["icon"] = "du",
        ["name"] = "中毒",
        ["removeFunc"] = function(status, general)  return general:getBasicProp2("yunqi") / 2  end,
    },
    ["全属性上升"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_21(state)",
            ["frameLen"] = 20,
            ["res"] = "Meff_21",
            ["startIndex"] = 1,
        },
        ["icon"] = "21",
        ["lastRounds"] = 2,
        ["name"] = "全属性上升",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") > 100 then return 10 else return 60 - general:getBasicProp2("yunqi") / 2 end  end,
        ["subStatuses"] = {
            "能力上升",
            "爆发力上升",
            "士气上升",
            "防御上升",
        },
        ["type"] = "addProp",
    },
    ["全属性下降"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_14(state)",
            ["frameLen"] = 9,
            ["res"] = "Meff_14",
            ["startIndex"] = 1,
        },
        ["icon"] = "14",
        ["lastRounds"] = 2,
        ["name"] = "全属性下降",
        ["removeFunc"] = function(status, general)  return general:getBasicProp2("yunqi") / 2  end,
        ["subStatuses"] = {
            "能力下降",
            "爆发力下降",
            "士气下降",
            "防御下降",
        },
        ["type"] = "subProp",
    },
    ["士气上升"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_15(state)",
            ["frameLen"] = 20,
            ["res"] = "Meff_15",
            ["startIndex"] = 1,
        },
        ["icon"] = "15",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "士气上升",
                ["name"] = "Morale",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "士气上升",
                ["name"] = "Morale",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "士气上升",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") > 100 then return 10 else return 60 - general:getBasicProp2("yunqi") / 2 end  end,
        ["type"] = "addProp",
    },
    ["士气下降"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_16(state)",
            ["frameLen"] = 9,
            ["res"] = "Meff_16",
            ["startIndex"] = 1,
        },
        ["icon"] = "16",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "士气下降",
                ["name"] = "Morale",
                ["value"] = 0.300000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "士气下降",
                ["name"] = "Morale",
                ["value"] = 0.300000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "士气下降",
        ["removeFunc"] = function(status, general)  return general:getBasicProp2("yunqi") / 2  end,
        ["type"] = "subProp",
    },
    ["定身"] = {
        ["icon"] = "fengzhou",
        ["name"] = "定身",
        ["removeFunc"] = function(status, general)  return general:getBasicProp2("yunqi") / 2  end,
    },
    ["封咒"] = {
        ["icon"] = "dingshen",
        ["name"] = "封咒",
        ["removeFunc"] = function(status, general)  return general:getBasicProp2("yunqi") / 2  end,
    },
    ["攻击力上升"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_13(state)",
            ["frameLen"] = 20,
            ["res"] = "Meff_13",
            ["startIndex"] = 1,
        },
        ["icon"] = "13",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "攻击力上升",
                ["name"] = "Attack",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "攻击力上升",
                ["name"] = "Attack",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "攻击力上升",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") > 100 then return 10 else return 60 - general:getBasicProp2("yunqi") / 2 end  end,
        ["type"] = "addProp",
    },
    ["混乱"] = {
        ["icon"] = "hunluan",
        ["name"] = "混乱",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") < 50 then return 10 else return general:getBasicProp2("yunqi") / 2 - 15 end  end,
    },
    ["爆发力上升"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_17(state)",
            ["frameLen"] = 20,
            ["res"] = "Meff_17",
            ["startIndex"] = 1,
        },
        ["icon"] = "17",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "爆发力上升",
                ["name"] = "Explode",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "爆发力上升",
                ["name"] = "Explode",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "爆发力上升",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") > 100 then return 10 else return 60 - general:getBasicProp2("yunqi") / 2 end  end,
        ["type"] = "addProp",
    },
    ["爆发力下降"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_18(state)",
            ["frameLen"] = 17,
            ["res"] = "Meff_18",
            ["startIndex"] = 1,
        },
        ["icon"] = "18",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "爆发力下降",
                ["name"] = "Explode",
                ["value"] = 0.300000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "爆发力下降",
                ["name"] = "Explode",
                ["value"] = 0.300000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "爆发力下降",
        ["removeFunc"] = function(status, general)  return general:getBasicProp2("yunqi") / 2  end,
        ["type"] = "subProp",
    },
    ["移动上升"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_22(state)",
            ["frameLen"] = 20,
            ["res"] = "Meff_22",
            ["startIndex"] = 1,
        },
        ["icon"] = "22",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "移动上升",
                ["name"] = "Movement",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "移动上升",
                ["name"] = "Movement",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "移动上升",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") > 100 then return 10 else return 60 - general:getBasicProp2("yunqi") / 2 end  end,
        ["type"] = "addProp",
    },
    ["精神力上升"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_13(state)",
            ["frameLen"] = 20,
            ["res"] = "Meff_13",
            ["startIndex"] = 1,
        },
        ["icon"] = "13",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "精神力上升",
                ["name"] = "Mentality",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "精神力上升",
                ["name"] = "Mentality",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "精神力上升",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") > 100 then return 10 else return 60 - general:getBasicProp2("yunqi") / 2 end  end,
        ["type"] = "addProp",
    },
    ["能力上升"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_13(state)",
            ["frameLen"] = 20,
            ["res"] = "Meff_13",
            ["startIndex"] = 1,
        },
        ["icon"] = "13",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "能力上升",
                ["name"] = "Mentality",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "能力上升",
                ["name"] = "Attack",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "能力上升",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") > 100 then return 10 else return 60 - general:getBasicProp2("yunqi") / 2 end  end,
        ["type"] = "addProp",
    },
    ["能力下降"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_14(state)",
            ["frameLen"] = 10,
            ["res"] = "Meff_14",
            ["startIndex"] = 1,
        },
        ["icon"] = "14",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "能力下降",
                ["name"] = "Mentality",
                ["value"] = 0.300000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "能力下降",
                ["name"] = "Attack",
                ["value"] = 0.300000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "能力下降",
        ["removeFunc"] = function(status, general)  return general:getBasicProp2("yunqi") / 2  end,
        ["type"] = "subProp",
    },
    ["防御上升"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_19(state)",
            ["frameLen"] = 20,
            ["res"] = "Meff_19",
            ["startIndex"] = 1,
        },
        ["icon"] = "19",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "防御上升",
                ["name"] = "Defense",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "防御上升",
                ["name"] = "Defense",
                ["value"] = 0.200000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "防御上升",
        ["removeFunc"] = function(status, general)  if general:getBasicProp2("yunqi") > 100 then return 10 else return 60 - general:getBasicProp2("yunqi") / 2 end  end,
        ["type"] = "addProp",
    },
    ["防御下降"] = {
        ["animationConfig"] = {
            ["action"] = "Meff_20(state)",
            ["frameLen"] = 9,
            ["res"] = "Meff_20",
            ["startIndex"] = 1,
        },
        ["icon"] = "20",
        ["influenceProps"] = {
            ["wen"] = {
                ["desc"] = "防御下降",
                ["name"] = "Defense",
                ["value"] = 0.300000,
                ["valueType"] = "percent",
            },
            ["wu"] = {
                ["desc"] = "防御下降",
                ["name"] = "Defense",
                ["value"] = 0.300000,
                ["valueType"] = "percent",
            },
        },
        ["lastRounds"] = 2,
        ["name"] = "防御下降",
        ["removeFunc"] = function(status, general)  return general:getBasicProp2("yunqi") / 2  end,
        ["type"] = "subProp",
    },
}

return StatusInfo
