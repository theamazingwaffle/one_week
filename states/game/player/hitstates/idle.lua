local idle = {}
idle.__index = idle

idle.onSwitch = function(self)
end

local MAX_LEFT = 80
local MAX_RIGHT = 520
local clamp
idle.update = function(self, dt)
	return "idle"
end

idle.hit = function(self)
	self.entity:damage(1)
	if self.entity.health <= 0 then
		return "dead"
	end
	return "iframes"
end

idle.collidesWith = function(self, shape)
	return self.entity:getShape():collidesWith(shape)
end

idle.draw = function(self)
	self.entity.sprite:drawCentered(self.entity.pos.x, self.entity.pos.y)
end

idle.getName = function()
	return "idle"
end

idle.isFuckingDead = function()
	return false
end

clamp = function(value, min, max)
	if value > max then return max
	elseif value < min then return min
	else return value end
end

local new = function(entity)
	local t = {}
	t.entity = entity
	return setmetatable(t, idle)
end

return setmetatable(
	{ new = new },
	{ __call = function(_, ...) return new(...) end } 
)
