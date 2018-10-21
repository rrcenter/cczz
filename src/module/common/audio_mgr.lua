--[[
    音频管理类
        目前应该没啥特别处理的，主要就是把quick的拿过来
--]]

local AudioMgr = {}

AudioMgr.playMusic = function(filename, isLoop)
    if filename == "无" then
        AudioMgr.stopMusic()
    else
        AudioMgr.curMusic = {filename, isLoop}
        audio.playMusic("ccz/music/" .. filename .. ".mp3", isLoop)
    end
end

AudioMgr.getCurMusic = function()
    return AudioMgr.curMusic
end

AudioMgr.stopMusic = function()
    AudioMgr.curMusic = nil
    audio.stopMusic()
end

AudioMgr.pauseMusic = function()
    audio.pauseMusic()
end

AudioMgr.resumeMusic = function()
    audio.resumeMusic()
end

AudioMgr.rewindMusic = function()
    audio.rewindMusic()
end

AudioMgr.willPlayMusic = function()
    return audio.willPlayMusic()
end

AudioMgr.isMusicPlaying = function()
    return audio.isMusicPlaying()
end

AudioMgr.playSound = function(filename, isLoop)
    return audio.playSound("ccz/sound/" .. filename, isLoop)
end

AudioMgr.pauseSound = function(handle)
    audio.pauseSound(handle)
end

AudioMgr.pauseAllSounds = function()
    audio.pauseAllSounds()
end

AudioMgr.resumeSound = function(handle)
    audio.resumeSound(handle)
end

AudioMgr.resumeAllSounds = function()
    audio.resumeAllSounds()
end

AudioMgr.stopSound = function(handle)
    audio.stopSound(handle)
end

AudioMgr.stopAllSounds = function()
    audio.stopAllSounds()
end

AudioMgr.plotOver = function()
    AudioMgr.stopMusic()
    AudioMgr.stopAllSounds()
end

EventMgr.registerEvent(EventConst.PLOT_OVER, AudioMgr.plotOver)

return AudioMgr