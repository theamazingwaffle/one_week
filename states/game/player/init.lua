local class = require "lib.hump.class"
local vector = require "lib.hump.vector"
local HC       = require "lib.HC"
local Node     = require "lib.node"
local animate  = require "lib.animate"

local Flying  = require "states.game.player.flying"
local Iframes = require "states.game.player.iframes"
local Dead = require "states.game.player.dead"

local Player = class {
	init = function(self, name, parent)
		self.sprites = {
			["left"]   = animate("res/gfx/aircraft3.png"),
			["middle"] = animate("res/gfx/aircraft1.png"),
			["right"]  = animate("res/gfx/aircraft2.png"),
			["explosion"]  = animate("res/gfx/explosion.png"),
		}
		self.sprites.explosion:setFps(10)
		self.sprites.explosion:setWidth(32)
		self.sprites.explosion:setLooping(false)
		for _, sprite in pairs(self.sprites) do
			sprite:setScale(4)
		end

		self.states = {
			["flying"] = Flying(),
			["iframes"] = Iframes(),
			["dead"] = Dead(),
		}

		self.state = self.states.flying
		self.state:onSwitch(self)
		self.name = name
		self.parent = parent
		self.pos = vector(300, 750)
		self.shape = HC.circle(self.pos.x, self.pos.y, 25)
		self.health = 4
	end,

	update = function(self, dt)
		self:switchState(self.state:update(dt, self))
		if self.health < 1 then
			self:switchState("dead")
		end
	end,

	hit = function(self)
		self:switchState(self.state:hit(self))
	end,

	switchState = function(self, nextState)
		local prevState = self.state:getName()
		self.state = self.states[nextState]
		if prevState ~= nextState then
			self.state:onSwitch(self)
		end
	end,

	-- functions that don't switch the state
	draw = function(self)
		self.state:draw(self)
	end,

	addBullet = function(self, bullet)
		self:getParent():addBullet(bullet)
	end,

	damage = function(self, damage)
		self.health = self.health - damage
	end,

	collidesWith = function(self, shape)
		return self.state:collidesWith(shape, self)
	end,

	getPos = function(self)
		return table.copy(self.pos)
	end,

	getShape = function(self)
		return table.copy(self.shape)
	end,
}

Player:include(Node)

return Player
