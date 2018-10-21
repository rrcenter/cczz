--[[
    转换脚本R_TXT/r_plot57.txt
--]]

local Plot = {
    {
        {
            {
                {cmd = "ShowMenu", args = {false}},
                {cmd = "PlayMusic", args = {"Track2"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"MMap-94"}},
                {cmd = "RolePlay", args = {"曹操", 55, 81, "up", "曹操", 0}},
                {cmd = "RolePlay", args = {"荀彧", 65, 65, "left", "荀彧", 0}},
                {cmd = "RolePlay", args = {"司马懿", 65, 59, "left", "司马懿", 0}},
                {cmd = "RolePlay", args = {"贾诩", 65, 53, "left", "贾诩", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 45, 65, "right", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"关羽", 45, 59, "right", "关羽", 0}},
                {cmd = "RolePlay", args = {"貂蝉", 45, 53, "right", "貂蝉", 0}},
                {cmd = "RSetTitle", args = {"最后决战"}},
                {cmd = "RShowSceneName", args = {"五丈原  曹操军主营"}},
                {cmd = "Delay", args = {3}},
                {cmd = "RolePlay", args = {"徐庶", 55, 23, "down", "徐庶", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "Dialog", args = {"徐庶", "……丞相。"}},
                {cmd = "RoleAction", args = {"曹操", 5}},
                {cmd = "Dialog", args = {"曹操", "哦，徐庶，你可来了！"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "RoleMove", args = {"徐庶", "down", 55, 65}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"徐庶", 8}},
                {cmd = "Dialog", args = {"徐庶", "元直发现了通往地下的密道，请即刻派兵追击孔明。"}},
                {cmd = "RoleAction", args = {"曹操", 5}},
                {cmd = "Dialog", args = {"曹操", "是吗！曹某在此谢过。这次真多亏元直鼎力相助。"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "Dialog", args = {"徐庶", "元直惶恐……"}},
                {cmd = "RoleAction", args = {"徐庶", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"曹操", 19}},
                {cmd = "Dialog", args = {"曹操", "好。马上追击孔明。这是最后的决战，大家要小心！"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"徐庶", 8}},
                {cmd = "Dialog", args = {"徐庶", "丞相，元直告辞了……"}},
                {cmd = "Dialog", args = {"曹操", "嗯。这次多亏你了。"}},
                {cmd = "Dialog", args = {"徐庶", "岂敢，祝丞相马到成功。"}},
                {cmd = "RoleAction", args = {"徐庶", 0}},
                {cmd = "Dialog", args = {"徐庶", "（吾友孔明……如今的我正盼望着你死去。你会恨我吗……？）"}},
                {cmd = "Delay", args = {5}},
                {cmd = "RoleChangeDirection", args = {"徐庶", "right", 0}},
                {cmd = "Dialog", args = {"徐庶", "（不……你应该不会怪我的。如果你真的还是你的话，一定会同意我所做的一切。）"}},
                {cmd = "Delay", args = {5}},
                {cmd = "RoleChangeDirection", args = {"徐庶", "up", 0}},
                {cmd = "Dialog", args = {"徐庶", "（吾友孔明……我将诚心地向上苍祈祷，只求你能够平静地安息。）"}},
                {cmd = "RoleMove", args = {"徐庶", "up", 55, 23}},
                {cmd = "RoleDisappear", args = {"徐庶"}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 15, 10}},
            },
        },
    },
    {
        {
            {cmd = "FightButtonPressedTest"},
            {
                {cmd = "Dialog", args = {"曹操", "出发！"}},
                {cmd = "ShowMenu", args = {false}},
                {cmd = "PlayMusic", args = {"无"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"荀彧"}},
            {
                {cmd = "Dialog", args = {"荀彧", "我军对地下战场的情况一无所知，只要小心谨慎，定能取得胜利。"}},
                {cmd = "Dialog", args = {"曹操", "嗯。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"司马懿"}},
            {
                {cmd = "Dialog", args = {"司马懿", "孔明……我真不想在这种情形下与你作战。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"贾诩"}},
            {
                {cmd = "Dialog", args = {"贾诩", "为何孔明将祭坛建于地下呢？难道……"}},
                {cmd = "Dialog", args = {"曹操", "……地下就是不见天日的地方，或许正是最适合死者出没之地。"}},
                {cmd = "Dialog", args = {"贾诩", "看来主公得多加留意才是。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"夏侯惇"}},
            {
                {cmd = "Dialog", args = {"夏侯惇", "什么都甭说了。胜利一定是属于咱们的。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"关羽"}},
            {
                {cmd = "Dialog", args = {"关羽", "只要赢了这场战事，就能够看到兄长托付关某的未来。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"貂蝉"}},
            {
                {cmd = "Dialog", args = {"貂蝉", "（父亲、母亲，请您拭目以待，这将是最后一战了。奉先……请赐给我力量吧……）"}},
                {cmd = "Dialog", args = {"曹操", "怎么了？貂蝉。"}},
                {cmd = "Dialog", args = {"貂蝉", "啊？没，没什么。丞相，请下令吧。"}},
            },
        },
    },
}

return Plot
