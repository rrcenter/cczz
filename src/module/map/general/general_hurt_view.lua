--[[
    敌人受伤界面
    同时也是敌人的结算界面，这里进行敌人的hp和mp的真正结算
    这里结算的处理，其实还需要调整：
    1、受伤结算，可能伤害hp或mp
    2、策略进攻结算，结算mp，这里还有可能增加mp（敌人施展谍报）
--]]

local GeneralViewBasic = import(".general_view_basic")

local ViewWidth  = MapConst.BLOCK_WIDTH * 4
local ViewHeight = MapConst.BLOCK_HEIGHT * 2

local GeneralHurtView = class("GeneralHurtView", function()
    return GeneralViewBasic.new()
end)

GeneralHurtView.ctor = function(self)
    self.hpNode:pos(0, -10)
    self.mpNode:pos(0, -20)
end

GeneralHurtView.initFromGeneral = function(self, general, hpDamge, mpDamge, callback)
    callback = callback or function() end

    self:setNameString(general:getName(), general:getSide())

    local armyTypeText = string.format("%s Lv %d", general:getProfessionName(), general:getLevel())
    self.armyTypeLabel:setString(armyTypeText)

    local maxHp = general:getMaxHp()
    local currentHp = general:getCurrentHp()
    self.hpLabel:setString(string.format("%d / %d", currentHp, maxHp))
    self.hpProgress:setPercent(currentHp / maxHp * 100)

    local maxMp = general:getMaxMp()
    local currentMp = general:getCurrentMp()
    self.mpLabel:setString(string.format("%d / %d", currentMp, maxMp))
    self.mpProgress:setPercent(currentMp / maxMp * 100)

    local seq = transition.sequence({
        cca.delay(SHORT_ANIMATION_TIME), cca.cb(function()
            self:updateProgress(hpDamge * 0.3, currentHp, maxHp, "hp")
            self:updateProgress(mpDamge * 0.3, currentMp, maxMp, "mp")
        end),
        cca.delay(SHORT_ANIMATION_TIME), cca.cb(function()
            self:updateProgress(hpDamge * 0.6, currentHp, maxHp, "hp")
            self:updateProgress(mpDamge * 0.6, currentMp, maxMp, "mp")
        end),
        cca.delay(SHORT_ANIMATION_TIME), cca.cb(function()
            self:updateProgress(hpDamge, currentHp, maxHp, "hp")
            self:updateProgress(mpDamge, currentMp, maxMp, "mp")
        end),
        cca.delay(SHORT_ANIMATION_TIME), cca.cb(function()
            EventMgr.triggerEvent(EventConst.HIDE_ENEMY_HURT_VIEW)

            if mpDamge > 0 then
                general:subMp(mpDamge)
            elseif mpDamge < 0 then
                general:addMp(-mpDamge)
            end

            general:subHp(hpDamge, callback)
        end)
    })
    self:runAction(seq)
end

GeneralHurtView.updateProgress = function(self, damge, currentValue, maxValue, prop)
    local newValue = currentValue - damge
    if newValue < 0 then
        newValue = 0
    elseif newValue > maxValue then
        newValue = maxValue
    end

    self[prop .. "Label"]:setString(string.format("%d / %d", newValue, maxValue))
    self[prop .. "Progress"]:setPercent(newValue / maxValue * 100)
end

GeneralHurtView.hide = function(self)
    self:stop()
    self:setVisible(false)
end

return GeneralHurtView