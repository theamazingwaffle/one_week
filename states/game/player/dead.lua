local class = require "lib.hump.class"

-----
local Dead = class {
	init = function(self)
		self.circle = {}
		self.circle.radius = 0
		self.circle.lineWidth = 50
	end,

	onSwitch = function(self, entity)
		entity.sprite = entity.sprites.explosion
		entity.sprite:reset()
	end,

	update = function(self, dt, entity)
		if self.circle.lineWidth >= 1 then
			self.circle.lineWidth = math.floor(math.max(0, self.circle.lineWidth - self.circle.lineWidth * 5 * dt))
			self.circle.radius = math.min(128, self.circle.radius + (500 * dt))
		end
		entity.sprite:update(dt)
		return "dead"
	end,

	getName = function(self)
		return "dead"
	end,

	hit = function(self, entity)
		return "dead"
	end,

	draw = function(self, entity)
		entity.sprite:drawCentered(entity.pos.x, entity.pos.y)
		love.graphics.setLineWidth(self.circle.lineWidth)
		love.graphics.circle("line", entity.pos.x, entity.pos.y, self.circle.radius)
	end,

	collidesWith = function()
		return false
	end,
}

return Dead
