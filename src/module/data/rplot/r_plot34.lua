--[[
    转换脚本R_TXT/r_plot34.txt
--]]

local Plot = {
    {
        {
            {
                {cmd = "ShowMenu", args = {false}},
                {cmd = "LoadBackground", args = {"MMap-94"}},
                {cmd = "RolePlay", args = {"张辽", 55, 81, "up", "张辽", 0}},
                {cmd = "RolePlay", args = {"乐进", 45, 65, "right", "乐进", 0}},
                {cmd = "RolePlay", args = {"李典", 65, 65, "left", "李典", 0}},
                {cmd = "PlaySound", args = {"Se_e_00.wav", 0}},
                {cmd = "Delay", args = {3}},
                {
                    {cmd = "VarTest", args = {{trueConditions = {"Var311"}}}},
                    {cmd = "RSetTitle", args = {"信义"}},
                },
                {
                    {cmd = "VarTest", args = {{falseConditions = {"Var311"}}}},
                    {cmd = "RSetTitle", args = {"程昱的自白"}},
                },
                {cmd = "RShowSceneName", args = {"合淝  曹操军主营"}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"李典", "down", 0}},
                {cmd = "Dialog", args = {"李典", "东吴有一个多月没动静了，大概已经放弃合淝了吧？"}},
                {cmd = "Dialog", args = {"张辽", "不，孙权不会就这么回去的。"}},
                {cmd = "Dialog", args = {"张辽", "对了，主公还在汉中吗？"}},
                {cmd = "RoleChangeDirection", args = {"乐进", "down", 0}},
                {cmd = "Dialog", args = {"乐进", "不会吧，应该正在返回许都。"}},
                {cmd = "Dialog", args = {"张辽", "好，立刻向主公求援吧，东吴的动向实在难以预测。"}},
                {cmd = "RoleChangeDirection", args = {"张辽", "right", 0}},
                {cmd = "Dialog", args = {"张辽", "孙权这家伙也许在集结兵力，准备决一死战。"}},
                {cmd = "Dialog", args = {"乐进", "那么我亲自去一趟许都，到时候一定搬来援军。"}},
                {cmd = "RoleChangeDirection", args = {"张辽", "up", 0}},
                {cmd = "Dialog", args = {"张辽", "嗯，拜托将军了。"}},
                {cmd = "PlaySound", args = {"Se_e_00.wav", 255}},
            },
        },
    },
    {
        {
            {
                {cmd = "LoadBackground", args = {"MMap-49"}},
                {cmd = "RolePlay", args = {"曹操", 35, 56, "right", "曹操", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 53, 71, "up", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"曹丕", 59, 71, "up", "曹丕", 0}},
                {cmd = "RolePlay", args = {"许褚", 65, 71, "up", "许褚", 0}},
                {cmd = "RolePlay", args = {"庞德", 71, 71, "up", "庞德", 0}},
                {cmd = "RolePlay", args = {"荀彧", 53, 41, "down", "荀彧", 0}},
                {cmd = "RolePlay", args = {"司马懿", 59, 41, "down", "司马懿", 0}},
                {cmd = "RolePlay", args = {"荀攸", 65, 41, "down", "荀攸", 0}},
                {cmd = "RolePlay", args = {"程昱", 71, 41, "down", "程昱", 0}},
                {cmd = "RolePlay", args = {"乐进", 49, 56, "left", "乐进", 8}},
                {cmd = "PlaySound", args = {"Se_e_00.wav", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RShowSceneName", args = {"许都  相府"}},
                {cmd = "Dialog", args = {"曹操", "是吗？东吴军有一个月没有进兵啦？"}},
                {cmd = "Dialog", args = {"乐进", "是的。虽然我军曾经派人潜入探听，还是无法掌握东吴的动向。"}},
                {cmd = "Dialog", args = {"乐进", "也许他们正在集结兵力，随时准备大战一场，所以我来请求主公增援。"}},
                {cmd = "Dialog", args = {"曹操", "好吧，我亲自率军去合淝。"}},
                {cmd = "Dialog", args = {"乐进", "是，谢主公。"}},
                {cmd = "PlaySound", args = {"Se_e_00.wav", 255}},
            },
        },
    },
    {
        {
            {
                {cmd = "PlayMusic", args = {"Track18"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"china"}},
                {cmd = "HeadPortraitPlay", args = {"张辽", 408, 168, "张辽"}},
                {cmd = "HeadPortraitPlay", args = {"孙权", 472, 188, "孙权"}},
                {cmd = "HeadPortraitPlay", args = {"曹操", 332, 88, "曹操"}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"曹操率领援军", "换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "HeadPortraitMove", args = {"曹操", 472, 88}},
                {cmd = "HeadPortraitMove", args = {"曹操", 472, 108}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"亲往合淝督阵。", "不换页", "不换行", "等待"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"MMap-94"}},
                {
                    {cmd = "VarTest", args = {{falseConditions = {"Var311"}}}},
                    {cmd = "PlayMusic", args = {"Track21"}},
                    {cmd = "Delay", args = {3}},
                    {cmd = "RolePlay", args = {"庞德", 45, 53, "right", "庞德", 0}},
                    {cmd = "RShowSceneName", args = {"合淝  曹操军主营"}},
                    {cmd = "RolePlay", args = {"程昱", 55, 23, "down", "程昱", 0}},
                    {cmd = "Dialog", args = {"程昱", "庞德将军，就你一个人吗？"}},
                    {cmd = "RoleMove", args = {"程昱", "down", 55, 53}},
                    {cmd = "Delay", args = {3}},
                    {cmd = "RoleChangeDirection", args = {"程昱", "left", 0}},
                    {cmd = "Dialog", args = {"程昱", "我正好有话对庞德将军说。"}},
                    {cmd = "Dialog", args = {"庞德", "什么事？"}},
                    {cmd = "Dialog", args = {"程昱", "是关于马腾的事……杀死马腾的是我。"}},
                    {cmd = "Dialog", args = {"庞德", "……！？"}},
                    {cmd = "RoleChangeDirection", args = {"程昱", "down", 0}},
                    {cmd = "Dialog", args = {"程昱", "当时马腾想谋害主公，主公却并无害他之心。"}},
                    {cmd = "RoleChangeDirection", args = {"程昱", "left", 0}},
                    {cmd = "Dialog", args = {"程昱", "杀害马腾的是我的主意，一切责任都在我。"}},
                    {cmd = "Dialog", args = {"庞德", "为什么要杀死马腾？"}},
                    {cmd = "Dialog", args = {"程昱", "我是主公的军师，军师的任务就是要………杜绝一切危及主公安全的因素。"}},
                    {cmd = "RoleChangeDirection", args = {"程昱", "down", 0}},
                    {cmd = "Dialog", args = {"程昱", "马腾参与谋害主公之事，我当然不能让他活在世上，想必你应该也了解这点道理吧。"}},
                    {cmd = "Dialog", args = {"庞德", "打了这么多年的仗，这点道理我还明白。"}},
                    {cmd = "RoleChangeDirection", args = {"庞德", "left", 0}},
                    {cmd = "Dialog", args = {"庞德", "原来曹大人不提马腾主公之死，是为了独自承担这个罪名？"}},
                    {cmd = "Dialog", args = {"庞德", "为了成为一个求存于乱世的霸主，只好采取这种不拘私怨的上策。"}},
                    {cmd = "Dialog", args = {"庞德", "这种不论善恶都一肩承担的做法，原来才是曹操大人真正的为人？"}},
                    {cmd = "Dialog", args = {"庞德", "毫无戒心地接受我庞德，也是信任部下的明证吧？"}},
                    {cmd = "Dialog", args = {"庞德", "既然如此，今后我也要好好做，为曹丞相尽犬马之劳！"}},
                    {cmd = "RoleChangeDirection", args = {"程昱", "left", 0}},
                    {cmd = "Dialog", args = {"程昱", "庞德将军……"}},
                    {cmd = "Delay", args = {10}},
                    {cmd = "PlayMusic", args = {"无"}},
                    {cmd = "RoleChangeDirection", args = {"程昱", "up", 0}},
                    {cmd = "Dialog", args = {"程昱", "哦？大家好像都来了。"}},
                    {cmd = "PlayMusic", args = {"Track17"}},
                    {cmd = "Delay", args = {3}},
                    {cmd = "RoleMove", args = {"程昱", "left", 65, 53}},
                    {cmd = "RoleChangeDirection", args = {"庞德", "right", 0}},
                    {cmd = "RolePlay", args = {"曹操", 55, 23, "down", "曹操", 0}},
                    {cmd = "RoleMove", args = {"曹操", "down", 55, 29}},
                    {cmd = "RolePlay", args = {"夏侯惇", 55, 23, "down", "夏侯惇", 0}},
                    {cmd = "RoleMove", args = {"曹操", "down", 55, 35}},
                    {cmd = "RoleMove", args = {"夏侯惇", "down", 55, 29}},
                    {cmd = "RolePlay", args = {"许褚", 55, 23, "down", "许褚", 0}},
                    {cmd = "RoleMove", args = {"曹操", "down", 55, 41}},
                    {cmd = "RoleMove", args = {"夏侯惇", "down", 55, 35}},
                    {cmd = "RoleMove", args = {"许褚", "down", 55, 29}},
                    {cmd = "RolePlay", args = {"荀彧", 55, 23, "down", "荀彧", 0}},
                    {cmd = "RoleMove", args = {"曹操", "down", 55, 47}},
                    {cmd = "RoleMove", args = {"夏侯惇", "down", 55, 41}},
                    {cmd = "RoleMove", args = {"许褚", "down", 55, 35}},
                    {cmd = "RoleMove", args = {"荀彧", "down", 55, 29}},
                    {cmd = "RolePlay", args = {"司马懿", 55, 23, "down", "司马懿", 0}},
                    {cmd = "RoleMove", args = {"曹操", "down", 55, 53}},
                    {cmd = "RoleMove", args = {"夏侯惇", "down", 55, 47}},
                    {cmd = "RoleMove", args = {"许褚", "down", 55, 41}},
                    {cmd = "RoleMove", args = {"荀彧", "down", 55, 35}},
                    {cmd = "RoleMove", args = {"司马懿", "down", 55, 29}},
                    {cmd = "Delay", args = {0}},
                    {cmd = "RoleMove", args = {"曹操", "up", 55, 81}},
                    {cmd = "RoleMove", args = {"夏侯惇", "right", 45, 65}},
                    {cmd = "RoleMove", args = {"许褚", "right", 45, 59}},
                    {cmd = "RoleMove", args = {"荀彧", "left", 65, 65}},
                    {cmd = "RoleMove", args = {"司马懿", "left", 65, 59}},
                    {cmd = "Delay", args = {10}},
                },
                {
                    {cmd = "VarTest", args = {{trueConditions = {"Var311"}}}},
                    {cmd = "RolePlay", args = {"曹操", 55, 81, "up", "曹操", 0}},
                    {cmd = "RolePlay", args = {"夏侯惇", 45, 65, "right", "夏侯惇", 0}},
                    {cmd = "RolePlay", args = {"许褚", 45, 59, "right", "许褚", 0}},
                    {cmd = "RolePlay", args = {"庞德", 45, 53, "right", "庞德", 0}},
                    {cmd = "RolePlay", args = {"荀彧", 65, 65, "left", "荀彧", 0}},
                    {cmd = "RolePlay", args = {"司马懿", 65, 59, "left", "司马懿", 0}},
                    {cmd = "RolePlay", args = {"程昱", 65, 53, "left", "程昱", 0}},
                    {cmd = "RShowSceneName", args = {"合淝  曹操军主营"}},
                },
                {cmd = "PlayMusic", args = {"Track17"}},
                {cmd = "Delay", args = {3}},
                {cmd = "RolePlay", args = {"士兵01", 55, 23, "down", "士兵01", 0}},
                {cmd = "Dialog", args = {"士兵01", "报！"}},
                {cmd = "RoleAction", args = {"士兵01", 13}},
                {cmd = "Dialog", args = {"士兵01", "主公，探听到东吴军的动向了。东吴军在濡须口对岸集结了重兵。"}},
                {cmd = "Dialog", args = {"曹操", "濡须口……？孙权这个小娃儿，必然想凭借他们擅长的水战一决胜负。"}},
                {cmd = "Dialog", args = {"曹操", "嗯，辛苦了。下去休息吧。"}},
                {cmd = "Dialog", args = {"士兵01", "是。"}},
                {cmd = "RoleAction", args = {"士兵01", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleDisappear", args = {"士兵01"}},
                {cmd = "Dialog", args = {"曹操", "正如大家刚才所听到的，时间拖得越久，东吴兵力将会与日俱增。"}},
                {cmd = "RoleChangeDirection", args = {"荀彧", "down", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"荀彧", 8}},
                {cmd = "Dialog", args = {"荀彧", "我们还是尽早发动攻势吧。"}},
                {cmd = "RoleAction", args = {"荀彧", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"司马懿", "down", 0}},
                {cmd = "Dialog", args = {"司马懿", "可是，直接进攻太危险了。"}},
                {cmd = "RoleAction", args = {"司马懿", 0}},
                {cmd = "Dialog", args = {"曹操", "嗯，庞德。"}},
                {cmd = "RoleChangeDirection", args = {"庞德", "down", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"庞德", 8}},
                {cmd = "Dialog", args = {"庞德", "在……"}},
                {cmd = "Dialog", args = {"曹操", "命你为分遣部队出战，孙权被我率领的主力牵制时，再趁机突击他的部队。"}},
                {
                    {cmd = "VarTest", args = {{trueConditions = {"Var311"}}}},
                    {cmd = "Dialog", args = {"庞德", "让在下担任分遣部队！？"}},
                    {cmd = "Dialog", args = {"曹操", "嗯，没错。这一仗看你的了。"}},
                    {cmd = "Dialog", args = {"庞德", "为什么派在下出战？不怕在下倒戈吗？"}},
                    {cmd = "Dialog", args = {"曹操", "你不是那种不讲信义的人。"}},
                    {cmd = "Dialog", args = {"庞德", "（曹操大人深知我的为人，而且对我没有一点疑心。）"}},
                    {cmd = "Dialog", args = {"庞德", "（我实在是不如他啊……此人胸襟太广阔了。）"}},
                    {cmd = "Dialog", args = {"庞德", "（想来马腾主公的不幸，也是乱世习以为常之事，一切都是无可奈何的。）"}},
                    {cmd = "Dialog", args = {"庞德", "（请马腾主公原谅我吧！我的心已经属于曹操了。）"}},
                },
                {
                    {cmd = "VarTest", args = {{falseConditions = {"Var311"}}}},
                    {cmd = "Dialog", args = {"庞德", "是，末将遵命。"}},
                    {cmd = "RoleAction", args = {"曹操", 19}},
                    {cmd = "Dialog", args = {"曹操", "好，出发！"}},
                },
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "RoleChangeDirection", args = {"庞德", "right", 0}},
                {cmd = "RoleChangeDirection", args = {"荀彧", "left", 0}},
                {cmd = "RoleChangeDirection", args = {"司马懿", "left", 0}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 15, 10, "司马懿", "张辽", "李典", "乐进", "庞德", }},
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
            {cmd = "RolePressedTest", args = {"荀彧"}},
            {
                {cmd = "Dialog", args = {"荀彧", "如今两军可说挟长江相互对峙。"}},
                {cmd = "Dialog", args = {"荀彧", "如果能成功地登上对岸就好了，可是对方……"}},
                {cmd = "Dialog", args = {"曹操", "你担心的是东吴的水军吧？"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"司马懿"}},
            {
                {cmd = "Dialog", args = {"司马懿", "我看孙权这个人非常稳重。"}},
                {cmd = "Dialog", args = {"司马懿", "这次作战要充分准备才行。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"程昱"}},
            {
                {cmd = "Dialog", args = {"程昱", "东吴诸将之中，吕蒙、陆逊之才可与周瑜匹敌。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"庞德"}},
            {
                {cmd = "Dialog", args = {"曹操", "看你的了，庞德。"}},
                {cmd = "Dialog", args = {"庞德", "请主公放心。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"许褚"}},
            {
                {cmd = "Dialog", args = {"许褚", "老是在水上跟东吴交手，要是在山上，我可最拿手了。"}},
                {cmd = "Dialog", args = {"曹操", "哦？那这次就让许褚休息吧。"}},
                {cmd = "Dialog", args = {"许褚", "啊，主公您别这么说嘛……"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"夏侯惇"}},
            {
                {cmd = "Dialog", args = {"夏侯惇", "孙权这个人打仗很有耐心。"}},
                {cmd = "Dialog", args = {"曹操", "嗯，这是他与父兄不同之处。"}},
            },
        },
    },
}

return Plot
