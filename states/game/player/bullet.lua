local Class   = require "lib.hump.class"
local animate = require "lib.animate"
local HC      = require "lib.HC"

local defaultImagePath = "res/gfx/bullet.png"

local bullet = {}
bullet.__index = bullet

local atan2 = math.atan2
local pi = math.pi

bullet.update = function(self, dt)
	self.rotation = atan2(self.vel.y, self.vel.x) + pi/2
	self.sprite:setRotation(self.rotation)
	self.pos = self.pos + (self.vel * dt)
	self.shape:moveTo(self.pos:unpack())
end

bullet.draw = function(self)
	self.sprite:drawCentered(self.pos.x, self.pos.y)
end

bullet.isOutOfBounds = function(self, minX, maxX, minY, maxY)
	return (self.pos.x < minX) or (self.pos.x > maxX) or (self.pos.y > maxY) or (self.pos.y < minY)
end

bullet.getShape = function(self)
	return self.shape
end

local new = function(pos, vel, imagePath)
	local t = {}
	t.pos = pos
	t.vel = vel
	-- Rotate because atan2 returns 90 degree angle
	t.rotation = atan2(vel.y, vel.x) + pi/2
	t.sprite = animate(imagePath or defaultImagePath, 0, 0)
	t.sprite:setScale(4)
	t.shape = HC.circle(t.pos.x, t.pos.y, 16)
	return setmetatable(t, bullet)
end

return setmetatable(
	{ new = new },
	{ __call = function(_, ...) return new(...) end }
)
