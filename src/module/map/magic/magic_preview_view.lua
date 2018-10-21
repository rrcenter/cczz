--[[
    武将策略攻击伤害预览界面
    基本同武将地形界面，主要就是第二行会有一个红色进度条显示大概能费多少血
    第四行为，伤害和命中的描述

    同攻击策略基本一样，唯一不同目前参考仅策略
--]]

local GeneralViewBasic = import("..general.general_view_basic")

local ViewWidth  = MapConst.BLOCK_WIDTH * 4
local ViewHeight = MapConst.BLOCK_HEIGHT * 2

local MagicPreviewView = class("MagicPreviewView", function()
    return GeneralViewBasic.new()
end)

MagicPreviewView.ctor = function(self)
    -- 第四行 损伤描述信息
    local hurtLabel = display.newTTFLabel({text = "损伤", size = FontSize, font = FontName, color = MapViewConst.HURT_LABEL_COLOR})
    hurtLabel:align(display.LEFT_CENTER, 3, ViewHeight * 0.15)
    hurtLabel:addTo(self)
    self.hurtLabel = hurtLabel

    -- 第四行 损伤具体数值信息
    local hurtValueLabel = display.newTTFLabel({text = "100", size = FontSize, font = FontName, color = MapViewConst.NORMAL_LABEL_COLOR})
    hurtValueLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 1.4, ViewHeight * 0.15)
    hurtValueLabel:addTo(self)
    self.hurtValueLabel = hurtValueLabel

    -- 第四行 命中描述信息
    local hitrateLabel = display.newTTFLabel({text = "命中", size = FontSize, font = FontName, color = MapViewConst.HITRATE_LABEL_COLOR})
    hitrateLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 2.2, ViewHeight * 0.15)
    hitrateLabel:addTo(self)
    self.hitrateLabel = hitrateLabel

    -- 第四行 命中具体数值信息
    local hitrateValueLabel = display.newTTFLabel({text = "0%", size = FontSize, font = FontName})
    hitrateValueLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 3, ViewHeight * 0.15)
    hitrateValueLabel:addTo(self)
    self.hitrateValueLabel = hitrateValueLabel
end

--[[
点击敌人:
    1、预览策略hp伤害
    2、预览策略mp伤害
    3、预览策略能力降低

点击我军或友军：
    1、预览策略hp加成
    1、预览策略mp加成
    2、预览策略能力上升
--]]
MagicPreviewView.initFromGeneral = function(self, general, target, magicConfig)
    self:setNameString(target:getName(), target:getSide())

    local armyTypeText = string.format("%s Lv %d", target:getProfessionName(), target:getLevel())
    self.armyTypeLabel:setString(armyTypeText)

    self.hpLabel:setString(string.format("%d / %d", target:getCurrentHp(), target:getMaxHp()))
    self.mpLabel:setString(string.format("%d / %d", target:getCurrentMp(), target:getMaxMp()))

    local hpPercent = target:getCurrentHp() / target:getMaxHp() * 100
    local mpPercent = target:getCurrentMp() / target:getMaxMp() * 100

    local damgeInfo = GeneralUtils.calcMagicDamge(general, target, magicConfig)
    local hitrate = GeneralUtils.calcMagicHitrate(general, target, magicConfig) .. "%"
    if magicConfig.hurtType == "subHp" then
        self:updateView({
            hpPercent = hpPercent - damgeInfo.estimatedDamgePercentLimit,
            hpHurtPercent = hpPercent,
            mpPercent = mpPercent,
            hurtValueText = damgeInfo.estimatedDamgeLimit,
            hitrateValueText = hitrate,
        })

    elseif magicConfig.hurtType == "addHp" then
        self:updateView({
            hpPercent = hpPercent,
            hpHealPercent = hpPercent + damgeInfo.estimatedDamgePercentLimit,
            mpPercent = mpPercent,
            hurtText = "恢复HP",
            hurtColor = MapViewConst.HEAL_LABEL_COLOR,
            hurtValueText = -damgeInfo.estimatedDamgeLimit,
            hitrateText = "效果",
        })

    elseif magicConfig.hurtType == "subMp" then
        self:updateView({
            hpPercent = hpPercent,
            mpPercent = mpPercent - damgeInfo.estimatedDamgePercentLimit,
            mpHurtPercent = mpPercent,
            hurtValueText = damgeInfo.estimatedDamgeLimit,
            hitrateValueText = hitrate,
        })

    elseif magicConfig.hurtType == "addMp" then
        self:updateView({
            hpPercent = hpPercent,
            mpPercent = mpPercent,
            mpHealPercent = mpPercent + damgeInfo.estimatedDamgePercentLimit,
            hurtText = "恢复MP",
            hurtColor = MapViewConst.HEAL_LABEL_COLOR,
            hurtValueText = -damgeInfo.estimatedDamgeLimit,
            hitrateText = "效果",
            hitrateValueText = hitrate,
        })

    else
        self:updateView({
            hpPercent = hpPercent,
            mpPercent = mpPercent,
            hurtText = magicConfig.effectDesc,
            hitrateValueText = hitrate,
        })

    end
end

MagicPreviewView.updateView = function(self, params)
    self.hpProgress:setPercent(params.hpPercent or 0)
    self.healHpProgress:setPercent(params.hpHealPercent or 0)
    self.hurtHpProgress:setPercent(params.hpHurtPercent or 0)

    self.mpProgress:setPercent(params.mpPercent or 0)
    self.healMpProgress:setPercent(params.mpHealPercent or 0)
    self.hurtMpProgress:setPercent(params.mpHurtPercent or 0)

    self.hurtLabel:setString(params.hurtText or "损伤")
    self.hurtLabel:setColor(params.hurtColor or MapViewConst.HURT_LABEL_COLOR)

    if params.hurtValueText then
        self.hurtValueLabel:setString(params.hurtValueText)
        self.hurtValueLabel:show()
    else
        self.hurtValueLabel:hide()
    end

    self.hitrateLabel:setString(params.hitrateText or "命中")
    self.hitrateValueLabel:setString(params.hitrateValueText or "100%")
end

return MagicPreviewView