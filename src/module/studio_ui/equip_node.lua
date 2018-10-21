--[[
    装备道具
--]]

local EquipNode = class("EquipNode", function()
    return cc.uiloader:load("ccz/ui/EquipNode.csb")
end)

EquipNode.ctor = function(self, itemInfo)
    self:initUI()
    self:initTouchEvent()
    self:refreshUI(itemInfo)
end

EquipNode.initUI = function(self)
    self.panel             = UIHelper.seekNodeByName(self, "Panel")
    self.itemSprite        = UIHelper.seekNodeByName(self, "ItemSprite")
    self.itemTypeLabel     = UIHelper.seekNodeByName(self, "ItemTypeLabel")
    self.itemNameLabel     = UIHelper.seekNodeByName(self, "ItemNameLabel")
    self.lvTitleLabel      = UIHelper.seekNodeByName(self, "LvTitleLabel")
    self.lvLabel           = UIHelper.seekNodeByName(self, "LvLabel")
    self.expTitleLabel     = UIHelper.seekNodeByName(self, "ExpTitleLabel")
    self.expNode           = UIHelper.seekNodeByName(self, "ExpProgress")
    self.expProgress       = UIHelper.seekNodeByName(self, "ProgressBar")
    self.expLabel          = UIHelper.seekNodeByName(self, "ProgressLabel")
    self.abilityKeyLabel   = UIHelper.seekNodeByName(self, "AbilityKeyLabel")
    self.abilityValueLabel = UIHelper.seekNodeByName(self, "AbilityValueLabel")
    self.effectLabel       = UIHelper.seekNodeByName(self, "EffectLabel")
    self.selectedSprite    = UIHelper.seekNodeByName(self, "SelectedSprite")
end

EquipNode.refreshUI = function(self, itemInfo)
    local equipConfig = InfoUtil.getItemConfig(itemInfo.itemId)
    self.itemInfo     = itemInfo
    self.equipConfig  = equipConfig

    self.itemSprite:setTexture(InfoUtil.getPath(equipConfig.icon, "equip"))
    self.itemTypeLabel:setString(equipConfig.type .. ":")
    self.itemNameLabel:setString(equipConfig.name)
    if equipConfig.cost then
        self.itemNameLabel:setColor(display.COLOR_WHITE)
    end

    if itemInfo.level then
        self.lvLabel:setString(itemInfo.level)
        self.expProgress:setPercent(itemInfo.exp)
        if itemInfo.exp < 100 then
            self.expLabel:setString(itemInfo.exp .. "/100")
        else
            self.expLabel:setString("Max")
        end
    else
        self.lvTitleLabel:hide()
        self.lvLabel:hide()
        self.expTitleLabel:hide()
        self.expNode:hide()
    end

    if equipConfig.addAbility then
        self.abilityKeyLabel:setString(PropMappingInfo[equipConfig.addAbility.abilityName])

        local value = equipConfig.addAbility.baseValue + equipConfig.addAbility.addtionValue * (itemInfo.level - 1)
        self.abilityValueLabel:setString("+" .. value)
    else
        self.abilityKeyLabel:hide()
        self.abilityValueLabel:hide()
    end

    if equipConfig.effectDesc then
        self.effectLabel:setString(equipConfig.effectDesc)
    else
        self.effectLabel:hide()
    end
end

EquipNode.initTouchEvent = function(self)
    self.panel:setSwallowTouches(false)
    self.panel:addTouchEventListener(function(sender, et)
        if et == ccui.TouchEventType.moved then
            return
        elseif et == ccui.TouchEventType.ended then
            self:selected(true)
            printInfo("选中装备：%s", self.itemInfo.itemId)
            EventMgr.triggerEvent(EventConst.UI_EQUIP_SELECTED, self)
        end
    end)
end

EquipNode.addTo = function(self, parent)
    parent:addChild(self)
end

EquipNode.selected = function(self, isSelected)
    self.selectedSprite:setVisible(isSelected)
end

EquipNode.getWidth = function(self)
    self.width = self.width or self.panel:getContentSize().width
    return self.width
end

EquipNode.getHeight = function(self)
    self.height = self.height or self.panel:getContentSize().height
    return self.height
end

EquipNode.center = function(self)
    self:pos(self:getWidth() / 2, self:getHeight() / 2)
end

-- 获取装备附加的五围属性
EquipNode.getAddProps = function(self)
    if not self.equipConfig then
        return {}
    end

    local props = {}
    if self.equipConfig.addAbility then
        local addAbility = self.equipConfig.addAbility
        props[addAbility.abilityName] = addAbility.baseValue + addAbility.addtionValue * (self.itemInfo.level - 1)
    end

    if self.equipConfig.effect then
        local effect = self.equipConfig.effect
        if effect.type == EquipEffectInfo.EFFECT_ADD_PROP.value then
            table.walk(effect.props, function(propName)
                assert(effect.valueType == "fix", "仅仅允许增加固定属性的装备，暂不支持百分比")
                props[propName] = props[propName] or 0
                props[propName] = props[propName] + effect.value
            end)
        end
    end

    return props
end

EquipNode.getType = function(self)
    return self.equipConfig.type
end

EquipNode.getEquipInfo = function(self)
    return self.itemInfo
end

return EquipNode