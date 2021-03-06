local Plot = {}

-- 战斗准备设置
Plot.battlePrepare = {
    battleName   = "五丈原之战",
    maxRounds    = 40,
    mapId        = "56.tmx",
    weatherStart = {"雨", "阴", "豪雨", "雪", "雪"},
    weatherType  = {"雨"},
    levelAdd     = -2,
    playerGeneralList = {
        {uid = "曹操"},
        {uid = "夏侯惇"},
    },
    enemyGeneralList = {
        {uid = "诸葛亮", aiType = "坚守原地", levelAdd = 4},
        {uid = "姜维", aiType = "坚守原地", levelAdd = 4},
        {uid = "策士1", aiType = "坚守原地"},
        {uid = "策士2", aiType = "坚守原地"},
        {uid = "炮兵1", aiType = "被动出击"},
        {uid = "炮兵2", aiType = "被动出击"},
        {uid = "炮兵3", aiType = "被动出击"},
        {uid = "炮兵4", aiType = "被动出击"},
        {uid = "炮兵5", aiType = "被动出击"},
        {uid = "炮兵6", aiType = "被动出击"},
        {uid = "步兵1", aiType = "坚守原地"},
        {uid = "步兵2", aiType = "坚守原地"},
        {uid = "步兵3", aiType = "坚守原地"},
        {uid = "步兵4", aiType = "坚守原地"},
        {uid = "步兵5", aiType = "坚守原地"},
        {uid = "步兵6", aiType = "坚守原地"},
        {uid = "弓兵1", aiType = "坚守原地"},
        {uid = "弓兵2", aiType = "坚守原地"},
        {uid = "弓兵3", aiType = "坚守原地"},
        {uid = "魏延", aiType = "坚守原地", levelAdd = 4},
        {uid = "赵云", aiType = "坚守原地", levelAdd = 4},
        {uid = "黄忠", aiType = "坚守原地", levelAdd = 4},
        {uid = "骑兵1", aiType = "坚守原地"},
        {uid = "骑兵2", aiType = "坚守原地"},
        {uid = "骑兵3", aiType = "坚守原地"},
        {uid = "骑兵4", aiType = "坚守原地"},
        {uid = "弓骑兵1", aiType = "坚守原地"},
        {uid = "弓骑兵2", aiType = "坚守原地"},
        {uid = "马超", aiType = "坚守原地", levelAdd = 4},
        {uid = "马岱", aiType = "坚守原地", levelAdd = 4},
        {uid = "西凉骑兵1", aiType = "坚守原地"},
        {uid = "西凉骑兵2", aiType = "坚守原地"},
        {uid = "西凉骑兵3", aiType = "坚守原地"},
        {uid = "西凉骑兵4", aiType = "坚守原地"},
        {uid = "西凉骑兵5", aiType = "坚守原地"},
        {uid = "西凉骑兵6", aiType = "坚守原地"},
        {uid = "西凉骑兵7", aiType = "坚守原地"},
        {uid = "海盗1", aiType = "坚守原地"},
        {uid = "海盗2", aiType = "坚守原地"},
        {uid = "海盗3", aiType = "坚守原地"},
        {uid = "海盗4", aiType = "坚守原地"},
        {uid = "海盗5", aiType = "坚守原地"},
        {uid = "武术家1", aiType = "坚守原地"},
        {uid = "武术家2", aiType = "坚守原地"},
        {uid = "风水士1", aiType = "坚守原地"},
        {uid = "风水士2", aiType = "坚守原地"},
        {uid = "孟获", aiType = "主动出击", isHide = true, levelAdd = 2},
        {uid = "祝融", aiType = "主动出击", isHide = true, levelAdd = 4},
        {uid = "驯虎师1", aiType = "主动出击", isHide = true},
        {uid = "驯虎师2", aiType = "主动出击", isHide = true},
        {uid = "驯虎师3", aiType = "主动出击", isHide = true},
        {uid = "驯熊师1", aiType = "主动出击", isHide = true},
        {uid = "驯熊师2", aiType = "主动出击", isHide = true},
        {uid = "驯熊师3", aiType = "主动出击", isHide = true},
        {uid = "道士1", aiType = "主动出击", isHide = true},
        {uid = "孟优", aiType = "主动出击", isHide = true, levelAdd = 2},
        {uid = "贼兵1", aiType = "主动出击", isHide = true},
        {uid = "贼兵2", aiType = "主动出击", isHide = true},
        {uid = "贼兵3", aiType = "主动出击", isHide = true},
        {uid = "贼兵4", aiType = "主动出击", isHide = true},
        {uid = "贼兵5", aiType = "主动出击", isHide = true},
        {uid = "贼兵6", aiType = "主动出击", isHide = true},
        {uid = "道士2", aiType = "主动出击", isHide = true},
        {uid = "道士3", aiType = "主动出击", isHide = true},
        {uid = "木人1", aiType = "主动出击", isHide = true},
        {uid = "木人2", aiType = "主动出击", isHide = true},
        {uid = "木人3", aiType = "主动出击", isHide = true},
        {uid = "木人4", aiType = "主动出击", isHide = true},
        {uid = "步兵7", aiType = "主动出击"},
        {uid = "步兵8", aiType = "主动出击"},
        {uid = "步兵9", aiType = "主动出击"},
        {uid = "弓兵4", aiType = "主动出击"},
        {uid = "弓兵5", aiType = "主动出击"},
        {uid = "步兵10", aiType = "被动出击"},
        {uid = "步兵11", aiType = "被动出击"},
        {uid = "步兵12", aiType = "被动出击"},
        {uid = "弓兵6", aiType = "被动出击"},
        {uid = "弓兵7", aiType = "被动出击"},
    },
}

Plot.battleStartPlot = {
    {
        {cmd = "GeneralEquipsSet", args = {"诸葛亮", "白羽扇", 0, "鹤氅", 0, "诸葛巾"}},
        {cmd = "GeneralEquipsSet", args = {"赵云", "默认装备", 0, "白银铠", 0, "默认装备"}},
    },
    {cmd = "PlayMusic", args = {"Track12"}},
    {
        {cmd = "FaceToFace", args = {"诸葛亮", "姜维"}},
        {cmd = "FaceToFace", args = {"姜维", "诸葛亮"}},
        {cmd = "Dialog", args = {"诸葛亮", "姜维，地下祭坛已经建成了吧？"}},
        {cmd = "Dialog", args = {"姜维", "是的，姜维已经亲自查过，一切依照丞相吩咐完成了。"}},
        {cmd = "RoleMove", args = {"诸葛亮", "down", 29, 4}},
        {cmd = "RoleMove", args = {"姜维", "down", 29, 5}},
        {cmd = "FaceToFace", args = {"诸葛亮", "姜维"}},
        {cmd = "FaceToFace", args = {"姜维", "诸葛亮"}},
        {cmd = "Dialog", args = {"诸葛亮", "那么我这就潜入地下。"}},
        {cmd = "Dialog", args = {"诸葛亮", "千万别让曹军接近。"}},
        {cmd = "Dialog", args = {"姜维", "是！"}},
        {cmd = "Dialog", args = {"姜维", "此后就交由姜维处理吧。"}},
        {cmd = "GeneralChangeDirection", args = {"诸葛亮", "up"}},
        {cmd = "Dialog", args = {"诸葛亮", "（魔王的神力终于要复苏了。\n哈、哈、哈！）"}},
        {cmd = "RoleDisappear", args = {"诸葛亮"}},
        {cmd = "RoleMove", args = {"姜维", "down", 29, 7}},
        {cmd = "GeneralAction", args = {"姜维", "prepareAttack"}},
        {cmd = "Dialog", args = {"姜维", "全军备战，阻挡曹军攻势。"}},
        {cmd = "Dialog", args = {"姜维", "千万别让他们接近地下的祭坛！"}},
        {cmd = "GeneralAction", args = {"姜维", "stand"}},
        {cmd = "FaceToFace", args = {"曹操", "姜维"}},
        {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
        {cmd = "Dialog", args = {"曹操", "既然魔王因徐庶之计无法复活，如今蜀军也不足为惧了！"}},
        {cmd = "Dialog", args = {"曹操", "全军前进！"}},
        {cmd = "GeneralAction", args = {"曹操", "stand"}},
        {cmd = "GeneralChangeDirection", args = {"曹操", "down"}},
        {cmd = "Dialog", args = {"曹操", "（……这天气恶劣得令人厌恶。\n魔王虽不复生，但只要有孔明在……\n难道真无法速战速决了吗？）"}},
    },
    {cmd = "BattleWinCondition", args = {"胜利条件\n一、击败姜维。\n\n失败条件\n一、曹操死亡。\n二、超过40回合。"}},
    {cmd = "ShowBattleWinCondition", args = {"击败姜维！"}},
    {cmd = "HighlightGeneral", args = {"姜维"}},
    {cmd = "VarSet", args = {"Var556", true}},
    {cmd = "ShowMenu", args = {true}},
}

Plot.battleMiddlePlot = {
    {
        {cmd = "RoundsTest", args = {4, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var70"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var70", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {7, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var71"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var71", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {10, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var72"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var72", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {13, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var73"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var73", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {16, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var74"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var74", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {19, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var75"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var75", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {22, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var76"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var76", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {25, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var77"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var77", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {28, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var78"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var78", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {31, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var79"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var79", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {34, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var80"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var80", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {37, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var81"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var81", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {40, "="}},
        {cmd = "VarTest", args = {{trueConditions = {"Var36"}, falseConditions = {"Var82"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "GeneralReborn", args = {"木人1", 28, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人2", 29, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人3", 30, 9, "down"}},
                {cmd = "GeneralReborn", args = {"木人4", 29, 8, "down"}},
            },
            {cmd = "VarSet", args = {"Var82", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 29, 7}},
        {cmd = "VarTest", args = {{falseConditions = {"Var20"}}}},
        {
            {cmd = "AddItem", args = {"恢复用米", 0}},
            {cmd = "VarSet", args = {"Var20", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 14, 30}},
        {cmd = "VarTest", args = {{falseConditions = {"Var21"}}}},
        {
            {cmd = "AddItem", args = {"恢复用米", 0}},
            {cmd = "VarSet", args = {"Var21", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 6, 21, 16, 33}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var31", "Var32"}}}},
        {
            {
                {cmd = "GeneralShow", args = {"孟优"}},
                {cmd = "GeneralShow", args = {"贼兵1"}},
                {cmd = "GeneralShow", args = {"贼兵2"}},
                {cmd = "GeneralShow", args = {"贼兵3"}},
                {cmd = "GeneralShow", args = {"道士2"}},
                {cmd = "GeneralShow", args = {"贼兵4"}},
                {cmd = "GeneralShow", args = {"贼兵5"}},
                {cmd = "GeneralShow", args = {"贼兵6"}},
                {cmd = "GeneralShow", args = {"道士3"}},
                {cmd = "Dialog", args = {"孟优", "来吧！冲上去！"}},
                {cmd = "Dialog", args = {"孟优", "等等，这么杀过去真的行吗？"}},
                {cmd = "Dialog", args = {"孟优", "啊，人都到哪去啦？"}},
                {cmd = "Dialog", args = {"孟优", "姜维不是说在这等就可以碰上的吗？"}},
                {cmd = "Dialog", args = {"曹操", "哼，这些伏兵何足为惧！"}},
            },
            {
                {cmd = "GeneralShow", args = {"孟获"}},
                {cmd = "GeneralShow", args = {"驯熊师1"}},
                {cmd = "GeneralShow", args = {"驯熊师2"}},
                {cmd = "GeneralShow", args = {"驯熊师3"}},
                {cmd = "GeneralShow", args = {"祝融"}},
                {cmd = "GeneralShow", args = {"驯虎师1"}},
                {cmd = "GeneralShow", args = {"驯虎师2"}},
                {cmd = "GeneralShow", args = {"驯虎师3"}},
                {cmd = "GeneralShow", args = {"道士1"}},
                {cmd = "FaceToFace", args = {"孟获", "曹操"}},
                {cmd = "FaceToFace", args = {"祝融", "曹操"}},
                {cmd = "Dialog", args = {"孟获", "俺不早说过了吗？没有向导带路，俺根本不知道北边山路怎么走的嘛！"}},
                {cmd = "Dialog", args = {"孟获", "谁知道咱们现在来到啥子地方了？"}},
                {cmd = "Dialog", args = {"祝融", "唷，那不是曹操吗？"}},
                {cmd = "Dialog", args = {"祝融", "能够在此相逢真是奇遇噢。"}},
                {cmd = "Dialog", args = {"祝融", "姑奶奶就陪他玩一玩吧！"}},
                {cmd = "Dialog", args = {"孟获", "什么？"}},
                {cmd = "Dialog", args = {"孟获", "他怎么会跑到这来？"}},
                {cmd = "Dialog", args = {"孟获", "你又高兴个什么劲儿？"}},
                {cmd = "Dialog", args = {"祝融", "怕什么呀！"}},
                {cmd = "Dialog", args = {"祝融", "大伙儿上啊！"}},
                {cmd = "Dialog", args = {"曹操", "这下子不就腹背受敌了吗？"}},
                {cmd = "Dialog", args = {"曹操", "这些家伙来得真不是时候！"}},
            },
            {cmd = "VarSet", args = {"Var31", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 14, 10, 24, 18}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var31", "Var32"}}}},
        {
            {
                {cmd = "GeneralShow", args = {"孟优"}},
                {cmd = "GeneralShow", args = {"贼兵1"}},
                {cmd = "GeneralShow", args = {"贼兵2"}},
                {cmd = "GeneralShow", args = {"贼兵3"}},
                {cmd = "GeneralShow", args = {"道士2"}},
                {cmd = "GeneralShow", args = {"贼兵4"}},
                {cmd = "GeneralShow", args = {"贼兵5"}},
                {cmd = "GeneralShow", args = {"贼兵6"}},
                {cmd = "GeneralShow", args = {"道士3"}},
                {cmd = "Dialog", args = {"孟优", "唉，跟大伙儿走散也就算了，现在连一个曹军的影子都没见着。"}},
                {cmd = "Dialog", args = {"孟优", "我可怎么办啊？"}},
            },
            {
                {cmd = "GeneralShow", args = {"孟获"}},
                {cmd = "GeneralShow", args = {"驯熊师1"}},
                {cmd = "GeneralShow", args = {"驯熊师2"}},
                {cmd = "GeneralShow", args = {"驯熊师3"}},
                {cmd = "GeneralShow", args = {"祝融"}},
                {cmd = "GeneralShow", args = {"驯虎师1"}},
                {cmd = "GeneralShow", args = {"驯虎师2"}},
                {cmd = "GeneralShow", args = {"驯虎师3"}},
                {cmd = "GeneralShow", args = {"道士1"}},
                {cmd = "FaceToFace", args = {"孟获", "曹操"}},
                {cmd = "FaceToFace", args = {"祝融", "曹操"}},
                {cmd = "Dialog", args = {"孟获", "俺不早说过了吗？没有向导带路，俺根本不知道北边山路怎么走的嘛！"}},
                {cmd = "Dialog", args = {"孟获", "谁知道咱们现在来到啥子地方了？"}},
                {cmd = "Dialog", args = {"祝融", "看起来是有点怪了。"}},
                {cmd = "Dialog", args = {"祝融", "赶紧追上去吧！"}},
            },
            {cmd = "VarSet", args = {"Var32", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 18, 26, 40, 40}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var33"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {
                    {cmd = "GeneralCountsTest", args = {{"enemy"}, 5, ">=", "指定区域", 22, 35, 24, 37}},
                    {cmd = "FaceToFace", args = {"姜维", "风水士1"}},
                    {cmd = "GeneralAction", args = {"姜维", "prepareAttack"}},
                    {cmd = "Dialog", args = {"姜维", "不要让曹军接近！"}},
                    {cmd = "Dialog", args = {"姜维", "水军拦截曹军。"}},
                    {cmd = "GeneralAction", args = {"姜维", "stand"}},
                },
            },
            {cmd = "RangeGeneralsAiChange", args = {{"enemy"}, 22, 35, 24, 37, "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var33", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 23, 26, 35, 32}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var34"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var56"}}}},
                {cmd = "FaceToFace", args = {"马超", "曹操"}},
                {cmd = "GeneralAction", args = {"马超", "prepareAttack"}},
                {cmd = "Dialog", args = {"马超", "这次一定要收拾曹操老贼。"}},
                {cmd = "Dialog", args = {"马超", "马超出战！"}},
                {cmd = "GeneralAction", args = {"马超", "stand"}},
            },
            {cmd = "RangeGeneralsAiChange", args = {{"enemy"}, 28, 21, 30, 23, "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var34", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 26, 20, 32, 25}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var35"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var58"}}}},
                {cmd = "FaceToFace", args = {"赵云", "曹操"}},
                {cmd = "GeneralAction", args = {"赵云", "prepareAttack"}},
                {cmd = "Dialog", args = {"赵云", "我也出战吧！"}},
                {cmd = "GeneralAction", args = {"赵云", "stand"}},
            },
            {cmd = "RangeGeneralsAiChange", args = {{"enemy"}, 28, 16, 30, 18, "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var35", true}},
        },
    },
    {
        {cmd = "GeneralCountsTest", args = {{"enemy"}, 4, "<", "指定区域", 28, 14, 30, 24}},
        {cmd = "GeneralCountsTest", args = {{"player"}, 1, ">=", "指定区域", 28, 14, 30, 24}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var36"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "FaceToFace", args = {"姜维", "曹操"}},
                {cmd = "GeneralAction", args = {"姜维", "prepareAttack"}},
                {cmd = "Dialog", args = {"姜维", "嗯嗯嗯，没办法了……"}},
                {cmd = "Dialog", args = {"姜维", "木人出来吧，给我杀了曹操！"}},
                {cmd = "GeneralAction", args = {"姜维", "stand"}},
                {cmd = "GeneralShow", args = {"木人1"}},
                {cmd = "GeneralShow", args = {"木人2"}},
                {cmd = "GeneralShow", args = {"木人3"}},
                {cmd = "GeneralShow", args = {"木人4"}},
            },
            {cmd = "RangeGeneralsAiChange", args = {{"enemy"}, 1, 1, 40, 40, "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"姜维", "坚守原地", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var36", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "姜维", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var40"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "姜维"}},
            {cmd = "FaceToFace", args = {"姜维", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "姜维，快说出孔明下落。"}},
            {cmd = "Dialog", args = {"姜维", "两军对阵岂有出卖主帅之理。"}},
            {cmd = "Dialog", args = {"姜维", "想知道就先杀了我姜维吧！"}},
            {cmd = "VarSet", args = {"Var40", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "马超", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var41"}}}},
        {
            {cmd = "FaceToFace", args = {"马超", "曹操"}},
            {cmd = "FaceToFace", args = {"曹操", "马超"}},
            {cmd = "Dialog", args = {"马超", "这次……这次非杀了你不可。"}},
            {cmd = "Dialog", args = {"曹操", "马超啊马超，你还是一样毛躁。"}},
            {cmd = "Dialog", args = {"曹操", "恐怕马腾见了你现在的样子之后，也会在黄泉之下痛心不已的。"}},
            {cmd = "Dialog", args = {"马超", "休得胡言乱语！"}},
            {cmd = "Dialog", args = {"马超", "马孟起若能手刃杀父仇人，先父只会高兴，何来悲伤！"}},
            {cmd = "Dialog", args = {"曹操", "我与马腾都知道所为何事，并依此信念转战于乱世，从未把私怨与霸业混为一谈。"}},
            {cmd = "Dialog", args = {"马超", "唔唔……"}},
            {cmd = "Dialog", args = {"曹操", "如果身为蜀将的你懂得心怀乱世，一切以天下为重的话，你就再来找我吧。"}},
            {cmd = "Dialog", args = {"曹操", "到那个时候，我自然会与你交手的。"}},
            {cmd = "Dialog", args = {"马超", "…………"}},
            {cmd = "VarSet", args = {"Var41", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "赵云", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var42"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "赵云"}},
            {cmd = "FaceToFace", args = {"赵云", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "子龙，想必你也逐渐察觉……"}},
            {cmd = "Dialog", args = {"曹操", "孔明的举止并不符合蜀国利益了吧？"}},
            {cmd = "Dialog", args = {"赵云", "身为武将，只知征战沙场，不由得自己有何主张。"}},
            {cmd = "Dialog", args = {"曹操", "如今大势已去，蜀国已无前途可言了。"}},
            {cmd = "Dialog", args = {"赵云", "也许蜀国不能一统天下，但我赵云愿与蜀国共存亡。"}},
            {cmd = "Dialog", args = {"曹操", "子龙……"}},
            {cmd = "VarSet", args = {"Var42", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"诸葛亮", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
        {
            {cmd = "Dialog", args = {"诸葛亮", "我得赶往地下祭坛……"}},
            {cmd = "VarSet", args = {"Var50", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"姜维", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"姜维", "哇啊！吾命休矣……"}},
            {cmd = "Dialog", args = {"姜维", "传令全军……"}},
            {cmd = "Dialog", args = {"姜维", "全部撤回蜀地，加强防备，不可攻伐，恢复国力……"}},
            {cmd = "Dialog", args = {"姜维", "不管是谁，帮我保卫…蜀…国……"}},
            {cmd = "GeneralRetreat", args = {"姜维", true}},
            {cmd = "RoleDisappear", args = {"木人1"}},
            {cmd = "RoleDisappear", args = {"木人2"}},
            {cmd = "RoleDisappear", args = {"木人3"}},
            {cmd = "RoleDisappear", args = {"木人4"}},
            {cmd = "VarSet", args = {"Var51", true}},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
                {cmd = "Dialog", args = {"孟获", "唔唔，不能再打下去了。"}},
                {cmd = "Dialog", args = {"孟获", "俺对蜀国也算仁至义尽喽！"}},
                {cmd = "Dialog", args = {"孟获", "还是回我的南国吧。"}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var56"}}}},
                {cmd = "Dialog", args = {"马超", "一切都结束了是吗？"}},
                {cmd = "Dialog", args = {"马超", "看来已经不是计较私怨的时候了。"}},
                {cmd = "Dialog", args = {"马超", "还是暂时回到蜀地再做打算吧。"}},
                {cmd = "Dialog", args = {"马超", "撤退！"}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var58"}}}},
                {cmd = "Dialog", args = {"赵云", "姜维将军也阵亡了？"}},
                {cmd = "Dialog", args = {"赵云", "我又岂能对后主刘禅置之不理？"}},
                {cmd = "Dialog", args = {"赵云", "撤回成都，加强防备吧。"}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var59"}}}},
                {cmd = "Dialog", args = {"黄忠", "看来乱世即将结束。"}},
                {cmd = "Dialog", args = {"黄忠", "再也无老朽的用武之地了。"}},
                {cmd = "Dialog", args = {"黄忠", "不如告老还乡吧！"}},
            },
            {cmd = "GeneralsDisappear", args = {{"enemy"}, 1, 1, 40, 40}},
            {cmd = "Dialog", args = {"曹操", "看来蜀军已经无意抵抗。"}},
            {cmd = "Dialog", args = {"曹操", "快点找出孔明！"}},
            {cmd = "Dialog", args = {"曹操", "千万不能放虎归山。"}},
            {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var100", true}},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var656", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"孟获", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
        {
            {cmd = "Dialog", args = {"孟获", "痛死我啦！"}},
            {cmd = "Dialog", args = {"孟获", "俺可不想死在这个鬼地方，还是回我南国去吧！"}},
            {cmd = "GeneralRetreat", args = {"孟获", false}},
            {cmd = "VarSet", args = {"Var52", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"孟优", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var53"}}}},
        {
            {cmd = "Dialog", args = {"孟优", "不行了。"}},
            {cmd = "Dialog", args = {"孟优", "老子先走人了！"}},
            {cmd = "GeneralRetreat", args = {"孟优", false}},
            {cmd = "VarSet", args = {"Var53", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"祝融", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var54"}}}},
        {
            {cmd = "Dialog", args = {"祝融", "嗯，就到此为止吧。"}},
            {cmd = "Dialog", args = {"祝融", "今儿个玩得真开心，姑奶奶太满足了。再见！"}},
            {cmd = "GeneralRetreat", args = {"祝融", false}},
            {cmd = "VarSet", args = {"Var54", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"魏延", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var55"}}}},
        {
            {cmd = "Dialog", args = {"魏延", "俺已经到极限了！"}},
            {cmd = "Dialog", args = {"魏延", "孔明，你自己惹的祸自己收拾！"}},
            {cmd = "Dialog", args = {"魏延", "俺可要回蜀国了。"}},
            {cmd = "GeneralRetreat", args = {"魏延", false}},
            {cmd = "VarSet", args = {"Var55", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"马超", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var56"}}}},
        {
            {cmd = "Dialog", args = {"马超", "遗憾！"}},
            {cmd = "Dialog", args = {"马超", "难道我力犹不及之处？"}},
            {cmd = "Dialog", args = {"马超", "返回蜀地再做打算不迟吧。撤！"}},
            {cmd = "GeneralRetreat", args = {"马超", false}},
            {cmd = "VarSet", args = {"Var56", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"马岱", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var57"}}}},
        {
            {cmd = "Dialog", args = {"马岱", "我已经无能为力了。"}},
            {cmd = "Dialog", args = {"马岱", "蜀兵已经所剩无几。"}},
            {cmd = "Dialog", args = {"马岱", "不能再做无谓的牺牲了。撤退！"}},
            {cmd = "GeneralRetreat", args = {"马岱", false}},
            {cmd = "VarSet", args = {"Var57", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"赵云", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var58"}}}},
        {
            {cmd = "Dialog", args = {"赵云", "看来已经取胜魏国无望了，不过我一定会守住蜀国的。"}},
            {cmd = "Dialog", args = {"赵云", "撤回蜀地吧！"}},
            {cmd = "GeneralRetreat", args = {"赵云", false}},
            {cmd = "VarSet", args = {"Var58", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"黄忠", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var59"}}}},
        {
            {cmd = "Dialog", args = {"黄忠", "难道老夫真的老了？"}},
            {cmd = "Dialog", args = {"黄忠", "不如辞官归隐吧。"}},
            {cmd = "GeneralRetreat", args = {"黄忠", false}},
            {cmd = "VarSet", args = {"Var59", true}},
        },
    },
    {
        {cmd = "BattleWinTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var0"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"曹操", "看来蜀军已经无意抵抗。"}},
            {cmd = "Dialog", args = {"曹操", "快点找出孔明！"}},
            {cmd = "Dialog", args = {"曹操", "千万不能放虎归山。"}},
            {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var656", true}},
        },
    },
    {
        {cmd = "BattleLoseTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var1"}}}},
        {
            {cmd = "Tip", args = {"曹操败退。"}},
            {cmd = "BattleOver"},
            {cmd = "BattleLose"},
            {cmd = "VarSet", args = {"Var1", true}},
        },
    },
}

return Plot
