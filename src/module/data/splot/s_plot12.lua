local Plot = {}

-- 战斗准备设置
Plot.battlePrepare = {
    battleName   = "张绣讨伐战（二）",
    maxRounds    = 20,
    mapId        = "12.tmx",
    weatherStart = {"晴", "晴", "阴", "晴", "阴"},
    weatherType  = {"普通"},
    levelAdd     = -2,
    playerGeneralList = {
        {uid = "曹操"},
        {uid = "郭嘉"},
    },
    enemyGeneralList = {
        {uid = "张绣", aiType = "坚守原地", levelAdd = 4},
        {uid = "贾诩", aiType = "坚守原地", levelAdd = 4},
        {uid = "步兵1", aiType = "坚守原地"},
        {uid = "步兵2", aiType = "坚守原地"},
        {uid = "步兵3", aiType = "坚守原地"},
        {uid = "步兵4", aiType = "坚守原地"},
        {uid = "步兵5", aiType = "坚守原地"},
        {uid = "步兵6", aiType = "坚守原地"},
        {uid = "弓兵1", aiType = "坚守原地"},
        {uid = "弓兵2", aiType = "坚守原地"},
        {uid = "步兵7", aiType = "主动出击", isHide = true},
        {uid = "步兵8", aiType = "主动出击", isHide = true},
        {uid = "步兵9", aiType = "主动出击", isHide = true},
        {uid = "步兵10", aiType = "主动出击", isHide = true},
        {uid = "步兵11", aiType = "主动出击", isHide = true},
        {uid = "步兵12", aiType = "主动出击", isHide = true},
        {uid = "弓兵3", aiType = "主动出击", isHide = true},
        {uid = "弓兵4", aiType = "主动出击", isHide = true},
        {uid = "弓兵5", aiType = "主动出击", isHide = true},
        {uid = "弓兵6", aiType = "主动出击", isHide = true},
        {uid = "骑兵1", aiType = "主动出击", isHide = true},
        {uid = "骑兵2", aiType = "主动出击", isHide = true},
        {uid = "骑兵3", aiType = "主动出击", isHide = true},
        {uid = "骑兵4", aiType = "主动出击", isHide = true},
        {uid = "骑兵5", aiType = "主动出击", isHide = true},
        {uid = "骑兵6", aiType = "主动出击", isHide = true},
        {uid = "骑兵7", aiType = "主动出击", isHide = true},
        {uid = "骑兵8", aiType = "主动出击", isHide = true},
        {uid = "贼兵1", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
        {uid = "贼兵2", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
        {uid = "贼兵3", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
        {uid = "贼兵4", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
        {uid = "贼兵5", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
        {uid = "贼兵6", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
        {uid = "贼兵7", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
        {uid = "贼兵8", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
        {uid = "弓骑兵1", aiType = "主动出击", isHide = true},
        {uid = "弓骑兵2", aiType = "主动出击", isHide = true},
        {uid = "弓骑兵3", aiType = "主动出击", isHide = true},
        {uid = "弓骑兵4", aiType = "主动出击", isHide = true},
        {uid = "贼兵9", aiType = "攻击武将", fixTarget = "曹操", isHide = true},
    },
}

Plot.battleStartPlot = {
    {cmd = "PlayMusic", args = {"Track3"}},
    {
        {cmd = "Dialog", args = {"张绣", "曹军已连续三天攻打西门……。"}},
        {cmd = "FaceToFace", args = {"贾诩", "张绣"}},
        {cmd = "Dialog", args = {"贾诩", "敌人大概是看到东门城墙已经旧损，所以打算声东击西吧。"}},
        {cmd = "Dialog", args = {"张绣", "这么说他们的真正目标是……东门！？"}},
        {cmd = "GeneralChangeDirection", args = {"张绣", "right"}},
        {cmd = "Dialog", args = {"贾诩", "正是，不过不用担心。"}},
        {cmd = "Dialog", args = {"贾诩", "如今曹操正为自己的计谋而得意，如此便很难看穿我们的计谋了。"}},
        {cmd = "Dialog", args = {"贾诩", "如此反倒可以借机利用。"}},
        {cmd = "Dialog", args = {"贾诩", "这件事就交给我吧。"}},
        {cmd = "FaceToFace", args = {"张绣", "贾诩"}},
        {cmd = "Dialog", args = {"张绣", "哦，是吗？"}},
        {cmd = "Dialog", args = {"张绣", "贾诩，就全靠你了。"}},
    },
    {cmd = "PlayMusic", args = {"Track4"}},
    {cmd = "BattleWinCondition", args = {"胜利条件\n一、歼灭城内所有敌军。\n\n失败条件\n一、曹操死亡。\n二、回合数超过20。"}},
    {cmd = "ShowBattleWinCondition", args = {"歼灭城内所有敌军！"}},
    {cmd = "VarSet", args = {"Var512", true}},
    {cmd = "ShowMenu", args = {true}},
}

Plot.battleMiddlePlot = {
    {
        {cmd = "RoundsTest", args = {7, ">="}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{trueConditions = {"Var3"}, falseConditions = {"Var2", "Var11"}}}},
        {
            {cmd = "GeneralShow", args = {"骑兵1"}},
            {cmd = "GeneralShow", args = {"骑兵2"}},
            {cmd = "GeneralShow", args = {"骑兵3"}},
            {cmd = "GeneralShow", args = {"骑兵4"}},
            {cmd = "GeneralShow", args = {"弓骑兵1"}},
            {cmd = "GeneralShow", args = {"弓骑兵2"}},
            {cmd = "GeneralShow", args = {"骑兵5"}},
            {cmd = "GeneralShow", args = {"骑兵6"}},
            {cmd = "GeneralShow", args = {"骑兵7"}},
            {cmd = "GeneralShow", args = {"骑兵8"}},
            {cmd = "GeneralShow", args = {"弓骑兵3"}},
            {cmd = "GeneralShow", args = {"弓骑兵4"}},
            {cmd = "FaceToFace", args = {"曹操", "骑兵1"}},
            {cmd = "Dialog", args = {"曹操", "嗯嗯？刘表派援军前来？"}},
            {cmd = "Dialog", args = {"曹操", "这下子麻烦了。"}},
            {cmd = "VarSet", args = {"Var11", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {1, ">="}},
        {cmd = "SideTest", args = {"我军阶段"}},
        {cmd = "VarTest", args = {{trueConditions = {"Var30"}, falseConditions = {"Var2", "Var12"}}}},
        {
            {cmd = "GeneralChangeDirection", args = {"曹操", "left"}},
            {cmd = "GeneralChangeDirection", args = {"曹操", "right"}},
            {cmd = "Dialog", args = {"曹操", "再这么拖延下去，刘表的援军就要到达了……"}},
            {cmd = "Dialog", args = {"曹操", "我该暂时退回许都吗……？"}},
            {cmd = "ChoiceDialog", args = {"曹操", {"退回许都", "征讨张绣"}}},
            {
                {cmd = "GeneralChangeDirection", args = {"曹操", "right"}},
                {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
                {cmd = "Dialog", args = {"曹操", "撤退！"}},
                {cmd = "Dialog", args = {"曹操", "撤回许都！"}},
                {cmd = "GeneralAction", args = {"曹操", "stand"}},
                {cmd = "GeneralAction", args = {"张绣", "prepareAttack"}},
                {cmd = "Dialog", args = {"张绣", "不要放过他们！"}},
                {cmd = "Dialog", args = {"张绣", "全军追击！"}},
                {cmd = "GeneralAction", args = {"张绣", "stand"}},
                {cmd = "BattleWinCondition", args = {"胜利条件\n一、曹操到达东北端。\n二、歼灭所有敌军。\n\n失败条件\n一、曹操死亡。\n二、回合数超过20。"}},
                {cmd = "ShowBattleWinCondition", args = {"曹操逃走！"}},
                {cmd = "HighlightRange", args = {28, 2, 28, 5, false}},
                {cmd = "VarSet", args = {"Var2", true}},
            },
            {
                {cmd = "GeneralAction", args = {"曹操", "attack"}},
                {cmd = "Dialog", args = {"曹操", "胜负还尚未知晓！"}},
                {cmd = "Dialog", args = {"曹操", "我们要在刘表援军赶到之前，攻下此城！"}},
                {cmd = "GeneralAction", args = {"曹操", "stand"}},
                {cmd = "GeneralAiChange", args = {"张绣", "被动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"贾诩", "被动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"步兵1", "被动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"步兵2", "被动出击", "无", 1, 1}},
                {cmd = "VarSet", args = {"Var3", true}},
            },
            {cmd = "VarSet", args = {"Var12", true}},
        },
    },
    {
        {cmd = "RoundsTest", args = {10, ">="}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{trueConditions = {"Var2"}, falseConditions = {"Var3", "Var13", "Var32"}}}},
        {
            {cmd = "GeneralShow", args = {"骑兵1"}},
            {cmd = "GeneralShow", args = {"骑兵2"}},
            {cmd = "GeneralShow", args = {"骑兵3"}},
            {cmd = "GeneralShow", args = {"骑兵4"}},
            {cmd = "GeneralShow", args = {"弓骑兵1"}},
            {cmd = "GeneralShow", args = {"弓骑兵2"}},
            {cmd = "GeneralShow", args = {"骑兵5"}},
            {cmd = "GeneralShow", args = {"骑兵6"}},
            {cmd = "GeneralShow", args = {"骑兵7"}},
            {cmd = "GeneralShow", args = {"骑兵8"}},
            {cmd = "GeneralShow", args = {"弓骑兵3"}},
            {cmd = "GeneralShow", args = {"弓骑兵4"}},
            {cmd = "FaceToFace", args = {"曹操", "骑兵1"}},
            {cmd = "Dialog", args = {"曹操", "嗯嗯？刘表派援军前来？"}},
            {cmd = "Dialog", args = {"曹操", "这下子麻烦了。"}},
            {cmd = "VarSet", args = {"Var13", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 1, 11}},
        {cmd = "VarTest", args = {{falseConditions = {"Var20"}}}},
        {
            {cmd = "AddItem", args = {"兴奋剂", 0}},
            {cmd = "VarSet", args = {"Var20", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 2, 9}},
        {cmd = "VarTest", args = {{falseConditions = {"Var21"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var21", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 2, 12}},
        {cmd = "VarTest", args = {{falseConditions = {"Var22"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var22", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 5, 4}},
        {cmd = "VarTest", args = {{falseConditions = {"Var23"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var23", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 5, 17}},
        {cmd = "VarTest", args = {{falseConditions = {"Var24"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var24", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 1, 10}},
        {cmd = "VarTest", args = {{falseConditions = {"Var25"}}}},
        {
            {cmd = "AddItem", args = {"恢复用米", 0}},
            {cmd = "VarSet", args = {"Var25", true}},
        },
    },
    {
        {cmd = "GeneralCountsTest", args = {{"enemy"}, 0, "=", "指定区域", 1, 1, 7, 20}},
        {cmd = "VarTest", args = {{falseConditions = {"Var2", "Var6"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "GeneralsDisappear", args = {{"enemy"}, 1, 1, 28, 20}},
            {cmd = "Dialog", args = {"曹操", "好，已经控制了城东，现在由城西杀进去！"}},
            {cmd = "Tip", args = {"曹操控制了宛城的东门，继续讨伐张绣。"}},
            {cmd = "Tip", args = {"可是却接到紧急报告，袁绍对防守薄弱的许都虎视眈眈。于是曹操不得不中止讨伐。"}},
            {cmd = "BattleExtraItems", args = {0, "印绶", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var100", true}},
            {cmd = "VarSet", args = {"Var612", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 1, 1, 7, 20}},
        {cmd = "RoundsTest", args = {2, ">="}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var30", "Var31", "Var50", "Var51"}}}},
        {
            {
                {cmd = "GeneralShow", args = {"步兵7"}},
                {cmd = "GeneralShow", args = {"步兵8"}},
                {cmd = "GeneralShow", args = {"步兵9"}},
                {cmd = "GeneralShow", args = {"步兵10"}},
                {cmd = "GeneralShow", args = {"步兵11"}},
                {cmd = "GeneralShow", args = {"步兵12"}},
                {cmd = "GeneralShow", args = {"弓兵3"}},
                {cmd = "GeneralShow", args = {"弓兵4"}},
                {cmd = "GeneralShow", args = {"弓兵5"}},
                {cmd = "GeneralShow", args = {"弓兵6"}},
            },
            {
                {cmd = "GeneralAiChange", args = {"步兵3", "主动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"步兵4", "主动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"步兵5", "主动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"步兵6", "主动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"弓兵1", "主动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"弓兵2", "主动出击", "无", 1, 1}},
            },
            {
                {cmd = "FaceToFace", args = {"张绣", "曹操"}},
                {cmd = "FaceToFace", args = {"贾诩", "曹操"}},
                {cmd = "Dialog", args = {"张绣", "哈哈哈，曹操中计了。"}},
                {cmd = "Dialog", args = {"张绣", "你这家伙的计策，我们早就识破了！"}},
                {cmd = "Dialog", args = {"贾诩", "我这招诱敌之计，还不错吧？"}},
                {cmd = "FaceToFace", args = {"曹操", "张绣"}},
                {cmd = "Dialog", args = {"曹操", "嗯嗯嗯！"}},
                {cmd = "Dialog", args = {"曹操", "真是完全出乎我的意料！"}},
            },
            {cmd = "VarSet", args = {"Var30", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 17, 1, 28, 20}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{trueConditions = {"Var2"}, falseConditions = {"Var13", "Var32"}}}},
        {
            {cmd = "GeneralShow", args = {"贼兵1"}},
            {cmd = "GeneralShow", args = {"贼兵2"}},
            {cmd = "GeneralShow", args = {"贼兵3"}},
            {cmd = "GeneralShow", args = {"贼兵4"}},
            {cmd = "GeneralShow", args = {"贼兵5"}},
            {cmd = "GeneralShow", args = {"贼兵6"}},
            {cmd = "GeneralShow", args = {"贼兵7"}},
            {cmd = "GeneralShow", args = {"贼兵8"}},
            {cmd = "GeneralShow", args = {"贼兵9"}},
            {cmd = "FaceToFace", args = {"曹操", "贼兵1"}},
            {cmd = "GeneralAction", args = {"曹操", "dizzy"}},
            {cmd = "Dialog", args = {"曹操", "唔，是敌人的伏兵？"}},
            {cmd = "Dialog", args = {"曹操", "想不到连这种地方，也布下了兵力！"}},
            {cmd = "VarSet", args = {"Var32", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 19, 1, 28, 8}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "GeneralCountsTest", args = {{"player"}, 0, "=", "指定区域", 22, 13, 28, 20}},
        {cmd = "VarTest", args = {{trueConditions = {"Var2", "Var32"}, falseConditions = {"Var33", "Var34"}}}},
        {
            {cmd = "GeneralShow", args = {"骑兵5"}},
            {cmd = "GeneralShow", args = {"骑兵6"}},
            {cmd = "GeneralShow", args = {"骑兵7"}},
            {cmd = "GeneralShow", args = {"骑兵8"}},
            {cmd = "GeneralShow", args = {"弓骑兵3"}},
            {cmd = "GeneralShow", args = {"弓骑兵4"}},
            {cmd = "FaceToFace", args = {"曹操", "骑兵5"}},
            {cmd = "GeneralAction", args = {"曹操", "defense"}},
            {cmd = "Dialog", args = {"曹操", "更没想到刘表的援军………"}},
            {cmd = "Dialog", args = {"曹操", "偏巧在这个时候赶到……！"}},
            {cmd = "VarSet", args = {"Var33", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 21, 12, 28, 20}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "GeneralCountsTest", args = {{"player"}, 0, "=", "指定区域", 22, 1, 28, 7}},
        {cmd = "VarTest", args = {{trueConditions = {"Var2", "Var32"}, falseConditions = {"Var33", "Var34"}}}},
        {
            {cmd = "GeneralShow", args = {"骑兵1"}},
            {cmd = "GeneralShow", args = {"骑兵2"}},
            {cmd = "GeneralShow", args = {"骑兵3"}},
            {cmd = "GeneralShow", args = {"骑兵4"}},
            {cmd = "GeneralShow", args = {"弓骑兵1"}},
            {cmd = "GeneralShow", args = {"弓骑兵2"}},
            {cmd = "FaceToFace", args = {"曹操", "骑兵1"}},
            {cmd = "GeneralAction", args = {"曹操", "weak"}},
            {cmd = "Dialog", args = {"曹操", "连刘表的援军也赶到了吗？"}},
            {cmd = "Dialog", args = {"曹操", "唔唔！"}},
            {cmd = "VarSet", args = {"Var34", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {"曹操", 28, 2, 28, 5}},
        {cmd = "VarTest", args = {{trueConditions = {"Var2"}, falseConditions = {"Var35"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"曹操", "呼，总算脱险了。"}},
            {cmd = "VarSet", args = {"Var35", true}},
            {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var101", true}},
            {cmd = "VarSet", args = {"Var612", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "张绣", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var40"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "张绣"}},
            {cmd = "FaceToFace", args = {"张绣", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "张绣，这次一定要砍下你的人头！"}},
            {cmd = "Dialog", args = {"张绣", "说什么蠢话！"}},
            {cmd = "Dialog", args = {"张绣", "我怎么可能败给你！"}},
            {cmd = "VarSet", args = {"Var40", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "贾诩", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var41"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "贾诩"}},
            {cmd = "FaceToFace", args = {"贾诩", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "识破我计谋的，就是贾诩你吧？"}},
            {cmd = "Dialog", args = {"曹操", "真是个值得敬佩的敌人。"}},
            {cmd = "Dialog", args = {"贾诩", "我贾诩向来善于计谋，这点小计何足挂齿。"}},
            {cmd = "Dialog", args = {"贾诩", "您也不须如此夸赞我！"}},
            {cmd = "Dialog", args = {"曹操", "你倒挺会说话的。"}},
            {cmd = "Dialog", args = {"贾诩", "不过如果杀不了你，这个计策就失去意义了。"}},
            {cmd = "Dialog", args = {"贾诩", "准备受死吧。"}},
            {cmd = "Dialog", args = {"曹操", "那正是我想说的。"}},
            {cmd = "VarSet", args = {"Var41", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"张绣", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
        {
            {cmd = "Dialog", args = {"张绣", "唔唔，先撤退吧！"}},
            {cmd = "Dialog", args = {"张绣", "与城西的部队会合。"}},
            {cmd = "GeneralRetreat", args = {"张绣", false}},
            {cmd = "VarSet", args = {"Var50", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"贾诩", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
        {
            {cmd = "Dialog", args = {"贾诩", "嗯嗯，暂时退往城西！"}},
            {cmd = "Dialog", args = {"贾诩", "只要在那里撑过一时……。"}},
            {cmd = "GeneralRetreat", args = {"贾诩", false}},
            {cmd = "VarSet", args = {"Var51", true}},
        },
    },
    {
        {cmd = "BattleWinTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var0"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"曹操", "好，已经控制了城东，现在由城西杀进去！"}},
            {cmd = "Tip", args = {"曹操控制了宛城的东门，继续讨伐张绣。"}},
            {cmd = "Tip", args = {"可是却接到紧急报告∶袁绍对防守薄弱的许都虎视眈眈。于是曹操不得不中止讨伐。"}},
            {
                {cmd = "VarTest", args = {{trueConditions = {"Var3"}}}},
                {cmd = "BattleExtraItems", args = {0, "印绶", 0, "", 0, "", 0, false}},
            },
            {
                {cmd = "Else"},
                {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            },
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var612", true}},
        },
    },
    {
        {cmd = "BattleLoseTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var1"}}}},
        {
            {cmd = "Tip", args = {"曹操败给了张绣军。"}},
            {cmd = "BattleOver"},
            {cmd = "BattleLose"},
            {cmd = "VarSet", args = {"Var1", true}},
        },
    },
}

return Plot
