--[[
    点击出兵以后的出阵选择武将界面
--]]

local OpitionalGeneralButton = import(".opitional_general_button")
local SelectedGeneralButton = import(".selected_general_button")

local FightPrepareUI = class("FightPrepareUI", function()
    return display.newLayer()
end)

FightPrepareUI.ctor = function(self, playerList, callback)
    self.callback = callback or function() end
    self.maxLimit = playerList.maxLimit
    self.minLimit = playerList.minLimit
    self.ignoreGenerals = {}
    self.mustSelectedGenerals = {}
    self.playerList = {}
    for _, uid in ipairs(playerList) do
        if string.sub(uid, 1, 1) == "!" then
            table.insert(self.ignoreGenerals, string.sub(uid, 2))
        else
            table.insert(self.mustSelectedGenerals, uid)
        end
    end

    self:initUI()
    self:initTouchEvent()
    self:initChoiceGenerals()
    self:initSelectedGenerals()
    self:refreshGeneralInfoPanel(playerList[1])

    self:setNodeEventEnabled(true)
end

FightPrepareUI.onEnter = function(self)
    self.handlers = {
        [EventConst.GENERAL_BUTTON_PRESSED] = handler(self, self.generalButtonPressed),
        [EventConst.GENERAL_INFO_REFRESHED] = handler(self, self.refreshGeneralInfoPanel),
    }

    for k, v in pairs(self.handlers) do
        EventMgr.registerEvent(k, v)
    end
end

FightPrepareUI.onExit = function(self)
    for k, v in pairs(self.handlers) do
        EventMgr.unregisterEvent(k, v)
    end

    self.callback()
    self.handlers = nil
end

FightPrepareUI.initUI = function(self)
    self.uiNode = cc.uiloader:load("ccz/ui/FightPrepareUI.csb")
    self.uiNode:addTo(self)

    self.rootNode               = UIHelper.seekNodeByName(self.uiNode, "Root")
    self.choiceGeneralsNode     = UIHelper.seekNodeByName(self.uiNode, "AllGeneralsBg")
    self.fightGeneralsInfoLabel = UIHelper.seekNodeByName(self.uiNode, "FightGeneralsInfoLabel")
    self.fightButton            = UIHelper.seekNodeByName(self.uiNode, "FightButton")
    self.headIcon               = UIHelper.seekNodeByName(self.uiNode, "HeadIcon")
    self.nameLabel              = UIHelper.seekNodeByName(self.uiNode, "NameLabel")
    self.armyLabel              = UIHelper.seekNodeByName(self.uiNode, "ArmyLabel")
    self.armyLabel              = UIHelper.seekNodeByName(self.uiNode, "ArmyLabel")
    self.hpProgress             = UIHelper.seekNodeByName(self.uiNode, "HPLoadingBar")
    self.mpProgress             = UIHelper.seekNodeByName(self.uiNode, "MPLoadingBar")
    self.expProgress            = UIHelper.seekNodeByName(self.uiNode, "ExpLoadingBar")
    self.attackProgress         = UIHelper.seekNodeByName(self.uiNode, "AttackLoadingBar")
    self.mentalityProgress      = UIHelper.seekNodeByName(self.uiNode, "MentalityLoadingBar")
    self.defenseProgress        = UIHelper.seekNodeByName(self.uiNode, "DefenseLoadingBar")
    self.explodeProgress        = UIHelper.seekNodeByName(self.uiNode, "ExplodeLoadingBar")
    self.moraleProgress         = UIHelper.seekNodeByName(self.uiNode, "MoralLoadingBar")
    self.hpLabel                = UIHelper.seekNodeByName(self.uiNode, "HPLabel")
    self.mpLabel                = UIHelper.seekNodeByName(self.uiNode, "MPLabel")
    self.expLabel               = UIHelper.seekNodeByName(self.uiNode, "ExpLabel")
    self.attackLabel            = UIHelper.seekNodeByName(self.uiNode, "AttackLabel")
    self.mentalityLabel         = UIHelper.seekNodeByName(self.uiNode, "MentalityLabel")
    self.defenseLabel           = UIHelper.seekNodeByName(self.uiNode, "DefenseLabel")
    self.explodeLabel           = UIHelper.seekNodeByName(self.uiNode, "ExplodeLabel")
    self.moraleLabel            = UIHelper.seekNodeByName(self.uiNode, "MoralLabel")
    self.movementLabel          = UIHelper.seekNodeByName(self.uiNode, "MovementLabel")

    UIHelper.buttonEnabled(self.fightButton, false)
    self.rootNode:align(display.CENTER, display.cx, display.cy)
end

FightPrepareUI.initTouchEvent = function(self)
    UIHelper.buttonRegister(self.fightButton, function()
        local finalPlayerList = {}
        for _, uid in ipairs(self.mustSelectedGenerals) do
            table.insert(finalPlayerList, {uid = uid})
        end
        for _, uid in ipairs(self.playerList) do
            table.insert(finalPlayerList, {uid = uid})
        end

        self:removeSelf()
        EventMgr.triggerEvent(EventConst.FIGHT_PREPARE_DONE, finalPlayerList)
    end)

    UIHelper.buttonRegisterByName(self.uiNode, "CloseButton", function()
        self:removeSelf()
    end)

    UIHelper.buttonRegisterByName(self.uiNode, "CancelButton", function()
        self:removeSelf()
    end)
end

FightPrepareUI.initSelectedGenerals = function(self)
    self.selectedGenerals = {}
    for i = 1, 15 do
        local mustSelectImage     = UIHelper.seekNodeByName(self, "MustSelectImage" .. i)
        local optionalSelectImage = UIHelper.seekNodeByName(self, "OptionalSelectImage" .. i)

        if i <= self.maxLimit then
            if self.mustSelectedGenerals[i] then
                local button = SelectedGeneralButton.new(self.mustSelectedGenerals[i])
                button:align(display.LEFT_BOTTOM, 0, 15)
                button:mustSelected()
                button:addTo(mustSelectImage)

                table.insert(self.selectedGenerals, button)
            end

            mustSelectImage:show()
            if i <= self.minLimit then
                optionalSelectImage:hide()
            else
                mustSelectImage:hide()
                optionalSelectImage:show()
            end
        else
            mustSelectImage:hide()
            optionalSelectImage:hide()
        end
    end

    self.fightGeneralsInfoLabel:setString(string.format("出阵武将 %d/%d", #self.mustSelectedGenerals, self.maxLimit))
end

-- 初始化上半部分的候选武将
FightPrepareUI.initChoiceGenerals = function(self)
    local button = OpitionalGeneralButton.new("曹操")
    local buttonWidth = button:getWidth()
    local buttonHeight = button:getHeight()

    local size = self.choiceGeneralsNode:getContentSize()
    local cols = math.floor(size.width / buttonWidth)
    local startX = (size.width - buttonWidth * cols) / 2
    local startY = size.height - 5

    local filterGeneralIds = clone(self.mustSelectedGenerals)
    for _, uid in pairs(GeneralDataMgr.getAllGeneralIds()) do
        if not self.ignoreGenerals[uid] and not table.indexof(filterGeneralIds, uid) then
            table.insert(filterGeneralIds, uid)
        end
    end

    local count = 0
    self.choiceGeneralButtons = {}
    for _, uid in ipairs(filterGeneralIds) do
        if not table.indexof(self.ignoreGenerals, uid) then
            local button = OpitionalGeneralButton.new(uid)
            button:align(display.LEFT_TOP, startX, startY)
            button:addTo(self.choiceGeneralsNode)

            table.insert(self.choiceGeneralButtons, button)
            if table.indexof(self.mustSelectedGenerals, uid) then
                button:disabled()
                button:selected()
            end

            count = count + 1
            startX = startX + buttonWidth
            if count >= cols then
                count = 0
                startX = (size.width - buttonWidth * cols) / 2
                startY = startY - buttonHeight - 5
            end
        end
    end
end

FightPrepareUI.generalButtonPressed = function(self, uid, isPressed)
    self:refreshGeneralInfoPanel(uid)
    if isPressed == nil then
        return
    end

    if isPressed then
        table.insert(self.playerList, uid)
        self:refreshGeneralInfoPanel(uid)
    else
        for i, gid in ipairs(self.playerList) do
            if gid == uid then
                table.remove(self.playerList, i)
                break
            end
        end
    end

    for i = #self.mustSelectedGenerals + 1, #self.selectedGenerals do
        self.selectedGenerals[i]:removeSelf()
        self.selectedGenerals[i] = nil
    end

    for i = 1, #self.playerList do
        local index = #self.mustSelectedGenerals + i
        local optionalSelectImage = UIHelper.seekNodeByName(self, "OptionalSelectImage" .. (#self.selectedGenerals + 1))
        local mustSelectImage = UIHelper.seekNodeByName(self, "MustSelectImage" .. (#self.selectedGenerals + 1))

        local button = SelectedGeneralButton.new(self.playerList[i])
        button:align(display.LEFT_BOTTOM, 0, 15)
        if optionalSelectImage:isVisible() then
            button:addTo(optionalSelectImage)
        else
            button:addTo(mustSelectImage)
        end

        table.insert(self.selectedGenerals, button)
    end

    local generalsCount = #self.mustSelectedGenerals + #self.playerList
    self.fightGeneralsInfoLabel:setString(string.format("出阵武将 %d/%d", generalsCount, self.maxLimit))
    UIHelper.buttonEnabled(self.fightButton, generalsCount >= self.minLimit)

    table.walk(self.choiceGeneralButtons, function(button)
        button:setNoTouchEffect(generalsCount >= self.maxLimit)
    end)
end

FightPrepareUI.refreshGeneralInfoPanel = function(self, uid)
    local headPath = InfoUtil.getPath(GeneralDataMgr.getProp(uid, GeneralDataConst.PROP_HEAD), "head")
    self.headIcon:setTexture(headPath)

    self.nameLabel:setString(GeneralDataMgr.getProp(uid, GeneralDataConst.PROP_NAME))
    self.armyLabel:setString(GeneralDataMgr.getProp(uid, GeneralDataConst.PROP_ARMYNAME))
    self.hpLabel:setString(GeneralDataMgr.getProp(uid, GeneralDataConst.PROP_HPMAX))
    self.mpLabel:setString(GeneralDataMgr.getProp(uid, GeneralDataConst.PROP_MPMAX))
    self.movementLabel:setString(GeneralDataMgr.getProp(uid, GeneralDataConst.PROP_MOVEMENT))
    self.hpProgress:setPercent(100)
    self.mpProgress:setPercent(100)

    local props = {
        ["exp"]       = GeneralDataConst.PROP_EXP,
        ["attack"]    = GeneralDataConst.PROP_ATTACK,
        ["mentality"] = GeneralDataConst.PROP_MENTALITY,
        ["defense"]   = GeneralDataConst.PROP_DEFENSE,
        ["explode"]   = GeneralDataConst.PROP_EXPLODE,
        ["morale"]    = GeneralDataConst.PROP_MORALE,
    }

    for k, v in pairs(props) do
        print(k, v, GeneralDataMgr.getProp(uid, v), GeneralUtils.getPropMaxLimit(k))

        self[k .. "Progress"]:setPercent(GeneralDataMgr.getProp(uid, v) / GeneralUtils.getPropMaxLimit(k) * 100)
        self[k .. "Label"]:setString(GeneralDataMgr.getProp(uid, v))
    end
end

return FightPrepareUI