--[[
    被选中的上阵武将
--]]

local SelectedGeneralButton = class("SelectedGeneralButton", function()
    return display.newSprite()
end)

SelectedGeneralButton.ctor = function(self, generalId)
    self.res = "ccz/general/icon/general_icons"
    ResMgr.addSpriteFrames(self.res)

    self:align(display.LEFT_BOTTOM)
    self:setSpriteFrame(InfoUtil.getPath(GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_RES), "generalIcon"))
    self:setNodeEventEnabled(true)
end

SelectedGeneralButton.onExit = function(self)
    ResMgr.removeSpriteFramesWithFile(self.res)
end

-- 必须上阵的
SelectedGeneralButton.mustSelected = function(self)
    self:setColor(cc.c3b(50, 50, 50))
end

return SelectedGeneralButton