--[[
    转换脚本R_TXT/r_plot37.txt
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
                {cmd = "RolePlay", args = {"夏侯惇", 45, 65, "right", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"许褚", 45, 59, "right", "许褚", 0}},
                {cmd = "RolePlay", args = {"徐晃", 45, 53, "right", "徐晃", 0}},
                {cmd = "RolePlay", args = {"荀彧", 65, 65, "left", "荀彧", 0}},
                {cmd = "RolePlay", args = {"司马懿", 65, 59, "left", "司马懿", 0}},
                {cmd = "RolePlay", args = {"程昱", 65, 53, "left", "程昱", 0}},
                {cmd = "RSetTitle", args = {"守卫粮仓"}},
                {cmd = "RShowSceneName", args = {"汉水附近  曹操军主营"}},
                {cmd = "Dialog", args = {"曹操", "想不到孔明的目标是斜谷粮仓，真是太大意了。"}},
                {cmd = "RoleChangeDirection", args = {"司马懿", "down", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"司马懿", 8}},
                {cmd = "Dialog", args = {"司马懿", "此人用兵神出鬼没……将是最令我军畏惧的人物。"}},
                {cmd = "RoleAction", args = {"司马懿", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"荀彧", "down", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"荀彧", 8}},
                {cmd = "Dialog", args = {"荀彧", "如果粮仓被夺，我军将进退不得。"}},
                {cmd = "RoleAction", args = {"荀彧", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"曹操", 19}},
                {cmd = "Dialog", args = {"曹操", "嗯，绝不能让蜀军夺走粮仓，马上赶往斜谷！"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "RoleChangeDirection", args = {"荀彧", "left", 0}},
                {cmd = "RoleChangeDirection", args = {"司马懿", "left", 0}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 8, 5}},
            },
        },
    },
    {
        {
            {cmd = "FightButtonPressedTest"},
            {
                {cmd = "ShowMenu", args = {false}},
                {cmd = "Dialog", args = {"曹操", "出发！"}},
                {cmd = "PlayMusic", args = {"无"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"徐晃"}},
            {
                {cmd = "Dialog", args = {"徐晃", "袭击粮仓的好像是马超的部队。"}},
                {cmd = "Dialog", args = {"曹操", "马超是吗？我见他不在汉水，当时就觉得有点奇怪，想不到是去斜谷了。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"荀彧"}},
            {
                {cmd = "Dialog", args = {"荀彧", "斜谷正如其名，夹于两山之间。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"司马懿"}},
            {
                {cmd = "Dialog", args = {"司马懿", "如果只有马超部队还不足挂齿，只怕刘备也亲率主力前往斜谷了。"}},
                {cmd = "Dialog", args = {"司马懿", "只是不知刘备主力何时抵达……不论如何……这将是一场苦战。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"程昱"}},
            {
                {cmd = "Dialog", args = {"程昱", "五虎将之一的马超？"}},
                {cmd = "Dialog", args = {"许褚", "啊，什么啊？什么是五虎将？"}},
                {cmd = "Dialog", args = {"荀彧", "嗯……关羽、张飞、赵云、黄忠、马超，这五员大将在蜀国被称为五虎将。"}},
                {cmd = "Dialog", args = {"程昱", "正是。"}},
                {cmd = "Dialog", args = {"许褚", "哦……？"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"许褚"}},
            {
                {cmd = "Dialog", args = {"许褚", "咱们一定得守住粮仓才行！粮草可比什么都来得重要。"}},
                {cmd = "Dialog", args = {"夏侯惇", "许褚，这话挺像你风格的嘛。"}},
                {cmd = "Dialog", args = {"许褚", "……没办法，我饭量大嘛。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"夏侯惇"}},
            {
                {cmd = "Dialog", args = {"夏侯惇", "孟德，咱们得快点行动，如果粮仓被蜀军夺走，最后只有放弃汉中了。"}},
                {cmd = "Dialog", args = {"曹操", "嗯。"}},
            },
        },
    },
}

return Plot
