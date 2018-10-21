--[[
    公共初始化部分，用来加载所有的常量和全局函数
--]]

-- 加载quick部分
scheduler  = require("framework.scheduler")
UserConfig = cc.UserDefault:getInstance()
UserConfig:setBoolForKey("QuickDialog", true)

-- 加载自定义逻辑部分
import(".ui.ui_const")
import(".data.init")
import(".map.init")
import(".ai.init")
import(".common.init")
import(".ui.init")
import(".char.init")
import(".general.init")
import(".player.init")