--[[
    AI-坚守原地
    无论如何都不会移动。
--]]

local AiJianShouYuanDi = class("AiJianShouYuanDi")

AiJianShouYuanDi.setGeneral = function(self, general)
    self.general = general
end

AiJianShouYuanDi.run = function(self)
    local attackCosts = {}
    local attackTargetInfos = self.general:getAttackAllHitTargets()
    table.walk(attackTargetInfos, function(attackTargetInfo)
        local cost = AiUtils.getAttackCost(self.general, attackTargetInfo.mainTarget, attackTargetInfo.targets, "坚守原地")
        table.insert(attackCosts, {cost = cost, targetInfo = attackTargetInfo})
    end)

    table.sort(attackCosts, function(l, r)
        return l.cost > r.cost
    end)

    local maxMagicCost
    if self.general:canUseMagic() then
        local isMove = false
        local hasAttackTargets = #attackCosts > 0
        maxMagicCost = AiUtils.getMagicCost(self.general, isMove, hasAttackTargets)
    end

    local actionCmds = {}
    local maxAttackCost = attackCosts[1]
    if maxAttackCost and maxMagicCost then
        if maxAttackCost.cost > maxMagicCost.cost then
            actionCmds[1] = AiUtils.genAttackCmd(self.general, maxAttackCost)
        else
            actionCmds[1] = AiUtils.genMagicCmd(self.general, maxMagicCost)
        end
    elseif maxAttackCost then
        actionCmds[1] = AiUtils.genAttackCmd(self.general, maxAttackCost)
    elseif maxMagicCost then
        actionCmds[1] = AiUtils.genMagicCmd(self.general, maxMagicCost)
    else
        actionCmds[1] = AiUtils.genNoneCmd()
    end

    return actionCmds
end

return AiJianShouYuanDi