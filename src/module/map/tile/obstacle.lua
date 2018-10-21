--[[
    障碍物
--]]

local Obstacle = class("Obstacle", function()
    return display.newSprite()
end)

Obstacle.ctor = function(self, name)
    self.name = name

    if string.find(name, "Gate") then
        local res = "ccz/obstacle/gate/" .. string.sub(name, 6) .. ".png"
        self:setTexture(res)
        self.type = "城门"
    elseif name == "船" then
        local res = "ccz/obstacle/boat/boat1.png"
        self:setTexture(res)
        self.type = "船"
    elseif name == "起火船" then
        local res = "ccz/obstacle/boat/fire_boat1.png"
        self:setTexture(res)
        self.type = "起火船"
    end
end

Obstacle.getName = function(self)
    return self.name
end

Obstacle.getType = function(self)
    return self.type
end

return Obstacle