local Plot = {
    {
        {
            {
                {cmd = "PlayMusic", args = {"Track17"}},
                {cmd = "LoadBackground", args = {"MMap-62"}},
                {cmd = "RoleAddOrLevel", args = {"曹操", "add", 0}},
                {cmd = "RoleAddOrLevel", args = {"夏侯惇", "add", 0}},
                -- {cmd = "RoleAddOrLevel", args = {"李典", "add", 0}},
                -- {cmd = "RoleAddOrLevel", args = {"乐进", "add", 0}},
                {cmd = "AddItem", args = {"大剑", 0}},
                {cmd = "AddItem", args = {"皮盔", 0}},
                {cmd = "AddItem", args = {"钢枪", 0}},
                {cmd = "AddItem", args = {"太平清领道", 0}},
                {cmd = "RolePlay", args = {"曹操", 50, 67, "up", "曹操", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 39, 53, "right", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"曹仁", 39, 47, "right", "曹仁", 0}},
                {cmd = "RolePlay", args = {"乐进", 39, 41, "right", "乐进", 0}},
                {cmd = "RolePlay", args = {"夏侯渊", 61, 53, "left", "夏侯渊", 0}},
                {cmd = "RolePlay", args = {"曹洪", 61, 47, "left", "曹洪", 0}},
                {cmd = "RolePlay", args = {"李典", 61, 41, "left", "李典", 0}},
                {cmd = "RShowSceneName", args = {"汜水关  曹操军主营"}},
                {cmd = "Dialog", args = {"曹操", "终于要与董卓军队交战了，我军以文台将军做先锋，其余部队跟后，大家要全力以赴。"}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 7, 4, "夏侯惇", }},
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
    },
}

return Plot