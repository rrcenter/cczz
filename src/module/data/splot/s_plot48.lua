local Plot = {}

-- 战斗准备设置
Plot.battlePrepare = {
    battleName   = "江陵之战",
    maxRounds    = 30,
    mapId        = "48.tmx",
    weatherStart = {"晴", "晴", "阴", "晴", "阴"},
    weatherType  = {"普通"},
    levelAdd     = -2,
    playerGeneralList = {
        {uid = "曹操"},
        {uid = "夏侯惇"},
    },
    enemyGeneralList = {
        {uid = "孙权", aiType = "坚守原地", levelAdd = 4},
        {uid = "诸葛瑾", aiType = "坚守原地", levelAdd = 4},
        {uid = "周泰", aiType = "坚守原地", levelAdd = 4},
        {uid = "凌统", aiType = "坚守原地", levelAdd = 4},
        {uid = "丁奉", aiType = "坚守原地", levelAdd = 2},
        {uid = "徐盛", aiType = "坚守原地", levelAdd = 2},
        {uid = "弓骑兵1", aiType = "坚守原地"},
        {uid = "武术家1", aiType = "坚守原地"},
        {uid = "武术家2", aiType = "坚守原地"},
        {uid = "全琮", aiType = "坚守原地", levelAdd = 2},
        {uid = "步兵1", aiType = "坚守原地"},
        {uid = "步兵2", aiType = "坚守原地"},
        {uid = "弓兵1", aiType = "坚守原地"},
        {uid = "潘璋", aiType = "主动出击", isHide = true, levelAdd = 2},
        {uid = "蒋钦", aiType = "主动出击", isHide = true, levelAdd = 2},
        {uid = "弓兵2", aiType = "主动出击", isHide = true},
        {uid = "弓兵3", aiType = "主动出击", isHide = true},
        {uid = "贼兵1", aiType = "主动出击", isHide = true},
        {uid = "贼兵2", aiType = "主动出击", isHide = true},
        {uid = "贼兵3", aiType = "主动出击", isHide = true},
        {uid = "贼兵4", aiType = "主动出击", isHide = true},
        {uid = "甘宁", aiType = "主动出击", isHide = true, levelAdd = 4},
        {uid = "鲁肃", aiType = "主动出击", isHide = true, levelAdd = 4},
        {uid = "海盗1", aiType = "主动出击", isHide = true},
        {uid = "海盗2", aiType = "主动出击", isHide = true},
        {uid = "海盗3", aiType = "主动出击", isHide = true},
        {uid = "海盗4", aiType = "主动出击", isHide = true},
        {uid = "海盗5", aiType = "主动出击", isHide = true},
        {uid = "海盗6", aiType = "主动出击", isHide = true},
        {uid = "海盗7", aiType = "主动出击", isHide = true},
    },
}

Plot.battleStartPlot = {
    {
        {cmd = "GeneralEquipsSet", args = {"诸葛瑾", "圣者宝剑", 0, "默认装备", 0, "默认装备"}},
        {cmd = "GeneralEquipsSet", args = {"凌统", "默认装备", 0, "默认装备", 0, "白银盾"}},
        {cmd = "GeneralEquipsSet", args = {"潘璋", "默认装备", 0, "默认装备", 0, "铁盔"}},
        {cmd = "GeneralEquipsSet", args = {"徐盛", "默认装备", 0, "连环铠", 0, "默认装备"}},
        {cmd = "GeneralEquipsSet", args = {"甘宁", "默认装备", 0, "飞龙道袍", 0, "默认装备"}},
    },
    {cmd = "PlayMusic", args = {"Track5"}},
    {
        {cmd = "FaceToFace", args = {"曹操", "孙权"}},
        {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
        {cmd = "Dialog", args = {"曹操", "现在开始进攻江陵城。"}},
        {cmd = "Dialog", args = {"曹操", "全军开始攻击！"}},
        {cmd = "GeneralAction", args = {"曹操", "stand"}},
        {cmd = "FaceToFace", args = {"关羽", "孙权"}},
        {cmd = "GeneralAction", args = {"关羽", "prepareAttack"}},
        {cmd = "Dialog", args = {"关羽", "关某结义兄弟还有儿子的血海深仇，要你们在此偿还！"}},
        {cmd = "GeneralAction", args = {"关羽", "stand"}},
        {cmd = "FaceToFace", args = {"丁奉", "关羽"}},
        {cmd = "Dialog", args = {"丁奉", "那不是关羽吗！？"}},
        {cmd = "Dialog", args = {"丁奉", "原来他投靠了曹操！"}},
        {cmd = "FaceToFace", args = {"徐盛", "丁奉"}},
        {cmd = "Dialog", args = {"徐盛", "丁奉，我们被关羽盯上了。"}},
        {cmd = "Dialog", args = {"徐盛", "一定是来报张飞和关平之仇的。"}},
        {cmd = "Dialog", args = {"徐盛", "怎么办？"}},
        {cmd = "FaceToFace", args = {"凌统", "徐盛"}},
        {cmd = "Dialog", args = {"凌统", "怕什么！"}},
        {cmd = "Dialog", args = {"凌统", "我不会让关羽过来的！"}},
        {cmd = "Dialog", args = {"凌统", "你们就在后面射箭吧。"}},
        {cmd = "FaceToFace", args = {"全琮", "关羽"}},
        {cmd = "GeneralAction", args = {"全琮", "doubleAttack"}},
        {cmd = "Dialog", args = {"全琮", "该死的关羽，把你杀退！"}},
        {cmd = "GeneralAction", args = {"全琮", "stand"}},
        {cmd = "FaceToFace", args = {"孙权", "诸葛瑾"}},
        {cmd = "FaceToFace", args = {"诸葛瑾", "孙权"}},
        {cmd = "FaceToFace", args = {"周泰", "孙权"}},
        {cmd = "Dialog", args = {"周泰", "老大……呃，我是说主公。"}},
        {cmd = "Dialog", args = {"周泰", "咱们这点兵力真的守得住吗？"}},
        {cmd = "Dialog", args = {"诸葛瑾", "援军马上就会来的，到时候就可以支持下去。"}},
        {cmd = "Dialog", args = {"孙权", "不错，即使失去江陵也无所谓。"}},
        {cmd = "Dialog", args = {"孙权", "只要能够争取更多的时间，用于赤壁的兵力布署。"}},
        {cmd = "Dialog", args = {"诸葛瑾", "周都督应该已在赤壁做好准备，我们没有必要在此与敌军硬拼。"}},
        {cmd = "Dialog", args = {"周泰", "这样当然最好，不过就怕……"}},
    },
    {cmd = "BattleWinCondition", args = {"胜利条件\n一、孙权撤退。\n\n失败条件\n一、曹操死亡\n二、回合数超过30个。"}},
    {cmd = "ShowBattleWinCondition", args = {"打败孙权！"}},
    {cmd = "HighlightGeneral", args = {"孙权"}},
    {cmd = "VarSet", args = {"Var548", true}},
    {cmd = "ShowMenu", args = {true}},
}

Plot.battleMiddlePlot = {
    {
        {cmd = "RoundsTest", args = {1, ">="}},
        {cmd = "SideTest", args = {"我军阶段"}},
        {cmd = "VarTest", args = {{trueConditions = {"Var2"}, falseConditions = {"Var11"}}}},
        {
            {
                {cmd = "GeneralShow", args = {"甘宁"}},
                {cmd = "RoleMove", args = {"甘宁", "left", 16, 21}},
                {cmd = "GeneralShow", args = {"鲁肃"}},
                {cmd = "RoleMove", args = {"鲁肃", "left", 16, 22}},
                {cmd = "GeneralShow", args = {"海盗1"}},
                {cmd = "RoleMove", args = {"海盗1", "left", 16, 23}},
                {cmd = "GeneralShow", args = {"海盗2"}},
                {cmd = "RoleMove", args = {"海盗2", "left", 17, 21}},
                {cmd = "GeneralShow", args = {"海盗3"}},
                {cmd = "RoleMove", args = {"海盗3", "left", 17, 22}},
                {cmd = "GeneralShow", args = {"海盗4"}},
                {cmd = "RoleMove", args = {"海盗4", "left", 17, 23}},
                {cmd = "GeneralShow", args = {"海盗5"}},
                {cmd = "RoleMove", args = {"海盗5", "left", 18, 21}},
                {cmd = "GeneralShow", args = {"海盗6"}},
                {cmd = "RoleMove", args = {"海盗6", "left", 18, 22}},
                {cmd = "GeneralShow", args = {"海盗7"}},
                {cmd = "RoleMove", args = {"海盗7", "left", 18, 23}},
            },
            {cmd = "Dialog", args = {"鲁肃", "快点，双方已经开战了！"}},
            {cmd = "Dialog", args = {"甘宁", "主公，请恕我等来迟。"}},
            {cmd = "Dialog", args = {"甘宁", "接下来就交给我们吧！"}},
            {cmd = "FaceToFace", args = {"鲁肃", "孙权"}},
            {cmd = "FaceToFace", args = {"甘宁", "孙权"}},
            {cmd = "Dialog", args = {"鲁肃", "主公，子敬已经抵达。"}},
            {cmd = "Dialog", args = {"鲁肃", "总算及时赶到，太好了。"}},
            {cmd = "Dialog", args = {"甘宁", "敌人在哪，在哪？"}},
            {cmd = "Dialog", args = {"甘宁", "老子可没什么耐心，快点过来受死！"}},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
                {cmd = "FaceToFace", args = {"诸葛瑾", "孙权"}},
                {cmd = "Dialog", args = {"诸葛瑾", "主公，援军来了。"}},
            },
            {cmd = "FaceToFace", args = {"孙权", "鲁肃"}},
            {cmd = "GeneralAction", args = {"孙权", "prepareAttack"}},
            {cmd = "Dialog", args = {"孙权", "鲁肃和甘宁来了是吗？"}},
            {cmd = "Dialog", args = {"孙权", "好，包围曹军再攻打他们！"}},
            {cmd = "GeneralAction", args = {"孙权", "stand"}},
            {cmd = "FaceToFace", args = {"曹操", "甘宁"}},
            {cmd = "Dialog", args = {"曹操", "碧眼儿，好周详的安排！"}},
            {cmd = "Dialog", args = {"曹操", "这场仗该怎么打好呢？"}},
            {cmd = "ChoiceDialog", args = {"曹操", {"迎击伏兵援军", "集中攻击孙权"}}},
            {
                {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
                {cmd = "Dialog", args = {"曹操", "敌军的兵力不足为惧，我们要冷静地逐一应对。"}},
                {cmd = "GeneralAction", args = {"曹操", "stand"}},
                {cmd = "FaceToFace", args = {"孙权", "曹操"}},
                {cmd = "Dialog", args = {"孙权", "唔唔，看来这点兵力还吓不走他们。"}},
                {cmd = "Dialog", args = {"孙权", "也罢！两军在这种情况下交战，我们还可以多争取一些时间。"}},
                {cmd = "FaceToFace", args = {"诸葛瑾", "孙权"}},
                {cmd = "Dialog", args = {"诸葛瑾", "我们还是快点赶去赤壁吧！"}},
                {cmd = "Dialog", args = {"孙权", "好，众将士听令！"}},
                {cmd = "Dialog", args = {"孙权", "这里全靠各位奋战了。"}},
                {cmd = "Dialog", args = {"孙权", "无论如何要尽量争取时间。"}},
                {cmd = "FaceToFace", args = {"诸葛瑾", "周泰"}},
                {cmd = "FaceToFace", args = {"周泰", "诸葛瑾"}},
                {cmd = "Dialog", args = {"诸葛瑾", "周泰，你也跟着保护主公。"}},
                {cmd = "Dialog", args = {"周泰", "只要不会有危险，我都愿意去。"}},
                {cmd = "Dialog", args = {"周泰", "那么这里的事就交给你们了。"}},
                {cmd = "RoleDisappear", args = {"孙权"}},
                {cmd = "RoleDisappear", args = {"诸葛瑾"}},
                {cmd = "RoleDisappear", args = {"周泰"}},
                {cmd = "Dialog", args = {"曹操", "什么！孙权逃了！？"}},
                {
                    {cmd = "VarTest", args = {{falseConditions = {"Var61"}}}},
                    {
                        {cmd = "VarTest", args = {{falseConditions = {"Var54"}}}},
                        {cmd = "Dialog", args = {"潘璋", "只要多争取一点时间，打到一定程度就跑吧，反正主公也看不见。"}},
                    },
                    {
                        {cmd = "VarTest", args = {{falseConditions = {"Var55"}}}},
                        {cmd = "Dialog", args = {"蒋钦", "看来关羽是来向咱们报仇的，此地不宜久留。"}},
                        {cmd = "Dialog", args = {"蒋钦", "差不多就逃吧！"}},
                    },
                    {
                        {cmd = "VarTest", args = {{falseConditions = {"Var57"}}}},
                        {cmd = "Dialog", args = {"丁奉", "争取时间的事就交给我丁奉吧。"}},
                        {cmd = "Dialog", args = {"丁奉", "即使关羽前来报仇，也要设法守住……"}},
                    },
                    {
                        {cmd = "VarTest", args = {{falseConditions = {"Var56"}}}},
                        {cmd = "Dialog", args = {"徐盛", "关羽可真是个大麻烦啊……"}},
                        {cmd = "Dialog", args = {"徐盛", "先前一战咱们射中了关平，最好还是别碰上他为妙。"}},
                    },
                },
                {cmd = "BattleWinCondition", args = {"胜利条件\n一、歼灭所有敌军。\n\n失败条件\n一、曹操死亡。\n二、回合数超过30。"}},
                {cmd = "ShowBattleWinCondition", args = {"歼灭所有敌军！"}},
                {cmd = "VarSet", args = {"Var3", true}},
            },
            {
                {cmd = "FaceToFace", args = {"曹操", "孙权"}},
                {cmd = "Dialog", args = {"曹操", "敌军兵力虽然不多，不过被夹击的话就棘手了。"}},
                {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
                {cmd = "Dialog", args = {"曹操", "我们必须在被完全包围之前，打倒孙权！"}},
                {cmd = "GeneralAction", args = {"曹操", "stand"}},
                {cmd = "FaceToFace", args = {"孙权", "曹操"}},
                {cmd = "Dialog", args = {"孙权", "曹操打算强行突破包围，杀到我跟前是吗！？"}},
                {cmd = "Dialog", args = {"孙权", "好吧，原本我想返回赤壁的，既然这样就留下当诱饵吧。"}},
                {cmd = "Dialog", args = {"孙权", "说不定可以一举消灭曹操！"}},
                {cmd = "GeneralAiChange", args = {"孙权", "主动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"诸葛瑾", "主动出击", "无", 1, 1}},
                {cmd = "GeneralAiChange", args = {"周泰", "主动出击", "无", 1, 1}},
            },
            {cmd = "VarSet", args = {"Var11", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 17, 3}},
        {cmd = "VarTest", args = {{falseConditions = {"Var20"}}}},
        {
            {cmd = "AddItem", args = {"恢复用桃", 0}},
            {cmd = "VarSet", args = {"Var20", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 16, 3}},
        {cmd = "VarTest", args = {{falseConditions = {"Var21"}}}},
        {
            {cmd = "AddItem", args = {"神秘酒", 0}},
            {cmd = "VarSet", args = {"Var21", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 16, 4}},
        {cmd = "VarTest", args = {{falseConditions = {"Var22"}}}},
        {
            {cmd = "AddItem", args = {"恢复用米", 0}},
            {cmd = "VarSet", args = {"Var22", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 17, 4}},
        {cmd = "VarTest", args = {{falseConditions = {"Var23"}}}},
        {
            {cmd = "AddItem", args = {"恢复用米", 0}},
            {cmd = "VarSet", args = {"Var23", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 16, 16}},
        {cmd = "VarTest", args = {{falseConditions = {"Var24"}}}},
        {
            {cmd = "AddItem", args = {"恢复用米", 0}},
            {cmd = "VarSet", args = {"Var24", true}},
        },
    },
    {
        {cmd = "GeneralCountsTest", args = {{"player"}, 3, ">=", "指定区域", 13, 14, 20, 24}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var2", "Var6"}}}},
        {
            {
                {cmd = "GeneralShow", args = {"蒋钦"}},
                {cmd = "GeneralShow", args = {"潘璋"}},
                {cmd = "GeneralShow", args = {"弓兵2"}},
                {cmd = "GeneralShow", args = {"弓兵3"}},
                {cmd = "GeneralShow", args = {"贼兵1"}},
                {cmd = "GeneralShow", args = {"贼兵2"}},
                {cmd = "GeneralShow", args = {"贼兵3"}},
                {cmd = "GeneralShow", args = {"贼兵4"}},
            },
            {cmd = "FaceToFace", args = {"潘璋", "曹操"}},
            {cmd = "FaceToFace", args = {"蒋钦", "曹操"}},
            {cmd = "Dialog", args = {"蒋钦", "嘿嘿，上当了吧，曹操。"}},
            {cmd = "Dialog", args = {"蒋钦", "我最在行的就是使诈术攻击敌人了！"}},
            {cmd = "Dialog", args = {"潘璋", "主公正在看我们的表现。"}},
            {cmd = "Dialog", args = {"潘璋", "如果杀了曹操就是大功一件！"}},
            {cmd = "FaceToFace", args = {"孙权", "蒋钦"}},
            {cmd = "GeneralAction", args = {"孙权", "prepareAttack"}},
            {cmd = "Dialog", args = {"孙权", "好！攻击曹操的军队！"}},
            {cmd = "GeneralAction", args = {"孙权", "stand"}},
            {cmd = "FaceToFace", args = {"曹操", "潘璋"}},
            {cmd = "Dialog", args = {"曹操", "是伏兵……？"}},
            {cmd = "Dialog", args = {"曹操", "看来敌军早有防范。"}},
            {cmd = "RangeGeneralsAiChange", args = {{"enemy"}, 11, 12, 20, 18, "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var2", true}},
            {cmd = "VarSet", args = {"Var6", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 3, 14, 7, 18}},
        {cmd = "VarTest", args = {{falseConditions = {"Var2", "Var30"}}}},
        {
            {
                {cmd = "GeneralShow", args = {"蒋钦"}},
                {cmd = "GeneralShow", args = {"潘璋"}},
                {cmd = "GeneralShow", args = {"弓兵2"}},
                {cmd = "GeneralShow", args = {"弓兵3"}},
                {cmd = "GeneralShow", args = {"贼兵1"}},
                {cmd = "GeneralShow", args = {"贼兵2"}},
                {cmd = "GeneralShow", args = {"贼兵3"}},
                {cmd = "GeneralShow", args = {"贼兵4"}},
            },
            {cmd = "FaceToFace", args = {"潘璋", "曹操"}},
            {cmd = "FaceToFace", args = {"蒋钦", "曹操"}},
            {cmd = "GeneralAction", args = {"潘璋", "dizzy"}},
            {cmd = "Dialog", args = {"潘璋", "糟了，被发觉了……"}},
            {cmd = "Dialog", args = {"蒋钦", "哼！只要能打败了敌人就行了。"}},
            {cmd = "Dialog", args = {"蒋钦", "反正所谓的伏兵，早晚会出现在敌人跟前的。"}},
            {cmd = "FaceToFace", args = {"孙权", "蒋钦"}},
            {cmd = "Dialog", args = {"孙权", "啧，既然如此，只好全军出战了！"}},
            {cmd = "Dialog", args = {"孙权", "不用守城了，大家全力攻击曹操。"}},
            {cmd = "FaceToFace", args = {"曹操", "孙权"}},
            {cmd = "Dialog", args = {"曹操", "果然有伏兵！"}},
            {cmd = "Dialog", args = {"曹操", "看来可能还有其他诡计。"}},
            {cmd = "RangeGeneralsAiChange", args = {{"enemy"}, 11, 12, 20, 18, "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var2", true}},
            {cmd = "VarSet", args = {"Var30", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "孙权", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var40"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "孙权"}},
            {cmd = "FaceToFace", args = {"孙权", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "孙权，你愿不愿意乖乖投降？"}},
            {cmd = "Dialog", args = {"孙权", "不要白费唇舌了。"}},
            {cmd = "Dialog", args = {"孙权", "我不会投降的！"}},
            {cmd = "Dialog", args = {"曹操", "那么我只好消灭吴国。"}},
            {cmd = "VarSet", args = {"Var40", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"关羽", "徐盛", true}},
        {cmd = "VarTest", args = {{trueConditions = {"Var3"}, falseConditions = {"Var41"}}}},
        {
            {cmd = "FaceToFace", args = {"关羽", "徐盛"}},
            {cmd = "FaceToFace", args = {"徐盛", "关羽"}},
            {cmd = "Dialog", args = {"关羽", "我要为战死于麦城的关平报仇！"}},
            {cmd = "Dialog", args = {"徐盛", "唔，哇！"}},
            {cmd = "Dialog", args = {"徐盛", "现在快逃吧！"}},
            {cmd = "RoleDisappear", args = {"徐盛"}},
            {cmd = "Dialog", args = {"关羽", "竟然让他逃走了。"}},
            {cmd = "VarSet", args = {"Var41", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"关羽", "蒋钦", true}},
        {cmd = "VarTest", args = {{trueConditions = {"Var3"}, falseConditions = {"Var42"}}}},
        {
            {cmd = "FaceToFace", args = {"关羽", "蒋钦"}},
            {cmd = "FaceToFace", args = {"蒋钦", "关羽"}},
            {cmd = "Dialog", args = {"关羽", "我要为战死于麦城的关索报仇！"}},
            {cmd = "Dialog", args = {"蒋钦", "哼！我才不跟你打。"}},
            {cmd = "Dialog", args = {"蒋钦", "再见！"}},
            {cmd = "RoleDisappear", args = {"蒋钦"}},
            {cmd = "Dialog", args = {"关羽", "想逃？休走！"}},
            {cmd = "Dialog", args = {"关羽", "你这不配称为武将的家伙！"}},
            {cmd = "VarSet", args = {"Var42", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"关羽", "潘璋", true}},
        {cmd = "VarTest", args = {{trueConditions = {"Var3"}, falseConditions = {"Var43"}}}},
        {
            {cmd = "FaceToFace", args = {"关羽", "潘璋"}},
            {cmd = "FaceToFace", args = {"潘璋", "关羽"}},
            {cmd = "Dialog", args = {"关羽", "我要为战死于麦城的关兴报仇！"}},
            {cmd = "Dialog", args = {"潘璋", "啊？是关羽！"}},
            {cmd = "Dialog", args = {"潘璋", "（没必要为了争取时间而把命给丢了，……撤退吧！）"}},
            {cmd = "RoleDisappear", args = {"潘璋"}},
            {cmd = "Dialog", args = {"关羽", "竟然如此轻易地逃走！？"}},
            {cmd = "Dialog", args = {"关羽", "可能有诈？"}},
            {cmd = "VarSet", args = {"Var43", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"关羽", "丁奉", true}},
        {cmd = "VarTest", args = {{trueConditions = {"Var3"}, falseConditions = {"Var44"}}}},
        {
            {cmd = "FaceToFace", args = {"关羽", "丁奉"}},
            {cmd = "FaceToFace", args = {"丁奉", "关羽"}},
            {cmd = "Dialog", args = {"关羽", "我要为战死于麦城的三弟报仇！"}},
            {cmd = "Dialog", args = {"丁奉", "对不起，我才没那个胆。"}},
            {cmd = "Dialog", args = {"丁奉", "撤退！"}},
            {cmd = "RoleDisappear", args = {"丁奉"}},
            {cmd = "Dialog", args = {"关羽", "让他给跑了！？真气人。"}},
            {cmd = "VarSet", args = {"Var44", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"关羽", "徐盛", false}},
        {cmd = "VarTest", args = {{trueConditions = {"Var11"}, falseConditions = {"Var3", "Var45"}}}},
        {
            {cmd = "FaceToFace", args = {"关羽", "徐盛"}},
            {cmd = "FaceToFace", args = {"徐盛", "关羽"}},
            {cmd = "Dialog", args = {"关羽", "还我儿关平的命来！"}},
            {cmd = "Dialog", args = {"关羽", "拿命来吧！"}},
            {cmd = "Dialog", args = {"徐盛", "唔、唔唔……"}},
            {cmd = "Dialog", args = {"徐盛", "等，等一下！"}},
            {cmd = "Dialog", args = {"关羽", "废话少说！拿命来吧！"}},
            {cmd = "Dialog", args = {"徐盛", "唔唔，又不能在孙权主公面前逃跑，这下可麻烦大了。"}},
            {cmd = "VarSet", args = {"Var45", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"关羽", "蒋钦", false}},
        {cmd = "VarTest", args = {{trueConditions = {"Var11"}, falseConditions = {"Var3", "Var46"}}}},
        {
            {cmd = "FaceToFace", args = {"关羽", "蒋钦"}},
            {cmd = "FaceToFace", args = {"蒋钦", "关羽"}},
            {cmd = "Dialog", args = {"关羽", "可找到你了。"}},
            {cmd = "Dialog", args = {"关羽", "我要报关索之仇！"}},
            {cmd = "Dialog", args = {"蒋钦", "哎呀，被这讨厌的家伙给遇到了！"}},
            {cmd = "VarSet", args = {"Var46", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"关羽", "潘璋", false}},
        {cmd = "VarTest", args = {{trueConditions = {"Var11"}, falseConditions = {"Var3", "Var47"}}}},
        {
            {cmd = "FaceToFace", args = {"关羽", "潘璋"}},
            {cmd = "FaceToFace", args = {"潘璋", "关羽"}},
            {cmd = "Dialog", args = {"关羽", "竟敢杀害关兴……"}},
            {cmd = "Dialog", args = {"关羽", "我绝不饶你！"}},
            {cmd = "Dialog", args = {"潘璋", "唔唔，关羽！"}},
            {cmd = "Dialog", args = {"潘璋", "这下不妙了。"}},
            {cmd = "Dialog", args = {"潘璋", "唔唔唔……"}},
            {cmd = "Dialog", args = {"潘璋", "偏偏在主公面又无法撤退。"}},
            {cmd = "Dialog", args = {"潘璋", "这下可惨了！"}},
            {cmd = "VarSet", args = {"Var47", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"关羽", "丁奉", false}},
        {cmd = "VarTest", args = {{trueConditions = {"Var11"}, falseConditions = {"Var3", "Var48"}}}},
        {
            {cmd = "FaceToFace", args = {"关羽", "丁奉"}},
            {cmd = "FaceToFace", args = {"丁奉", "关羽"}},
            {cmd = "Dialog", args = {"关羽", "丁奉，我要替三弟报仇！"}},
            {cmd = "Dialog", args = {"丁奉", "嗯嗯，关羽？"}},
            {cmd = "Dialog", args = {"丁奉", "好！来吧！"}},
            {cmd = "VarSet", args = {"Var48", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"孙权", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"孙权", "我已经无能为力了。"}},
            {cmd = "Dialog", args = {"孙权", "撤退！"}},
            {cmd = "RoleDisappear", args = {"孙权"}},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
                {cmd = "Dialog", args = {"诸葛瑾", "看来还是别逞强的好。"}},
                {cmd = "Dialog", args = {"诸葛瑾", "我也撤退吧！"}},
                {cmd = "RoleDisappear", args = {"诸葛瑾"}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var53"}}}},
                {cmd = "Dialog", args = {"周泰", "主公都走了，咱们也撤退吧。"}},
                {cmd = "RoleDisappear", args = {"周泰"}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var58"}}}},
                {cmd = "Dialog", args = {"凌统", "照预定计划撤退吧！"}},
                {cmd = "RoleDisappear", args = {"凌统"}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var61"}}}},
                {cmd = "Dialog", args = {"鲁肃", "没必要再打下去了。"}},
                {cmd = "Dialog", args = {"鲁肃", "全军撤退吧！"}},
                {cmd = "RoleDisappear", args = {"鲁肃"}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var60"}}}},
                {cmd = "Dialog", args = {"甘宁", "什么？老子正打得起劲啊！"}},
                {cmd = "Dialog", args = {"甘宁", "怎么就这样撤退了？"}},
                {cmd = "Dialog", args = {"甘宁", "我还没杀过瘾呢。"}},
                {cmd = "RoleDisappear", args = {"甘宁"}},
            },
            {cmd = "GeneralsDisappear", args = {{"enemy"}, 1, 1, 20, 24}},
            {cmd = "Dialog", args = {"曹操", "想不到吴军如此轻易地撤退了。"}},
            {cmd = "Dialog", args = {"曹操", "难道这一仗是为争取时间？"}},
            {cmd = "Dialog", args = {"曹操", "嗯，也罢。"}},
            {cmd = "Dialog", args = {"曹操", "不管你们耍什么花招，我都会击破你所有的诡计。"}},
            {cmd = "Dialog", args = {"曹操", "好，全军驻扎江陵！"}},
            {cmd = "Dialog", args = {"曹操", "等待命令！"}},
            {
                {cmd = "VarTest", args = {{trueConditions = {"Var3"}}}},
                {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            },
            {
                {cmd = "Else"},
                {cmd = "BattleExtraItems", args = {0, "印绶", 0, "", 0, "", 0, false}},
            },
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var50", true}},
            {cmd = "VarSet", args = {"Var100", true}},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var648", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"鲁肃", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
        {
            {cmd = "Dialog", args = {"鲁肃", "唔哇！"}},
            {cmd = "Dialog", args = {"鲁肃", "鲁肃撤退了。"}},
            {cmd = "GeneralRetreat", args = {"鲁肃", false}},
            {cmd = "VarSet", args = {"Var51", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"诸葛瑾", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
        {
            {cmd = "Dialog", args = {"诸葛瑾", "没办法。"}},
            {cmd = "Dialog", args = {"诸葛瑾", "撤退吧。"}},
            {cmd = "GeneralRetreat", args = {"诸葛瑾", false}},
            {cmd = "VarSet", args = {"Var52", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"周泰", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var53"}}}},
        {
            {cmd = "Dialog", args = {"周泰", "啐，看来该撤退了。"}},
            {cmd = "Dialog", args = {"周泰", "撤退，撤退！"}},
            {cmd = "GeneralRetreat", args = {"周泰", false}},
            {cmd = "VarSet", args = {"Var53", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"潘璋", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var54"}}}},
        {
            {cmd = "Dialog", args = {"潘璋", "哇啊！"}},
            {cmd = "Dialog", args = {"潘璋", "撤、撤退！"}},
            {cmd = "GeneralRetreat", args = {"潘璋", false}},
            {cmd = "VarSet", args = {"Var54", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"蒋钦", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var55"}}}},
        {
            {cmd = "Dialog", args = {"蒋钦", "好痛啊！"}},
            {cmd = "Dialog", args = {"蒋钦", "啧，撤退吧。"}},
            {cmd = "GeneralRetreat", args = {"蒋钦", false}},
            {cmd = "VarSet", args = {"Var55", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"徐盛", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var56"}}}},
        {
            {cmd = "Dialog", args = {"徐盛", "不行了，不行了！撤退吧！"}},
            {cmd = "Dialog", args = {"徐盛", "快、快走啊！"}},
            {cmd = "GeneralRetreat", args = {"徐盛", false}},
            {cmd = "VarSet", args = {"Var56", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"丁奉", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var57"}}}},
        {
            {cmd = "Dialog", args = {"丁奉", "人常说千万别勉力而为。"}},
            {cmd = "Dialog", args = {"丁奉", "今天就暂且先撤退吧。"}},
            {cmd = "GeneralRetreat", args = {"丁奉", false}},
            {cmd = "VarSet", args = {"Var57", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"凌统", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var58"}}}},
        {
            {cmd = "Dialog", args = {"凌统", "可恨！"}},
            {cmd = "Dialog", args = {"凌统", "今天的屈辱日后一定要你们偿还！"}},
            {cmd = "GeneralRetreat", args = {"凌统", false}},
            {cmd = "VarSet", args = {"Var58", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"全琮", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var59"}}}},
        {
            {cmd = "Dialog", args = {"全琮", "什么，我输了？"}},
            {cmd = "Dialog", args = {"全琮", "啧，没办法。"}},
            {cmd = "Dialog", args = {"全琮", "撤退吧！"}},
            {cmd = "GeneralRetreat", args = {"全琮", false}},
            {cmd = "VarSet", args = {"Var59", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"甘宁", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var60"}}}},
        {
            {cmd = "Dialog", args = {"甘宁", "好痛啊，你这小子！"}},
            {cmd = "Dialog", args = {"甘宁", "可恶，不能再打了。"}},
            {cmd = "Dialog", args = {"甘宁", "撤回去吧，啐！"}},
            {cmd = "GeneralRetreat", args = {"甘宁", false}},
            {cmd = "VarSet", args = {"Var60", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"关羽", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var61"}}}},
        {
            {cmd = "VarSet", args = {"Var61", true}},
        },
    },
    {
        {cmd = "BattleWinTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var0"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"曹操", "嗯，我军胜利了！"}},
            {cmd = "Dialog", args = {"曹操", "不过孙权军队的形势有些奇怪，好像根本就无意作战……"}},
            {cmd = "Dialog", args = {"曹操", "莫非这座城是诱饵？"}},
            {cmd = "Dialog", args = {"曹操", "又是周瑜的诡计吧？"}},
            {cmd = "Dialog", args = {"曹操", "无论如何，还是小心为妙。"}},
            {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var648", true}},
        },
    },
    {
        {cmd = "BattleLoseTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var1"}}}},
        {
            {cmd = "Tip", args = {"曹操在孙权军前大败而归。"}},
            {cmd = "BattleOver"},
            {cmd = "BattleLose"},
            {cmd = "VarSet", args = {"Var1", true}},
        },
    },
}
return Plot
