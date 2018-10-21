--[[
    地图UI上的相关常量
--]]

local MapViewConst = {}

MapViewConst.ZORDER_FIRE                = 10
MapViewConst.ZORDER_OBSTACLE            = 10
MapViewConst.ZORDER_SELECT_BOX          = 12
MapViewConst.ZORDER_GENERAL             = 20
MapViewConst.ZORDER_MOVE_LAYER          = 21
MapViewConst.ZORDER_ATTACK_LAYER        = 22
MapViewConst.ZORDER_MAGIC_LAYER         = 22
MapViewConst.ZORDER_ITEM_LAYER          = 22
MapViewConst.ZORDER_MAP_TILE_VIEW       = 40
MapViewConst.ZORDER_GENERAL_TILE_VIEW   = 40
MapViewConst.ZORDER_ATTACK_PREVIEW_VIEW = 40
MapViewConst.ZORDER_MAGIC_PREVIEW_VIEW  = 40
MapViewConst.ZORDER_HURT_VIEW           = 40
MapViewConst.ZORDER_GENERAL_MENU        = 50
MapViewConst.ZORDER_MAGIC_MENU          = 50
MapViewConst.ZORDER_ITEM_MENU           = 50

MapViewConst.HURT_LABEL_COLOR           = FontOrangeColor
MapViewConst.HEAL_LABEL_COLOR           = FontWaterBlueColor
MapViewConst.NORMAL_LABEL_COLOR         = FontWhiteColor
MapViewConst.HITRATE_LABEL_COLOR        = FontYellowColor
MapViewConst.GENERAL_TILE_COLOR         = FontGreenColor

MapViewConst.TILE_RECT                  = cc.rect(0, 0, MapConst.BLOCK_WIDTH, MapConst.BLOCK_HEIGHT)

return MapViewConst