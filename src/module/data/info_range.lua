
-- 导表工具自动生成

local RangeInfo = {
    ["RANGE_ALL"] = {
        ["desc"] = "全屏攻击，某些技能",
        ["icon"] = "range_all",
        ["rangeType"] = "all",
    },
    ["RANGE_CIRCLE_12"] = {
        ["args"] = {
            2,
        },
        ["desc"] = "拿了没羽箭的山贼",
        ["icon"] = "range_circle_12",
        ["rangeType"] = "circle",
    },
    ["RANGE_CIRCLE_24"] = {
        ["args"] = {
            3,
        },
        ["desc"] = "计谋的攻击范围",
        ["icon"] = "range_circle_24",
        ["rangeType"] = "circle",
    },
    ["RANGE_CIRCLE_40"] = {
        ["args"] = {
            4,
        },
        ["desc"] = "也像是计谋一样的攻击范围",
        ["icon"] = "range_circle_40",
        ["rangeType"] = "circle",
    },
    ["RANGE_INTERVAL_CIRCLE_16"] = {
        ["args"] = {
            3,
            4,
        },
        ["desc"] = "16个间隔攻击块，如炮车",
        ["icon"] = "range_interval_circle_16",
        ["rangeType"] = "intervalCircle",
    },
    ["RANGE_INTERVAL_CIRCLE_20"] = {
        ["args"] = {
            1,
            3,
        },
        ["desc"] = "20个间隔攻击块，如弩兵",
        ["icon"] = "range_interval_circle_20",
        ["rangeType"] = "intervalCircle",
    },
    ["RANGE_INTERVAL_CIRCLE_36"] = {
        ["args"] = {
            3,
            5,
        },
        ["desc"] = "36个间隔攻击块，如霹雳车",
        ["icon"] = "range_interval_circle_36",
        ["rangeType"] = "intervalCircle",
    },
    ["RANGE_INTERVAL_CIRCLE_36_2"] = {
        ["args"] = {
            1,
            4,
        },
        ["desc"] = "36个间隔攻击块，如连弩兵",
        ["icon"] = "range_interval_circle_36_2",
        ["rangeType"] = "intervalCircle",
    },
    ["RANGE_INTERVAL_CIRCLE_8"] = {
        ["args"] = {
            1,
            2,
        },
        ["desc"] = "8个间隔攻击块，如弓兵",
        ["icon"] = "range_interval_circle_8",
        ["rangeType"] = "intervalCircle",
    },
    ["RANGE_INTERVAL_LINE_4"] = {
        ["args"] = {
            1,
            2,
        },
        ["desc"] = "弓骑兵攻击范围",
        ["icon"] = "range_interval_line_4",
        ["rangeType"] = "intervalLine",
    },
    ["RANGE_LINE_4"] = {
        ["args"] = {
            1,
        },
        ["desc"] = "4个单点的攻击范围，如骑兵",
        ["icon"] = "range_line_4",
        ["rangeType"] = "line",
    },
    ["RANGE_LINE_8"] = {
        ["args"] = {
            2,
        },
        ["desc"] = "计谋烈爆一样，四个方向的直线范围，和驯虎师差不多",
        ["icon"] = "range_line_8",
        ["rangeType"] = "line",
    },
    ["RANGE_NONE"] = {
        ["desc"] = "无攻击范围，如皇帝这个兵种",
        ["icon"] = "range_none",
        ["rangeType"] = "none",
    },
    ["RANGE_RECT_8"] = {
        ["args"] = {
            1,
        },
        ["desc"] = "步兵攻击范围",
        ["icon"] = "range_rect_8",
        ["rangeType"] = "rect",
    },
    ["RANGE_SELF"] = {
        ["desc"] = "单点的攻击范围，如针对自身释放的策略",
        ["icon"] = "range_dot",
        ["rangeType"] = "self",
    },
    ["RANGE_SINGLE_LINE_2"] = {
        ["args"] = {
            2,
        },
        ["desc"] = "单直线攻击范围，主要是为了蛇矛和训熊师这一类的",
        ["icon"] = "type_line_2",
        ["rangeType"] = "singleLine",
    },
    ["RANGE_SINGLE_LINE_5"] = {
        ["args"] = {
            5,
        },
        ["desc"] = "单直线攻击范围，主要是为了炎爆这类技能",
        ["icon"] = "type_line_5",
        ["rangeType"] = "singleLine",
    },
}

return RangeInfo
