--[[
    天气管理类
        这里主要仅负责数据管理
        目前共有5类天气：晴，阴，雨，豪雨，雪
        可以指定每局游戏的天气走向，该天气出现几率为60%，其他天气几率为10%，普通为每种天气出现几率均等，默认为普通
            除普通为每种天气出现几率均等以外，其他都是主要天气
--]]

local ALL_WEATHERS = {"晴", "阴", "雨", "豪雨", "雪"}

local WeatherMgr = class("WeatherMgr")

WeatherMgr.ctor = function(self, weatherStart, weatherType, weathers)
    self.weatherStart = weatherStart or {}
    self.weatherType  = weatherType or "普通"
    self.weathers     = weathers or {} -- 记录每回合的天气情况

    if self.weatherType ~= "普通" then
        self.otherWeatherTypes = clone(ALL_WEATHERS)
        for i, v in ipairs(self.otherWeatherTypes) do
            if v == self.weatherType then
                table.remove(self.otherWeatherTypes, i)
                break
            end
        end
    end
end

WeatherMgr.getWeather = function(self, round)
    if not self.weathers[round] then
        printInfo("自动生成新的天气：%s(%d回合)", self:genNewWeather(round), round)
    else
        printInfo("天气已存在：%s(%d回合)", self.weathers[round], round)
    end

    return self.weathers[round]
end

WeatherMgr.genNewWeather = function(self, round)
    if round <= #self.weatherStart then
        self.weathers[round] = self.weatherStart[round]
    else
        if self.weatherType == "普通" then
            self.weathers[round] = ALL_WEATHERS[Random.getNumber(#ALL_WEATHERS)]
        else
            local rate = Random.getNumber(100)
            if rate < 60 then
                self.weathers[round] = self.weatherType
            else
                local index = Random.getNumber(#self.otherWeatherTypes)
                print(index, #self.otherWeatherTypes)
                self.weathers[round] = self.otherWeatherTypes[index]
            end
        end
    end

    return self.weathers[round]
end

WeatherMgr.getSaveData = function(self)
    local saveData = {}
    saveData.weatherType  = self.weatherType
    saveData.weatherStart = self.weatherStart
    saveData.weathers     = self.weathers

    return saveData
end

-- 强制更新天气，一般仅受天气策略影响
WeatherMgr.setWeather = function(self, round, weatherType)
    self.weathers[round] = weatherType
end

return WeatherMgr