--[[
    武将攻击伤害预览界面
    基本同武将地形界面，主要就是第二行会有一个红色进度条显示大概能费多少血
    第四行为，伤害和命中的描述
--]]

local GeneralViewBasic = import("..general.general_view_basic")

local ViewWidth  = MapConst.BLOCK_WIDTH * 4
local ViewHeight = MapConst.BLOCK_HEIGHT * 2

local AttackPreviewView = class("AttackPreviewView", function()
    return GeneralViewBasic.new()
end)

AttackPreviewView.ctor = function(self)
    -- 第四行 损伤描述信息
    local hurtLabel = display.newTTFLabel({text = "损伤", size = FontSize, font = FontName, color = MapViewConst.HURT_LABEL_COLOR})
    hurtLabel:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, ViewHeight * 0.15)
    hurtLabel:addTo(self)

    -- 第四行 损伤具体数值信息
    local hurtValueLabel = display.newTTFLabel({text = "100", size = FontSize, font = FontName, color = MapViewConst.NORMAL_LABEL_COLOR})
    hurtValueLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 1.2, ViewHeight * 0.15)
    hurtValueLabel:addTo(self)
    self.hurtValueLabel = hurtValueLabel

    -- 第四行 命中描述信息
    local hitrateLabel = display.newTTFLabel({text = "命中", size = FontSize, font = FontName, color = MapViewConst.HITRATE_LABEL_COLOR})
    hitrateLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 2.2, ViewHeight * 0.15)
    hitrateLabel:addTo(self)

    -- 第四行 命中具体数值信息
    local hitrateValueLabel = display.newTTFLabel({text = "100%", size = FontSize, font = FontName})
    hitrateValueLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 3, ViewHeight * 0.15)
    hitrateValueLabel:addTo(self)
    self.hitrateValueLabel = hitrateValueLabel
end

AttackPreviewView.initFromGeneral = function(self, general, target)
    self:setNameString(target:getName(), target:getSide())

    local armyTypeText = string.format("%s Lv %d", target:getProfessionName(), target:getLevel())
    self.armyTypeLabel:setString(armyTypeText)

    self.hpLabel:setString(string.format("%d / %d", target:getCurrentHp(), target:getMaxHp()))
    self.mpLabel:setString(string.format("%d / %d", target:getCurrentMp(), target:getMaxMp()))

    local hpPercent = target:getCurrentHp() / target:getMaxHp() * 100
    local mpPercent = target:getCurrentMp()/ target:getMaxMp() * 100
    local damgeInfo = GeneralUtils.calcAttackDamge(general, target)
    if damgeInfo.type == "mp" then
        self.mpProgress:setPercent(mpPercent - damgeInfo.estimatedDamgePercentLimit)
        self.hurtMpProgress:setPercent(mpPercent)
        self.hpProgress:setPercent(hpPercent)
        self.hurtHpProgress:setPercent(0)
        printInfo("点击区域武将(%s)，当前MP百分比:%d, 预计造成伤害百分比:%d", target:getName(), mpPercent, damgeInfo.estimatedDamgePercentLimit)
    else
        self.hpProgress:setPercent(hpPercent - damgeInfo.estimatedDamgePercentLimit)
        self.hurtHpProgress:setPercent(hpPercent)
        self.mpProgress:setPercent(mpPercent)
        self.hurtMpProgress:setPercent(0)
        printInfo("点击区域武将(%s)，当前HP百分比:%d, 预计造成伤害百分比:%d", target:getName(), hpPercent, damgeInfo.estimatedDamgePercentLimit)
    end

    self.hurtValueLabel:setString(damgeInfo.estimatedDamgeLimit)
    self.hitrateValueLabel:setString(GeneralUtils.calcAttackHitrate(general, target))
end

return AttackPreviewView