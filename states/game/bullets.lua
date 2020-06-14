local Node = require "lib.node"
local Class = require "lib.hump.class"
local vector = require "lib.hump.vector"

local BulletsWrapper = Class {
	init = function(self, name, parent)
		self.name = name
		self.parent = parent
		self.bullets = {}
	end,

	getBullets = function(self)
		return self.bullets
	end,

	addBullet = function(self, bullet)
		table.insert(self.bullets, bullet)
	end,

	update = function(self, dt)
		for i, bullet in ipairs(self.bullets) do
			bullet:update(dt)
			if bullet:isOutOfBounds(0, 600, 0, 800) then
				table.remove(self.bullets, i)
			end
		end
	end,

	draw = function(self)
		for i, bullet in ipairs(self.bullets) do
			bullet:draw()
		end
	end,

	removeBullet = function(self, i)
		table.remove(self.bullets, i)
	end,
}

BulletsWrapper:include(node)

return BulletsWrapper
