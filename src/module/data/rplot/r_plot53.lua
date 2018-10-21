--[[
    转换脚本R_TXT/r_plot53.txt
--]]

local Plot = {
    {
        {
            {
                {cmd = "ShowMenu", args = {false}},
                {cmd = "PlayMusic", args = {"Track17"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"MMap-94"}},
                {cmd = "RolePlay", args = {"曹操", 55, 81, "up", "曹操", 0}},
                {cmd = "RolePlay", args = {"荀彧", 65, 65, "left", "荀彧", 0}},
                {cmd = "RolePlay", args = {"司马懿", 65, 59, "left", "司马懿", 0}},
                {cmd = "RolePlay", args = {"贾诩", 65, 53, "left", "贾诩", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 45, 65, "right", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"关羽", 45, 59, "right", "关羽", 0}},
                {cmd = "RolePlay", args = {"貂蝉", 45, 53, "right", "貂蝉", 0}},
                {cmd = "RSetTitle", args = {"白色祭坛"}},
                {cmd = "RShowSceneName", args = {"鱼腹浦  曹操军主营"}},
                {cmd = "HeadChange", args = {1}},
                {cmd = "Dialog", args = {"曹操", "想不到魔王竟然如此法力无边。我们进军的速度已被延误多时。"}},
                {cmd = "HeadChange", args = {0}},
                {cmd = "RoleChangeDirection", args = {"司马懿", "down", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"司马懿", 8}},
                {cmd = "Dialog", args = {"司马懿", "抵达白帝城的时间，似乎比预计要晚很多。"}},
                {cmd = "RoleAction", args = {"司马懿", 0}},
                {cmd = "Dialog", args = {"曹操", "不过孔明在路上设下机关层层阻挠，无非是不让我们接近白帝城，看来白帝城内必有蹊跷。"}},
                {cmd = "RoleAction", args = {"曹操", 19}},
                {cmd = "Dialog", args = {"曹操", "好，一鼓作气进攻白帝城！"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "RoleChangeDirection", args = {"司马懿", "left", 0}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 10, 6}},
            },
        },
    },
    {
        {
            {cmd = "FightButtonPressedTest"},
            {
                {cmd = "ShowMenu", args = {false}},
                {cmd = "Dialog", args = {"曹操", "出发。"}},
                {cmd = "PlayMusic", args = {"无"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"荀彧"}},
            {
                {cmd = "Dialog", args = {"荀彧", "以前曾经禀报过主公，白帝城内外是三道城墙的结构，构筑得非常坚固。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"司马懿"}},
            {
                {cmd = "Dialog", args = {"司马懿", "孔明为何不让我们接近呢……主公，属下只想到唯一的可能性……"}},
                {cmd = "Dialog", args = {"曹操", "……第二个祭坛！"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"关羽"}},
            {
                {cmd = "Dialog", args = {"关羽", "兄长……云长又回到白帝城了。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"貂蝉"}},
            {
                {cmd = "Dialog", args = {"貂蝉", "我们在鱼腹浦得到了青龙宝玉，不过它有什么功用呢？"}},
                {cmd = "Dialog", args = {"荀彧", "貂蝉，这块宝玉正如其名，蕴含着四神之一的青龙力量。"}},
                {cmd = "Dialog", args = {"荀彧", "据传青龙的力量就是雷电。"}},
                {cmd = "Dialog", args = {"貂蝉", "不愧是荀彧先生，真是见识广博。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"贾诩"}},
            {
                {cmd = "Dialog", args = {"贾诩", "能够装备青龙宝玉的部队，似乎只有骑马策士类的司马懿先生了。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"夏侯惇"}},
            {
                {cmd = "Dialog", args = {"夏侯惇", "蜀将知道孔明被魔王附体的事吗？"}},
                {cmd = "Dialog", args = {"曹操", "恐怕尚不知情，到现在还被孔明蒙在鼓里吧！"}},
                {cmd = "Dialog", args = {"关羽", "……………"}},
            },
        },
    },
}

return Plot
