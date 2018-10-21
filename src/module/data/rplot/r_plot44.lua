--[[
    转换脚本R_TXT/r_plot44.txt
--]]

local Plot = {
    {
        {
            {
                {cmd = "PlayMusic", args = {"Track18"}},
                {cmd = "Delay", args = {3}},
                {cmd = "ShowMenu", args = {false}},
                {cmd = "HeadChange", args = {11}},
                {cmd = "LoadBackground", args = {"china"}},
                {cmd = "HeadPortraitPlay", args = {"曹操", 282, 234, "曹操"}},
                {cmd = "HeadPortraitPlay", args = {"孙权", 346, 234, "孙权"}},
                {cmd = "SceneDialog", args = {"在赤壁战败的东吴军", "换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "HeadPortraitMove", args = {"孙权", 443, 220}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"撤退到建业。", "不换页", "不换行", "等待"}},
                {cmd = "PlayMusic", args = {"Track17"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"MMap-94"}},
                {cmd = "RolePlay", args = {"曹操", 55, 81, "up", "曹操", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 45, 65, "right", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"许褚", 45, 59, "right", "许褚", 0}},
                {cmd = "RolePlay", args = {"张合", 45, 53, "right", "张合", 0}},
                {cmd = "RolePlay", args = {"荀彧", 65, 65, "left", "荀彧", 0}},
                {cmd = "RolePlay", args = {"司马懿", 65, 59, "left", "司马懿", 0}},
                {cmd = "RolePlay", args = {"贾诩", 65, 53, "left", "贾诩", 0}},
                {cmd = "RSetTitle", args = {"最后的水战"}},
                {cmd = "RShowSceneName", args = {"赤壁  曹操军主营"}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"司马懿", "down", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"司马懿", 8}},
                {cmd = "Dialog", args = {"司马懿", "孙权和孔明好像一起撤往建业了。"}},
                {cmd = "RoleAction", args = {"司马懿", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"夏侯惇", "down", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"夏侯惇", 5}},
                {cmd = "Dialog", args = {"夏侯惇", "孟德，终于要攻打建业了！如果打赢这一仗，就可以统一天下了！"}},
                {cmd = "RoleAction", args = {"荀彧", 8}},
                {cmd = "Dialog", args = {"荀彧", "不，夏侯惇将军。很遗憾的，挥兵建业之前还得打一仗。"}},
                {cmd = "RoleAction", args = {"荀彧", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"夏侯惇", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"夏侯惇", "right", 0}},
                {cmd = "Dialog", args = {"夏侯惇", "还得打一仗？什么意思？"}},
                {cmd = "RoleAction", args = {"贾诩", 8}},
                {cmd = "Dialog", args = {"贾诩", "位于建业前哨的濡须口，必然会设下重兵严防的。"}},
                {cmd = "RoleAction", args = {"贾诩", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"夏侯惇", 5}},
                {cmd = "Dialog", args = {"夏侯惇", "濡须口？又要水战了吗！？"}},
                {cmd = "RoleAction", args = {"夏侯惇", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"曹操", "right", 0}},
                {cmd = "Dialog", args = {"曹操", "嗯，正所谓「南船北马」。敌人当然很清楚这一点。"}},
                {cmd = "RoleChangeDirection", args = {"曹操", "up", 0}},
                {cmd = "Dialog", args = {"曹操", "好，不管敌人的防守多么坚强，我们也无后路可退。"}},
                {cmd = "RoleAction", args = {"曹操", 19}},
                {cmd = "Dialog", args = {"曹操", "攻下濡须口，建业就没有屏障了。不能犹豫了！准备出战！"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "RoleChangeDirection", args = {"司马懿", "left", 0}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 12, 9}},
            },
        },
    },
    {
        {
            {cmd = "FightButtonPressedTest"},
            {
                {cmd = "ShowMenu", args = {false}},
                {cmd = "Dialog", args = {"曹操", "出兵！"}},
                {cmd = "PlayMusic", args = {"无"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"夏侯惇"}},
            {
                {cmd = "Dialog", args = {"夏侯惇", "既然已经追到这里，当然绝不能输。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"荀彧"}},
            {
                {cmd = "Dialog", args = {"荀彧", "战场和以前比没有什么太大的变化。"}},
                {cmd = "Dialog", args = {"荀彧", "还是隔江对峙。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"司马懿"}},
            {
                {cmd = "Dialog", args = {"司马懿", "我军于赤壁获得玄武宝玉，这么一来宝玉就收集齐全了。"}},
                {cmd = "Dialog", args = {"夏侯惇", "这玄武宝玉有什么效果？"}},
                {cmd = "Dialog", args = {"司马懿", "这是道士类的部队使用的宝玉。"}},
                {cmd = "Dialog", args = {"司马懿", "它可以改变敌我双方所有部队的状态。"}},
                {cmd = "Dialog", args = {"许褚", "改变状态？那是什么意思？"}},
                {cmd = "Dialog", args = {"贾诩", "可使敌人中毒或降低各种能力，反之有时也会提高。"}},
                {cmd = "Dialog", args = {"夏侯惇", "也会提高……？这么说来，有时候也会帮助敌人喽？"}},
                {cmd = "Dialog", args = {"贾诩", "是的。这个策略最难的地方，就在如何掌握使用时机。"}},
                {cmd = "Dialog", args = {"夏侯惇", "这太难了吧！"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"张合"}},
            {
                {cmd = "Dialog", args = {"张合", "主公，请您务必使用看看。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"许褚"}},
            {
                {cmd = "Dialog", args = {"许褚", "结果到头来没有我可以使用的宝玉，我明明会使用地类策略的不是吗……？为什么会这样呢！"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"贾诩"}},
            {
                {cmd = "Dialog", args = {"贾诩", "攻下濡须口就只剩下建业了，这场战事东吴一定也会全力死战的。"}},
            },
        },
    },
}

return Plot
