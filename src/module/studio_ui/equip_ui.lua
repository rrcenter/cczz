--[[
    装备界面
--]]

local EquipNode   = import(".equip_node")
local PopMenu     = import(".pop_menu")
local GeneralNode = import(".general_node")

local PROPS_MAPPING = {
    [GeneralDataConst.PROP_LEVEL]     = "GeneralLevel",
    [GeneralDataConst.PROP_HPMAX]     = "Hp",
    [GeneralDataConst.PROP_MPMAX]     = "Mp",
    [GeneralDataConst.PROP_ATTACK]    = "Attack",
    [GeneralDataConst.PROP_DEFENSE]   = "Defense",
    [GeneralDataConst.PROP_MENTALITY] = "Mentality",
    [GeneralDataConst.PROP_EXPLODE]   = "Explode",
    [GeneralDataConst.PROP_MORALE]    = "Morale",
    [GeneralDataConst.PROP_MOVEMENT]  = "Movement",
}

local EQUIP_MAPPING = {
    ["武器"] = GeneralDataConst.EQUIP_WUQI,
    ["防具"] = GeneralDataConst.EQUIP_FANGJU,
    ["辅助"] = GeneralDataConst.EQUIP_SHIPING,
}

local EquipUI = class("EquipUI", function()
    return display.newLayer()
end)

EquipUI.ctor = function(self, callback)
    self.callback = callback or function() end

    self:initUI()
    self:initGeneralsList()
    self:initButtonEvent()
    self:initEventHandles()

    self:center()
    self:setNodeEventEnabled(true)
end

EquipUI.onExit = function(self)
    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.handlers = nil
end

EquipUI.initEventHandles = function(self)
    self.handlers = {
        [EventConst.UI_GENERAL_SELECTED] = handler(self, self.generalSelected),
        [EventConst.UI_EQUIP_SELECTED] = handler(self, self.equipSelected),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

EquipUI.initPopMenu = function(self)
    self.popMenu = PopMenu.new("装备", {{text = "装上", callback = handler(self, self.equipSwap)}})
    self.popMenu:scale(0.8)
    self.popMenu:hide()
    self.popMenu:addTo(self.equipList)
end

EquipUI.initUI = function(self)
    self.uiNode = cc.uiloader:load("ccz/ui/EquipUI.csb")
    self.uiNode:scale(0.9)
    self.uiNode:addTo(self)

    self.equipList = UIHelper.seekNodeByName(self.uiNode, "EquipsListView")
    self.generalList = UIHelper.seekNodeByName(self.uiNode, "GeneralsListView")
end

EquipUI.initGeneralsList = function(self)
    self.generalList:setClippingType(1)

    local listSize = self.generalList:getContentSize()
    local allGeneralIds = GeneralDataMgr.getAllGeneralIds()
    for i, generalId in ipairs(allGeneralIds) do
        local node = GeneralNode.new(generalId)
        node:center()

        local layout = ccui.Layout:create()
        layout:size(node:getWidth(), node:getHeight())
        layout:addChild(node)
        self.generalList:pushBackCustomItem(layout)

        if i == 1 then
            node:selected(true)
            self.selectedGeneralNode = node
            self:refreshGeneralView(generalId)
            self:refreshEquipsList(generalId)
        end
    end
end

EquipUI.initButtonEvent = function(self)
    UIHelper.buttonRegisterByName(self, "CloseButton", function()
        self.callback()
        self:removeSelf()
    end)
end

EquipUI.refreshGeneralView = function(self, generalId)
    self:refreshGeneralEquips(generalId)
    self:refreshGeneralProps(generalId)
end

EquipUI.refreshEquipsList = function(self, generalId)
    local EQUIP_SCALE = 0.8
    -- 为了裁剪有用，1相当于镂空，0相当于模板，模板在此版本有问题，需要开启深度测试才可以
    -- 参见：http://www.cocoachina.com/bbs/read.php?tid-213932-keyword-uilistview.html
    self.equipList:setClippingType(1)
    self.equipList:removeAllItems()

    local equipListSize = self.equipList:getContentSize()
    local tmpNode = cc.uiloader:load("ccz/ui/EquipNode.csb")
    local nodeSize = UIHelper.seekNodeByName(tmpNode, "Panel"):getContentSize()
    local padding = (equipListSize.width - nodeSize.width * 2 * EQUIP_SCALE) / 3

    local createEquipNode = function(itemInfo, isLeft, x)
        local node = EquipNode.new(itemInfo, isLeft)
        node:setScale(EQUIP_SCALE, 1)
        node:pos(x + node:getWidth() / 2 * EQUIP_SCALE, node:getHeight() / 2)
        return node
    end

    local armyType = GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_ARMYTYPE)
    local allEquips = GameData.getAllEquips(armyType)
    for i = 1, #allEquips, 2 do
        local layout = ccui.Layout:create()
        layout:size(equipListSize.width, nodeSize.height + 10)
        self.equipList:pushBackCustomItem(layout)

        local node1 = createEquipNode(allEquips[i], true, padding)
        node1:addTo(layout)

        if allEquips[i + 1] then
            local node2 = createEquipNode(allEquips[i + 1], false, padding + nodeSize.width * EQUIP_SCALE)
            node2:addTo(layout)
        end
    end

    self:initPopMenu()
end

EquipUI.refreshGeneralEquips = function(self, generalId)
    local initEquipNode = function(nodeName, id, level, exp)
        local node              = UIHelper.seekNodeByName(self.uiNode, nodeName)
        local itemSprite        = UIHelper.seekNodeByName(node, "ItemSprite")
        local itemTypeLabel     = UIHelper.seekNodeByName(node, "ItemTypeLabel")
        local itemNameLabel     = UIHelper.seekNodeByName(node, "ItemNameLabel")
        local lvTitleLabel      = UIHelper.seekNodeByName(node, "LvTitleLabel")
        local lvLabel           = UIHelper.seekNodeByName(node, "LvLabel")
        local expTitleLabel     = UIHelper.seekNodeByName(node, "ExpTitleLabel")
        local expNode           = UIHelper.seekNodeByName(node, "ExpProgress")
        local expProgress       = UIHelper.seekNodeByName(node, "ProgressBar")
        local expLabel          = UIHelper.seekNodeByName(node, "ProgressLabel")
        local abilityKeyLabel   = UIHelper.seekNodeByName(node, "AbilityKeyLabel")
        local abilityValueLabel = UIHelper.seekNodeByName(node, "AbilityValueLabel")
        local effectLabel       = UIHelper.seekNodeByName(node, "EffectLabel")

        local isShow = id and true or false
        itemSprite:setVisible(isShow)
        lvTitleLabel:setVisible(isShow)
        lvLabel:setVisible(isShow)
        expTitleLabel:setVisible(isShow)
        expNode:setVisible(isShow)
        abilityKeyLabel:setVisible(isShow)
        abilityValueLabel:setVisible(isShow)
        effectLabel:setVisible(isShow)

        if not id then
            if nodeName == "WuqiNode" then
                itemTypeLabel:setString("武器:")
            elseif nodeName == "FangjuNode" then
                itemTypeLabel:setString("防具:")
            else
                itemTypeLabel:setString("辅助:")
            end
            itemNameLabel:setString("无")
            itemNameLabel:setColor(display.COLOR_WHITE)

            return
        end

        local config = InfoUtil.getItemConfig(id)
        itemSprite:setTexture(InfoUtil.getPath(config.icon, "equip"))
        itemTypeLabel:setString(config.type .. ":")
        itemNameLabel:setString(config.name)
        if config.cost then
            itemNameLabel:setColor(display.COLOR_WHITE)
        end

        if level then
            lvLabel:setString(level)
            expProgress:setPercent(exp)
            if exp < 100 then
                expLabel:setString(exp .. "/100")
            else
                expLabel:setString("Max")
            end
        else
            lvTitleLabel:hide()
            lvLabel:hide()
            expTitleLabel:hide()
            expNode:hide()
        end

        if config.addAbility then
            abilityKeyLabel:setString(PropMappingInfo[config.addAbility.abilityName])

            local value = config.addAbility.baseValue + config.addAbility.addtionValue * (level - 1)
            abilityValueLabel:setString("+" .. value)
        else
            abilityKeyLabel:hide()
            abilityValueLabel:hide()
        end

        if config.effectDesc then
            effectLabel:setString(config.effectDesc)
        else
            effectLabel:hide()
        end
    end

    local EQUIP_MAPPING = {
        ["WuqiNode"]    = GeneralDataConst.EQUIP_WUQI,
        ["FangjuNode"]  = GeneralDataConst.EQUIP_FANGJU,
        ["ShipingNode"] = GeneralDataConst.EQUIP_SHIPING,
    }

    table.walk(EQUIP_MAPPING, function(equipType, equipNodeName)
        local equip = GeneralDataMgr.getEquip(generalId, equipType)
        initEquipNode(equipNodeName, equip:getId(), equip:getLevel(), equip:getExp())
    end)
end

EquipUI.refreshGeneralProps = function(self, generalId)
    table.walk(PROPS_MAPPING, function(propName, prop)
        local value = GeneralDataMgr.getProp(generalId, prop)
        print(value, propName, prop, generalId)
        local label = UIHelper.seekNodeByName(self.uiNode, propName .. "Label")
        label:setString(value)
    end)

    local armyNameLabel = UIHelper.seekNodeByName(self.uiNode, "ArmyNameLabel")
    armyNameLabel:setString(GeneralDataMgr.getProp(generalId, GeneralDataConst.PROP_ARMYNAME))
end

EquipUI.generalSelected = function(self, generalNode)
    if self.selectedGeneralNode ~= generalNode then
        self.selectedGeneralNode:selected(false)
        generalNode:selected(true)
        self.selectedGeneralNode = generalNode

        self.selectedEquipNode = nil
        self:refreshEquipsList(generalNode:getGeneralId())
        self:refreshGeneralView(generalNode:getGeneralId())
    end
end

EquipUI.equipSelected = function(self, equipNode)
    if self.selectedEquipNode ~= equipNode then
        if self.selectedEquipNode then
            self.selectedEquipNode:selected(false)
        end

        equipNode:selected(true)
        self.selectedEquipNode = equipNode
        self:refreshSelectEquipInfluence(equipNode:getType())

        local y = equipNode:getHeight() + equipNode:getParent():getPositionY()
        if equipNode:getPositionX() < equipNode:getWidth() then
            self.popMenu:show(true, display.LEFT_CENTER, equipNode:getPositionX() + equipNode:getWidth() * equipNode:getScaleX() * 0.8, y)
        else
            self.popMenu:show(false, display.RIGHT_CENTER, equipNode:getPositionX() - equipNode:getWidth() * equipNode:getScaleX() * 0.3, y)
        end
    else
        self:hideSelectedEquip()
    end
end

EquipUI.hideSelectedEquip = function(self)
    self:hideEquipInfluence()

    if self.selectedEquipNode then
        self.selectedEquipNode:selected(false)
        self.selectedEquipNode = nil
    end

    self.popMenu:hide()
end

EquipUI.hideEquipInfluence = function(self)
    table.walk(PROPS_MAPPING, function(propName)
        local label = UIHelper.seekNodeByName(self.uiNode, propName .. "ChangeLabel")
        if label then
            label:hide()
        end
    end)
end

-- 显示选中道具对武将属性的影响（不计算对应装备卸下的影响）
EquipUI.refreshSelectEquipInfluence = function(self, equipType)
    local selfProps = self:getAddProps(equipType)
    local influenceProps = self.selectedEquipNode:getAddProps()
    table.walk(PROPS_MAPPING, function(propName)
        local label = UIHelper.seekNodeByName(self.uiNode, propName .. "ChangeLabel")
        if influenceProps[propName] then
            label:show()

            local value =  selfProps[propName] or 0
            if value > influenceProps[propName] then
                label:setString("-" .. (value - influenceProps[propName]))
                label:setColor(display.COLOR_RED)
            elseif value == influenceProps[propName] then
                label:hide()
            else
                label:setString("+" .. (influenceProps[propName] - value))
                label:setColor(display.COLOR_GREEN)
            end
        elseif label then
            label:hide()
        end
    end)
end

EquipUI.getAddProps = function(self, equipType)
    local getEquipAddProps = function(generalId, equipType)
        local equipId = GeneralDataMgr.getEquip(generalId, equipType):getId()
        local level = GeneralDataMgr.getEquip(generalId, equipType):getLevel()
        local equipConfig = InfoUtil.getItemConfig(equipId)
        local props = {}
        if equipConfig.addAbility then
            local addAbility = equipConfig.addAbility
            props[addAbility.abilityName] = addAbility.baseValue + addAbility.addtionValue * (level - 1)
        end

        if equipConfig.effect then
            local effect = equipConfig.effect
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

    local generalId = self.selectedGeneralNode:getGeneralId()
    for et, name in pairs(EQUIP_MAPPING) do
        if name == equipType and GeneralDataMgr.getEquip(generalId, et):getId() then
            return getEquipAddProps(generalId, et)
        end
    end

    return {}
end

-- 装备装上
EquipUI.equipSwap = function(self)
    self.popMenu:hide()

    local generalId         = self.selectedGeneralNode:getGeneralId()
    local selectedEquipType = self.selectedEquipNode:getType()
    local selectedEquip     = self.selectedEquipNode:getEquipInfo()

    table.walk(EQUIP_MAPPING, function(equipType, equipName)
        if selectedEquipType == equipName then
            local equip = GeneralDataMgr.getEquip(generalId, equipType)
            if equip:isExisted() then
                self.selectedEquipNode:refreshUI({itemId = equip:getId(), level = equip:getLevel(), exp = equip:getExp()})
            end
            self:hideSelectedEquip()

            GameData.changePlayerEquip(generalId, equipType, selectedEquip.itemId, selectedEquip.level, selectedEquip.exp, selectedEquip.itemIndex)

            self:refreshGeneralView(generalId)
            self:refreshEquipsList(generalId)
        end
    end)
end

return EquipUI