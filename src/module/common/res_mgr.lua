--[[
    创建一个资源管理器
        通过引用计数的方式来管理和卸载资源
        目前资源最简单就是R剧本解析器和S剧本解析器退出时，移除当前所有已经加载的资源即可
        目前资源有以下两类:
            display.addSpriteFrames
            display.setAnimationCache

        移除方法
            display.removeSpriteFramesWithFile
            display.removeUnusedSpriteFrames
            display.removeAnimationCache
--]]

local RES_SEPARATOR = "-"

local ResMgr = {}
ResMgr.spriteFrames = {}
ResMgr.animationCaches = {}

ResMgr.init = function()
    ResMgr.clearAll()
end

ResMgr.addSpriteFrames = function(res, postfix)
    local plistFilename = res .. ".plist"
    local imageName = res .. (postfix or ".png")
    local key = plistFilename .. RES_SEPARATOR .. imageName
    if ResMgr.spriteFrames[key] then
        ResMgr.spriteFrames[key] = ResMgr.spriteFrames[key] + 1
        return
    end

    display.addSpriteFrames(plistFilename, imageName)
    ResMgr.spriteFrames[key] = 1
end

ResMgr.removeSpriteFramesWithFile = function(res, postfix)
    local plistFilename = res .. ".plist"
    local imageName = res .. (postfix or ".png")
    local key = plistFilename .. RES_SEPARATOR .. imageName
    if not ResMgr.spriteFrames[key] then
        return
    end

    ResMgr.spriteFrames[key] = ResMgr.spriteFrames[key] - 1
    if ResMgr.spriteFrames[key] == 0 then
        ResMgr.spriteFrames[key] = nil
        display.removeSpriteFramesWithFile(plistFilename, imageName)
    end
end

ResMgr.addAnimationCache = function(animationName, animation)
    local key = animationName
    if ResMgr.animationCaches[key] then
        ResMgr.animationCaches[key] = ResMgr.animationCaches[key] + 1
        return
    end

    display.setAnimationCache(animationName, animation)
    ResMgr.animationCaches[key] = 1
end

ResMgr.removeAnimationCache = function(animationName)
    local key = animationName
    if not ResMgr.animationCaches[key] then
        return
    end

    ResMgr.animationCaches[key] = ResMgr.animationCaches[key] - 1
    if ResMgr.animationCaches[key] == 0 then
        ResMgr.animationCaches[key] = nil
        display.removeAnimationCache(animationName)
    end
end

ResMgr.dumpAll = function()
    printInfo("\n\nSpriteFrames Info:")
    table.walk(ResMgr.spriteFrames, function(count, key)
        local res = string.split(key, RES_SEPARATOR)
        printInfo("\t%s %s %s", res[1], res[2], count)
    end)

    printInfo("\n\nAnimationCaches Info:")
    table.walk(ResMgr.animationCaches, function(count, key)
        printInfo("\t%s %s", key, count)
    end)

    printInfo("\n\n")
end

ResMgr.clearAll = function()
    table.walk(ResMgr.spriteFrames, function(_, key)
        local res = string.split(key, RES_SEPARATOR)
        ResMgr.removeSpriteFramesWithFile(res[1], res[2])
    end)

    table.walk(ResMgr.animationCaches, function(_, key)
        ResMgr.removeAnimationCache(key)
    end)

    display.removeUnusedSpriteFrames()

    assert(#ResMgr.spriteFrames == 0, "SpriteFrames资源没有清楚干净")
    assert(#ResMgr.animationCaches == 0, "AnimationCache资源没有清楚干净")

    ResMgr.spriteFrames = {}
    ResMgr.animationCaches = {}
end

EventMgr.registerEvent(EventConst.PLOT_OVER, ResMgr.clearAll)

return ResMgr