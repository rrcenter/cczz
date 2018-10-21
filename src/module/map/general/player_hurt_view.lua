--[[
    玩家武将结算界面
--]]

local GeneralViewBasic = import(".general_view_basic")

local ViewWidth    = MapConst.BLOCK_WIDTH * 4
local ViewHeight   = MapConst.BLOCK_HEIGHT * 3
local HpMpWidth    = ViewWidth * 0.6
local HpMpHeight   = 8
local HpMpViewRect = cc.rect(0, 0, HpMpWidth, HpMpHeight)

local PlayerHurtView = class("PlayerHurtView", function()
    return GeneralViewBasic.new(ViewWidth, ViewHeight)
end)

PlayerHurtView.ctor = function(self)
    -- 第四行 EXP
    self.expNode = display.newNode()
    self.expNode:addTo(self)

    local expSprite = display.newSprite("ccz/general/tile_view/exp.png")
    expSprite:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, ViewHeight * 0.25)
    expSprite:addTo(self.expNode)

    local expProgress = cc.ui.UILoadingBar.new({
        scale9 = true,
        capInsets = cc.rect(0, 0, 8, 8),
        image = "ccz/general/tile_view/exp_fg.png",
        viewRect = HpMpViewRect,
        percent = 0,
    })
    expProgress:align(display.CENTER, MapConst.BLOCK_WIDTH * 2.5 / 2, expSprite:getPositionY())
    expProgress:addTo(self.expNode, 2)
    self.expProgress = expProgress

    -- 生成一个黑色进度条底图
    display.newRect(cc.rect(expProgress:getPositionX(), expSprite:getPositionY(), HpMpWidth, HpMpHeight), {fillColor = BlackColor, borderWidth = 0}):addTo(self.expNode)

    local expLabel = display.newTTFLabel({text = "0 / 100", size = FontSize, font = FontName})
    expLabel:align(display.CENTER_BOTTOM, MapConst.BLOCK_WIDTH * 2.5, expSprite:getPositionY())
    expLabel:addTo(self.expNode, 3)
    self.expLabel = expLabel

    self.hpNode:pos(0, 15)
    self.mpNode:pos(0, 15)

    -- 第五行 描述信息
    local wuqiSprite = display.newSprite("ccz/general/tile_view/wuqi.png")
    wuqiSprite:align(display.CENTER, MapConst.BLOCK_WIDTH * 0.5, ViewHeight * 0.1)
    wuqiSprite:addTo(self)
    wuqiSprite:hide()
    self.wuqiSprite = wuqiSprite

    local wuqiLabel = display.newTTFLabel({text = "0", size = FontSize, font = FontName})
    wuqiLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 1.5, wuqiSprite:getPositionY())
    wuqiLabel:hide()
    wuqiLabel:addTo(self)
    self.wuqiLabel = wuqiLabel

    local fangjuSprite = display.newSprite("ccz/general/tile_view/fangju.png")
    fangjuSprite:align(display.CENTER, MapConst.BLOCK_WIDTH * 2.5, ViewHeight * 0.1)
    fangjuSprite:hide()
    fangjuSprite:addTo(self)
    self.fangjuSprite = fangjuSprite

    local fangjuLabel = display.newTTFLabel({text = "0", size = FontSize, font = FontName})
    fangjuLabel:align(display.CENTER, MapConst.BLOCK_WIDTH * 3.5, fangjuSprite:getPositionY())
    fangjuLabel:hide()
    fangjuLabel:addTo(self)
    self.fangjuLabel = fangjuLabel
end

PlayerHurtView.initFromGeneral = function(self, general, hpDamge, mpDamge, exp, wuqiExp, fangjuExp, callback)
    callback = callback or function() end

    local currentExp = general:getCurrentExp()
    if exp > 0 then
        general:addExp(exp)
    end

    local equipWuqi = general:getEquipment(GeneralDataConst.EQUIP_WUQI)
    local currentWuqiExp = equipWuqi:getExp()
    if wuqiExp > 0 then
        equipWuqi:addExp(wuqiExp)
    end

    local equipFangju = general:getEquipment(GeneralDataConst.EQUIP_FANGJU)
    local currentFangjuExp = equipFangju:getExp()
    if fangjuExp > 0 then
        equipFangju:addExp(fangjuExp)
    end

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

    local maxExp = GeneralUtils.getPropMaxLimit("exp")
    if currentExp ~= "Max" then
        self.expLabel:setString(string.format("%d / %d", currentExp, maxExp))
        self.expProgress:setPercent(currentExp / maxExp * 100)
    else
        self.expLabel:setString(currentExp)
        self.expProgress:setPercent(100)
    end

    self:updateWuqiAndFangjuExp(equipWuqi, equipFangju, currentWuqiExp, currentFangjuExp)

    local seq = transition.sequence({
        cca.delay(SHORT_ANIMATION_TIME), cca.cb(function()
            self:updateProgress(hpDamge * 0.3, currentHp, maxHp, "hp")
            self:updateProgress(mpDamge * 0.3, currentMp, maxMp, "mp")
            self:updateProgress(-exp * 0.3, currentExp, maxExp, "exp")
        end),
        cca.delay(SHORT_ANIMATION_TIME), cca.cb(function()
            self:updateProgress(hpDamge * 0.6, currentHp, maxHp, "hp")
            self:updateProgress(mpDamge * 0.6, currentMp, maxMp, "mp")
            self:updateProgress(-exp * 0.6, currentExp, maxExp, "exp")

            -- 随便放在这里，让武器或防具经验改变
            self:updateWuqiAndFangjuExp(equipWuqi, equipFangju)
        end),
        cca.delay(SHORT_ANIMATION_TIME), cca.cb(function()
            self:updateProgress(hpDamge, currentHp, maxHp, "hp")
            self:updateProgress(mpDamge, currentMp, maxMp, "mp")
            self:updateProgress(-exp, currentExp, maxExp, "exp")
        end),
        cca.delay(SHORT_ANIMATION_TIME), cca.cb(function()
            EventMgr.triggerEvent(EventConst.HIDE_PLAYER_HURT_VIEW)

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

PlayerHurtView.updateProgress = function(self, damge, currentValue, maxValue, prop)
    if currentValue == "Max" then
        return
    end

    local newValue = currentValue - damge
    if newValue < 0 then
        newValue = 0
    elseif newValue > maxValue then
        newValue = maxValue
    end

    self[prop .. "Label"]:setString(string.format("%d / %d", newValue, maxValue))
    self[prop .. "Progress"]:setPercent(newValue / maxValue * 100)
end

PlayerHurtView.updateWuqiAndFangjuExp = function(self, equipWuqi, equipFangju, currentWuqiExp, currentFangjuExp)
    currentWuqiExp = currentWuqiExp or equipWuqi:getExp()
    currentFangjuExp = currentFangjuExp or equipFangju:getExp()

    if equipWuqi:isExisted() then
        self.wuqiLabel:setString(currentWuqiExp)
        self.wuqiLabel:show()
        self.wuqiSprite:show()
    else
        self.wuqiLabel:hide()
        self.wuqiSprite:hide()
    end

    if equipFangju:isExisted() then
        self.fangjuLabel:setString(currentFangjuExp)
        self.fangjuLabel:show()
        self.fangjuSprite:show()
    else
        self.fangjuLabel:hide()
        self.fangjuSprite:hide()
    end
end

PlayerHurtView.hide = function(self)
    self:stop()
    self:setVisible(false)
end

return PlayerHurtView