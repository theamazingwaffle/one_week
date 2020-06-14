local class = require "lib.hump.class"
local vector = require "lib.hump.vector"

local animate = require "lib.animate"

-----
local Bomb = class {
	init = function(self, pos, vel, imagePath, scale, shape)
		self.pos = pos
		self.vel = vel
		self.rotation = math.pi * 1.5 - math.atan2(vel.y, vel.x)
		self.sprite = animate(imagePath)
		self.scale = scale or 1
		self.sprite:setScale(self.scale)
		self.shape = shape
		self.health = 3
		self.gravity = vector(0, 800)
	end,

	update = function(self, dt)
		self.vel.y = self.vel.y + self.gravity.y * dt
		self.pos = self.pos + (self.vel * dt)
		self.shape:moveTo(self.pos:unpack())
	end,

	draw = function(self)
		self.sprite:drawCentered(self.pos:unpack())
	end,

	collidesWith = function(self, shape)
		return self.shape:collidesWith(shape)
	end,

	hit = function(self)
		self.health = self.health - 1
	end,

	setGravity = function(self, x, y)
		self.gravity.x = x
		self.gravity.y = y
	end,

	getHealth = function(self)
		return self.health
	end,

	getShape = function(self)
		return table.copy(self.shape)
	end,
}

return Bomb
