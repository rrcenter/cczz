--[[
    转换脚本R_TXT/r_plot28.txt
--]]

local Plot = {
    {
        {
            {
                {cmd = "PlayMusic", args = {"Track2"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"MMap-94"}},
                {cmd = "RolePlay", args = {"曹操", 55, 81, "up", "曹操", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 45, 65, "right", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"许褚", 45, 59, "right", "许褚", 0}},
                {cmd = "RolePlay", args = {"张合", 45, 53, "right", "张合", 0}},
                {cmd = "RolePlay", args = {"荀彧", 65, 65, "left", "荀彧", 0}},
                {cmd = "RolePlay", args = {"贾诩", 65, 59, "left", "贾诩", 0}},
                {cmd = "RolePlay", args = {"荀攸", 65, 53, "left", "荀攸", 0}},
                {cmd = "Tip", args = {"同意黄盖归顺的三日后，约定的日子终于到来了。"}},
                {cmd = "RShowSceneName", args = {"乌林  曹操军主营"}},
                {cmd = "RoleAction", args = {"曹操", 19}},
                {cmd = "Dialog", args = {"曹操", "今天是和黄盖约定的日子，等插着青龙旗的船只一到，我们就出发！"}},
                {cmd = "RoleChangeDirection", args = {"夏侯惇", "down", 0}},
                {cmd = "Dialog", args = {"夏侯惇", "孟德！"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "Dialog", args = {"曹操", "什么事，元让？"}},
                {cmd = "RoleAction", args = {"夏侯惇", 5}},
                {cmd = "Dialog", args = {"夏侯惇", "孟德，我刚才在外面巡视，发现风向变了。"}},
                {cmd = "RoleAction", args = {"夏侯惇", 0}},
                {cmd = "Dialog", args = {"夏侯惇", "原本的顺风现在变成了逆风，不知怎的，总有种不祥的预感。"}},
                {cmd = "Dialog", args = {"曹操", "元让，你平时不是这样的。不必在意风向了。"}},
                {cmd = "RoleAction", args = {"曹操", 19}},
                {cmd = "Dialog", args = {"曹操", "好！大家准备出发！"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "RoleChangeDirection", args = {"夏侯惇", "right", 0}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 15, 10, "张辽", "程昱", }},
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
            {cmd = "RolePressedTest", args = {"夏侯惇"}},
            {
                {cmd = "Dialog", args = {"夏侯惇", "孟德，我老是有种不祥的预感。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"荀彧"}},
            {
                {cmd = "Dialog", args = {"曹操", "文若，战场的地形如何？"}},
                {cmd = "Dialog", args = {"荀彧", "是。战场上几乎全是水域。"}},
                {cmd = "Dialog", args = {"曹操", "南船北马这句话，真是一点也不错。不过就算地形大幅改变成水域，整个局势还是对我军有利。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"许褚"}},
            {
                {cmd = "Dialog", args = {"许褚", "在水中作战？唉！"}},
                {cmd = "Dialog", args = {"夏侯惇", "许褚将军，怎么了？为什么叹气？"}},
                {cmd = "Dialog", args = {"许褚", "啊？没……没什么……！"}},
                {cmd = "Dialog", args = {"夏侯惇", "难道许褚将军不会游泳……"}},
                {cmd = "Dialog", args = {"许褚", "没……没那回事！！"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"张合"}},
            {
                {cmd = "Dialog", args = {"张合", "奇怪，风向为什么会改变？现在的季节应该刮西北风啊……"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"荀攸"}},
            {
                {cmd = "Dialog", args = {"荀攸", "对岸看不见刘备军的旗号，看来刘备和孔明打算隔岸观火。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"贾诩"}},
            {
                {cmd = "Dialog", args = {"贾诩", "我总觉得黄盖不是真心归降。"}},
                {cmd = "Dialog", args = {"曹操", "哈哈，文和啊。疑神疑鬼是打不了仗的。"}},
            },
        },
    },
}

return Plot
