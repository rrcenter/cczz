--[[
道具使用流程
    1、使用道具武将身上出现一个道具移动到目标武将身上(附加一个大到小消失的动画)
    2、根据道具效果，添加hp，mp（如果有实际变化，则显示结算界面）
        2.1、如果道具效果是去除状态，则还显示一个状态移除的动画
        2.2、如果是各种果子，使用以后，还会添加一个相应的buffer（属性增添）
        2.3、如果是印绶，则人物模型也需要转变
--]]

local ITEM_ZORDER = 1000

local ItemUse = class("ItemUse")

ItemUse.ctor = function(self, itemId, user, target, callback)
    local itemConfig = InfoUtil.getItemConfig(itemId)
    assert(itemConfig, "有问题，使用了不存在的道具")

    printInfo("%s武将正在对%s武将使用%s", user:getName(), target:getName(), itemConfig.name)

    if user ~= target then
        local itemRes = InfoUtil.getItemPath(itemConfig.icon, itemConfig.type)
        local itemIcon = display.newSprite(itemRes)
        itemIcon:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, MapConst.BLOCK_HEIGHT / 2)
        itemIcon:addTo(user, ITEM_ZORDER)

        transition.execute(itemIcon, cca.moveBy(LONG_ANIMATION_TIME, 0, 10), {onComplete = function()
            itemIcon:removeSelf()
            if user:isPlayer() then
                GameData.subItem(itemId)
            end

            self:useForTarget(itemId, target, callback)
        end})
    else
        self:useForTarget(itemId, target, callback)
    end
end

ItemUse.useForTarget = function(self, itemId, target, callback)
    local itemConfig = InfoUtil.getItemConfig(itemId)
    local itemRes = InfoUtil.getItemPath(itemConfig.icon, itemConfig.type)
    local itemIcon = display.newSprite(itemRes)
    itemIcon:align(display.CENTER, MapConst.BLOCK_WIDTH / 2, MapConst.BLOCK_HEIGHT / 2 + 10)
    itemIcon:addTo(target, ITEM_ZORDER)

    target:excitation(0, 0)
    transition.execute(itemIcon, cca.moveBy(LONG_ANIMATION_TIME, 0, -10), {onComplete = function()
        itemIcon:removeSelf()

        -- 升级，转职回调
        local onComplete = function()
            -- 1、属性的添加影响
            if itemConfig.addProps then
                table.walk(GeneralDataConst.ADD_PROP_MAPPING, function(_, propName)
                    if itemConfig.addProps[propName] then
                        target:addBasicProp2(propName, itemConfig.addProps[propName])
                    end
                end)
            end

            -- 2、计算hp和mp
            local hpAdd = itemConfig.hpAdd or 0
            local mpAdd = itemConfig.mpAdd or 0
            if hpAdd == 0 or target:getCurrentHp() >= target:getMaxHp() then
                hpAdd = 0
            end
            if mpAdd == 0 or target:getCurrentMp() >= target:getMaxMp() then
                mpAdd = 0
            end

            -- 3、去除负面状态
            if itemConfig.statusRemove then
                target:removeStatus(itemConfig.statusRemove)
            end

            -- 4、添加额外正面状态
            if itemConfig.outStatus then
                target:addStatus(itemConfig.outStatus)

                local statusConfig = InfoUtil.getStatusConfig(itemConfig.outStatus)
                Magic.new(statusConfig.animationConfig):addTo(target, CharViewConst.ZORDER_GENERAL_MAGIC)
            end

            -- 4、hp和mp结算
            if mpAdd ~= 0 or hpAdd ~= 0 then
                local generalInfo = {general = target, hpDamge = -hpAdd, mpDamge = -mpAdd}
                EventMgr.triggerEvent(EventConst.SHOW_HURT_VIEW, {generalInfo}, target, true, callback)
            else
                callback()
            end
        end

        if itemConfig.levelAdd then
            target:levelUp(itemConfig.levelAdd, onComplete)
        elseif itemConfig.armyUp then
            target:armyUp(onComplete)
        else
            onComplete()
        end
    end})
end

return ItemUse