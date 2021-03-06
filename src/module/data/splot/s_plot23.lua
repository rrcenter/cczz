local Plot = {}

-- 战斗准备设置
Plot.battlePrepare = {
    battleName   = "南皮攻略战",
    maxRounds    = 25,
    mapId        = "23.tmx",
    weatherStart = {"晴", "晴", "阴", "晴", "阴"},
    weatherType  = {"小雪"},
    levelAdd     = -2,
    playerGeneralList = {
        {uid = "曹操"},
        {uid = "夏侯惇"},
    },
    enemyGeneralList = {
        {uid = "袁谭", aiType = "坚守原地", isKeyGeneral = true, fangjuId = "黄金铠", levelAdd = 2},
        {uid = "步兵1", aiType = "被动出击"},
        {uid = "步兵2", aiType = "被动出击"},
        {uid = "步兵3", aiType = "被动出击"},
        {uid = "步兵4", aiType = "被动出击"},
        {uid = "炮兵1", aiType = "被动出击"},
        {uid = "炮兵2", aiType = "主动出击"},
        {uid = "炮兵3", aiType = "主动出击"},
        {uid = "炮兵4", aiType = "主动出击"},
        {uid = "辛评", aiType = "主动出击", shipingId = "皮手套", levelAdd = 4},
        {uid = "步兵5", aiType = "主动出击"},
        {uid = "步兵6", aiType = "主动出击"},
        {uid = "弓兵1", aiType = "主动出击"},
        {uid = "弓兵2", aiType = "主动出击"},
        {uid = "炮兵5", aiType = "主动出击"},
        {uid = "郭图", aiType = "主动出击", shipingId = "纶巾", levelAdd = 2},
        {uid = "步兵7", aiType = "主动出击"},
        {uid = "步兵8", aiType = "主动出击"},
        {uid = "弓兵3", aiType = "主动出击"},
        {uid = "弓兵4", aiType = "主动出击"},
        {uid = "炮兵6", aiType = "主动出击"},
        {uid = "步兵9", aiType = "坚守原地"},
        {uid = "步兵10", aiType = "坚守原地"},
        {uid = "弓兵5", aiType = "坚守原地"},
        {uid = "弓兵6", aiType = "坚守原地"},
        {uid = "步兵11", aiType = "坚守原地"},
        {uid = "步兵12", aiType = "坚守原地"},
        {uid = "弓兵7", aiType = "坚守原地"},
        {uid = "弓兵8", aiType = "坚守原地"},
        {uid = "贼兵1", aiType = "主动出击", isHide = true},
        {uid = "贼兵2", aiType = "主动出击", isHide = true},
        {uid = "贼兵3", aiType = "主动出击", isHide = true},
        {uid = "贼兵4", aiType = "主动出击", isHide = true},
        {uid = "贼兵5", aiType = "主动出击", isHide = true},
        {uid = "贼兵6", aiType = "主动出击", isHide = true},
        {uid = "贼兵7", aiType = "主动出击", isHide = true},
        {uid = "贼兵8", aiType = "主动出击", isHide = true},
    },
}

Plot.battleStartPlot = {
    {
        {cmd = "AddObstacle", args = {"Gate-29", true, "城门", 10, 5}},
        {cmd = "AddObstacle", args = {"Gate-31", true, "城门", 10, 6}},
        {cmd = "AddObstacle", args = {"Gate-33", true, "城门", 15, 11}},
        {cmd = "AddObstacle", args = {"Gate-35", true, "城门", 16, 11}},
    },
    {cmd = "PlayMusic", args = {"Track7"}},
    {
        {cmd = "GeneralAction", args = {"袁谭", "weak"}},
        {cmd = "Dialog", args = {"袁谭", "没想到今天竟落到这般田地。"}},
        {cmd = "FaceToFace", args = {"辛评", "袁谭"}},
        {cmd = "FaceToFace", args = {"郭图", "袁谭"}},
        {cmd = "GeneralAction", args = {"辛评", "prepareAttack"}},
        {cmd = "Dialog", args = {"辛评", "主公，不要紧的，这南皮城城池坚固，不会轻易失陷的。"}},
        {cmd = "GeneralAction", args = {"辛评", "stand"}},
        {cmd = "GeneralAction", args = {"郭图", "prepareAttack"}},
        {cmd = "Dialog", args = {"郭图", "只要有我郭图在，根本不用害怕曹操。"}},
        {cmd = "GeneralAction", args = {"郭图", "stand"}},
        {cmd = "FaceToFace", args = {"曹操", "郭嘉"}},
        {cmd = "Dialog", args = {"曹操", "这座城易守难攻，郭嘉，有何妙计？"}},
        {cmd = "FaceToFace", args = {"郭嘉", "曹操"}},
        {cmd = "Dialog", args = {"郭嘉", "是。"}},
        {cmd = "Dialog", args = {"郭嘉", "可以兵分两路，同时进攻……"}},
        {cmd = "GeneralAction", args = {"郭嘉", "deepBreath"}},
        {cmd = "Dialog", args = {"郭嘉", "咳、咳！"}},
        {cmd = "FaceToFace", args = {"曹操", "郭嘉"}},
        {cmd = "Dialog", args = {"曹操", "不要紧吧，郭嘉？"}},
        {cmd = "Dialog", args = {"曹操", "你的病还没痊愈吗？"}},
        {cmd = "Dialog", args = {"郭嘉", "只是受了点风寒，不过……"}},
        {cmd = "Dialog", args = {"郭嘉", "现在还不能休息……"}},
        {cmd = "Dialog", args = {"郭嘉", "请主公不必费心。"}},
        {cmd = "Dialog", args = {"郭嘉", "这风寒没有大碍。"}},
        {cmd = "Dialog", args = {"郭嘉", "咳、咳……"}},
        {cmd = "Dialog", args = {"曹操", "你太固执了……"}},
        {cmd = "FaceToFace", args = {"曹操", "曹丕"}},
        {cmd = "Dialog", args = {"曹操", "曹丕！"}},
        {cmd = "FaceToFace", args = {"曹丕", "曹操"}},
        {cmd = "Dialog", args = {"曹丕", "在。"}},
        {cmd = "Dialog", args = {"曹丕", "父亲何事招唤孩儿！"}},
        {cmd = "Dialog", args = {"曹操", "给你一半军马前去立功。"}},
        {cmd = "Dialog", args = {"曹丕", "孩儿一定不辜负父亲期望。"}},
        {cmd = "Dialog", args = {"曹操", "嗯、看你的了。"}},
        {cmd = "FaceToFace", args = {"曹操", "郭嘉"}},
        {cmd = "Dialog", args = {"曹操", "郭嘉，你辅佐曹丕。"}},
        {cmd = "Dialog", args = {"郭嘉", "是……"}},
        {cmd = "Dialog", args = {"郭嘉", "咳、咳……"}},
        {
            {cmd = "PlayerGeneralMove", args = {0, 5, 12, "up"}},
            {cmd = "PlayerGeneralMove", args = {3, 5, 11, "up"}},
            {cmd = "PlayerGeneralMove", args = {5, 6, 11, "up"}},
            {cmd = "PlayerGeneralMove", args = {7, 4, 11, "up"}},
            {cmd = "PlayerGeneralMove", args = {9, 6, 12, "up"}},
            {cmd = "PlayerGeneralMove", args = {11, 4, 12, "up"}},
            {cmd = "PlayerGeneralMove", args = {1, 9, 16, "right"}},
            {cmd = "PlayerGeneralMove", args = {2, 10, 16, "right"}},
            {cmd = "PlayerGeneralMove", args = {4, 10, 15, "right"}},
            {cmd = "PlayerGeneralMove", args = {6, 10, 17, "right"}},
            {cmd = "PlayerGeneralMove", args = {8, 9, 15, "right"}},
            {cmd = "PlayerGeneralMove", args = {10, 9, 17, "right"}},
            {cmd = "PlayerGeneralMove", args = {12, 9, 18, "right"}},
        },
    },
    {cmd = "BattleWinCondition", args = {"胜利条件\n一、击退袁谭。\n\n失败条件\n一、曹操死亡。\n二、回合数超过25。"}},
    {cmd = "ShowBattleWinCondition", args = {"击退袁谭！"}},
    {cmd = "HighlightGeneral", args = {"袁谭"}},
    {cmd = "VarSet", args = {"Var523", true}},
    {cmd = "ShowMenu", args = {true}},
}

Plot.battleMiddlePlot = {
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 19, 2}},
        {cmd = "VarTest", args = {{falseConditions = {"Var20"}}}},
        {
            {cmd = "AddItem", args = {"恢复用桃", 0}},
            {cmd = "VarSet", args = {"Var20", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 18, 3}},
        {cmd = "VarTest", args = {{falseConditions = {"Var21"}}}},
        {
            {cmd = "AddItem", args = {"神秘水", 0}},
            {cmd = "VarSet", args = {"Var21", true}},
        },
    },
    {
        {cmd = "GeneralCountsTest", args = {{"enemy"}, 4, "<", "指定区域", 8, 5, 9, 6}},
        {cmd = "VarTest", args = {{falseConditions = {"Var6"}}}},
        {
            {cmd = "GeneralChangeDirection", args = {"辛评", "down"}},
            {cmd = "GeneralAction", args = {"辛评", "raiseWuqi"}},
            {cmd = "Dialog", args = {"辛评", "喂、动手了。"}},
            {cmd = "Dialog", args = {"辛评", "快！"}},
            {cmd = "GeneralShow", args = {"贼兵1"}},
            {cmd = "GeneralShow", args = {"贼兵2"}},
            {cmd = "GeneralShow", args = {"贼兵3"}},
            {cmd = "GeneralShow", args = {"贼兵4"}},
            {cmd = "GeneralAction", args = {"贼兵3", "prepareAttack"}},
            {cmd = "Dialog", args = {"贼兵3", "小子们！"}},
            {cmd = "GeneralAction", args = {"贼兵3", "stand"}},
            {cmd = "GeneralAiChange", args = {"步兵9", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵10", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵5", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵6", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var6", true}},
        },
    },
    {
        {cmd = "GeneralCountsTest", args = {{"enemy"}, 4, "<", "指定区域", 15, 12, 16, 13}},
        {cmd = "VarTest", args = {{falseConditions = {"Var7"}}}},
        {
            {cmd = "GeneralChangeDirection", args = {"郭图", "down"}},
            {cmd = "GeneralAction", args = {"郭图", "raiseWuqi"}},
            {cmd = "Dialog", args = {"郭图", "现在动手！"}},
            {cmd = "Dialog", args = {"郭图", "袭击他们的背后！"}},
            {cmd = "GeneralShow", args = {"贼兵5"}},
            {cmd = "GeneralShow", args = {"贼兵6"}},
            {cmd = "GeneralShow", args = {"贼兵7"}},
            {cmd = "GeneralShow", args = {"贼兵8"}},
            {cmd = "GeneralAction", args = {"贼兵6", "prepareAttack"}},
            {cmd = "Dialog", args = {"贼兵6", "好、是时机了！"}},
            {cmd = "GeneralAction", args = {"贼兵6", "stand"}},
            {cmd = "GeneralAiChange", args = {"步兵11", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵12", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵7", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵8", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var7", true}},
        },
    },
    {
        {cmd = "GeneralCountsTest", args = {{"enemy"}, 3, "<", "指定区域", 1, 1, 9, 20}},
        {cmd = "GeneralCountsTest", args = {{"enemy"}, 3, "<", "指定区域", 10, 12, 20, 20}},
        {cmd = "VarTest", args = {{falseConditions = {"Var8"}}}},
        {
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51", "Var52"}}}},
                {cmd = "FaceToFace", args = {"袁谭", "郭图"}},
                {cmd = "GeneralAction", args = {"袁谭", "weak"}},
                {cmd = "Dialog", args = {"袁谭", "可恶………唔唔！"}},
                {cmd = "Dialog", args = {"袁谭", "事到如今……"}},
                {cmd = "Dialog", args = {"袁谭", "干脆投降吧。"}},
                {cmd = "FaceToFace", args = {"郭图", "袁谭"}},
                {cmd = "Dialog", args = {"郭图", "主、主公！您说什么！"}},
                {cmd = "Dialog", args = {"郭图", "要投降！？"}},
                {cmd = "Dialog", args = {"袁谭", "与其牺牲大家性命，还不如投降曹操，我想曹操会答应吧。"}},
                {cmd = "GeneralAction", args = {"郭图", "weak"}},
                {cmd = "Dialog", args = {"郭图", "………"}},
                {cmd = "Dialog", args = {"郭图", "（难道我郭图要成为败军之将吗？"}},
                {cmd = "Dialog", args = {"郭图", "为什么会变成这样！）"}},
                {cmd = "FaceToFace", args = {"袁谭", "辛评"}},
                {cmd = "Dialog", args = {"袁谭", "辛评，你去向曹操求降。"}},
                {cmd = "FaceToFace", args = {"辛评", "袁谭"}},
                {cmd = "Dialog", args = {"辛评", "……是，我一定不辱使命。"}},
                {cmd = "AddObstacle", args = {"Gate-29", false, "城内", 10, 5}},
                {cmd = "AddObstacle", args = {"Gate-31", false, "城内", 10, 6}},
                {cmd = "RoleMove", args = {"辛评", "left", 10, 5}},
                {cmd = "FaceToFace", args = {"辛评", "曹操"}},
                {cmd = "Dialog", args = {"辛评", "丞相大人，小人实在难以启齿，我家主公想归降丞相大人。"}},
                {cmd = "Dialog", args = {"辛评", "再打下去只会增加无谓的牺牲，请您务必答应我军的请求。"}},
                {cmd = "FaceToFace", args = {"曹操", "辛评"}},
                {cmd = "Dialog", args = {"曹操", "（……现在放过袁谭"}},
                {cmd = "Dialog", args = {"曹操", "有百害而无一益……）"}},
                {cmd = "ChoiceDialog", args = {"曹操", {"不接受投降", "只接受辛评", "接受投降"}}},
                {
                    {cmd = "Dialog", args = {"曹操", "难得你们有投降诚意，不过我不能答应，袁谭不是那种甘居人下之人。"}},
                    {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
                    {cmd = "Dialog", args = {"曹操", "城门打开了！"}},
                    {cmd = "Dialog", args = {"曹操", "全军杀入吧！"}},
                    {cmd = "Dialog", args = {"曹操", "一鼓作气攻下城来！"}},
                    {cmd = "GeneralAction", args = {"曹操", "stand"}},
                    {cmd = "GeneralAction", args = {"辛评", "dizzy"}},
                    {cmd = "Dialog", args = {"辛评", "什、什么……？"}},
                    {cmd = "Dialog", args = {"辛评", "曹操这么想取胜吗！"}},
                    {cmd = "FaceToFace", args = {"袁谭", "曹操"}},
                    {cmd = "Dialog", args = {"袁谭", "曹操老贼！"}},
                    {cmd = "Dialog", args = {"袁谭", "我要与你同归于尽，全军出击和曹操拼了。"}},
                },
                {
                    {cmd = "Dialog", args = {"曹操", "辛评，学学你弟弟辛毗，放弃袁谭归降我军吧？"}},
                    {cmd = "Dialog", args = {"辛评", "丞相还是不肯接纳我军是吗？"}},
                    {cmd = "Dialog", args = {"曹操", "现在太迟了……"}},
                    {cmd = "Dialog", args = {"曹操", "不过我可以接纳你。"}},
                    {cmd = "Dialog", args = {"辛评", "这可不行。"}},
                    {cmd = "Dialog", args = {"辛评", "我与弟弟各为其主。"}},
                    {cmd = "RoleMove", args = {"辛评", "right", 16, 3}},
                    {cmd = "FaceToFace", args = {"辛评", "袁谭"}},
                    {cmd = "Dialog", args = {"辛评", "很遗憾………"}},
                    {cmd = "Dialog", args = {"辛评", "曹操根本不打算接受我等的归降，我们只有决一死战了。"}},
                    {cmd = "FaceToFace", args = {"袁谭", "辛评"}},
                    {cmd = "Dialog", args = {"袁谭", "什么……！？"}},
                    {cmd = "Dialog", args = {"袁谭", "你就这么乖乖回来了？"}},
                    {cmd = "Dialog", args = {"辛评", "这、这是因为……"}},
                    {cmd = "Dialog", args = {"袁谭", "听说你弟弟也投入曹操麾下了。"}},
                    {cmd = "Dialog", args = {"袁谭", "所以你认为自己没有性命之忧是吗？"}},
                    {cmd = "Dialog", args = {"袁谭", "哼、你这个卑鄙小人！"}},
                    {cmd = "Dialog", args = {"辛评", "什、什么…！"}},
                    {cmd = "Dialog", args = {"辛评", "主公您错怪我了……"}},
                    {cmd = "GeneralAction", args = {"辛评", "weak"}},
                    {cmd = "GeneralAction", args = {"辛评", "attack"}},
                    {cmd = "GeneralAction", args = {"辛评", "stand"}},
                    {cmd = "Dialog", args = {"辛评", "既然如此………"}},
                    {cmd = "Dialog", args = {"辛评", "只有一死证明我的清白……"}},
                    {cmd = "Dialog", args = {"辛评", "唔啊……"}},
                    {cmd = "GeneralRetreat", args = {"辛评", true}},
                    {cmd = "Dialog", args = {"袁谭", "啊、啊…辛、辛评……"}},
                    {cmd = "Dialog", args = {"袁谭", "我这一怒又失去了一个忠臣，真是天丧我也……"}},
                    {cmd = "FaceToFace", args = {"郭图", "袁谭"}},
                    {cmd = "Dialog", args = {"郭图", "主公，如今后悔也无益。"}},
                    {cmd = "Dialog", args = {"郭图", "没办法了，我们准备战斗吧！"}},
                    {cmd = "Dialog", args = {"袁谭", "嗯、嗯…全军出动吧！"}},
                    {cmd = "Dialog", args = {"袁谭", "拼死一战的话，也许还有一线生机。"}},
                    {cmd = "Dialog", args = {"郭图", "（我绝不能允许自己失败。"}},
                    {cmd = "Dialog", args = {"郭图", "绝对不能！）"}},
                    {
                        {cmd = "GeneralAiChange", args = {"袁谭", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵1", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵2", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵3", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵4", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵9", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵10", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵11", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵12", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"弓兵5", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"弓兵6", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"弓兵7", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"弓兵8", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"炮兵1", "主动出击", "无", 1, 1}},
                    },
                    {cmd = "AddObstacle", args = {"Gate-33", false, "城内", 15, 11}},
                    {cmd = "AddObstacle", args = {"Gate-35", false, "城内", 16, 11}},
                },
                {
                    {cmd = "Dialog", args = {"曹操", "嗯、好吧……"}},
                    {cmd = "Dialog", args = {"曹操", "将士的罪责就不追究了。"}},
                    {cmd = "Dialog", args = {"曹操", "不过我不能放过袁谭，交出他的首级吧。"}},
                    {cmd = "Dialog", args = {"辛评", "不行……"}},
                    {cmd = "Dialog", args = {"曹操", "那么这件事就没有商量的余地了。"}},
                    {cmd = "RoleMove", args = {"辛评", "right", 16, 3}},
                    {cmd = "FaceToFace", args = {"辛评", "袁谭"}},
                    {cmd = "Dialog", args = {"辛评", "曹操说只要交出主公首级，他就既往不咎。"}},
                    {cmd = "FaceToFace", args = {"袁谭", "辛毗"}},
                    {cmd = "GeneralAction", args = {"袁谭", "circle"}},
                    {cmd = "Dialog", args = {"袁谭", "什、什么！"}},
                    {cmd = "Dialog", args = {"袁谭", "要我的首级？"}},
                    {cmd = "Dialog", args = {"袁谭", "开什么玩笑！"}},
                    {cmd = "Dialog", args = {"辛评", "主公…让我陪您一起死吧，为了不让无辜的人牺牲，辛评心意已决。"}},
                    {cmd = "Dialog", args = {"袁谭", "别说笑！我还不想死，我要与曹操老贼决一死战。"}},
                    {cmd = "FaceToFace", args = {"郭图", "袁谭"}},
                    {cmd = "Dialog", args = {"郭图", "（有这种人当统帅，再怎么足智多谋也打不过曹操，看来我的气数已尽……）"}},
                    {cmd = "FaceToFace", args = {"袁谭", "曹操"}},
                    {cmd = "GeneralAction", args = {"袁谭", "prepareAttack"}},
                    {cmd = "Dialog", args = {"袁谭", "全军突击！后退者斩！"}},
                    {cmd = "Dialog", args = {"袁谭", "和曹操拼死一战！"}},
                    {cmd = "GeneralAction", args = {"袁谭", "stand"}},
                    {
                        {cmd = "GeneralAiChange", args = {"步兵1", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵2", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵3", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵4", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵9", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵10", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵11", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"步兵12", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"弓兵5", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"弓兵6", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"弓兵7", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"弓兵8", "主动出击", "无", 1, 1}},
                        {cmd = "GeneralAiChange", args = {"炮兵1", "主动出击", "无", 1, 1}},
                    },
                    {cmd = "AddObstacle", args = {"Gate-33", false, "城内", 15, 11}},
                    {cmd = "AddObstacle", args = {"Gate-35", false, "城内", 16, 11}},
                    {cmd = "Dialog", args = {"步兵6", "开啥玩笑！"}},
                    {cmd = "Dialog", args = {"步兵6", "我可不想死在这里！"}},
                    {cmd = "RoleDisappear", args = {"步兵6"}},
                    {cmd = "Dialog", args = {"弓兵1", "救、救命啊……！"}},
                    {cmd = "Dialog", args = {"弓兵1", "我可要逃命去了……"}},
                    {cmd = "RoleDisappear", args = {"弓兵1"}},
                    {cmd = "Dialog", args = {"炮兵6", "我还想活命呢，可不能这么死了！"}},
                    {cmd = "RoleDisappear", args = {"炮兵6"}},
                    {cmd = "Dialog", args = {"弓兵4", "我不想再呆在这了……"}},
                    {cmd = "RoleDisappear", args = {"弓兵4"}},
                    {cmd = "Dialog", args = {"袁谭", "哼！不中用的东西！"}},
                },
            },
            {
                {cmd = "Else"},
                {cmd = "FaceToFace", args = {"袁谭", "曹操"}},
                {cmd = "GeneralAction", args = {"袁谭", "weak"}},
                {cmd = "Dialog", args = {"袁谭", "嗯嗯嗯……"}},
                {cmd = "Dialog", args = {"袁谭", "这样下去可不行…"}},
                {cmd = "Dialog", args = {"袁谭", "全军突击！"}},
                {cmd = "Dialog", args = {"袁谭", "打开城门杀出去，直接攻击曹操，杀出一条出路！"}},
                {
                    {cmd = "GeneralAiChange", args = {"袁谭", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"步兵1", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"步兵2", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"步兵3", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"步兵4", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"步兵9", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"步兵10", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"步兵11", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"步兵12", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"弓兵5", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"弓兵6", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"弓兵7", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"弓兵8", "主动出击", "无", 1, 1}},
                    {cmd = "GeneralAiChange", args = {"炮兵1", "主动出击", "无", 1, 1}},
                },
                {cmd = "AddObstacle", args = {"Gate-29", false, "城内", 10, 5}},
                {cmd = "AddObstacle", args = {"Gate-31", false, "城内", 10, 6}},
                {cmd = "AddObstacle", args = {"Gate-33", false, "城内", 15, 11}},
                {cmd = "AddObstacle", args = {"Gate-35", false, "城内", 16, 11}},
            },
            {cmd = "VarSet", args = {"Var8", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "袁谭", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var40"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "袁谭"}},
            {cmd = "FaceToFace", args = {"袁谭", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "你已经无路可逃了。"}},
            {cmd = "Dialog", args = {"袁谭", "唔唔，曹操！"}},
            {cmd = "VarSet", args = {"Var40", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹洪", "袁谭", true}},
        {cmd = "VarTest", args = {{falseConditions = {"Var41"}}}},
        {
            {cmd = "FaceToFace", args = {"曹洪", "袁谭"}},
            {cmd = "FaceToFace", args = {"袁谭", "曹洪"}},
            {cmd = "Dialog", args = {"曹洪", "袁谭，拿命来！"}},
            {cmd = "Dialog", args = {"袁谭", "什么！"}},
            {
                {cmd = "PkPrepare", args = {"曹洪", "袁谭"}},
                {cmd = "PkGeneralShow", args = {true, "臭小子，快滚开！\n不知道我袁谭的厉害吗！", "攻击"}},
                {cmd = "PkGeneralShow", args = {false, "我乃曹氏大将，\n对付你绰绰有余。\n来吧，一决高下！", "防御"}},
                {cmd = "PkShowStart"},
                {cmd = "PkShowDialog", args = {true, "唔唔、不妙。", true}},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "PkGeneralAction", args = {false, "攻击预备"}},
                {cmd = "PkShowDialog", args = {false, "还想跑！？", true}},
                {cmd = "PkGeneralAction", args = {false, "前移"}},
                {cmd = "PkGeneralAttack", args = {false, "移动攻击", true}},
                {cmd = "PkGeneralAction", args = {false, "后转"}},
                {cmd = "PkGeneralAttack", args = {false, "移动攻击", true}},
                {cmd = "PkShowDialog", args = {true, "哇啊啊！", true}},
                {cmd = "PkGeneralAction", args = {true, "晕倒"}},
                {cmd = "PkGeneralDie", args = {true}},
                {cmd = "PkGeneralAction", args = {false, "后转"}},
                {cmd = "PkGeneralAction", args = {false, "攻击"}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkGeneralAction", args = {false, "攻击预备"}},
                {cmd = "PkShowDialog", args = {false, "我砍下袁谭的首级了！", true}},
                {cmd = "PkOver"},
            },
            {cmd = "GeneralRetreat", args = {"袁谭", true}},
            {cmd = "VarSet", args = {"Var50", true}},
            {cmd = "AddItem", args = {"黄金铠", 0}},
            {cmd = "AllGeneralsRecover"},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "FaceToFace", args = {"辛评", "袁谭"}},
                {cmd = "Dialog", args = {"辛评", "怎么会这样！？"}},
                {cmd = "Dialog", args = {"辛评", "主公怎么会被杀了……"}},
                {cmd = "VarSet", args = {"Var51", true}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
                {cmd = "FaceToFace", args = {"郭图", "袁谭"}},
                {cmd = "GeneralAction", args = {"郭图", "weak"}},
                {cmd = "Dialog", args = {"郭图", "完、完了……"}},
                {cmd = "VarSet", args = {"Var52", true}},
            },
            {cmd = "RangeGeneralsRetreat", args = {{"enemy"}, 1, 1, 20, 20, true}},
            {cmd = "VarSet", args = {"Var41", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"乐进", "郭图", true}},
        {cmd = "VarTest", args = {{falseConditions = {"Var42"}}}},
        {
            {cmd = "FaceToFace", args = {"乐进", "郭图"}},
            {cmd = "FaceToFace", args = {"郭图", "乐进"}},
            {cmd = "Dialog", args = {"乐进", "可找到你了，郭图！"}},
            {cmd = "Dialog", args = {"郭图", "啊？什么人！？"}},
            {
                {cmd = "PkPrepare", args = {"乐进", "郭图"}},
                {cmd = "PkGeneralShow", args = {false, "我乃乐进、乐文谦！\n郭图，下马受死吧！", "攻击预备"}},
                {cmd = "PkGeneralShow", args = {true, "滚开！匹夫！\n我以智谋为战，\n不想和你单挑！", "攻击"}},
                {cmd = "PkShowStart"},
                {cmd = "PkGeneralAction", args = {true, "防御"}},
                {cmd = "PkShowDialog", args = {true, "哼！\n没闲功夫理你！", true}},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "PkGeneralAction", args = {true, "小步前移"}},
                {cmd = "PkGeneralAction", args = {true, "小步前移"}},
                {cmd = "PkShowDialog", args = {false, "别逃！", true}},
                {cmd = "PkGeneralAttack", args = {false, "移动攻击", true}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {true, "后转"}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkGeneralAction", args = {true, "小步后退"}},
                {cmd = "Delay", args = {10}},
                {cmd = "PkShowDialog", args = {true, "我、我郭图……\n难道要死在这里？\n唔唔……", true}},
                {cmd = "PkGeneralAction", args = {true, "晕倒"}},
                {cmd = "PkGeneralDie", args = {true}},
                {cmd = "PkGeneralAction", args = {false, "无"}},
                {cmd = "Delay", args = {5}},
                {cmd = "PkGeneralAction", args = {false, "攻击预备"}},
                {cmd = "PkShowDialog", args = {false, "郭图已经被斩！\n一鼓作气击溃敌军！", true}},
                {cmd = "PkOver"},
            },
            {cmd = "GeneralRetreat", args = {"郭图", true}},
            {cmd = "VarSet", args = {"Var52", true}},
            {cmd = "AddItem", args = {"纶巾", 0}},
            {cmd = "VarSet", args = {"Var42", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"袁谭", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
        {
            {cmd = "Dialog", args = {"袁谭", "可、可恶…可恶啊！"}},
            {cmd = "Dialog", args = {"袁谭", "唔啊……"}},
            {cmd = "GeneralRetreat", args = {"袁谭", true}},
            {cmd = "AddItem", args = {"黄金铠", 0}},
            {cmd = "AllGeneralsRecover"},
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
                {cmd = "FaceToFace", args = {"辛评", "袁谭"}},
                {cmd = "Dialog", args = {"辛评", "怎么会这样！？"}},
                {cmd = "Dialog", args = {"辛评", "主公怎么被杀了……"}},
                {cmd = "VarSet", args = {"Var51", true}},
            },
            {
                {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
                {cmd = "FaceToFace", args = {"郭图", "袁谭"}},
                {cmd = "GeneralAction", args = {"郭图", "weak"}},
                {cmd = "Dialog", args = {"郭图", "完、完了……"}},
                {cmd = "VarSet", args = {"Var52", true}},
            },
            {cmd = "RangeGeneralsRetreat", args = {{"enemy"}, 1, 1, 20, 20, true}},
            {cmd = "VarSet", args = {"Var50", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"辛评", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
        {
            {cmd = "Dialog", args = {"辛评", "这就是我的下场吗……"}},
            {cmd = "Dialog", args = {"辛评", "唔、唔……"}},
            {cmd = "GeneralRetreat", args = {"辛评", true}},
            {cmd = "AddItem", args = {"皮手套", 0}},
            {cmd = "VarSet", args = {"Var51", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"郭图", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
        {
            {cmd = "Dialog", args = {"郭图", "唔唔、咳……"}},
            {cmd = "Dialog", args = {"郭图", "…………"}},
            {cmd = "GeneralRetreat", args = {"郭图", true}},
            {cmd = "AddItem", args = {"纶巾", 0}},
            {cmd = "VarSet", args = {"Var52", true}},
        },
    },
    {
        {cmd = "BattleWinTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var0"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"曹操", "很好，总算歼灭敌人！"}},
            {cmd = "Dialog", args = {"曹操", "我军胜利了！"}},
            {cmd = "BattleExtraItems", args = {0, "印绶", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var623", true}},
        },
    },
    {
        {cmd = "BattleLoseTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var1"}}}},
        {
            {cmd = "Tip", args = {"曹操败给了袁谭。"}},
            {cmd = "BattleOver"},
            {cmd = "BattleLose"},
            {cmd = "VarSet", args = {"Var1", true}},
        },
    },
}

return Plot
