--[[
    事件常来定义
--]]

local EventConst = {}

-- 事件优先级
EventConst.PRIO_HIGH   = 10
EventConst.PRIO_MIDDLE = 5
EventConst.PRIO_LOW    = 1

-- 这里用来扩展游戏里自定义的
EventConst.SCENE_EXIT                         = "scene_exit" -- 场景退出
EventConst.MOVE_MAP_VIEW                      = "move_map_view" -- 移动地图
EventConst.MOVE_TO_NODE                       = "move_to_node" -- 移动地图到指定节点
EventConst.MOVE_TO_POS                        = "move_to_pos" -- 移动地图到指定坐标
EventConst.HIDE_ALL_VIEW                      = "hide_all_view" -- 关闭所有弹出界面
EventConst.GENERAL_SHOW_MOVE_RANGE            = "general_show_move_range" -- 武将显示其移动区域
EventConst.GENERAL_HIDE_MOVE_RANGE            = "general_hide_move_range" -- 武将隐藏其移动区域
EventConst.GENERAL_MOVE                       = "general_move" -- 武将进行移动
EventConst.GENERAL_AI_MOVE                    = "general_ai_move" -- ai武将进行移动(需要自己传入地图阻挡信息，并且支持回调而且不会显示战斗菜单)
EventConst.GENERAL_SMALLMAP_SHOW              = "general_smallmap_show" -- 武将在小地图出现
EventConst.GENERAL_SMALLMAP_MOVE              = "general_smallmap_move" -- 武将在小地图进行移动
EventConst.GENERAL_SMALLMAP_DONE              = "general_smallmap_done" -- 武将在小地图进行回合结束
EventConst.GENERAL_SMALLMAP_REFRESH           = "general_smallmap_refresh" -- 武将在小地图回合刷新
EventConst.GENERAL_DIE                        = "general_die" -- 武将死亡
EventConst.GENERAL_SHOW_MENU                  = "general_show_menu" -- 显示武将战斗菜单
EventConst.GENERAL_SHOW_TILE_VIEW             = "general_show_tile_view" -- 显示武将站在地形上的信息
EventConst.GENERAL_SHOW_ATTACK_RANGE          = "general_show_attack_range" -- 显示武将的攻击范围
EventConst.GENERAL_HIDE_ATTACK_RANGE          = "general_hide_attack_range" -- 显示武将的攻击范围
EventConst.GENERAL_SHOW_MAGIC_RANGE           = "general_show_magic_range" -- 显示武将的策略攻击范围
EventConst.GENERAL_HIDE_MAGIC_RANGE           = "general_hide_magic_range" -- 隐藏武将的策略攻击范围
EventConst.GENERAL_SHOW_ITEM_RANGE            = "general_show_item_range" -- 显示武将的道具使用范围
EventConst.GENERAL_HIDE_ITEM_RANGE            = "general_hide_item_range" -- 隐藏武将的道具使用范围
EventConst.GENERAL_ACTION_CANCEL              = "general_action_cancel" -- 点击战斗菜单取消
EventConst.GENERAL_ACTION_CANCEL_NO_ANIMATION = "general_action_cancel_no_animation" -- 点击战斗菜单取消无移动动画版本
EventConst.GENERAL_ACTION_STOP                = "general_action_stop" -- 点击战斗菜单待命
EventConst.GENERAL_ACTION_DONE                = "general_action_done" -- 武将行动完毕
EventConst.GENERAL_SHOW_MAGIC_MENU            = "general_show_magic_menu" -- 显示玩家武将策略菜单
EventConst.GENERAL_SHOW_ITEM_MENU             = "general_show_item_menu" -- 显示玩家武将道具菜单
EventConst.GENERAL_HP_CHANGE                  = "general_hp_change" -- 武将hp变化，为了血条变化
EventConst.GENERAL_LEVELUP                    = "general_levelup" -- 武将升级
EventConst.GENERAL_ARMYUP                     = "general_armyup" -- 武将职业｀升级
EventConst.SHOW_ATTACK_PREVIEW                = "show_attack_preview" -- 显示伤害预览界面
EventConst.HIDE_ATTACK_PREVIEW                = "hide_attack_preview" -- 隐藏伤害预览界面
EventConst.SHOW_MAGIC_PREVIEW                 = "show_magic_preview" -- 显示策略伤害预览界面
EventConst.HIDE_MAGIC_PREVIEW                 = "hide_magic_preview" -- 隐藏策略伤害预览界面
EventConst.SHOW_HURT_VIEW                     = "show_hurt_view" -- 显示受伤或进攻结算界面
EventConst.HIDE_ENEMY_HURT_VIEW               = "hide_enemy_hurt_view" -- 隐藏敌人或友军结算界面
EventConst.HIDE_PLAYER_HURT_VIEW              = "hide_player_hurt_view" -- 隐藏玩家武将结算界面
EventConst.TOUCH_MAGIC_BOX                    = "touch_magic_box" -- 用来更新策略攻击框
EventConst.TOUCH_ATTACK_BOX                   = "touch_attack_box" -- 用来更新物理攻击框
EventConst.ADD_NONTOUCH_LAYER                 = "add_nontouch_layer" -- 添加一个禁止触摸层
EventConst.REMOVE_NONTOUCH_LAYER              = "remove_nontouch_layer" -- 移除一个禁止触摸层
EventConst.REFRESH_ALL_GENERALS               = "refresh_all_generals" -- 重新刷新所有武将回合
EventConst.REFRESH_GENERALS                   = "refresh_generals" -- 重新刷新指定武将回合
EventConst.HIGHLIGHT_RANGE                    = "highlight_range" -- 高亮地图块
EventConst.HIGHLIGHT_GENERAL                  = "highlight_general" -- 高亮武将
EventConst.CHAT_DIALOG                        = "chat_dialog" -- 对话，交由mapView来控制位置
EventConst.PLOT_SHOW_DIALOG                   = "plot_show_dialog" -- 显示剧情对话
EventConst.PLOT_GENERAL_ACTION                = "plot_general_action" -- 显示武将工作
EventConst.PLOT_SHOW_GENERAL_ATTACK           = "plot_show_general_attack" -- 显示剧情武将攻击
EventConst.PLOT_SHOW_GENERAL                  = "plot_show_general" -- 显示剧情武将（同时小地图上也要显示）
EventConst.PLOT_SHOW_GENERAL_MOVE             = "plot_show_general_move" -- 显示剧情武将移动
EventConst.PLOT_SHOW_GENERAL_ACTION_DONE      = "plot_show_general_action_done" -- 显示剧情武将回合结束
EventConst.PLOT_SKIP_PLAYER_TURN              = "plot_skip_player_turn" -- 掠过我方回合
EventConst.PLOT_ADD_FIRE                      = "plot_add_fire" -- 地图上加火
EventConst.PLOT_SHOW_SPECIAL_ANIMATION        = "plot_show_special_animation" -- 显示特别动画
EventConst.PLOT_ADD_STATUS                    = "plot_add_status" -- 指定对象，添加状态
EventConst.PLOT_ADD_ITEM                      = "plot_add_item" -- 获得道具
EventConst.PLOT_FACE_TO_FACE                  = "plot_face_to_face" -- 武将互相朝向
EventConst.PLOT_SHOW_BATTLE_CONDTION_LAYER    = "plot_show_battle_condtion_layer" -- 显示战斗条件界面
EventConst.PLOT_SHOW_BATTLE_WIN_LAYER         = "plot_show_battle_win_layer" -- 显示战斗胜利界面
EventConst.PLOT_SHOW_BATTLE_LOSE_LAYER        = "plot_show_battle_lose_layer" -- 显示战斗失败界面
EventConst.PLOT_CHANGE_AI                     = "plot_change_ai" -- 指定武将ai变更
EventConst.PLOT_RANGE_CHANGE_AI               = "plot_range_change_ai" -- 范围内武将ai变更
EventConst.PLOT_GENERAL_STATUS_CHANGE         = "plot_general_status_change" -- 武将状态变更
EventConst.PLOT_GENERAL_RETREAT               = "plot_general_retreat" -- 武将撤退
EventConst.PLOT_RANGE_RETREAT                 = "plot_range_retreat" -- 范围内武将撤退
EventConst.PLOT_GENERAL_DISAPPEAR             = "plot_general_disappear" -- 武将消失
EventConst.PLOT_GENERALS_DISAPPEAR            = "plot_generals_disappear" -- 范围内武将消失
EventConst.PLOT_GENERAL_INIT_EQUIP            = "plot_general_init_equip" -- 指定武将初始化装备
EventConst.PLOT_GENERAL_ADD_LEVEL             = "plot_general_add_level" -- 指定武将等级增加
EventConst.PLOT_GENERAL_REBORN                = "plot_general_reborn" -- 指定武将复活
EventConst.PLOT_CHECK_CONDTION                = "plot_check_condtion" -- 战斗中的条件检测
EventConst.PLOT_RANGE_CHANGE_STATUS           = "plot_range_change_status" -- 指定范围内的武将状态变更
EventConst.PLOT_ALL_GENERALS_RECOVER          = "plot_all_generals_recover" -- 所有武将回合重置，且恢复满hp和mp
EventConst.PLOT_SHOW_CHOICES                  = "plot_show_choices" -- 显示s剧情选择框
EventConst.PLOT_PLAYER_INIT                   = "plot_player_init" -- 玩家武将坐标和隐藏朝向设置
EventConst.PLOT_SHOW_PLAYER_RETREATWORDS      = "plot_show_player_retreatwords" -- 玩家武将是否显示撤退台词
EventConst.PLOT_ADD_OBSTACLE                  = "plot_add_obstacle" -- 添加或移除障碍物
EventConst.PLOT_ADD_CAREERISM                 = "plot_add_careerism" -- 增加或减少野心值
EventConst.PK_SHOW_VIEW                       = "pk_show_view" -- 显示单挑界面
EventConst.PK_PREPARE                         = "pk_prepare" -- 单挑武将初始化
EventConst.PK_GENERAL_SHOW                    = "pk_general_show" -- 单挑武将入场
EventConst.PK_SHOW_START                      = "pk_show_start" -- 单挑开始显示
EventConst.PK_SHOW_DIALOG                     = "pk_show_dialog" -- 单挑对话框
EventConst.PK_GENERAL_ACTION                  = "pk_general_action" -- 单挑武将动作
EventConst.PK_GENERAL_ATTACK                  = "pk_general_attack" -- 单挑武将攻击
EventConst.PK_GENERAL_ATTACK2                 = "pk_general_attack2" -- 单挑武将攻击2
EventConst.PK_GENERAL_DIE                     = "pk_general_die" -- 单挑武将死亡
EventConst.PK_OVER                            = "pk_over" -- 单挑结束
EventConst.PLOT_OVER                          = "plot_over" -- 剧本执行结束
EventConst.BATTLE_START_PLOT_DONE             = "battle_start_plot_done" -- 开场战斗剧情结束
EventConst.NEXT_PLOT                          = "next_plot" -- 进入下一个剧本
EventConst.ADD_PLAYER                         = "add_player" -- 添加玩家武将
EventConst.SET_PLAYER_EQUIPS                  = "set_player_equips" -- 设置玩家武将装备
EventConst.SET_SCENE_NAME                     = "set_scene_name" -- 设置R剧本场景名
EventConst.SET_PLOT_TITLE                     = "set_plot_title" -- 设置R剧本标题名
EventConst.SHOW_PLOT_MENU                     = "show_plot_menu" -- 显示R剧本菜单(也就是出兵按钮这一堆玩意)
EventConst.ROLE_PRESSED_PLOT                  = "role_pressed_plot" -- 显示武将点击以后的剧情
EventConst.FIGHT_PRESSED_PLOT                 = "fight_pressed_plot" -- 点击出战按钮的剧情
EventConst.BATTLE_OVER                        = "battle_over" -- 战斗结束
EventConst.BATTLE_START                       = "battle_start" -- 战斗开始（目前仅为了重置ai_mgr中的战斗失败标记）
EventConst.FIGHT_PREPARE_DONE                 = "fight_prepare_done" -- 出阵选将确定
EventConst.GENERAL_BUTTON_PRESSED             = "general_button_pressed" -- 出阵候选武将的点击情况
EventConst.GENERAL_INFO_REFRESHED             = "general_info_refreshed" -- 出阵候选武将信息刷新
EventConst.UPDATE_SCENE_INDEX                 = "update_scene_index" -- 更新当前执行到的sceneIndex
EventConst.UPDATE_SECTION_INDEX               = "update_section_index" -- 更新当前执行到的sectionIndex
EventConst.NEW_GAME                           = "new_game" -- 重新开始
EventConst.AUTO_SAVE_DATA                     = "auto_save_data" -- 自动保存存档
EventConst.SAVE_DATA                          = "save_data" -- 保存存档
EventConst.LOAD_DATA                          = "load_data" -- 读取存档
EventConst.SHOW_WEATHER                       = "show_weather" -- 显示天气
EventConst.UI_GENERAL_SELECTED                = "ui_general_selected" -- ui界面中武将被选中
EventConst.UI_EQUIP_SELECTED                  = "ui_equip_selected" -- ui界面中装备被选中
EventConst.UI_SHOP_ITEM_SELECTED              = "ui_shop_item_selected" -- ui界面中商店道具被选中
EventConst.SPLOT_UI_ENABLED                   = "splot_ui_enabled" -- ui界面中商店道具被选中

return EventConst