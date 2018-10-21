local Plot = {}

-- 战斗准备设置
Plot.battlePrepare = {
    battleName   = "吕布包围战",
    maxRounds    = 20,
    mapId        = "14.tmx",
    weatherStart = {"雨", "阴", "豪雨", "雪", "雪"},
    weatherType  = {"雪"},
    levelAdd     = -2,
    playerGeneralList = {
        {uid = "曹操"},
        {uid = "夏侯惇"},
    },
    enemyGeneralList = {
        {uid = "吕布", aiType = "坚守原地", wuqiId = "方天画戟", shipingId = "赤兔马", levelAdd = 4},
        {uid = "陈宫", aiType = "被动出击", shipingId = "头巾", levelAdd = 4},
        {uid = "貂蝉", aiType = "坚守原地", levelAdd = 4},
        {uid = "武道家1", aiType = "被动出击"},
        {uid = "炮兵1", aiType = "被动出击"},
        {uid = "炮兵2", aiType = "被动出击"},
        {uid = "贼兵1", aiType = "被动出击"},
        {uid = "贼兵2", aiType = "被动出击"},
        {uid = "张辽", aiType = "坚守原地", levelAdd = 4},
        {uid = "高顺", aiType = "坚守原地", shipingId = "铜盾", levelAdd = 2},
        {uid = "弓兵1", aiType = "坚守原地"},
        {uid = "弓兵2", aiType = "坚守原地"},
        {uid = "侯成", aiType = "坚守原地", shipingId = "皮制马铠", levelAdd = 2},
        {uid = "步兵1", aiType = "坚守原地"},
        {uid = "弓兵3", aiType = "坚守原地"},
        {uid = "弓兵4", aiType = "坚守原地"},
        {uid = "步兵2", aiType = "坚守原地"},
        {uid = "步兵3", aiType = "坚守原地"},
        {uid = "弓兵5", aiType = "坚守原地"},
        {uid = "弓兵6", aiType = "坚守原地"},
        {uid = "步兵4", aiType = "坚守原地"},
        {uid = "步兵5", aiType = "坚守原地"},
        {uid = "步兵6", aiType = "坚守原地"},
        {uid = "步兵7", aiType = "坚守原地"},
    },
    friendGeneralList = {
        {uid = "刘备", aiType = "主动出击", wuqiId = "雌雄双剑", shipingId = "的卢", levelAdd = 4},
        {uid = "关羽", aiType = "主动出击", wuqiId = "青龙偃月刀", levelAdd = 4},
        {uid = "张飞", aiType = "主动出击", wuqiId = "蛇矛", levelAdd = 4},
        {uid = "孙乾", aiType = "主动出击", levelAdd = 2},
    },
}

Plot.battleStartPlot = {
    {cmd = "PlayMusic", args = {"Track3"}},
    {
        {cmd = "Dialog", args = {"曹操", "如今刘备的援军也已到达，这座下邳城连只蚂蚁都出不来了。"}},
        {cmd = "Dialog", args = {"曹操", "虽然这是与吕布的最后一战，不过以后少了这样一个对手，倒觉得有点冷清呢……。"}},
        {cmd = "FaceToFace", args = {"吕布", "貂蝉"}},
        {cmd = "FaceToFace", args = {"貂蝉", "吕布"}},
        {cmd = "Dialog", args = {"吕布", "这里已经被完全包围了………"}},
        {cmd = "Dialog", args = {"吕布", "貂蝉，事到如今……"}},
        {cmd = "Dialog", args = {"吕布", "我担心的只有你……。"}},
        {cmd = "Dialog", args = {"貂蝉", "奉先…我们还没输。"}},
        {cmd = "Dialog", args = {"貂蝉", "让我也帮帮你吧。"}},
        {cmd = "GeneralAction", args = {"吕布", "weak"}},
        {cmd = "Dialog", args = {"吕布", "貂蝉……。"}},
        {cmd = "FaceToFace", args = {"陈宫", "曹操"}},
        {cmd = "Dialog", args = {"陈宫", "事到如今也已经无计可施了。"}},
        {cmd = "Dialog", args = {"陈宫", "我只有竭尽全力，与曹操抗衡了。"}},
        {cmd = "GeneralAction", args = {"陈宫", "defense"}},
        {cmd = "Dialog", args = {"陈宫", "通告全军！现在是冬天，长期作战对曹军非常不利！"}},
        {cmd = "Dialog", args = {"陈宫", "如今坚守城池方为上策。"}},
        {cmd = "Dialog", args = {"陈宫", "我们要毫不气馁地抗敌到底。"}},
        {cmd = "Dialog", args = {"陈宫", "如果丧失斗志，就正中曹操下怀了！"}},
        {cmd = "FaceToFace", args = {"刘备", "曹操"}},
        {cmd = "Dialog", args = {"刘备", "孟德大人，我们已经准备好了。"}},
        {cmd = "Dialog", args = {"刘备", "只要号令一下，我们立即进攻。"}},
        {cmd = "RoleMove", args = {"吕布", "left", 10, 17}},
        {cmd = "FaceToFace", args = {"吕布", "张辽"}},
        {cmd = "FaceToFace", args = {"张辽", "吕布"}},
        {cmd = "Dialog", args = {"吕布", "文远，有件事要拜托你。"}},
        {cmd = "Dialog", args = {"张辽", "不知主公有何吩咐？"}},
        {cmd = "Dialog", args = {"吕布", "如果此战我们落败，希望你能归顺曹操。"}},
        {cmd = "Dialog", args = {"张辽", "主公，何出此言？"}},
        {cmd = "Dialog", args = {"张辽", "我张辽不仕二主。"}},
        {cmd = "Dialog", args = {"吕布", "这一仗恐怕是我最后一战了，战死沙场原本是武将所愿，不过我最放心不下的就是貂蝉……"}},
        {cmd = "Dialog", args = {"吕布", "所以希望你能保护她。"}},
        {cmd = "Dialog", args = {"张辽", "主公…现在可不能泄气，战争还没结束呢。"}},
        {cmd = "Dialog", args = {"张辽", "我张辽一定奋勇杀敌，赢得这场战争的胜利。"}},
        {cmd = "Dialog", args = {"吕布", "……是吗？我就全靠你了。"}},
        {cmd = "Dialog", args = {"吕布", "原来我吕奉先也有如此丧气的一天！"}},
        {cmd = "Dialog", args = {"吕布", "哈哈哈。"}},
        {cmd = "Dialog", args = {"张辽", "（主公……。）"}},
        {cmd = "RoleMove", args = {"吕布", "up", 14, 17}},
        {cmd = "GeneralChangeDirection", args = {"张辽", "left"}},
        {cmd = "FaceToFace", args = {"吕布", "曹操"}},
        {cmd = "Dialog", args = {"吕布", "曹贼，放马过来吧！"}},
        {cmd = "Dialog", args = {"吕布", "让你见识我吕奉先纵横乱世，盖世无双的武勇！"}},
        {cmd = "Dialog", args = {"侯成", "主公，您的话让我侯成感动不已。"}},
        {cmd = "Dialog", args = {"侯成", "我一定跟曹操拼了。"}},
        {cmd = "Dialog", args = {"魏续", "（我已经厌倦在吕布之下。"}},
        {cmd = "Dialog", args = {"魏续", "该是换个主子的时候了吧？）"}},
        {cmd = "Dialog", args = {"宋宪", "（这么下去，我的性命恐怕不保。"}},
        {cmd = "Dialog", args = {"宋宪", "还是找机会归降吧……。）"}},
        {cmd = "Dialog", args = {"曹操", "嗯，都准备好了吧？"}},
        {cmd = "Dialog", args = {"曹操", "全军开始进攻。"}},
    },
    {cmd = "PlayMusic", args = {"Track5"}},
    {cmd = "BattleWinCondition", args = {"胜利条件\n一、歼灭所有敌军。\n\n失败条件\n一、曹操死亡。\n二、回合数超过20。"}},
    {cmd = "ShowBattleWinCondition", args = {"歼灭所有敌军！"}},
    {cmd = "VarSet", args = {"Var514", true}},
    {cmd = "ShowMenu", args = {true}},
}

Plot.battleMiddlePlot = {
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 14, 17}},
        {cmd = "VarTest", args = {{falseConditions = {"Var20"}}}},
        {
            {cmd = "AddItem", args = {"恢复用米", 0}},
            {cmd = "VarSet", args = {"Var20", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 15, 17}},
        {cmd = "VarTest", args = {{falseConditions = {"Var21"}}}},
        {
            {cmd = "AddItem", args = {"止咳药", 0}},
            {cmd = "VarSet", args = {"Var21", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 14, 16}},
        {cmd = "VarTest", args = {{falseConditions = {"Var22"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var22", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 15, 16}},
        {cmd = "VarTest", args = {{falseConditions = {"Var23"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var23", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 9, 12, 20, 21}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var30"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var50", "Var53"}}}},
                {cmd = "Dialog", args = {"吕布", "终于被杀到城里来了……。"}},
                {cmd = "FaceToFace", args = {"貂蝉", "吕布"}},
                {cmd = "Dialog", args = {"貂蝉", "奉先，我也出战。"}},
                {cmd = "FaceToFace", args = {"吕布", "貂蝉"}},
                {cmd = "Dialog", args = {"吕布", "你呆在这吧。"}},
                {cmd = "Dialog", args = {"吕布", "这里比较安全。"}},
                {cmd = "Dialog", args = {"吕布", "全军出战！"}},
                {cmd = "Dialog", args = {"貂蝉", "奉先，求求你！"}},
                {cmd = "Dialog", args = {"貂蝉", "求你也带我出战吧。"}},
                {cmd = "Dialog", args = {"吕布", "……………"}},
                {cmd = "Dialog", args = {"吕布", "好，但是千万别离我太远。"}},
                {cmd = "Dialog", args = {"貂蝉", "奉先…………"}},
                {cmd = "Dialog", args = {"貂蝉", "没关系的，我不会拖累你。"}},
                {cmd = "Dialog", args = {"吕布", "貂蝉！"}},
                {cmd = "Dialog", args = {"貂蝉", "奉先！"}},
            },
            {cmd = "GeneralAiChange", args = {"吕布", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"陈宫", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"貂蝉", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"武术家1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"炮兵1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"炮兵2", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"贼兵1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"贼兵2", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"张辽", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"高顺", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵2", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"侯成", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵3", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵4", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"魏续", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"宋宪", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵5", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵6", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵2", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵3", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵7", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵8", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵4", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵5", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵6", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵7", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var30", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 7, 15, 8, 18}},
        {cmd = "VarTest", args = {{falseConditions = {"Var31"}}}},
        {
            {cmd = "GeneralAiChange", args = {"张辽", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"高顺", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵2", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var31", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 13, 10, 16, 11}},
        {cmd = "VarTest", args = {{falseConditions = {"Var32"}}}},
        {
            {cmd = "GeneralAiChange", args = {"步兵1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵3", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵4", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"侯成", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var32", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 21, 15, 22, 18}},
        {cmd = "VarTest", args = {{falseConditions = {"Var33"}}}},
        {
            {cmd = "GeneralAiChange", args = {"弓兵5", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵6", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"魏续", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"宋宪", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var33", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 13, 22, 16, 23}},
        {cmd = "VarTest", args = {{falseConditions = {"Var34"}}}},
        {
            {cmd = "GeneralAiChange", args = {"步兵2", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵3", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵7", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵8", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var34", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "吕布", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var40"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "吕布"}},
            {cmd = "FaceToFace", args = {"吕布", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "终于等到这一天了。"}},
            {cmd = "Dialog", args = {"曹操", "能死在我手上，你应该感激我。"}},
            {cmd = "Dialog", args = {"吕布", "哼，我吕奉先是不会输的！"}},
            {cmd = "VarSet", args = {"Var40", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "貂蝉", true}},
        {cmd = "VarTest", args = {{falseConditions = {"Var41"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "貂蝉"}},
            {cmd = "FaceToFace", args = {"貂蝉", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "你为何在此！？"}},
            {cmd = "Dialog", args = {"貂蝉", "一切只能说是命运作弄吧。"}},
            {cmd = "Dialog", args = {"貂蝉", "如今我与奉先相爱，已经结下生死不渝的誓约。"}},
            {cmd = "Dialog", args = {"貂蝉", "我没忘记父亲在世之时，大人对我们家的恩情。只是如今我们互为仇敌，请恕我冒犯了。"}},
            {
                {cmd = "PkPrepare", args = {"曹操", "貂蝉"}},
                {cmd = "PkGeneralShow", args = {false, "（居然肯为吕布而战！？\n有志气……）", "无"}},
                {cmd = "PkGeneralShow", args = {true, "曹大人………您小心了！", "攻击"}},
                {cmd = "PkShowStart"},
                {cmd = "PkGeneralAction", args = {true, "无"}},
                {cmd = "PkShowDialog", args = {true, "来吧！", true}},
                {cmd = "PkGeneralAction", args = {true, "前移"}},
                {cmd = "PkGeneralAttack2", args = {true, "格挡", true}},
                {cmd = "PkGeneralAttack2", args = {true, "格挡", true}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkGeneralAttack2", args = {false, "后退", true}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {false, "无"}},
                {cmd = "PkShowDialog", args = {false, "好快的身手！\n原来还懂得些武艺……！？", true}},
                {cmd = "PkGeneralAction", args = {true, "防御"}},
                {cmd = "PkShowDialog", args = {true, "虽然只是点雕虫小技，不过………", true}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {true, "攻击预备"}},
                {cmd = "PkShowDialog", args = {true, "小心了！这次要来真的！", true}},
                {cmd = "PkGeneralAction", args = {false, "小步后退"}},
                {cmd = "PkShowDialog", args = {false, "慢着！\n我不想和你交手！", true}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {true, "无"}},
                {cmd = "PkShowDialog", args = {true, "曹大人………\n为爱而死是女子的宿命。\n事到如今，我没有别的路了！", true}},
                {cmd = "PkGeneralAction", args = {false, "防御"}},
                {cmd = "PkShowDialog", args = {false, "你也无须向命运低头。\n如果你就这么死去，王允大人会难过的。\n你再想想吧！", true}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkGeneralAction", args = {false, "后转"}},
                {cmd = "PkShowDialog", args = {false, "唔唔，我下不了手……，再见了！", true}},
                {cmd = "PkGeneralAction", args = {false, "前移"}},
                {cmd = "PkGeneralAction", args = {false, "撤退"}},
                {cmd = "Delay", args = {15}},
                {cmd = "PkGeneralAction", args = {true, "晕倒"}},
                {cmd = "PkShowDialog", args = {true, "曹大人…………\n我该如何是好……？", true}},
                {cmd = "PkOver"},
            },
            {cmd = "VarSet", args = {"Var41", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "侯成", true}},
        {cmd = "VarTest", args = {{falseConditions = {"Var42"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "侯成"}},
            {cmd = "FaceToFace", args = {"侯成", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "闪开！"}},
            {cmd = "Dialog", args = {"侯成", "曹操！我老早就想见你了。"}},
            {cmd = "Dialog", args = {"侯成", "只要能砍你一刀，我死也值得。"}},
            {cmd = "Dialog", args = {"侯成", "拿命来吧！"}},
            {
                {cmd = "PkPrepare", args = {"曹操", "侯成"}},
                {cmd = "PkGeneralShow", args = {true, "多言无益！\n接招吧，曹操！", "攻击"}},
                {cmd = "PkGeneralShow", args = {false, "放马过来！", "攻击预备"}},
                {cmd = "PkShowStart"},
                {cmd = "PkGeneralAttack", args = {false, "互相冲锋", true}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {false, "后转"}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {true, "小步前移"}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {true, "小步前移"}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkShowDialog", args = {true, "吕，吕布将军……！", true}},
                {cmd = "PkGeneralAction", args = {true, "晕倒"}},
                {cmd = "PkGeneralDie", args = {true}},
                {cmd = "PkGeneralAction", args = {false, "防御"}},
                {cmd = "PkShowDialog", args = {false, "原来一开始就抱定必死的决心了？\n真是个令人敬佩的敌将。\n不过我还不能死在此地。", true}},
                {cmd = "PkOver"},
            },
            {cmd = "GeneralRetreat", args = {"侯成", true}},
            {cmd = "AddItem", args = {"皮制马铠", 0}},
            {cmd = "VarSet", args = {"Var51", true}},
            {cmd = "VarSet", args = {"Var42", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"刘备", "吕布", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var43"}}}},
        {
            {cmd = "FaceToFace", args = {"刘备", "吕布"}},
            {cmd = "FaceToFace", args = {"吕布", "刘备"}},
            {cmd = "Dialog", args = {"刘备", "吕将军！拿命来吧！"}},
            {cmd = "Dialog", args = {"吕布", "刘备，咱们也算是老交情了！"}},
            {cmd = "Dialog", args = {"吕布", "这恐怕是最后一次跟你交手。"}},
            {cmd = "Dialog", args = {"吕布", "就让你记住我吕奉先的盖世武功吧！"}},
            {cmd = "VarSet", args = {"Var43", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"魏续", "夏侯惇", true}},
        {cmd = "VarTest", args = {{falseConditions = {"Var44"}}}},
        {
            {cmd = "FaceToFace", args = {"魏续", "夏侯惇"}},
            {cmd = "FaceToFace", args = {"夏侯惇", "魏续"}},
            {cmd = "Dialog", args = {"魏续", "（是时侯了。）"}},
            {cmd = "Dialog", args = {"魏续", "喂，那边的人听着！我投降了。"}},
            {cmd = "Dialog", args = {"魏续", "带我去见曹操吧！"}},
            {cmd = "Dialog", args = {"夏侯惇", "哼，居然临阵倒戈？"}},
            {cmd = "Dialog", args = {"夏侯惇", "我看你也不是什么好东西。"}},
            {cmd = "Dialog", args = {"夏侯惇", "干脆回家吃奶去吧！"}},
            {cmd = "Dialog", args = {"魏续", "什么！"}},
            {cmd = "Dialog", args = {"魏续", "我绝不饶你！让你见识一下我的实力。"}},
            {cmd = "Dialog", args = {"魏续", "跟我一比高下吧！"}},
            {
                {cmd = "PkPrepare", args = {"夏侯惇", "魏续"}},
                {cmd = "PkGeneralShow", args = {true, "我本来打算诚意归降的！\n呆会下阴间就别后悔了！", "二次攻击"}},
                {cmd = "PkGeneralShow", args = {false, "我军不需要你这样的卑鄙小人。\n让我来送你上黄泉路！", "攻击预备"}},
                {cmd = "PkShowStart"},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "PkGeneralAction", args = {false, "无"}},
                {cmd = "PkShowDialog", args = {false, "嗯嗯？", true}},
                {cmd = "PkGeneralAction", args = {true, "攻击预备"}},
                {cmd = "PkShowDialog", args = {true, "哇哈哈！\n你已经跑不掉了！\n看我的绝招！", true}},
                {cmd = "PkGeneralAttack", args = {true, "移动攻击", false}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkGeneralAttack2", args = {false, "格档后退", true}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {false, "无"}},
                {cmd = "PkShowDialog", args = {false, "怎么啦？\n根本不管用嘛。", true}},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "PkShowDialog", args = {true, "怎、怎么可能…？\n一定是弄错了！\n再吃我一招！", true}},
                {cmd = "PkGeneralAction", args = {true, "小步前移"}},
                {cmd = "PkGeneralAction", args = {true, "前移"}},
                {cmd = "PkGeneralAttack2", args = {true, "格挡", true}},
                {cmd = "PkGeneralAttack2", args = {true, "格挡", true}},
                {cmd = "PkGeneralAttack2", args = {true, "闪躲绕前", true}},
                {cmd = "PkGeneralAction", args = {false, "小步后退"}},
                {cmd = "PkGeneralAction", args = {false, "小步后退"}},
                {cmd = "PkGeneralAction", args = {false, "小步后退"}},
                {cmd = "PkGeneralAction", args = {true, "前移"}},
                {cmd = "PkShowDialog", args = {true, "人、人呢？\n人到哪去了？", true}},
                {cmd = "PkGeneralAction", args = {false, "攻击预备"}},
                {cmd = "PkShowDialog", args = {false, "你已经完蛋了！\n让你见识我真正的绝招，\n就当送你下黄泉的礼物吧！", true}},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "PkShowDialog", args = {true, "救、救命啊！", false}},
                {cmd = "PkGeneralAttack", args = {false, "移动攻击", true}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkShowDialog", args = {true, "哇啊啊啊……！", true}},
                {cmd = "PkGeneralAction", args = {true, "晕倒"}},
                {cmd = "PkGeneralDie", args = {true}},
                {cmd = "PkGeneralAction", args = {false, "后转"}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkGeneralAction", args = {false, "前移"}},
                {cmd = "PkShowDialog", args = {false, "没有志气的家伙！\n哼！", false}},
                {cmd = "PkGeneralAction", args = {false, "攻击"}},
                {cmd = "PkOver"},
            },
            {cmd = "GeneralRetreat", args = {"魏续", true}},
            {cmd = "VarSet", args = {"Var55", true}},
            {cmd = "VarSet", args = {"Var44", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"宋宪", "夏侯渊", true}},
        {cmd = "VarTest", args = {{falseConditions = {"Var45"}}}},
        {
            {cmd = "FaceToFace", args = {"宋宪", "夏侯渊"}},
            {cmd = "Dialog", args = {"宋宪", "（我、我不想死在这里。"}},
            {cmd = "Dialog", args = {"宋宪", "叛逃吧？对、只能这么做了。）"}},
            {cmd = "Dialog", args = {"宋宪", "喂、那边的敌将！"}},
            {cmd = "FaceToFace", args = {"夏侯渊", "宋宪"}},
            {cmd = "Dialog", args = {"夏侯渊", "嗯？"}},
            {cmd = "Dialog", args = {"夏侯渊", "你想跟我夏侯渊单挑是吗？"}},
            {cmd = "Dialog", args = {"夏侯渊", "好啊，那就来吧！"}},
            {
                {cmd = "PkPrepare", args = {"夏侯渊", "宋宪"}},
                {cmd = "PkGeneralShow", args = {false, "我乃夏侯渊、字妙才。\n来吧，与我一比高下！", "攻击预备"}},
                {cmd = "PkGeneralShow", args = {true, "我、我叫宋宪。\n（……不、不对啊！\n我到底在想什么！）", "攻击预备"}},
                {cmd = "PkShowStart"},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "PkShowDialog", args = {true, "（怎、怎么会变成是这样？\n这、这下糟了……）", true}},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "PkShowDialog", args = {true, "（……听说夏侯渊是箭术高手，\n我怎么打得过他呀………）", true}},
                {cmd = "PkGeneralAction", args = {false, "无"}},
                {cmd = "PkShowDialog", args = {false, "怎么了，宋宪！\n你还不放马过来？", true}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkGeneralAction", args = {false, "小步前移"}},
                {cmd = "PkShowDialog", args = {false, "事到如今，\n你该不是想临阵脱逃吧？", true}},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "PkShowDialog", args = {true, "后、后会无期……！", true}},
                {cmd = "PkGeneralAction", args = {true, "小步前移"}},
                {cmd = "PkGeneralAttack2", args = {false, "命中", false}},
                {cmd = "PkShowDialog", args = {true, "哇啊啊！", true}},
                {cmd = "PkGeneralAction", args = {true, "晕倒"}},
                {cmd = "PkGeneralDie", args = {true}},
                {cmd = "PkGeneralAction", args = {false, "无"}},
                {cmd = "PkShowDialog", args = {false, "可恶，居然用单挑来侮辱我！\n两军交战不战而逃，\n这真是身为武将的耻辱！", true}},
                {cmd = "PkGeneralAction", args = {false, "后转"}},
                {cmd = "PkShowDialog", args = {false, "唔唔，\n害我白白浪费了一箭！", true}},
                {cmd = "PkGeneralAction", args = {false, "小步前移"}},
                {cmd = "PkGeneralAction", args = {false, "前移"}},
                {cmd = "PkGeneralAction", args = {false, "撤退"}},
                {cmd = "PkOver"},
            },
            {cmd = "GeneralRetreat", args = {"宋宪", true}},
            {cmd = "VarSet", args = {"Var57", true}},
            {cmd = "VarSet", args = {"Var45", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"吕布", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
        {
            {cmd = "Dialog", args = {"吕布", "唔喔！"}},
            {cmd = "Dialog", args = {"吕布", "不能动了，难道我要命丧于此……"}},
            {cmd = "Dialog", args = {"吕布", "貂蝉啊……，原谅我吧。"}},
            {cmd = "GeneralRetreat", args = {"吕布", true}},
            {cmd = "AddItem", args = {"方天画戟", 0}},
            {cmd = "VarSet", args = {"Var50", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"侯成", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
        {
            {cmd = "Dialog", args = {"侯成", "哇啊！"}},
            {cmd = "Dialog", args = {"侯成", "真遗憾，吕……将军………"}},
            {cmd = "GeneralRetreat", args = {"侯成", true}},
            {cmd = "AddItem", args = {"皮制马铠", 0}},
            {cmd = "VarSet", args = {"Var51", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"高顺", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
        {
            {cmd = "Dialog", args = {"高顺", "吾命休矣……！"}},
            {cmd = "GeneralRetreat", args = {"高顺", true}},
            {cmd = "AddItem", args = {"铜盾", 0}},
            {cmd = "VarSet", args = {"Var52", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"貂蝉", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var53"}}}},
        {
            {cmd = "Dialog", args = {"貂蝉", "啊啊……奉先。"}},
            {cmd = "Dialog", args = {"貂蝉", "貂蝉也到此为止了。"}},
            {cmd = "GeneralRetreat", args = {"貂蝉", false}},
            {cmd = "VarSet", args = {"Var53", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"张辽", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var54"}}}},
        {
            {cmd = "Dialog", args = {"张辽", "唔唔，是我的失策。"}},
            {cmd = "Dialog", args = {"张辽", "…………"}},
            {cmd = "Dialog", args = {"张辽", "来吧，快杀了我！"}},
            {cmd = "Dialog", args = {"张辽", "…………"}},
            {cmd = "Dialog", args = {"张辽", "（主公……）"}},
            {cmd = "Dialog", args = {"张辽", "嗯？等等！"}},
            {cmd = "Dialog", args = {"张辽", "我要归降曹军，带我去见曹操。"}},
            {cmd = "GeneralRetreat", args = {"张辽", false}},
            {cmd = "VarSet", args = {"Var54", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"魏续", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var55"}}}},
        {
            {cmd = "Dialog", args = {"魏续", "你！"}},
            {cmd = "Dialog", args = {"魏续", "呜唔…………"}},
            {cmd = "GeneralRetreat", args = {"魏续", true}},
            {cmd = "VarSet", args = {"Var55", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"陈宫", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var56"}}}},
        {
            {cmd = "Dialog", args = {"陈宫", "为什么曹操手下有如此强大的实力？"}},
            {cmd = "Dialog", args = {"陈宫", "为什么！"}},
            {cmd = "Dialog", args = {"陈宫", "难道我主张的正义是错的，曹操的正义才是对的吗？"}},
            {cmd = "Dialog", args = {"陈宫", "那就让我到……。"}},
            {cmd = "GeneralRetreat", args = {"陈宫", true}},
            {cmd = "AddItem", args = {"方巾", 0}},
            {cmd = "VarSet", args = {"Var56", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"宋宪", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var57"}}}},
        {
            {cmd = "Dialog", args = {"宋宪", "早知不跟随吕布了………"}},
            {cmd = "Dialog", args = {"宋宪", "哇啊！"}},
            {cmd = "GeneralRetreat", args = {"宋宪", true}},
            {cmd = "VarSet", args = {"Var57", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"刘备", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var58"}}}},
        {
            {cmd = "Dialog", args = {"刘备", "嗯嗯，无法再战了……！"}},
            {cmd = "GeneralRetreat", args = {"刘备", false}},
            {cmd = "VarSet", args = {"Var58", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"关羽", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var59"}}}},
        {
            {cmd = "Dialog", args = {"关羽", "撤退！"}},
            {cmd = "GeneralRetreat", args = {"关羽", false}},
            {cmd = "VarSet", args = {"Var59", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"张飞", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var60"}}}},
        {
            {cmd = "Dialog", args = {"张飞", "给俺记住！"}},
            {cmd = "GeneralRetreat", args = {"张飞", false}},
            {cmd = "VarSet", args = {"Var60", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"孙乾", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var61"}}}},
        {
            {cmd = "Dialog", args = {"孙乾", "主公，孙乾先行撤退了。"}},
            {cmd = "GeneralRetreat", args = {"孙乾", false}},
            {cmd = "VarSet", args = {"Var61", true}},
        },
    },
    {
        {cmd = "BattleWinTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var0"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"曹操", "如今吕布终于也伏诛了……"}},
            {cmd = "Dialog", args = {"曹操", "仔细想想，我们交手也挺久的。"}},
            {cmd = "GeneralChangeDirection", args = {"曹操", "down"}},
            {cmd = "BattleExtraItems", args = {0, "印绶", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var614", true}},
        },
    },
    {
        {cmd = "BattleLoseTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var1"}}}},
        {
            {cmd = "Tip", args = {"曹操败给了吕布。"}},
            {cmd = "BattleOver"},
            {cmd = "BattleLose"},
            {cmd = "VarSet", args = {"Var1", true}},
        },
    },
}

return Plot
