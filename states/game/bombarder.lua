local class = require "lib.hump.class"
local vector = require "lib.hump.vector"
local HC = require "lib.HC"

local Bomb = require "states.game.bomb"
local Node = require "lib.node"

local Bombs = class {
	init = function(self, name, parent)
		self.name = name
		self.parent = parent
		self.bombs = {}
	end,

	update = function(self, dt)
		for i, bomb in ipairs(self.bombs) do
			bomb:update(dt)
			if bomb:getHealth() < 1 or bomb.pos.y > 800 then
				self:removeBullet(i)
			end
		end
	end,

	draw = function(self)
		for _, bomb in ipairs(self.bombs) do
			bomb:draw()
		end
	end,

	collideWith = function(self, shape)
		if not shape then
			return false
		end
		for _, bomb in ipairs(self.bombs) do
			if bomb:collidesWith(shape) then
				return true
			end
		end
		return false
	end,

	removeBullet = function(self, i)
		table.remove(self.bombs, i)
	end,

	newBomb = function(self, pos, vel)
		local vel = vel or  vector(0, 100)
		table.insert(self.bombs, Bomb(pos, vel, "res/gfx/bomb.png", 4, HC.circle(pos.x, pos.y, 16)))
	end,

	getBombs = function(self)
		return self.bombs
	end,
}

Bombs:include(Node)

return Bombs
