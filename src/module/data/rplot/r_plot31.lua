--[[
    转换脚本R_TXT/r_plot31.txt
--]]

local Plot = {
    {
        {
            {
                {cmd = "ShowMenu", args = {false}},
                {cmd = "LoadBackground", args = {"MMap-49"}},
                {cmd = "RolePlay", args = {"曹操", 35, 56, "right", "曹操", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 53, 71, "up", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"曹丕", 59, 71, "up", "曹丕", 0}},
                {cmd = "RolePlay", args = {"许褚", 65, 71, "up", "许褚", 0}},
                {cmd = "RolePlay", args = {"徐晃", 71, 71, "up", "徐晃", 0}},
                {cmd = "RolePlay", args = {"荀彧", 53, 41, "down", "荀彧", 0}},
                {cmd = "RolePlay", args = {"贾诩", 59, 41, "down", "贾诩", 0}},
                {cmd = "RolePlay", args = {"荀攸", 65, 41, "down", "荀攸", 0}},
                {cmd = "RolePlay", args = {"程昱", 71, 41, "down", "程昱", 0}},
                {cmd = "RolePlay", args = {"曹植", 53, 56, "left", "曹植", 8}},
                {cmd = "PlaySound", args = {"Se_e_00.wav", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RSetTitle", args = {"西凉锦马超"}},
                {cmd = "RShowSceneName", args = {"许都  相府"}},
                {
                    {cmd = "VarTest", args = {{trueConditions = {"Var309"}}}},
                    {cmd = "Dialog", args = {"曹操", "子建，铜雀台竣工了吗？"}},
                    {cmd = "Dialog", args = {"曹植", "是！只等父亲查验了。"}},
                    {cmd = "Dialog", args = {"曹操", "是吗？你做得很好。这次真是值得赞扬！"}},
                    {cmd = "Dialog", args = {"曹植", "谢父亲。对了父亲，您和我一块去邺城吗？"}},
                    {cmd = "Dialog", args = {"曹操", "嗯，去邺城是吗……？荀彧，还是你代我去查验吧。"}},
                    {cmd = "RoleAction", args = {"荀彧", 8}},
                    {cmd = "Dialog", args = {"荀彧", "是。"}},
                    {cmd = "RoleAction", args = {"荀彧", 0}},
                    {cmd = "Delay", args = {3}},
                    {cmd = "RoleAction", args = {"曹植", 0}},
                    {cmd = "Dialog", args = {"曹植", "哎？父亲不去吗？"}},
                    {cmd = "RoleAction", args = {"荀彧", 8}},
                    {cmd = "Dialog", args = {"荀彧", "世子对荀彧可有不满？"}},
                    {cmd = "RoleAction", args = {"荀彧", 0}},
                    {cmd = "Delay", args = {3}},
                    {cmd = "RoleChangeDirection", args = {"曹植", "up", 0}},
                    {cmd = "Dialog", args = {"曹植", "不……不是的……曹植并非此意，只是……"}},
                    {cmd = "RoleAction", args = {"曹操", 5}},
                    {cmd = "Dialog", args = {"曹操", "文和，通知各地诸侯，就说铜雀台竣工了。这回要尽量办得风光一点。"}},
                    {cmd = "RoleAction", args = {"贾诩", 8}},
                    {cmd = "Dialog", args = {"贾诩", "是。属下明白。"}},
                    {cmd = "RoleAction", args = {"贾诩", 0}},
                    {cmd = "Delay", args = {3}},
                    {cmd = "RoleAction", args = {"曹操", 0}},
                    {cmd = "Dialog", args = {"曹操", "子建，待天下统一之后，我再上铜雀台吧，现在还不是时候。"}},
                    {cmd = "RoleChangeDirection", args = {"曹植", "left", 0}},
                    {cmd = "Dialog", args = {"曹植", "孩儿明白了。"}},
                    {cmd = "RoleChangeDirection", args = {"曹植", "up", 0}},
                    {cmd = "Dialog", args = {"曹植", "那么荀彧先生，请。"}},
                    {cmd = "RoleAction", args = {"荀彧", 8}},
                    {cmd = "Dialog", args = {"荀彧", "是。"}},
                    {cmd = "RoleAction", args = {"荀彧", 0}},
                    {cmd = "Delay", args = {3}},
                },
                {
                    {cmd = "VarTest", args = {{falseConditions = {"Var309"}}}},
                    {cmd = "Dialog", args = {"曹操", "子建，听说你建了铜雀台？建造铜雀台的费用，是从施政资金支取的吧。"}},
                    {cmd = "HeadChange", args = {2}},
                    {cmd = "RoleAction", args = {"曹操", 4}},
                    {cmd = "Dialog", args = {"曹操", "国家的资金不能用于私事，难道你不明白吗！"}},
                    {cmd = "Dialog", args = {"曹植", "父亲您别生气。孩儿并未动用官资，这全是荀彧先生的……"}},
                    {cmd = "RoleAction", args = {"荀彧", 8}},
                    {cmd = "Dialog", args = {"荀彧", "主公，建造铜雀台的费用，全是来自属下的私产。这点请主公放心。"}},
                    {cmd = "RoleAction", args = {"荀彧", 0}},
                    {cmd = "Dialog", args = {"荀彧", "主公，世子是没有过错的，一切责任就由文若承担吧。"}},
                    {cmd = "Delay", args = {10}},
                    {cmd = "HeadChange", args = {0}},
                    {cmd = "RoleAction", args = {"曹操", 0}},
                    {cmd = "Dialog", args = {"曹操", "唔，也就是说没有罪过喽？好了，退下吧！这回就不追究了，下不为例。"}},
                    {cmd = "RoleAction", args = {"荀彧", 8}},
                    {cmd = "Dialog", args = {"荀彧", "是，谢主公。"}},
                    {cmd = "RoleAction", args = {"荀彧", 0}},
                    {cmd = "Delay", args = {3}},
                    {cmd = "RoleAction", args = {"贾诩", 8}},
                    {cmd = "Dialog", args = {"贾诩", "主公，该如何处置铜雀台？拆掉吗？"}},
                    {cmd = "RoleAction", args = {"贾诩", 0}},
                    {cmd = "Dialog", args = {"曹操", "既然已经建好，也没办法了。就这么放着吧。不过我突然有个想法。"}},
                    {cmd = "RoleAction", args = {"曹操", 5}},
                    {cmd = "Dialog", args = {"曹操", "文和，通知各地诸侯，就说铜雀台竣工了。这回要尽量办得风光一点。"}},
                    {cmd = "RoleAction", args = {"曹操", 0}},
                    {cmd = "Dialog", args = {"贾诩", "啊？"}},
                    {cmd = "RoleAction", args = {"贾诩", 8}},
                    {cmd = "Dialog", args = {"贾诩", "原来如此。是！属下明白。"}},
                    {cmd = "RoleAction", args = {"贾诩", 0}},
                    {cmd = "Delay", args = {3}},
                    {cmd = "RoleAction", args = {"曹植", 0}},
                    {cmd = "Delay", args = {3}},
                },
                {cmd = "RoleMove", args = {"荀彧", "up", 53, 35}},
                {cmd = "RoleMove", args = {"贾诩", "up", 59, 35}},
                {cmd = "RoleMove", args = {"曹植", "right", 59, 56}},
                {cmd = "Delay", args = {0}},
                {cmd = "RoleMove", args = {"荀彧", "right", 81, 35}},
                {cmd = "RoleMove", args = {"贾诩", "right", 81, 35}},
                {cmd = "RoleMove", args = {"曹植", "right", 99, 56}},
                {cmd = "RoleDisappear", args = {"曹植"}},
                {cmd = "RoleDisappear", args = {"荀彧"}},
                {cmd = "RoleDisappear", args = {"贾诩"}},
                {cmd = "Dialog", args = {"曹操", "仲德，听说刘备夺取了荆州。"}},
                {cmd = "RoleAction", args = {"程昱", 8}},
                {cmd = "Dialog", args = {"程昱", "是的。"}},
                {cmd = "RoleChangeDirection", args = {"曹操", "down", 0}},
                {cmd = "Dialog", args = {"曹操", "刘备这家伙自从有了军师孔明，似乎如鱼得水，越发壮大了。孔明也真有一手！"}},
                {cmd = "RoleAction", args = {"程昱", 0}},
                {cmd = "Dialog", args = {"程昱", "主公不可轻视刘备的存在，否则只有百害而无一益。"}},
                {cmd = "RoleChangeDirection", args = {"曹操", "right", 0}},
                {cmd = "Dialog", args = {"曹操", "我知道。对了，周瑜后来怎么样了？如今还卧病不起吗？"}},
                {cmd = "RoleAction", args = {"程昱", 8}},
                {cmd = "Dialog", args = {"程昱", "不，似乎已经回到军中了。"}},
                {cmd = "RoleAction", args = {"曹操", 5}},
                {cmd = "HeadChange", args = {3}},
                {cmd = "Dialog", args = {"曹操", "好，我就祝贺周瑜的康复，让他出任荆州江夏的太守吧。"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"程昱", 0}},
                {cmd = "Dialog", args = {"程昱", "封周瑜官职……？哦，原来如此。赐给周瑜官职，好让他对付孔明！"}},
                {cmd = "HeadChange", args = {0}},
                {cmd = "Dialog", args = {"曹操", "不错。即刻上奏朝廷。"}},
                {cmd = "RoleAction", args = {"程昱", 8}},
                {cmd = "Dialog", args = {"程昱", "是！"}},
                {cmd = "RoleAction", args = {"程昱", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleMove", args = {"程昱", "right", 96, 41}},
                {cmd = "RoleDisappear", args = {"程昱"}},
                {cmd = "Dialog", args = {"曹操", "周瑜和孔明……这两个人太危险了。必须先除掉其中一个。"}},
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
                {cmd = "HeadPortraitPlay", args = {"曹操", 337, 99, "曹操"}},
                {cmd = "HeadPortraitPlay", args = {"刘备", 275, 229, "刘备"}},
                {cmd = "HeadPortraitPlay", args = {"孙权", 568, 218, "孙权"}},
                {cmd = "SceneDialog", args = {"曹操请示朝廷，", "换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "HeadPortraitPlay", args = {"周瑜", 339, 229, "周瑜"}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"任命周瑜为江夏太守。", "不换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {8}},
                {cmd = "SceneDialog", args = {"刘备和孙权的荆州争夺战遂愈演愈烈。", "不换页", "换行", "不等待"}},
                {cmd = "Delay", args = {8}},
                {cmd = "SceneDialog", args = {"双方争斗的结果", "不换页", "换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "HeadPortraitDisappear", args = {"周瑜"}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"周瑜殒命，", "不换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"刘备完全控制了荆州。", "不换页", "不换行", "等待"}},
                {cmd = "PlayMusic", args = {"无"}},
                {cmd = "LoadBackground", args = {"MMap-49"}},
                {cmd = "RolePlay", args = {"曹操", 35, 56, "right", "曹操", 0}},
                {cmd = "RolePlay", args = {"荀攸", 53, 41, "down", "荀攸", 0}},
                {cmd = "RolePlay", args = {"程昱", 59, 41, "down", "程昱", 0}},
                {cmd = "PlaySound", args = {"Se_e_01.wav", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RShowSceneName", args = {"许都  相府"}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"荀攸", 8}},
                {cmd = "Dialog", args = {"荀攸", "由于孔明足智多谋，刘备最后取得荆州争夺战的胜利。"}},
                {cmd = "RoleAction", args = {"荀攸", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"程昱", 8}},
                {cmd = "Dialog", args = {"程昱", "周瑜也在这期间吐血而死。"}},
                {cmd = "RoleAction", args = {"程昱", 0}},
                {cmd = "Dialog", args = {"曹操", "是吗……原来孔明还是比周瑜技高一筹。"}},
                {cmd = "PlaySound", args = {"Se_e_01.wav", 255}},
                {cmd = "PlayMusic", args = {"Track13"}},
                {cmd = "Delay", args = {3}},
                {
                    {cmd = "ChoiceDialog", args = {"曹操", {"有点感到意外", "果然不出所料"}}},
                    {
                        {cmd = "AddCareerism", args = {"-", 2}},
                        {cmd = "PlayMusic", args = {"无"}},
                        {cmd = "PlaySound", args = {"Se_e_01.wav", 0}},
                        {cmd = "Delay", args = {3}},
                        {cmd = "Dialog", args = {"曹操", "有点让人感到意外。"}},
                        {cmd = "Dialog", args = {"荀彧", "主公一直以为周瑜较强是吗？"}},
                        {cmd = "Dialog", args = {"曹操", "嗯，我也有看错的时候。"}},
                    },
                    {
                        {cmd = "AddCareerism", args = {"+", 2}},
                        {cmd = "PlayMusic", args = {"无"}},
                        {cmd = "PlaySound", args = {"Se_e_01.wav", 0}},
                        {cmd = "Delay", args = {3}},
                        {cmd = "Dialog", args = {"曹操", "嗯，果然和我想的一样。最令人害怕的还是孔明啊。"}},
                    },
                },
                {cmd = "RoleAction", args = {"荀攸", 8}},
                {cmd = "Dialog", args = {"荀攸", "听说庞统也出任了刘备的副军师。"}},
                {cmd = "RoleAction", args = {"曹操", 5}},
                {cmd = "HeadChange", args = {1}},
                {cmd = "Dialog", args = {"曹操", "什么？庞统！"}},
                {cmd = "Dialog", args = {"荀攸", "不能再放任刘备了，必须马上对付他。"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "HeadChange", args = {0}},
                {cmd = "Dialog", args = {"曹操", "嗯。"}},
                {cmd = "RolePlay", args = {"士兵01", 91, 56, "left", "士兵01", 0}},
                {cmd = "Dialog", args = {"士兵01", "报。"}},
                {cmd = "RoleAction", args = {"荀攸", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"士兵01", 13}},
                {cmd = "Dialog", args = {"士兵01", "主公，西凉马腾求见主公，现在正在外面等候。"}},
                {cmd = "Dialog", args = {"曹操", "马腾？哦，让他进来。"}},
                {cmd = "Dialog", args = {"士兵01", "是。"}},
                {cmd = "RoleAction", args = {"士兵01", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleDisappear", args = {"士兵01"}},
                {cmd = "RoleAction", args = {"程昱", 0}},
                {cmd = "Dialog", args = {"程昱", "马腾是西凉军的统帅，为什么来都城……"}},
                {cmd = "RolePlay", args = {"马腾", 91, 56, "left", "马腾", 0}},
                {cmd = "Dialog", args = {"马腾", "参见丞相。"}},
                {cmd = "RoleMove", args = {"马腾", "left", 53, 56}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"马腾", 8}},
                {cmd = "Dialog", args = {"马腾", "在下马腾。"}},
                {cmd = "Dialog", args = {"曹操", "我乃曹孟德。马腾将军来得正好。"}},
                {cmd = "Dialog", args = {"马腾", "是。听说丞相的铜雀台竣工，在下特地前来祝贺。"}},
                {cmd = "Dialog", args = {"曹操", "是吗？多谢将军抬爱，我马上设宴为将军洗尘。"}},
                {cmd = "Dialog", args = {"马腾", "马腾不胜感激。不过接受丞相款待之前，马腾希望前去谒见陛下。"}},
                {cmd = "RoleAction", args = {"曹操", 5}},
                {cmd = "Dialog", args = {"曹操", "哦，曹某一时失察。我马上为将军禀明陛下。"}},
                {cmd = "RoleAction", args = {"曹操", 0}},
                {cmd = "Dialog", args = {"曹操", "届时会为将军安排接见之处，还请将军稍待片刻。"}},
                {cmd = "Dialog", args = {"马腾", "是。那么在下告辞。"}},
                {cmd = "RoleAction", args = {"马腾", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleMove", args = {"马腾", "right", 96, 56}},
                {cmd = "RoleDisappear", args = {"马腾"}},
                {cmd = "RoleAction", args = {"荀攸", 8}},
                {cmd = "Dialog", args = {"荀攸", "主公，让马腾讨伐刘备如何？"}},
                {cmd = "RoleAction", args = {"荀攸", 0}},
                {cmd = "Dialog", args = {"曹操", "让马腾去……？不，现在还不能信任他。"}},
                {cmd = "Dialog", args = {"曹操", "仲德，你去准备马腾谒见的事宜，不过要布下耳目留意他的举动。"}},
                {cmd = "RoleAction", args = {"程昱", 8}},
                {cmd = "Dialog", args = {"程昱", "是。"}},
                {cmd = "RoleAction", args = {"荀攸", 0}},
                {cmd = "Dialog", args = {"荀攸", "您打算监视马腾吗？"}},
                {cmd = "Dialog", args = {"曹操", "我可不认为他是为了庆贺铜雀台，才专程从西凉千里迢迢赶来许都的。"}},
                {cmd = "Delay", args = {3}},
                {cmd = "PlaySound", args = {"Se_e_01.wav", 255}},
            },
        },
    },
    {
        {
            {
                {cmd = "PlayMusic", args = {"Track14"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"MMap-56"}},
                {cmd = "RolePlay", args = {"献帝", 28, 56, "right", "献帝", 0}},
                {cmd = "RolePlay", args = {"马腾", 47, 56, "left", "马腾", 8}},
                {cmd = "RolePlay", args = {"文官01", 47, 44, "down", "文官01", 0}},
                {cmd = "RolePlay", args = {"文官02", 53, 44, "down", "文官02", 0}},
                {cmd = "RShowSceneName", args = {"许都  宫廷"}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"文官01", 8}},
                {cmd = "Dialog", args = {"文官01", "陛下，西凉马腾进见。"}},
                {cmd = "RoleAction", args = {"文官01", 0}},
                {cmd = "Dialog", args = {"献帝", "哦，马爱卿！你终于来了。朕已经等候多时。"}},
                {cmd = "Dialog", args = {"马腾", "是，陛下。"}},
                {cmd = "RoleAction", args = {"文官01", 8}},
                {cmd = "Dialog", args = {"文官01", "马将军，自从来到许都，陛下从来没有开心过。"}},
                {cmd = "RoleAction", args = {"文官01", 0}},
                {cmd = "Dialog", args = {"献帝", "刘皇叔远在荆州不便前来，诸侯又毫无忠君爱国之心，朕也只有寄望名门马家了。"}},
                {cmd = "RoleAction", args = {"马腾", 0}},
                {cmd = "Dialog", args = {"马腾", "陛下何出此言，难道曹操……"}},
                {cmd = "Dialog", args = {"献帝", "嗯，最初朕也很相信他，可是见他多年的所作所为，已经不再对他信任。"}},
                {cmd = "Dialog", args = {"献帝", "朕认为曹操并无忠君之心。"}},
                {cmd = "RoleAction", args = {"马腾", 8}},
                {cmd = "Dialog", args = {"马腾", "臣明白了。臣心意已决。"}},
                {cmd = "RoleAction", args = {"马腾", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"文官02", 8}},
                {cmd = "Dialog", args = {"文官02", "马将军可有什么主意？"}},
                {cmd = "RoleAction", args = {"文官02", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"马腾", "up", 0}},
                {cmd = "Dialog", args = {"马腾", "是的。马腾体察圣意，早已准备行动。"}},
                {cmd = "RoleAction", args = {"文官01", 5}},
                {cmd = "Dialog", args = {"文官01", "哦！马将军是说……"}},
                {cmd = "RoleAction", args = {"马腾", 8}},
                {cmd = "Dialog", args = {"马腾", "是的。臣决心铲除曹操，解救陛下。"}},
                {cmd = "RoleAction", args = {"马腾", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"文官01", 0}},
                {cmd = "Dialog", args = {"文官01", "可……可是将军真能铲除曹操吗？万一失败………"}},
                {cmd = "Dialog", args = {"马腾", "不必担心。曹操尚不知我心中的想法。"}},
                {cmd = "RoleAction", args = {"马腾", 5}},
                {cmd = "Dialog", args = {"马腾", "只须唤来留守西凉的部队，届时内外同时举兵夹击，曹操根本不是对手。"}},
                {cmd = "RoleAction", args = {"马腾", 0}},
                {cmd = "Dialog", args = {"文官02", "原来如此。"}},
                {cmd = "RoleChangeDirection", args = {"文官01", "left", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"文官01", 8}},
                {cmd = "Dialog", args = {"文官01", "陛……陛下！我们终于得偿所望了……"}},
                {cmd = "Dialog", args = {"献帝", "马腾！希望你能解救朕脱离曹操之手。"}},
                {cmd = "RoleChangeDirection", args = {"马腾", "left", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"马腾", 8}},
                {cmd = "Dialog", args = {"马腾", "请陛下放心。"}},
                {cmd = "Dialog", args = {"马腾", "那么臣即刻返回营中，准备举兵的事宜，请恕臣先行告退。"}},
                {cmd = "Dialog", args = {"献帝", "嗯，全靠你了。马爱卿……"}},
                {cmd = "RoleAction", args = {"马腾", 0}},
                {cmd = "RoleAction", args = {"文官01", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleChangeDirection", args = {"文官01", "down", 0}},
                {cmd = "RoleMove", args = {"马腾", "right", 96, 56}},
                {cmd = "RoleDisappear", args = {"马腾"}},
                {cmd = "Dialog", args = {"献帝", "马腾真能除掉曹操吗……万一失败，朕………"}},
                {cmd = "RoleAction", args = {"文官01", 8}},
                {cmd = "Dialog", args = {"文官01", "……陛下，您放心吧。"}},
                {cmd = "RoleAction", args = {"文官01", 0}},
                {cmd = "Dialog", args = {"文官02", "啊，对了！马将军还不知道曹军内情呢……"}},
                {cmd = "RoleAction", args = {"文官02", 8}},
                {cmd = "Dialog", args = {"文官02", "陛下，臣马上去告诉马将军，有关曹军的详实内情吧。"}},
                {cmd = "Dialog", args = {"献帝", "嗯，嗯。你快去吧。"}},
                {cmd = "Dialog", args = {"文官02", "是。"}},
                {cmd = "RoleAction", args = {"文官02", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleMove", args = {"文官02", "right", 77, 44}},
                {cmd = "Dialog", args = {"文官02", "（马腾果然心怀不轨……必须马上报告程昱先生。）"}},
                {cmd = "RoleMove", args = {"文官02", "right", 91, 44}},
                {cmd = "RoleDisappear", args = {"文官02"}},
                {cmd = "PlayMusic", args = {"无"}},
            },
        },
    },
    {
        {
            {
                {cmd = "LoadBackground", args = {"MMap-49"}},
                {cmd = "RolePlay", args = {"曹操", 35, 56, "right", "曹操", 0}},
                {cmd = "RolePlay", args = {"荀彧", 53, 41, "down", "荀彧", 0}},
                {cmd = "RolePlay", args = {"贾诩", 59, 41, "down", "贾诩", 0}},
                {cmd = "RolePlay", args = {"荀攸", 65, 41, "down", "荀攸", 0}},
                {cmd = "RolePlay", args = {"程昱", 71, 41, "down", "程昱", 0}},
                {cmd = "PlaySound", args = {"Se_e_01.wav", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RShowSceneName", args = {"许都  相府"}},
                {cmd = "Dialog", args = {"曹操", "是吗？消灭我们才是马腾的目的？"}},
                {cmd = "RoleAction", args = {"程昱", 8}},
                {cmd = "Dialog", args = {"程昱", "是的。而且他想招来西凉军，到时候里外夹攻。"}},
                {cmd = "RoleAction", args = {"程昱", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"荀攸", 8}},
                {cmd = "Dialog", args = {"荀攸", "主公，我们必须马上采取行动。"}},
                {cmd = "RoleAction", args = {"荀攸", 0}},
                {cmd = "Dialog", args = {"曹操", "我知道。就是想套出这些隐藏的政敌，我才让文和大肆宣扬铜雀台的。"}},
                {cmd = "RoleAction", args = {"贾诩", 8}},
                {cmd = "Dialog", args = {"贾诩", "马腾果然也一如预料，落入了主公的圈套。"}},
                {cmd = "RoleAction", args = {"贾诩", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"荀彧", 8}},
                {cmd = "Dialog", args = {"荀彧", "可是如果让敌人里外夹攻，应付起来将会十分棘手啊。"}},
                {cmd = "RoleAction", args = {"荀彧", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "RoleAction", args = {"程昱", 8}},
                {cmd = "Dialog", args = {"程昱", "必须马上行动了。主公，捉拿马腾吧。"}},
                {cmd = "RoleAction", args = {"程昱", 0}},
                {cmd = "Dialog", args = {"曹操", "嗯………"}},
                {cmd = "PlaySound", args = {"Se_e_01.wav", 255}},
                {cmd = "PlayMusic", args = {"Track13"}},
                {cmd = "Delay", args = {3}},
                {
                    {cmd = "ChoiceDialog", args = {"曹操", {"将马腾斩首", "让马腾下狱"}}},
                    {
                        {cmd = "VarSet", args = {"Var311", true}},
                        {cmd = "AddCareerism", args = {"+", 5}},
                        {cmd = "PlayMusic", args = {"无"}},
                        {cmd = "PlaySound", args = {"Se_e_01.wav", 0}},
                        {cmd = "Delay", args = {3}},
                        {cmd = "HeadChange", args = {2}},
                        {cmd = "RoleAction", args = {"曹操", 4}},
                        {cmd = "Dialog", args = {"曹操", "仲德，将马腾押赴午门斩首。不让他活在世上！至于陛下暂不追究。"}},
                        {cmd = "HeadChange", args = {0}},
                        {cmd = "RoleAction", args = {"曹操", 0}},
                        {cmd = "Delay", args = {3}},
                        {cmd = "RoleAction", args = {"程昱", 8}},
                        {cmd = "Dialog", args = {"程昱", "是。属下马上去办。"}},
                        {cmd = "RoleAction", args = {"程昱", 0}},
                        {cmd = "Delay", args = {3}},
                        {cmd = "RoleMove", args = {"程昱", "right", 96, 41}},
                        {cmd = "RoleDisappear", args = {"程昱"}},
                        {cmd = "Dialog", args = {"曹操", "文和，你曾在长安打败马腾军，你对他的部队评价如何？"}},
                        {cmd = "RoleAction", args = {"贾诩", 8}},
                        {cmd = "Dialog", args = {"贾诩", "西凉部队的战斗力不可低估，尤其是马腾的儿子马超，有万夫莫敌之勇。"}},
                        {cmd = "Dialog", args = {"曹操", "马超这名字我也听说过，好像人称「西凉锦马超」，是个武艺高超的年轻武将。"}},
                        {cmd = "Dialog", args = {"贾诩", "是的。属下认为动用大军，与马超为主的西凉军作战，此举实为下策，还是智取为佳。"}},
                        {cmd = "Dialog", args = {"曹操", "好吧。全军进入备战状态。马超……啊！真是令人期待啊。"}},
                    },
                    {
                        {cmd = "VarSet", args = {"Var311", false}},
                        {cmd = "AddCareerism", args = {"-", 5}},
                        {cmd = "PlayMusic", args = {"无"}},
                        {cmd = "PlaySound", args = {"Se_e_01.wav", 0}},
                        {cmd = "Delay", args = {3}},
                        {cmd = "Dialog", args = {"曹操", "程昱，将马腾投入大狱。"}},
                        {cmd = "RoleAction", args = {"程昱", 8}},
                        {cmd = "Dialog", args = {"程昱", "啊……？"}},
                        {cmd = "Delay", args = {5}},
                        {cmd = "RoleAction", args = {"程昱", 0}},
                        {cmd = "Delay", args = {3}},
                        {cmd = "RoleMove", args = {"程昱", "right", 77, 41}},
                        {cmd = "Dialog", args = {"程昱", "（主公似乎没有发觉，马腾是个危险人物，应该斩草除根才是啊！）"}},
                        {cmd = "RoleMove", args = {"程昱", "right", 96, 41}},
                        {cmd = "RoleDisappear", args = {"程昱"}},
                        {cmd = "Tip", args = {"结果程昱未将马腾关入大牢，反倒自作主张杀害了马腾。曹操得知这件事后十分懊悔，遂郑重地将马腾遗体送回西凉。"}},
                        {cmd = "Dialog", args = {"曹操", "文和，你曾在长安打败马腾军，你对他的部队评价如何？"}},
                        {cmd = "RoleAction", args = {"贾诩", 8}},
                        {cmd = "Dialog", args = {"贾诩", "西凉部队的战力不可低估，尤其是马腾的儿子马超，有万夫莫敌之勇。"}},
                        {cmd = "Dialog", args = {"曹操", "马超这名字我也听说过，好像人称「西凉锦马超」，是个武艺高超的年轻武将。"}},
                        {cmd = "Dialog", args = {"贾诩", "是的。属下认为动用大军，与马超为主的西凉军作战，此举实为下策，还是智取为佳。"}},
                        {cmd = "Dialog", args = {"曹操", "好吧。全军进入备战状态。马超……啊！真是令人期待啊。"}},
                    },
                },
                {cmd = "PlaySound", args = {"Se_e_01.wav", 255}},
            },
        },
    },
    {
        {
            {
                {cmd = "LoadBackground", args = {"MMap-49"}},
                {cmd = "RolePlay", args = {"曹操", 35, 56, "right", "曹操", 0}},
                {cmd = "RolePlay", args = {"荀彧", 53, 41, "down", "荀彧", 0}},
                {cmd = "RolePlay", args = {"贾诩", 59, 41, "down", "贾诩", 0}},
                {cmd = "RolePlay", args = {"荀攸", 65, 41, "down", "荀攸", 0}},
                {cmd = "RolePlay", args = {"程昱", 71, 41, "down", "程昱", 0}},
                {cmd = "PlaySound", args = {"Se_e_02.wav", 0}},
                {cmd = "Delay", args = {3}},
                {cmd = "Tip", args = {"半月后……。"}},
                {cmd = "RShowSceneName", args = {"许都  相府"}},
                {cmd = "RolePlay", args = {"士兵01", 91, 56, "left", "士兵01", 0}},
                {cmd = "Dialog", args = {"士兵01", "报！"}},
                {cmd = "RoleAction", args = {"士兵01", 13}},
                {cmd = "Dialog", args = {"士兵01", "主公，西凉军进攻渭水了。"}},
                {cmd = "RoleAction", args = {"曹操", 19}},
                {cmd = "Dialog", args = {"曹操", "来了？好！我们也去渭水。迎击西凉军！"}},
                {cmd = "PlaySound", args = {"Se_e_02.wav", 255}},
            },
        },
    },
    {
        {
            {
                {cmd = "PlayMusic", args = {"Track18"}},
                {cmd = "Delay", args = {3}},
                {cmd = "LoadBackground", args = {"china"}},
                {cmd = "HeadPortraitPlay", args = {"曹操", 331, 130, "曹操"}},
                {cmd = "SceneDialog", args = {"马腾的儿子", "换页", "不换行", "不等待"}},
                {cmd = "HeadPortraitPlay", args = {"马超", 51, 1, "马超"}},
                {cmd = "SceneDialog", args = {"马超率领西凉军，", "不换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {5}},
                {cmd = "HeadPortraitMove", args = {"马超", 177, 84}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"南下直指目标许都。", "不换页", "不换行", "不等待"}},
                {cmd = "Delay", args = {8}},
                {cmd = "HeadPortraitMove", args = {"曹操", 241, 84}},
                {cmd = "Delay", args = {5}},
                {cmd = "SceneDialog", args = {"曹操则进军渭水迎击。", "不换页", "换行", "等待"}},
                {cmd = "PlayMusic", args = {"Track17"}},
                {cmd = "LoadBackground", args = {"MMap-94"}},
                {cmd = "RolePlay", args = {"曹操", 55, 81, "up", "曹操", 0}},
                {cmd = "RolePlay", args = {"夏侯惇", 45, 65, "right", "夏侯惇", 0}},
                {cmd = "RolePlay", args = {"许褚", 45, 59, "right", "许褚", 0}},
                {cmd = "RolePlay", args = {"曹洪", 45, 53, "right", "曹洪", 0}},
                {cmd = "RolePlay", args = {"荀彧", 65, 65, "left", "荀彧", 0}},
                {cmd = "RolePlay", args = {"贾诩", 65, 59, "left", "贾诩", 0}},
                {cmd = "RolePlay", args = {"荀攸", 65, 53, "left", "荀攸", 0}},
                {cmd = "RShowSceneName", args = {"渭水  曹操军主营"}},
                {cmd = "ShowMenu", args = {true}},
                {cmd = "FightGeneralsInfo", args = {true, 13, 8, "曹洪", "徐晃", "贾诩", "许褚", "!张辽", "!乐进", "!李典", }},
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
                {cmd = "Dialog", args = {"曹操", "文若，说明一下战场的地形吧。"}},
                {cmd = "Dialog", args = {"荀彧", "是。西凉军的鹿砦旁环绕着大河。"}},
                {cmd = "Dialog", args = {"荀彧", "其他没有什么明显的特征，较棘手的是战场被大雪覆盖。"}},
                {cmd = "Dialog", args = {"曹操", "雪？这下可麻烦了。"}},
                {cmd = "Dialog", args = {"荀彧", "是的。这么一来就无法快速移动了。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"曹洪"}},
            {
                {cmd = "Dialog", args = {"曹操", "子孝，你和徐晃迂回到西凉军后方。明白吗？"}},
                {cmd = "Dialog", args = {"曹洪", "是。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"许褚"}},
            {
                {cmd = "Dialog", args = {"许褚", "我的拳脚都等得发痒了。请主公务必让我大战马超。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"夏侯惇"}},
            {
                {cmd = "Dialog", args = {"夏侯惇", "「西凉锦马超」？好像不怎么样嘛。真的很厉害吗？"}},
                {cmd = "Dialog", args = {"贾诩", "马超的刚勇是无可置疑的。"}},
                {cmd = "Dialog", args = {"夏侯惇", "是吗……？"}},
                {cmd = "Dialog", args = {"曹操", "听说他还生得相当英挺俊秀。要是见到元让的相貌，我看女人都全吓跑了。"}},
                {cmd = "Dialog", args = {"夏侯惇", "孟德！！"}},
                {cmd = "Dialog", args = {"曹操", "哈哈哈。说笑，说笑嘛。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"贾诩"}},
            {
                {cmd = "Dialog", args = {"贾诩", "主公，武艺高超的不只马超一人。"}},
                {cmd = "Dialog", args = {"贾诩", "马超的堂弟马岱，还有庞德，都是勇冠三军的猛将。"}},
            },
        },
        {
            {cmd = "RolePressedTest", args = {"荀攸"}},
            {
                {cmd = "Dialog", args = {"荀攸", "这个时候天气容易转坏，使用策略时必须注意。"}},
            },
        },
    },
}

return Plot
