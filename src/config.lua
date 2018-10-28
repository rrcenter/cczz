
-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 1

-- display FPS stats on screen
DEBUG_FPS = false

-- dump memory info every 10 seconds
DEBUG_MEM = false

-- load deprecated API
LOAD_DEPRECATED_API = false

-- load shortcodes API
LOAD_SHORTCODES_API = true

-- screen orientation
CONFIG_SCREEN_ORIENTATION = "landscape"

-- design resolution
CONFIG_SCREEN_WIDTH  = 640
-- CONFIG_SCREEN_WIDTH  = 960
CONFIG_SCREEN_HEIGHT = 640

-- auto scale mode
CONFIG_SCREEN_AUTOSCALE = "FIXED_WIDTH"

-- 是否显示calcAttackDamge和calcMagicDamge
DEBUG_SHOW_DAMGEINFO = false

-- 是否显示AiUtils中的打印
DEBUG_SHOW_AI_UTILS = false

-- 是否显示R剧本中的网格
DEBUG_SHOW_RPLOT_GRID = false

-- 是否打印地图上的点的信息
DEBUG_MAP_VIEW_INFO = false

-- 是否合并对话到一个命令
RPLOT_UNION_DIALOG = false

-- 是否合并连续的SceneDialog命令
RPLOT_UNION_SCENE_DIALOG = true

-- 是否合并连续的RoleMove命令，这个是必须的，因为原版的不合并，单个就会无法一起移动
RPLOT_UNION_ROLEMOVE = true

-- 是否显示忽略命令的注释
PLOT_NEED_SHOW_IGNORE_CMD = false

-- R剧本中快速测试，不显示各种对话框
RPLOT_QUICK_TEST = false