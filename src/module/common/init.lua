--[[
    放一些公共类，目前已有
        EventMgr        = 事件管理器
        EventConst      = 事件常量
        SearchPathUtils = 寻路工具类
        Random          = 随机概率处理类，概率计算都交到这里，统一处理
--]]

import(".math_ext")
import(".table_ext")

Random          = import(".random")
EventConst      = import(".event_const")
EventMgr        = import(".event_mgr")
AudioMgr        = import(".audio_mgr")
ResMgr          = import(".res_mgr")
SearchPathUtils = import(".search_path_utils")
UIHelper        = import(".ui_helper")
Profiler        = import(".profiler")

