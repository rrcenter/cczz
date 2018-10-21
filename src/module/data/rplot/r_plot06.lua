--[[
    转换脚本R_TXT/r_plot06.txt
--]]

local Plot = {
    {
        {
            {
                {cmd = "PlayMusic", args = {"Track18"}},
                {cmd = "Delay", args = {3}},
                {cmd = "ShowMenu", args = {false}},
                {cmd = "LoadBackground", args = {"china"}},
                {cmd = "HeadPortraitPlay", args = {"曹操", 483, 126, "曹操"}},
                {cmd = "HeadPortraitPlay", args = {"陶谦", 547, 126, "陶谦"}},
                {cmd = "SceneDialog", args = {"当曹操正与徐州的陶谦交战时，", "换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "HeadPortraitPlay", args = {"吕布", 370, 105, "吕布"}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"吕布趁曹军后方空虚，", "不换页", "换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "HeadPortraitMove", args = {"吕布", 409, 77}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"夺取了曹操的根据地濮阳。", "不换页", "不换行", "等待"}},
                {cmd = "SceneDialog", args = {"曹操于是撤回攻打徐州的部队，", "换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "HeadPortraitMove", args = {"曹操", 473, 77}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"回头展开濮阳争夺战。", "不换页", "不换行", "等待"}},
                {cmd = "PlayMusic", args = {"无"}},
                {cmd = "Delay", args = {3}},
                {cmd = "PlayMusic", args = {"Track17"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"MMap-62"}},
                {cmd = "RolePlay", args = {"曹操", 50, 68, "up", "曹操", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 39, 53, "right", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"典韦", 39, 47, "right", "典韦", 0}},
                {cmd = "RolePlay", args = {"荀彧", 61, 53, "left", "荀彧", 0}},
                {cmd = "RolePlay", args = {"郭嘉", 61, 47, "left", "郭嘉", 0}},
                {cmd = "RolePlay", args = {"程昱", 61, 41, "left", "程昱", 0}},
                {cmd = "RSetTitle", args = {"夺回濮阳！"}},
                {cmd = "RShowSceneName", args = {"濮阳郊外  曹操军主营"}},
                {cmd = "RoleAction", args = {"曹操", 4}},
                {cmd = "HeadChange", args = {2}},
                {cmd = "Dialog", args = {"曹操", "可恨的吕布！居然趁机进攻我的濮阳！"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"郭嘉", "down", 0}},
                {cmd = "Dialog", args = {"郭嘉", "不过实在令人难以相信……吕布竟然有如此智谋。"}},
                {cmd = "RoleChangeDirection", args = {"程昱", "down", 0}},
                {cmd = "Dialog", args = {"程昱", "这一定有人替他出主意。"}},
                {cmd = "RoleChangeDirection", args = {"荀彧", "down", 0}},
                {cmd = "Dialog", args = {"荀彧", "濮阳是我们的根据地，必须马上夺回。"}},
                {cmd = "RoleAction", args = {"曹操", 4}},
                {cmd = "Dialog", args = {"曹操", "这些我当然都知道！该死的吕布，我一定要打败你！"}},
                {cmd = "HeadChange", args = {0}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "PlayMusic", args = {"Track20"}},
                {cmd = "Delay", args = {3}},
                {cmd = "RolePlay", args = {"士兵01", 50, 17, "down", "士兵01", 0}},
                {cmd = "Dialog", args = {"士兵01", "报告。"}},
                {cmd = "RoleChangeDirection", args = {"郭嘉", "left", 0}},
                {cmd = "RoleChangeDirection", args = {"程昱", "left", 0}},
                {cmd = "RoleChangeDirection", args = {"荀彧", "left", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"士兵01", 13}},
                {cmd = "Dialog", args = {"士兵01", "主公，有个名叫于禁的壮士前来投奔。"}},
                {cmd = "Dialog", args = {"曹操", "于禁？没听说过这个人。"}},
                {cmd = "Dialog", args = {"士兵01", "看起来武艺相当不凡。"}},
                {cmd = "Dialog", args = {"曹操", "嗯……有意思，带他来见我。"}},
                {cmd = "Dialog", args = {"士兵01", "是。"}},
                {cmd = "RoleAction", args = {"士兵01", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleDisappear", args = {"士兵01"}},
                {cmd = "Delay", args = {5}},
                {cmd = "RolePlay", args = {"于禁", 50, 17, "down", "于禁", 0}},
                {cmd = "Dialog", args = {"于禁", "在下失礼了。"}},
                {cmd = "Delay", args = {5}},
                {cmd = "RoleMove", args = {"于禁", "down", 50, 53}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"于禁", 13}},
                {cmd = "Dialog", args = {"于禁", "初次拜见明公，在下姓于名禁，字文则。"}},
                {cmd = "Dialog", args = {"曹操", "嗯，听说你想为我效力。"}},
                {cmd = "Dialog", args = {"于禁", "是的，濮阳的百姓都期待您打败吕布，重返濮阳。"}},
                {cmd = "Dialog", args = {"于禁", "请让我帮助您打败吕布吧。"}},
                {cmd = "RoleAction", args = {"曹操", 5}},
                {cmd = "Dialog", args = {"曹操", "嗯……好吧。希望你能好好表现。"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "Dialog", args = {"于禁", "多谢主公。"}},
                {cmd = "RoleAddOrLevel", args = {"于禁", "add", 0}},
                {cmd = "PlayMusic", args = {"Track17"}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"于禁", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleMove", args = {"于禁", "up", 50, 41}},
                {cmd = "Delay", args = {1}},
                {cmd = "RoleMove", args = {"于禁", "right", 39, 41}},
                {cmd = "RoleAction", args = {"于禁", 0}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 10, 6, "典韦", "于禁", }},
            },
        },
    },
    {
        {
            {cmd = "FightButtonPressedTest"},
            {
                {cmd = "ShowMenu", args = {false}},
                {cmd = "Dialog", args = {"曹操", "出兵。"}},
                {cmd = "PlayMusic", args = {"无"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"夏侯惇"}},
            {
                {cmd = "Dialog", args = {"夏侯惇", "吕布这厮真不是个东西。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"郭嘉"}},
            {
                {cmd = "Dialog", args = {"郭嘉", "打仗不光是一味进攻，有时候以退为进也很重要。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"程昱"}},
            {
                {cmd = "Dialog", args = {"程昱", "和一般武器三段进化的方式不同的，特殊装备分成九个阶段。"}},
                {cmd = "Dialog", args = {"程昱", "从陶谦那里得到的白银铠就是这一类。"}},
                {cmd = "Dialog", args = {"曹操", "而且它还有特殊的能力。"}},
                {cmd = "Dialog", args = {"程昱", "是的。不过也正因为如此，所以一般能力略为低了一点。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"于禁"}},
            {
                {cmd = "Dialog", args = {"于禁", "远距离攻击的任务请交给我，我对消灭骑兵尤为拿手。不过论机动力，骑兵倒是更强一些。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"典韦"}},
            {
                {cmd = "Dialog", args = {"典韦", "听说于禁是弓兵！攻击力不就跟弓骑兵一样？"}},
                {cmd = "Dialog", args = {"荀彧", "哈哈哈，典韦将军，弓兵的射程较广，容易射出致命一击。"}},
                {cmd = "Dialog", args = {"典韦", "是吗？我倒不怎么清楚……。反正这回就看他的了，哈哈哈哈！！"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"荀彧"}},
            {
                {cmd = "Dialog", args = {"曹操", "文若，主战场的情况如何？"}},
                {cmd = "Dialog", args = {"荀彧", "主战场在濮阳城西北，有北、西两座城门。"}},
                {cmd = "Dialog", args = {"荀彧", "濮阳是适合防守的艰城，所以这将是一场苦战。"}},
                {cmd = "Dialog", args = {"曹操", "嗯嗯……可恨的吕布！"}},
            },
        },
    },
}

return Plot
