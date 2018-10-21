local Plot = {}

-- 战斗准备设置
Plot.battlePrepare = {
    battleName   = "徐州救援战",
    maxRounds    = 20,
    mapId        = "13.tmx",
    weatherStart = {"晴", "晴", "阴", "晴", "阴"},
    weatherType  = {"普通"},
    levelAdd     = -2,
    playerGeneralList = {
        {uid = "曹操"},
        {uid = "夏侯惇"},
    },
    enemyGeneralList = {
        {uid = "吕布", aiType = "主动出击", wuqiId = "方天画戟", shipingId = "赤兔马", levelAdd = 4},
        {uid = "侯成", aiType = "主动出击", shipingId = "皮制马铠", levelAdd = 2},
        {uid = "骑兵1", aiType = "主动出击"},
        {uid = "骑兵2", aiType = "主动出击"},
        {uid = "弓骑兵1", aiType = "主动出击"},
        {uid = "骑兵3", aiType = "主动出击"},
        {uid = "策士1", aiType = "主动出击"},
        {uid = "弓骑兵2", aiType = "主动出击"},
        {uid = "道士1", aiType = "主动出击"},
        {uid = "高顺", aiType = "主动出击", shipingId = "铜盾", levelAdd = 2},
        {uid = "曹性", aiType = "主动出击", levelAdd = 2},
        {uid = "步兵1", aiType = "主动出击"},
        {uid = "弓兵1", aiType = "主动出击"},
        {uid = "弓兵2", aiType = "主动出击"},
        {uid = "张辽", aiType = "被动出击", levelAdd = 4},
        {uid = "宋宪", aiType = "被动出击", levelAdd = 2},
        {uid = "魏续", aiType = "被动出击", levelAdd = 2},
        {uid = "武道家1", aiType = "被动出击"},
        {uid = "武道家2", aiType = "被动出击"},
        {uid = "陈宫", aiType = "坚守原地", shipingId = "头巾", levelAdd = 4},
        {uid = "臧霸", aiType = "坚守原地", shipingId = "没羽箭", levelAdd = 2},
        {uid = "弓兵3", aiType = "坚守原地"},
        {uid = "弓兵4", aiType = "坚守原地"},
        {uid = "贼兵1", aiType = "坚守原地"},
    },
    friendGeneralList = {
        {uid = "刘备", aiType = "主动出击", wuqiId = "雌雄双剑", shipingId = "的卢", levelAdd = 4},
        {uid = "关羽", aiType = "主动出击", wuqiId = "青龙偃月刀", levelAdd = 4},
        {uid = "张飞", aiType = "主动出击", wuqiId = "蛇矛", levelAdd = 4},
        {uid = "糜竺", aiType = "被动出击", isHide = true, shipingId = "三略", levelAdd = 2},
        {uid = "糜芳", aiType = "被动出击", isHide = true, shipingId = "六韬", levelAdd = 2},
        {uid = "孙乾", aiType = "被动出击", isHide = true, levelAdd = 2},
    },
}

Plot.battleStartPlot = {
    {cmd = "AddObstacle", args = {"Gate-9", true, "城门", 18, 24}},
    {cmd = "AddObstacle", args = {"Gate-11", true, "城门", 18, 25}},
    {cmd = "GeneralStatusChange", args = {"刘备", "无", "无", "无", 50, 0}},
    {cmd = "GeneralStatusChange", args = {"关羽", "无", "无", "无", 80, 0}},
    {cmd = "GeneralStatusChange", args = {"张飞", "无", "无", "无", 80, 0}},
    {cmd = "PlayMusic", args = {"Track7"}},
    {
        {cmd = "FaceToFace", args = {"曹操", "夏侯惇"}},
        {cmd = "Dialog", args = {"曹操", "看来好像赶上了。"}},
        {cmd = "Dialog", args = {"曹操", "元让，你要在主力军到达之前，死守小沛！"}},
        {cmd = "FaceToFace", args = {"夏侯惇", "曹操"}},
        {cmd = "Dialog", args = {"夏侯惇", "交给我吧，孟德。"}},
        {cmd = "FaceToFace", args = {"夏侯惇", "刘备"}},
        {cmd = "FaceToFace", args = {"刘备", "曹操"}},
        {cmd = "Dialog", args = {"刘备", "哦？是曹操的援军！"}},
        {cmd = "Dialog", args = {"刘备", "真是太好了。"}},
        {cmd = "Dialog", args = {"刘备", "二弟，三弟，再坚持一会就行了！"}},
        {cmd = "FaceToFace", args = {"吕布", "曹操"}},
        {cmd = "Dialog", args = {"吕布", "唔唔，是曹操……？"}},
        {cmd = "Dialog", args = {"吕布", "不快点击败刘备的话，就麻烦了……。"}},
        {cmd = "FaceToFace", args = {"吕布", "曹性"}},
        {cmd = "GeneralAction", args = {"吕布", "attack"}},
        {cmd = "Dialog", args = {"吕布", "曹性、高顺，别让敌人靠近！"}},
        {cmd = "GeneralAction", args = {"吕布", "stand"}},
        {cmd = "FaceToFace", args = {"高顺", "夏侯惇"}},
        {cmd = "FaceToFace", args = {"曹性", "夏侯惇"}},
        {cmd = "GeneralAction", args = {"高顺", "prepareAttack"}},
        {cmd = "Dialog", args = {"高顺", "遵命！请放心，吕将军！"}},
        {cmd = "GeneralAction", args = {"高顺", "stand"}},
        {cmd = "GeneralAction", args = {"曹性", "prepareAttack"}},
        {cmd = "Dialog", args = {"曹性", "高顺，你牵制住夏侯惇。"}},
        {cmd = "Dialog", args = {"曹性", "其他的事就交给我吧。"}},
        {cmd = "Dialog", args = {"曹性", "我们走！"}},
        {cmd = "GeneralAction", args = {"曹性", "stand"}},
        {cmd = "RoleMove", args = {"步兵1", "left", 6, 18}},
        {cmd = "RoleMove", args = {"弓兵1", "left", 6, 19}},
        {cmd = "RoleMove", args = {"弓兵2", "left", 7, 18}},
        {cmd = "RoleMove", args = {"高顺", "left", 6, 17}},
        {cmd = "FaceToFace", args = {"高顺", "夏侯惇"}},
        {cmd = "FaceToFace", args = {"夏侯惇", "高顺"}},
        {cmd = "GeneralAction", args = {"高顺", "attack"}},
        {cmd = "GeneralAction", args = {"高顺", "stand"}},
        {cmd = "GeneralAction", args = {"夏侯惇", "defense"}},
        {cmd = "PlaySound", args = {"Se30.wav", 1}},
        {cmd = "Delay", args = {10}},
        {cmd = "Dialog", args = {"高顺", "夏侯惇，准备受死吧！"}},
        {cmd = "Dialog", args = {"夏侯惇", "哼，少逞口舌之快！"}},
        {cmd = "Dialog", args = {"曹性", "（太好了，高顺！就这样牵制他。）"}},
        {cmd = "GeneralAction", args = {"夏侯惇", "attack"}},
        {cmd = "GeneralAction", args = {"夏侯惇", "stand"}},
        {cmd = "GeneralAction", args = {"高顺", "defense"}},
        {cmd = "PlaySound", args = {"Se31.wav", 1}},
        {cmd = "Delay", args = {10}},
        {cmd = "GeneralAction", args = {"高顺", "attack"}},
        {cmd = "GeneralAction", args = {"高顺", "stand"}},
        {cmd = "GeneralAction", args = {"夏侯惇", "defense"}},
        {cmd = "PlaySound", args = {"Se30.wav", 1}},
        {cmd = "Delay", args = {10}},
        {
            {cmd = "RoleMove", args = {"曹性", "left", 5, 18}},
            {cmd = "FaceToFace", args = {"曹性", "夏侯惇"}},
            {cmd = "GeneralAction", args = {"曹性", "prepareAttack"}},
            {cmd = "PlaySound", args = {"Se37.wav", 1}},
            {cmd = "Delay", args = {10}},
            {cmd = "GeneralAction", args = {"曹性", "attack"}},
            {cmd = "GeneralAction", args = {"曹性", "stand"}},
            {cmd = "FaceToFace", args = {"夏侯惇", "曹性"}},
            {cmd = "GeneralAction", args = {"夏侯惇", "defense"}},
            {cmd = "PlaySound", args = {"Se31.wav", 1}},
            {cmd = "Delay", args = {15}},
            {cmd = "Dialog", args = {"曹性", "嗯！躲过了！？"}},
            {cmd = "Dialog", args = {"夏侯惇", "这种雕虫小技，又能奈我何！"}},
            {
                {cmd = "PkPrepare", args = {"夏侯惇", "曹性"}},
                {cmd = "PkGeneralShow", args = {true, "（这次一定要杀了你。）", "无"}},
                {cmd = "PkGeneralShow", args = {false, "可恶！居然插手捣乱！\n我不会放过你的！", "攻击"}},
                {cmd = "PkShowStart"},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "PkGeneralAction", args = {true, "前移"}},
                {cmd = "PkGeneralAction", args = {true, "小步前移"}},
                {cmd = "PkGeneralAction", args = {false, "前移"}},
                {cmd = "PkShowDialog", args = {false, "站住！休走！", true}},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "PkShowDialog", args = {true, "哼，中计了吧，夏侯惇！\n吃我一招！", true}},
                {cmd = "PkGeneralAttack2", args = {true, "命中", false}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {false, "晕倒"}},
                {cmd = "PkShowDialog", args = {false, "哇啊，眼睛，我的眼睛！", true}},
                {cmd = "PkGeneralAction", args = {true, "前移"}},
                {cmd = "PkShowDialog", args = {true, "赢了！\n这样的伤势没办法再作战了！\n趁机宰了他！", true}},
                {cmd = "PkGeneralAction", args = {false, "攻击预备"}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkShowDialog", args = {false, "我不会因为这样就退缩的！\n唔喔喔喔喔！\n（噗！）", true}},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "PkShowDialog", args = {true, "啊？\n连眼珠子和箭都一起拔出来了！", true}},
                {cmd = "PkGeneralAction", args = {false, "防御"}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkShowDialog", args = {false, "喔喔喔喔！\n（咕噜！）", true}},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "PkShowDialog", args = {true, "什么！\n这、这家伙……\n把自己的眼珠子吞了！？", true}},
                {cmd = "PkGeneralAction", args = {false, "二次攻击"}},
                {cmd = "PkShowDialog", args = {false, "噢噢噢！\n来吧！我要报夺我目之仇！\n你准备受死吧！", true}},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "PkShowDialog", args = {true, "开什么玩笑！\n我还能跟这种家伙打吗？", true}},
                {cmd = "PkGeneralAction", args = {true, "小步前移"}},
                {cmd = "PkGeneralAction", args = {true, "撤退"}},
                {cmd = "PkGeneralAction", args = {false, "前移"}},
                {cmd = "PkGeneralAction", args = {false, "攻击"}},
                {cmd = "PkShowDialog", args = {false, "喂！站住！", true}},
                {cmd = "PkOver"},
            },
            {cmd = "HeadChange", args = {11}},
            {cmd = "Dialog", args = {"夏侯惇", "可恨！这个夺目之仇！"}},
            {cmd = "Dialog", args = {"夏侯惇", "我一定要报！"}},
            {cmd = "Dialog", args = {"曹操", "喔喔喔…，元让！"}},
            {cmd = "Dialog", args = {"曹操", "可恶的吕布，居然敢……！"}},
        },
    },
    {cmd = "ChoiceDialog", args = {"曹操", {"先援救刘备", "为夏侯惇报仇"}}},
    {
        {cmd = "FaceToFace", args = {"曹操", "夏侯惇"}},
        {cmd = "Dialog", args = {"曹操", "元让，你快退下！"}},
        {cmd = "Dialog", args = {"曹操", "其他人马马上救援小沛！"}},
        {cmd = "FaceToFace", args = {"夏侯惇", "曹操"}},
        {cmd = "Dialog", args = {"夏侯惇", "这只是点小伤……"}},
        {cmd = "Dialog", args = {"夏侯惇", "我还能战斗！"}},
        {cmd = "FaceToFace", args = {"刘备", "曹操"}},
        {cmd = "Dialog", args = {"刘备", "孟德大人……"}},
        {cmd = "Dialog", args = {"刘备", "真是不胜感激……"}},
        {cmd = "BattleWinCondition", args = {"胜利条件\n一、歼灭所有敌军。\n\n失败条件\n一、曹操死亡。\n二、刘备撤退。\n三、回合数超过20。"}},
        {cmd = "ShowBattleWinCondition", args = {"死守刘备！"}},
        {cmd = "HighlightGeneral", args = {"刘备"}},
        {cmd = "GeneralChangeDirection", args = {"刘备", "right"}},
        {cmd = "Dialog", args = {"刘备", "（徐州城中应该有不少人怨恨吕布，如果有他们协助的话……）"}},
    },
    {
        {cmd = "FaceToFace", args = {"曹操", "吕布"}},
        {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
        {cmd = "Dialog", args = {"曹操", "元让危险了！"}},
        {cmd = "Dialog", args = {"曹操", "全军救援元让！"}},
        {cmd = "GeneralAction", args = {"曹操", "stand"}},
        {cmd = "FaceToFace", args = {"吕布", "刘备"}},
        {cmd = "Dialog", args = {"吕布", "好！"}},
        {cmd = "Dialog", args = {"吕布", "趁现在消灭刘备他们。"}},
        {cmd = "GeneralAction", args = {"刘备", "weak"}},
        {cmd = "Dialog", args = {"刘备", "看来无法指望曹操的援军了！"}},
        {cmd = "Dialog", args = {"刘备", "只有凭自己的力量渡过难关……"}},
        {cmd = "BattleWinCondition", args = {"胜利条件\n一、歼灭所有敌军。\n\n失败条件\n一、曹操死亡。\n二、回合数超过20。"}},
        {cmd = "ShowBattleWinCondition", args = {"歼灭所有敌军！"}},
        {cmd = "GeneralShow", args = {"糜竺"}},
        {cmd = "GeneralShow", args = {"糜芳"}},
        {cmd = "GeneralShow", args = {"孙乾"}},
        {cmd = "AddObstacle", args = {"Gate-9", false, "城内", 18, 24}},
        {cmd = "AddObstacle", args = {"Gate-11", false, "城内", 18, 25}},
        {cmd = "FaceToFace", args = {"糜竺", "刘备"}},
        {cmd = "FaceToFace", args = {"孙乾", "刘备"}},
        {cmd = "FaceToFace", args = {"糜芳", "刘备"}},
        {cmd = "Dialog", args = {"糜竺", "刘备大人！"}},
        {cmd = "Dialog", args = {"糜竺", "请赶快逃入徐州城吧！"}},
        {cmd = "FaceToFace", args = {"刘备", "糜竺"}},
        {cmd = "FaceToFace", args = {"关羽", "糜竺"}},
        {cmd = "FaceToFace", args = {"张飞", "糜竺"}},
        {cmd = "Dialog", args = {"刘备", "哦！"}},
        {cmd = "Dialog", args = {"刘备", "糜竺、糜芳、孙乾！"}},
        {cmd = "Dialog", args = {"刘备", "原来你们都没事？"}},
        {cmd = "Dialog", args = {"糜竺", "主公被吕布赶出徐州，逃往许都时，我们迟走了一步，因此不得已投降了吕布。"}},
        {cmd = "Dialog", args = {"糜竺", "今天终于能够洗雪这个耻辱了。"}},
        {cmd = "Dialog", args = {"糜竺", "主公，请赶快入城吧。"}},
        {cmd = "Dialog", args = {"刘备", "哦！这真是太感激你们了。"}},
        {cmd = "RoleMove", args = {"刘备", "left", 20, 25}},
        {cmd = "RoleMove", args = {"关羽", "left", 20, 24}},
        {cmd = "RoleMove", args = {"张飞", "left", 20, 26}},
        {cmd = "RoleDisappear", args = {"刘备"}},
        {cmd = "RoleDisappear", args = {"关羽"}},
        {cmd = "RoleDisappear", args = {"张飞"}},
        {cmd = "AddObstacle", args = {"Gate-9", true, "城门", 18, 24}},
        {cmd = "AddObstacle", args = {"Gate-11", true, "城门", 18, 25}},
        {
            {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
            {cmd = "FaceToFace", args = {"糜竺", "吕布"}},
            {cmd = "FaceToFace", args = {"吕布", "糜竺"}},
            {cmd = "Dialog", args = {"吕布", "什、什么！"}},
            {cmd = "Dialog", args = {"吕布", "徐州被刘备占领了！"}},
            {cmd = "Dialog", args = {"吕布", "难道糜竺他们叛变了？"}},
            {cmd = "GeneralAction", args = {"糜竺", "attack"}},
            {cmd = "Dialog", args = {"糜竺", "哈哈哈，吕布！"}},
            {cmd = "Dialog", args = {"糜竺", "你的命就到今天为止了！"}},
            {cmd = "Dialog", args = {"糜竺", "就让曹操消灭你吧！"}},
            {cmd = "GeneralAction", args = {"糜竺", "stand"}},
            {cmd = "Dialog", args = {"吕布", "可恶……"}},
            {cmd = "Dialog", args = {"吕布", "等我杀了曹操，再回头跟你们算帐。"}},
        },
        {cmd = "RoleDisappear", args = {"糜竺"}},
        {cmd = "RoleDisappear", args = {"糜芳"}},
        {cmd = "RoleDisappear", args = {"孙乾"}},
        {cmd = "VarSet", args = {"Var58", true}},
    },
    {cmd = "VarSet", args = {"Var513", true}},
    {cmd = "ShowMenu", args = {true}},
}

Plot.battleMiddlePlot = {
    {
        {cmd = "RoundsTest", args = {2, "="}},
        {cmd = "SideTest", args = {"友军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var11"}}}},
        {
            {cmd = "Dialog", args = {"张飞", "我最讨厌防守了！"}},
            {cmd = "Dialog", args = {"刘备", "多亏孟德大人的援助，敌军的兵力已经分散了，现在是出击的机会……。"}},
            {cmd = "Dialog", args = {"关羽", "我们也应该配合曹大人才对，杀出去吧。"}},
            {cmd = "GeneralAiChange", args = {"刘备", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"关羽", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"张飞", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var11", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 12, 6}},
        {cmd = "VarTest", args = {{falseConditions = {"Var20"}}}},
        {
            {cmd = "AddItem", args = {"神秘水", 0}},
            {cmd = "VarSet", args = {"Var20", true}},
        },
    },
    {
        {cmd = "GeneralCountsTest", args = {{"player"}, 3, ">=", "指定区域", 6, 14, 20, 28}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "GeneralCountsTest", args = {{"enemy"}, 5, "=", "指定区域", 15, 11, 17, 14}},
        {cmd = "VarTest", args = {{falseConditions = {"Var6", "Var54", "Var56"}}}},
        {
            {cmd = "FaceToFace", args = {"张辽", "曹操"}},
            {cmd = "GeneralAction", args = {"张辽", "prepareAttack"}},
            {cmd = "Dialog", args = {"张辽", "追上曹操了！"}},
            {cmd = "Dialog", args = {"张辽", "全军冲锋！"}},
            {cmd = "GeneralAction", args = {"张辽", "stand"}},
            {cmd = "GeneralAiChange", args = {"张辽", "攻击武将", "曹操", 1, 1}},
            {cmd = "GeneralAiChange", args = {"宋宪", "攻击武将", "曹操", 1, 1}},
            {cmd = "GeneralAiChange", args = {"魏续", "攻击武将", "曹操", 1, 1}},
            {cmd = "GeneralAiChange", args = {"武术家1", "攻击武将", "曹操", 1, 1}},
            {cmd = "GeneralAiChange", args = {"武术家2", "攻击武将", "曹操", 1, 1}},
            {
                {cmd = "GeneralCountsTest", args = {{"player"}, 0, "=", "指定区域", 1, 1, 16, 10}},
                {
                    {cmd = "VarTest", args = {{falseConditions = {"Var56", "Var57"}}}},
                    {cmd = "FaceToFace", args = {"陈宫", "曹操"}},
                    {cmd = "FaceToFace", args = {"臧霸", "曹操"}},
                    {cmd = "GeneralAction", args = {"陈宫", "prepareAttack"}},
                    {cmd = "Dialog", args = {"陈宫", "已经没必要守住这个关口了。"}},
                    {cmd = "Dialog", args = {"陈宫", "我们也跟着张辽吧！"}},
                    {cmd = "GeneralAction", args = {"陈宫", "stand"}},
                    {cmd = "GeneralAction", args = {"臧霸", "doubleAttack"}},
                    {cmd = "Dialog", args = {"臧霸", "没办法了。我是跟着去呢？"}},
                    {cmd = "Dialog", args = {"臧霸", "还是慢慢走呢？"}},
                    {cmd = "GeneralAction", args = {"臧霸", "stand"}},
                    {cmd = "GeneralAiChange", args = {"陈宫", "攻击武将", "曹操", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"臧霸", "攻击武将", "曹操", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"弓兵3", "攻击武将", "曹操", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"弓兵4", "攻击武将", "曹操", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"贼兵1", "攻击武将", "曹操", 1, 1}},
                },
            },
            {cmd = "VarSet", args = {"Var6", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 10, 3, 14, 9}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var6", "Var7"}}}},
        {
            {cmd = "GeneralAiChange", args = {"臧霸", "被动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵3", "被动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵4", "被动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"贼兵1", "被动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var7", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "曹性", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var40"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "曹性"}},
            {cmd = "FaceToFace", args = {"曹性", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "看来你已经准备受死了。"}},
            {cmd = "Dialog", args = {"曹操", "我要为元让报仇！"}},
            {cmd = "Dialog", args = {"曹性", "哼！"}},
            {cmd = "VarSet", args = {"Var40", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "高顺", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var41"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "高顺"}},
            {cmd = "FaceToFace", args = {"高顺", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "为了替元让报仇，我要你们的命！"}},
            {cmd = "Dialog", args = {"高顺", "奉吕将军之命，我要杀了你！"}},
            {cmd = "VarSet", args = {"Var41", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "吕布", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var42"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "吕布"}},
            {cmd = "FaceToFace", args = {"吕布", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "我们之间交手的次数，不知道有多少了……"}},
            {cmd = "Dialog", args = {"吕布", "看来如果没有一方先倒地，这场战争将没完没了！"}},
            {cmd = "Dialog", args = {"吕布", "你准备受死吧！"}},
            {cmd = "VarSet", args = {"Var42", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "侯成", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var43"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "侯成"}},
            {cmd = "FaceToFace", args = {"侯成", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "哼、无名小辈！滚开！"}},
            {cmd = "Dialog", args = {"侯成", "你说什么？看我教训你！"}},
            {cmd = "VarSet", args = {"Var43", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "臧霸", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var44"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "臧霸"}},
            {cmd = "FaceToFace", args = {"臧霸", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "滚开，我没空理你！"}},
            {cmd = "Dialog", args = {"臧霸", "居然这么对我说话，我绝不饶你！"}},
            {cmd = "Dialog", args = {"臧霸", "好歹你也该说「请让让吧」。"}},
            {cmd = "VarSet", args = {"Var44", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "陈宫", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var6", "Var45"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "陈宫"}},
            {cmd = "FaceToFace", args = {"陈宫", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "赶快献关投降！"}},
            {cmd = "Dialog", args = {"曹操", "这样我还可以饶你不死。"}},
            {cmd = "Dialog", args = {"陈宫", "说什么鬼话！"}},
            {cmd = "Dialog", args = {"陈宫", "兰关不会这么轻易就失守的！"}},
            {cmd = "VarSet", args = {"Var45", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "张辽", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var46"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "张辽"}},
            {cmd = "FaceToFace", args = {"张辽", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "真是一位出色的将才！"}},
            {cmd = "Dialog", args = {"曹操", "可惜是为敌人卖命。"}},
            {cmd = "Dialog", args = {"张辽", "我要忠告你！"}},
            {cmd = "Dialog", args = {"张辽", "战场上一个不留神，就会断送你的性命。"}},
            {cmd = "Dialog", args = {"张辽", "你还是集中精力作战吧！"}},
            {cmd = "Dialog", args = {"曹操", "（我越来越想收服张辽了。）"}},
            {cmd = "Dialog", args = {"张辽", "受死吧！"}},
            {cmd = "VarSet", args = {"Var46", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "刘备", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var47"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "刘备"}},
            {cmd = "FaceToFace", args = {"刘备", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "玄德，你没事吧？"}},
            {cmd = "Dialog", args = {"刘备", "孟德大人，真是不胜感激。"}},
            {cmd = "Dialog", args = {"刘备", "为了报答你的仗义相助，可否请你请收下这个？"}},
            {cmd = "AddItem", args = {"印绶", 0}},
            {cmd = "VarSet", args = {"Var47", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"吕布", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
        {
            {cmd = "Dialog", args = {"吕布", "曹操、刘备！"}},
            {cmd = "Dialog", args = {"吕布", "这就是你们的为人吗！"}},
            {cmd = "Dialog", args = {"吕布", "唔唔……。"}},
            {cmd = "GeneralRetreat", args = {"吕布", false}},
            {cmd = "VarSet", args = {"Var50", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"侯成", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
        {
            {cmd = "Dialog", args = {"侯成", "唔唔唔！"}},
            {cmd = "Dialog", args = {"侯成", "居然会如此惨败……"}},
            {cmd = "Dialog", args = {"侯成", "撤退！"}},
            {cmd = "GeneralRetreat", args = {"侯成", false}},
            {cmd = "VarSet", args = {"Var51", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"高顺", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
        {
            {cmd = "Dialog", args = {"高顺", "吕将军，我对不起您。"}},
            {cmd = "Dialog", args = {"高顺", "撤退。"}},
            {cmd = "GeneralRetreat", args = {"高顺", false}},
            {cmd = "VarSet", args = {"Var52", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"曹性", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var53"}}}},
        {
            {cmd = "Dialog", args = {"曹性", "啊！"}},
            {cmd = "GeneralRetreat", args = {"曹性", true}},
            {cmd = "VarSet", args = {"Var53", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"张辽", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var54"}}}},
        {
            {cmd = "Dialog", args = {"张辽", "没办法了。"}},
            {cmd = "Dialog", args = {"张辽", "撤退吧。"}},
            {cmd = "GeneralRetreat", args = {"张辽", false}},
            {cmd = "VarSet", args = {"Var54", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"魏续", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var55"}}}},
        {
            {cmd = "Dialog", args = {"魏续", "可恶！"}},
            {cmd = "Dialog", args = {"魏续", "给我记住！"}},
            {cmd = "GeneralRetreat", args = {"魏续", false}},
            {cmd = "VarSet", args = {"Var55", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"陈宫", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var56"}}}},
        {
            {cmd = "Dialog", args = {"陈宫", "唔唔！"}},
            {cmd = "Dialog", args = {"陈宫", "撤、撤退！"}},
            {cmd = "GeneralRetreat", args = {"陈宫", false}},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var6", "Var54"}}}},
                {
                    {cmd = "GeneralCountsTest", args = {{"enemy"}, 5, "=", "指定区域", 15, 11, 17, 14}},
                    {cmd = "GeneralAction", args = {"张辽", "prepareAttack"}},
                    {cmd = "Dialog", args = {"张辽", "想不到兰关会陷落！这下不妙了。"}},
                    {cmd = "Dialog", args = {"张辽", "全军迎击敌军！"}},
                    {cmd = "Dialog", args = {"张辽", "别让任何人通过这里！"}},
                    {cmd = "GeneralAction", args = {"张辽", "stand"}},
                    {cmd = "GeneralAiChange", args = {"张辽", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"宋宪", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"魏续", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"武术家1", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"武术家2", "主动出击", "无", 1, 1}},
                },
            },
            {cmd = "VarSet", args = {"Var56", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"臧霸", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var57"}}}},
        {
            {cmd = "Dialog", args = {"臧霸", "唔唔，算你运气……"}},
            {cmd = "Dialog", args = {"臧霸", "居然能打败我……"}},
            {cmd = "Dialog", args = {"臧霸", "不，我是说打成平手……"}},
            {cmd = "Dialog", args = {"臧霸", "我先到阴间等你，到时候再来一场真正的较量……"}},
            {cmd = "Dialog", args = {"臧霸", "呜呼！"}},
            {cmd = "GeneralRetreat", args = {"臧霸", true}},
            {cmd = "AddItem", args = {"没羽箭", 0}},
            {cmd = "VarSet", args = {"Var57", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"刘备", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var58"}}}},
        {
            {cmd = "Dialog", args = {"刘备", "嗯嗯嗯，这就是我的下场吗……？"}},
            {cmd = "FaceToFace", args = {"曹操", "刘备"}},
            {cmd = "Dialog", args = {"曹操", "糟了！"}},
            {cmd = "Dialog", args = {"曹操", "玄德大人……！"}},
            {cmd = "GeneralShow", args = {"糜竺"}},
            {cmd = "GeneralShow", args = {"糜芳"}},
            {cmd = "GeneralShow", args = {"孙乾"}},
            {cmd = "AddObstacle", args = {"Gate-9", false, "城内", 18, 24}},
            {cmd = "AddObstacle", args = {"Gate-11", false, "城内", 18, 25}},
            {cmd = "FaceToFace", args = {"糜竺", "刘备"}},
            {cmd = "FaceToFace", args = {"糜芳", "刘备"}},
            {cmd = "FaceToFace", args = {"糜芳", "刘备"}},
            {cmd = "Dialog", args = {"糜竺", "主公，还不到放弃的时候！"}},
            {cmd = "Dialog", args = {"糜竺", "请逃入徐州吧！"}},
            {cmd = "FaceToFace", args = {"刘备", "糜竺"}},
            {cmd = "Dialog", args = {"刘备", "哦！"}},
            {cmd = "Dialog", args = {"刘备", "糜竺、糜芳、孙乾！"}},
            {cmd = "Dialog", args = {"刘备", "原来你们都没事？"}},
            {cmd = "Dialog", args = {"糜竺", "主公被吕布赶出徐州，逃往许都时，我们迟走了一步，因此不得已投降了吕布。"}},
            {cmd = "Dialog", args = {"糜竺", "今天终于能够洗雪这个耻辱了。"}},
            {cmd = "Dialog", args = {"糜竺", "主公，请赶快入城吧。"}},
            {cmd = "Dialog", args = {"刘备", "哦！这真是太感激你们了。"}},
            {cmd = "RoleMove", args = {"刘备", "left", 20, 25}},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var59"}}}},
                {cmd = "FaceToFace", args = {"关羽", "糜竺"}},
                {cmd = "Dialog", args = {"关羽", "糜竺先生，原来你没事！"}},
                {cmd = "RoleMove", args = {"关羽", "left", 20, 24}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var60"}}}},
                {cmd = "FaceToFace", args = {"张飞", "糜竺"}},
                {cmd = "Dialog", args = {"张飞", "太好了，这下得救了！"}},
                {cmd = "RoleMove", args = {"张飞", "left", 20, 26}},
            },
            {cmd = "RoleDisappear", args = {"刘备"}},
            {cmd = "RoleDisappear", args = {"关羽"}},
            {cmd = "RoleDisappear", args = {"张飞"}},
            {cmd = "AddObstacle", args = {"Gate-9", true, "城门", 18, 24}},
            {cmd = "AddObstacle", args = {"Gate-11", true, "城门", 18, 25}},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
                {cmd = "FaceToFace", args = {"糜竺", "吕布"}},
                {cmd = "FaceToFace", args = {"吕布", "糜竺"}},
                {cmd = "Dialog", args = {"吕布", "什、什么！"}},
                {cmd = "Dialog", args = {"吕布", "徐州插上了刘备的旗帜？"}},
                {cmd = "Dialog", args = {"吕布", "难道糜竺他们叛变了！"}},
                {cmd = "GeneralAction", args = {"糜竺", "attack"}},
                {cmd = "Dialog", args = {"糜竺", "哈哈哈，吕布！"}},
                {cmd = "Dialog", args = {"糜竺", "你的命就到今天为止了！"}},
                {cmd = "Dialog", args = {"糜竺", "就让曹操消灭你吧！"}},
                {cmd = "GeneralAction", args = {"糜竺", "stand"}},
                {cmd = "Dialog", args = {"吕布", "可恶……"}},
                {cmd = "Dialog", args = {"吕布", "等我杀了曹操，再回头跟你们算帐。"}},
            },
            {cmd = "RoleDisappear", args = {"糜竺"}},
            {cmd = "RoleDisappear", args = {"糜芳"}},
            {cmd = "RoleDisappear", args = {"孙乾"}},
            {cmd = "GeneralChangeDirection", args = {"曹操", "down"}},
            {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
            {cmd = "Dialog", args = {"曹操", "好，看来刘备脱险了。"}},
            {cmd = "Dialog", args = {"曹操", "接下来要歼灭敌军，全军突击！"}},
            {cmd = "GeneralAction", args = {"曹操", "stand"}},
            {cmd = "BattleWinCondition", args = {"胜利条件\n一、歼灭所有敌军。\n\n失败条件\n一、曹操死亡。\n二、回合数超过20。"}},
            {cmd = "ShowBattleWinCondition", args = {"歼灭所有敌军！"}},
            {cmd = "VarSet", args = {"Var58", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"关羽", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var59"}}}},
        {
            {cmd = "Dialog", args = {"关羽", "太不甘心了，撤退！"}},
            {cmd = "GeneralRetreat", args = {"关羽", false}},
            {cmd = "VarSet", args = {"Var59", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"张飞", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var60"}}}},
        {
            {cmd = "Dialog", args = {"张飞", "给我记着！"}},
            {cmd = "Dialog", args = {"张飞", "这次就饶了你们吧。"}},
            {cmd = "GeneralRetreat", args = {"张飞", false}},
            {cmd = "VarSet", args = {"Var60", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"宋宪", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var61"}}}},
        {
            {cmd = "Dialog", args = {"宋宪", "救、救命啊………"}},
            {cmd = "Dialog", args = {"宋宪", "就趁现在！快逃吧，快呀！"}},
            {cmd = "GeneralRetreat", args = {"宋宪", false}},
            {cmd = "VarSet", args = {"Var61", true}},
        },
    },
    {
        {cmd = "BattleWinTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var0"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"曹操", "很好，总算歼灭了敌人。"}},
            {cmd = "Dialog", args = {"曹操", "我军胜利了！"}},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var47", "Var58"}}}},
                {cmd = "FaceToFace", args = {"曹操", "刘备"}},
                {cmd = "FaceToFace", args = {"刘备", "曹操"}},
                {cmd = "Dialog", args = {"曹操", "这次虽然渡过了难关，不过还是得杀了吕布才行。"}},
                {cmd = "Dialog", args = {"曹操", "玄德，加入我军吧。"}},
                {cmd = "Dialog", args = {"刘备", "如果这就是乱世的常规，我当然不得不答应。"}},
                {cmd = "Dialog", args = {"刘备", "还是先报答你的恩情吧。"}},
                {cmd = "Dialog", args = {"刘备", "可否请你收下这个？"}},
                {cmd = "AddItem", args = {"印绶", 0}},
            },
            {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var613", true}},
        },
    },
    {
        {cmd = "BattleLoseTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var1"}}}},
        {
            {cmd = "Tip", args = {"曹操败给了吕布军。"}},
            {cmd = "BattleOver"},
            {cmd = "BattleLose"},
            {cmd = "VarSet", args = {"Var1", true}},
        },
    },
}

return Plot