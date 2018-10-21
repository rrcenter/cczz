local Plot = {}

-- 战斗准备设置
Plot.battlePrepare = {
    battleName   = "徐州复仇战",
    maxRounds    = 20,
    mapId        = "5.tmx",
    weatherStart = {"晴", "晴", "阴", "晴", "阴"},
    weatherType  = {"普通"},
    levelAdd     = -2,
    playerGeneralList = {
        {uid = "曹操", shipingId = "没羽箭"},
        {uid = "郭嘉"},
        {uid = "程昱"},
    },
    enemyGeneralList = {
        {uid = "陶谦", aiType = "坚守原地", fangjuId = "白银铠", levelAdd = 2},
        {uid = "糜竺", aiType = "坚守原地", shipingId = "三略", levelAdd = 4},
        {uid = "步兵1", aiType = "坚守原地"},
        {uid = "步兵2", aiType = "坚守原地"},
        {uid = "步兵3", aiType = "坚守原地"},
        {uid = "步兵4", aiType = "坚守原地"},
        {uid = "步兵5", aiType = "坚守原地"},
        {uid = "步兵6", aiType = "坚守原地"},
        {uid = "步兵7", aiType = "坚守原地"},
        {uid = "步兵8", aiType = "坚守原地"},
        {uid = "弓兵1", aiType = "被动出击"},
        {uid = "弓兵2", aiType = "被动出击"},
        {uid = "弓兵3", aiType = "被动出击"},
        {uid = "弓兵4", aiType = "被动出击"},
        {uid = "步兵9", aiType = "坚守原地"},
        {uid = "步兵10", aiType = "坚守原地"},
        {uid = "步兵11", aiType = "坚守原地"},
        {uid = "弓兵5", aiType = "坚守原地"},
        {uid = "骑兵1", aiType = "主动出击"},
        {uid = "骑兵2", aiType = "主动出击"},
        {uid = "骑兵3", aiType = "主动出击"},
        {uid = "骑兵4", aiType = "主动出击"},
        {uid = "弓骑兵1", aiType = "主动出击"},
        {uid = "弓骑兵2", aiType = "主动出击"},
        {uid = "步兵12", aiType = "被动出击"},
        {uid = "步兵13", aiType = "被动出击"},
        {uid = "弓兵6", aiType = "被动出击"},
        {uid = "步兵14", aiType = "被动出击"},
        {uid = "步兵15", aiType = "被动出击"},
        {uid = "弓兵7", aiType = "被动出击"},
        {uid = "刘备", aiType = "主动出击", isHide = true, wuqiId = "雌雄双剑", shipingId = "的卢", levelAdd = 4},
        {uid = "关羽", aiType = "主动出击", isHide = true, wuqiId = "青龙偃月刀", levelAdd = 4},
        {uid = "张飞", aiType = "主动出击", isHide = true, wuqiId = "蛇矛", levelAdd = 4},
        {uid = "赵云", aiType = "主动出击", isHide = true, fangjuId = "白银铠", levelAdd = 4},
        {uid = "炮兵1", aiType = "被动出击"},
    },
}

Plot.battleStartPlot = {
    {cmd = "PlayMusic", args = {"Track7"}},
    {
        {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
        {cmd = "Dialog", args = {"曹操", "现在开始进攻徐州。（我要在这乱世中扬名立万，为父报仇将是平定天下的第一步。）"}},
        {cmd = "GeneralAction", args = {"曹操", "stand"}},
        {cmd = "Dialog", args = {"郭嘉", "（这是我参加的第一仗，首先要确立自己在军中的地位……。）"}},
        {cmd = "Dialog", args = {"程昱", "（身为策士应该做什么呢？此战将是我的试金石……？）"}},
        {cmd = "Dialog", args = {"陶谦", "连属下也管不好，我陶谦确实是老了……只是现在后悔也太晚了。"}},
        {cmd = "Dialog", args = {"陶谦", "身为太守，我有义务保护此地，交出首级若能平息此事的话………"}},
        {cmd = "FaceToFace", args = {"糜竺", "陶谦"}},
        {cmd = "Dialog", args = {"糜竺", "主公，万万不可！"}},
        {cmd = "Dialog", args = {"糜竺", "曹操为父报仇只是借口，他的目标其实是徐州。"}},
        {cmd = "Dialog", args = {"糜竺", "这场仗已经暴露了曹操的野心，此地若由他来统治，将是百姓的不幸。"}},
        {cmd = "Dialog", args = {"糜竺", "还请您三思啊！"}},
        {cmd = "Dialog", args = {"陶谦", "可是，我们根本挡不住曹军啊……"}},
        {cmd = "Dialog", args = {"陶谦", "这样下去只会伤及无辜百姓的。"}},
        {cmd = "Dialog", args = {"糜竺", "一定会有正义之师前来救援的，不要绝望。"}},
        {cmd = "GeneralChangeDirection", args = {"糜竺", "left"}},
    },
    {cmd = "BattleWinCondition", args = {"胜利条件\n一、击退陶谦。\n\n失败条件\n一、曹操死亡。\n二、回合数超过20。"}},
    {cmd = "ShowBattleWinCondition", args = {"击退陶谦！"}},
    {cmd = "HighlightGeneral", args = {"陶谦"}},
    {cmd = "VarSet", args = {"Var505", true}},
    {cmd = "ShowMenu", args = {true}},
}

Plot.battleMiddlePlot = {
    {
        {cmd = "RoundsTest", args = {8, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var11"}}}},
        {
            {cmd = "GeneralShow", args = {"刘备"}},
            {cmd = "GeneralShow", args = {"关羽"}},
            {cmd = "GeneralShow", args = {"张飞"}},
            {cmd = "GeneralShow", args = {"赵云"}},
            {
                {cmd = "Dialog", args = {"刘备", "唔！战斗已经开始了。"}},
                {cmd = "Dialog", args = {"刘备", "没想到曹操居然会做出这种事……。"}},
                {cmd = "Dialog", args = {"关羽", "表面上是为父报仇，不过我却体会到他征服天下的野心，这次一定要阻止他。"}},
                {cmd = "Dialog", args = {"刘备", "嗯！先劝说他看看吧。"}},
                {cmd = "Dialog", args = {"赵云", "要是能听得进去当然最好，只怕……。"}},
                {cmd = "FaceToFace", args = {"刘备", "曹操"}},
                {cmd = "Dialog", args = {"刘备", "曹大人何在？"}},
                {cmd = "Dialog", args = {"刘备", "我有话对曹大人说！"}},
                {cmd = "Dialog", args = {"刘备", "请先住手吧。"}},
                {cmd = "FaceToFace", args = {"曹操", "刘备"}},
                {cmd = "Dialog", args = {"曹操", "刘玄德！这场仗是为了替我父亲报仇，你不要插手。"}},
                {cmd = "Dialog", args = {"刘备", "陶大人的情况你也知道，他没有什么野心，这件事肯定有误会，其实他是没有恶意的……。"}},
                {cmd = "Dialog", args = {"曹操", "父亲的死是铁一般的事实，与陶谦的为人没有任何关系。"}},
                {cmd = "Dialog", args = {"刘备", "此事关系国与国的安危，还请抛弃私人的恩怨。"}},
                {cmd = "Dialog", args = {"曹操", "虽然你这么说，但我办不到！"}},
                {cmd = "GeneralAction", args = {"刘备", "dizzy"}},
                {cmd = "GeneralAction", args = {"刘备", "weak"}},
                {cmd = "Dialog", args = {"刘备", "什么……？难道我刘备看错了人！"}},
                {cmd = "Dialog", args = {"刘备", "我以为曹孟德是为天下着想的，没想到！"}},
                {cmd = "Dialog", args = {"曹操", "我当然也曾经为天下着想，但是玄德，如果用你的方法，根本无法改变世间。"}},
                {cmd = "FaceToFace", args = {"郭嘉", "曹操"}},
                {cmd = "Dialog", args = {"郭嘉", "主公，请借一步说话…"}},
                {cmd = "Dialog", args = {"郭嘉", "如此这般……。"}},
                {cmd = "Dialog", args = {"曹操", "（什么！？吕布进攻濮阳！）"}},
                {cmd = "Dialog", args = {"曹操", "（眼看着就快攻下徐州，这时候该怎么办……？）"}},
            },
            {cmd = "ChoiceDialog", args = {"曹操", {"立即和谈转往濮阳", "继续讨伐陶谦"}}},
            {
                {
                    {cmd = "Dialog", args = {"曹操", "刘玄德！这次给你个面子，我答应讲和。"}},
                    {cmd = "Dialog", args = {"刘备", "哦？你答应了！"}},
                    {cmd = "Dialog", args = {"曹操", "不过下次再给我捣乱，我可不留情面，你记住了。"}},
                    {cmd = "FaceToFace", args = {"陶谦", "曹操"}},
                    {cmd = "Dialog", args = {"陶谦", "曹大人，请等一下，请收下这件白银铠。"}},
                    {cmd = "Dialog", args = {"陶谦", "为了表明我等并无恶意，把这件宝物送给你。"}},
                    {cmd = "FaceToFace", args = {"曹操", "陶谦"}},
                    {cmd = "AddItem", args = {"白银铠", 0}},
                    {cmd = "Dialog", args = {"曹操", "好吧，那我就收下了。"}},
                    {cmd = "GeneralChangeDirection", args = {"曹操", "left"}},
                    {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
                    {cmd = "Dialog", args = {"曹操", "全军撤退，马上返回濮阳。"}},
                    {cmd = "GeneralAction", args = {"曹操", "stand"}},
                    {cmd = "FaceToFace", args = {"曹操", "刘备"}},
                    {cmd = "Dialog", args = {"曹操", "刘备！没有城，没有兵，光有想法能做什么！"}},
                    {cmd = "Dialog", args = {"曹操", "只知道为天下着想，是没办法考虑到每个人的。"}},
                    {cmd = "GeneralsDisappear", args = {{"player"}, 1, 1, 24, 24}},
                },
                {
                    {cmd = "FaceToFace", args = {"刘备", "关羽"}},
                    {cmd = "Dialog", args = {"刘备", "终于平息了一场争斗，然而……。"}},
                    {cmd = "FaceToFace", args = {"关羽", "刘备"}},
                    {cmd = "Dialog", args = {"关羽", "原来这就是曹操平定天下之道？"}},
                    {cmd = "Dialog", args = {"刘备", "看来我们这个样子，大概什么也做不成。"}},
                    {cmd = "Dialog", args = {"关羽", "兄长，徐州百姓获救也是不争的事实。"}},
                    {cmd = "Dialog", args = {"关羽", "如今也只有把一切交给上苍，带领我们找寻自己的安身之所了。"}},
                    {cmd = "Dialog", args = {"刘备", "你说的对。"}},
                    {cmd = "Dialog", args = {"刘备", "好，咱们回公孙瓒那儿吧。"}},
                    {cmd = "Dialog", args = {"刘备", "此外也要注意袁绍的行动才行。"}},
                    {cmd = "FaceToFace", args = {"陶谦", "刘备"}},
                    {cmd = "Dialog", args = {"陶谦", "玄德先生，谢谢你。"}},
                    {cmd = "Dialog", args = {"陶谦", "我也没什么好报答你的。"}},
                    {cmd = "FaceToFace", args = {"陶谦", "糜竺"}},
                    {cmd = "Dialog", args = {"陶谦", "糜竺，传令下去准备庆祝。"}},
                    {cmd = "FaceToFace", args = {"糜竺", "刘备"}},
                    {cmd = "Dialog", args = {"糜竺", "你是我们徐州的恩人，就让我们好好款待你吧。"}},
                    {cmd = "Dialog", args = {"糜竺", "请各位一定留下来。"}},
                    {cmd = "FaceToFace", args = {"刘备", "陶谦"}},
                    {cmd = "FaceToFace", args = {"关羽", "陶谦"}},
                    {cmd = "FaceToFace", args = {"张飞", "陶谦"}},
                    {cmd = "FaceToFace", args = {"赵云", "陶谦"}},
                    {cmd = "FaceToFace", args = {"陶谦", "刘备"}},
                    {cmd = "Dialog", args = {"刘备", "这点小事大人无须放在心上，我们不过是为了伸张正义，现在还得回去复命。"}},
                    {cmd = "Dialog", args = {"张飞", "难得有人招待我们，大哥你就接受嘛。"}},
                    {cmd = "Dialog", args = {"张飞", "这一路行军，肚子早就空了！"}},
                    {cmd = "Dialog", args = {"张飞", "那俺就替大哥先谢过了！"}},
                    {cmd = "Dialog", args = {"刘备", "喂，三弟………"}},
                    {cmd = "Dialog", args = {"刘备", "算了，我也不好拒绝。"}},
                    {cmd = "Dialog", args = {"刘备", "好吧，那就接受陶大人的一片好意了。"}},
                    {cmd = "Dialog", args = {"关羽", "嗯！陶谦大人，多谢盛情款待。"}},
                    {cmd = "Dialog", args = {"陶谦", "哪里的话。来，来！"}},
                    {cmd = "Dialog", args = {"陶谦", "请各位别客气。"}},
                },
                {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
                {cmd = "BattleOver"},
                {cmd = "VarSet", args = {"Var0", true}},
                {cmd = "VarSet", args = {"Var100", true}},
                {cmd = "VarSet", args = {"Var605", true}},
            },
            {
                {cmd = "Dialog", args = {"曹操", "（眼看着就快攻下徐州，说什么也不能放弃。）"}},
                {cmd = "Dialog", args = {"曹操", "没什么好说的！"}},
                {cmd = "Dialog", args = {"曹操", "想活命就闪开！"}},
                {cmd = "Dialog", args = {"刘备", "帮助眼前有难的人，向来是我刘备一贯的作风！"}},
                {cmd = "Dialog", args = {"刘备", "我绝不会退缩的！"}},
                {cmd = "FaceToFace", args = {"张飞", "曹操"}},
                {cmd = "GeneralAction", args = {"张飞", "prepareAttack"}},
                {cmd = "Dialog", args = {"张飞", "看来已经谈判破裂了！"}},
                {cmd = "Dialog", args = {"张飞", "好，开打吧！"}},
                {cmd = "GeneralAction", args = {"张飞", "stand"}},
            },
            {cmd = "VarSet", args = {"Var11", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 20, 14}},
        {cmd = "VarTest", args = {{falseConditions = {"Var20"}}}},
        {
            {cmd = "AddItem", args = {"膏药", 0}},
            {cmd = "VarSet", args = {"Var20", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 16, 10}},
        {cmd = "VarTest", args = {{falseConditions = {"Var21"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var21", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 8, 13}},
        {cmd = "VarTest", args = {{falseConditions = {"Var24"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var24", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 18, 3}},
        {cmd = "VarTest", args = {{falseConditions = {"Var25"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var25", true}},
        },
    },
    {
        {cmd = "EnterTileTest", args = {{"player", "friend"}, 17, 22}},
        {cmd = "VarTest", args = {{falseConditions = {"Var26"}}}},
        {
            {cmd = "AddItem", args = {"恢复用豆", 0}},
            {cmd = "VarSet", args = {"Var26", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 6, 1, 24, 24}},
        {cmd = "VarTest", args = {{falseConditions = {"Var30"}}}},
        {
            {cmd = "GeneralAiChange", args = {"步兵9", "被动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵10", "被动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵11", "被动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵5", "被动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var30", true}},
        },
    },
    {
        {cmd = "EnterRangeTest", args = {{"player", "friend"}, 16, 8, 22, 17}},
        {cmd = "SideTest", args = {"敌军阶段"}},
        {cmd = "VarTest", args = {{falseConditions = {"Var31"}}}},
        {
            {cmd = "GeneralAction", args = {"陶谦", "weak"}},
            {cmd = "Dialog", args = {"陶谦", "难道我大限已到……。"}},
            {cmd = "FaceToFace", args = {"糜竺", "陶谦"}},
            {cmd = "Dialog", args = {"糜竺", "主公…既然如此，只有发动全军与曹操一拼。"}},
            {cmd = "FaceToFace", args = {"糜竺", "曹操"}},
            {cmd = "GeneralAiChange", args = {"糜竺", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵2", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵3", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵4", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵5", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵6", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵7", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵8", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵12", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵13", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵14", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"步兵15", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵1", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵2", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵3", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵4", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵6", "主动出击", "无", 1, 1}},
            {cmd = "GeneralAiChange", args = {"弓兵7", "主动出击", "无", 1, 1}},
            {cmd = "VarSet", args = {"Var31", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "陶谦", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var40"}}}},
        {
            {cmd = "FaceToFace", args = {"曹操", "陶谦"}},
            {cmd = "FaceToFace", args = {"陶谦", "曹操"}},
            {cmd = "Dialog", args = {"曹操", "陶谦，你觉悟吧！"}},
            {cmd = "Dialog", args = {"陶谦", "看来现在说什么都没用了……。"}},
            {cmd = "VarSet", args = {"Var40", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "糜竺", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var41"}}}},
        {
            {cmd = "FaceToFace", args = {"糜竺", "曹操"}},
            {cmd = "FaceToFace", args = {"曹操", "糜竺"}},
            {cmd = "Dialog", args = {"糜竺", "曹嵩之死是我们的过失，如今我们也没什么好说的。"}},
            {cmd = "Dialog", args = {"糜竺", "不过如果曹操想吞并徐州，我糜竺一步也不会退让的。"}},
            {cmd = "Dialog", args = {"曹操", "为了对抗天下群雄，我当然需要力量！"}},
            {cmd = "Dialog", args = {"曹操", "因此这次你们自己播下的火种，只能说是你们的不幸！"}},
            {cmd = "Dialog", args = {"糜竺", "可恶，果然是冲着徐州而来的……。"}},
            {cmd = "VarSet", args = {"Var41", true}},
        },
    },
    {
        {cmd = "GeneralMeetTest", args = {"曹操", "刘备", false}},
        {cmd = "VarTest", args = {{falseConditions = {"Var42"}}}},
        {
            {cmd = "FaceToFace", args = {"刘备", "曹操"}},
            {cmd = "FaceToFace", args = {"曹操", "刘备"}},
            {cmd = "Dialog", args = {"刘备", "曹操！"}},
            {cmd = "Dialog", args = {"曹操", "刘备！"}},
            {cmd = "GeneralAction", args = {"刘备", "attack"}},
            {cmd = "GeneralAction", args = {"曹操", "attack"}},
            {cmd = "Dialog", args = {"曹操", "我们虽然有相同的志向，可是走的路"}},
            {cmd = "Dialog", args = {"曹操", "却不同…这真是让人感到不可思议，看来日后见面的日子还很长啊！"}},
            {cmd = "GeneralAction", args = {"刘备", "stand"}},
            {cmd = "GeneralAction", args = {"曹操", "stand"}},
            {cmd = "VarSet", args = {"Var42", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"陶谦", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var50"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"陶谦", "想要我的命，可以随时拿去。"}},
            {cmd = "Dialog", args = {"陶谦", "不过……徐州的百姓是没有罪的，你不可伤害他们。"}},
            {cmd = "AddItem", args = {"白银铠", 0}},
            {cmd = "FaceToFace", args = {"曹操", "陶谦"}},
            {cmd = "Dialog", args = {"曹操", "我没有打算屠杀徐州的百姓，你放心吧。"}},
            {cmd = "Dialog", args = {"程昱", "曹操主公，濮阳传来报告…"}},
            {cmd = "Dialog", args = {"程昱", "守军与吕布作战失败，濮阳陷落了……。"}},
            {cmd = "Dialog", args = {"曹操", "什么！可恨的吕布！"}},
            {cmd = "Dialog", args = {"曹操", "（没有时间平定徐州了，必须夺回濮阳。）"}},
            {cmd = "Dialog", args = {"曹操", "陶谦，先留着你的狗命吧。"}},
            {cmd = "GeneralChangeDirection", args = {"曹操", "left"}},
            {cmd = "GeneralAction", args = {"曹操", "prepareAttack"}},
            {cmd = "Dialog", args = {"曹操", "全军撤退！立即退兵！"}},
            {cmd = "Dialog", args = {"曹操", "我们要夺回濮阳。"}},
            {cmd = "GeneralAction", args = {"曹操", "stand"}},
            {cmd = "VarSet", args = {"Var50", true}},
            {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var101", true}},
            {cmd = "VarSet", args = {"Var605", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"糜竺", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var51"}}}},
        {
            {cmd = "Dialog", args = {"糜竺", "主，主公……我心有余而力不足，先行撤退了。"}},
            {cmd = "GeneralRetreat", args = {"糜竺", false}},
            {cmd = "VarSet", args = {"Var51", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"刘备", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var52"}}}},
        {
            {cmd = "Dialog", args = {"刘备", "虽然我有心想要制止这场暴行…"}},
            {cmd = "Dialog", args = {"刘备", "可惜心有余而力不足……"}},
            {cmd = "Dialog", args = {"刘备", "太遗憾了！"}},
            {cmd = "GeneralRetreat", args = {"刘备", false}},
            {cmd = "VarSet", args = {"Var52", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"张飞", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var53"}}}},
        {
            {cmd = "Dialog", args = {"张飞", "可恶，竟然败给这些家伙……！"}},
            {cmd = "Dialog", args = {"张飞", "唉、撤退、撤退！"}},
            {cmd = "GeneralRetreat", args = {"张飞", false}},
            {cmd = "VarSet", args = {"Var53", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"关羽", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var54"}}}},
        {
            {cmd = "Dialog", args = {"关羽", "唔唔，曹军越来越强大了。"}},
            {cmd = "Dialog", args = {"关羽", "撤退。"}},
            {cmd = "GeneralRetreat", args = {"关羽", false}},
            {cmd = "VarSet", args = {"Var54", true}},
        },
    },
    {
        {cmd = "GeneralPropTest", args = {"赵云", "HPCur", 0, "="}},
        {cmd = "VarTest", args = {{falseConditions = {"Var55"}}}},
        {
            {cmd = "Dialog", args = {"赵云", "嗯嗯嗯……。"}},
            {cmd = "Dialog", args = {"赵云", "太遗憾了，看来非撤不可。"}},
            {cmd = "GeneralRetreat", args = {"赵云", false}},
            {cmd = "VarSet", args = {"Var55", true}},
        },
    },
    {
        {cmd = "BattleWinTest"},
        {cmd = "VarTest", args = {{trueConditions = {"Var100", "Var101"}, falseConditions = {"Var0"}}}},
        {
            {cmd = "AllGeneralsRecover"},
            {cmd = "Dialog", args = {"曹操", "好极了！总算歼灭了敌人。"}},
            {cmd = "Dialog", args = {"曹操", "我军终于胜利了！"}},
            {cmd = "BattleExtraItems", args = {0, "", 0, "", 0, "", 0, false}},
            {cmd = "BattleOver"},
            {cmd = "VarSet", args = {"Var0", true}},
            {cmd = "VarSet", args = {"Var605", true}},
        },
    },
    {
        {cmd = "BattleLoseTest"},
        {cmd = "VarTest", args = {{falseConditions = {"Var1"}}}},
        {
            {cmd = "Tip", args = {"曹操败在陶谦军手下。"}},
            {cmd = "BattleOver"},
            {cmd = "BattleLose"},
            {cmd = "VarSet", args = {"Var1", true}},
        },
    },
}

return Plot