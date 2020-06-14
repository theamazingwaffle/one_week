local Class   = require "lib.hump.class"
local animate = require "lib.animate"
local HC      = require "lib.HC"

local defaultImagePath = "res/gfx/bullet.png"

local atan2 = math.atan2
local pi = math.pi
local Bullet = Class {
	init = function(self, pos, vel, imagePath)
		self.pos = pos
		self.vel = vel
		-- Rotate because atan2 returns retarded angle
		self.rotation = atan2(-vel.y, vel.x) - pi/2
		self.sprite = animate(imagePath or defaultImagePath, 0, 0)
		self.sprite:setScale(4)
		self.shape = HC.circle(self.pos.x, self.pos.y, 16)
	end,

	update = function(self, dt)
		self.pos = self.pos + (self.vel * dt)
		self.shape:moveTo(self.pos:unpack())
	end,

	draw = function(self)
		self.sprite:drawCentered(self.pos.x, self.pos.y)
	end,

	isOutOfBounds = function(self, min_x, max_x, min_y, max_y)
		return (self.pos.x < min_x) or (self.pos.x > max_x) or (self.pos.y > max_y) or (self.pos.y < min_y)
	end,

	getShape = function(self)
		return self.shape
	end,
}

return Bullet
