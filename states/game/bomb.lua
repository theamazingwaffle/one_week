local class = require "lib.hump.class"
local vector = require "lib.hump.vector"

local animate = require "lib.animate"

local Dead = class {
	init = function(self)
	end,

	onSwitch = function(self, entity)
		self.timer = 5
		entity.sprite = entity.sprites["explosion"]
		entity.sprite:reset()
	end,

	update = function(self, dt, entity)
		self.timer = self.timer - dt * 10
		entity.sprite:update(dt)
		return "dead"
	end,

	hit = function(self, entity)
		return "dead"
	end,

	isActive = function(self)
		return (self.timer > 0)
	end,

	draw = function(self, entity)
		entity.sprite:drawCentered(entity.pos:unpack())
	end,

	collidesWith = function(self, shape, entity)
		return false
	end,

	getName = function(self)
		return "dead"
	end,
}

local Active = class {
	init = function(self)
	end,
	onSwitch = function(self, entity)
		entity.sprite = entity.sprites["active"]
	end,

	update = function(self, dt, entity)
		entity.vel.y = entity.vel.y + entity.gravity.y * dt
		entity.pos = entity.pos + (entity.vel * dt)
		entity.shape:moveTo(entity.pos:unpack())
		return "active"
	end,

	hit = function(self, entity)
		entity.health = entity.health - 1
		if entity.health < 1 then
			return "dead"
		end
		return "active"
	end,

	isActive = function(self)
		return true
	end,

	draw = function(self, entity)
		entity.sprite:drawCentered(entity.pos:unpack())
	end,

	getName = function(self)
		return "active"
	end,

	collidesWith = function(self, shape, entity)
		return entity.shape:collidesWith(shape)
	end,
}

-----
local Bomb = class {
	init = function(self, pos, vel, shape)
		self.pos = pos
		self.vel = vel
		self.rotation = math.pi * 1.5 - math.atan2(vel.y, vel.x)
		self.shape = shape
		self.health = 3
		self.gravity = vector(0, 800)

		self.sprites = {
			["active"] = animate("res/gfx/bomb.png"),
			["explosion"] = animate("res/gfx/bomb_explosion.png", 0, 0, 32, 32, 4, 10),
		}
		self.sprites.active:setScale(4)
		self.sprites.explosion:setScale(4)
		self.sprites.explosion:setLooping(false)
		self.sprite = self.sprites.active
		
		self.states = {
			["active"] = Active(),
			["dead"] = Dead(),
		}
		self.state = self.states.active
	end,

	update = function(self, dt)
		self:switchState(self.state:update(dt, self))
	end,

	hit = function(self)
		self:switchState(self.state:hit(self))
	end,

	explode = function(self)
		if self.state:getName() == "active" then
			self:switchState("dead")
		end
	end,

	switchState = function(self, nextState)
		local prevState = self.state:getName()
		self.state = self.states[nextState]
		if prevState ~= nextState then
			self.state:onSwitch(self)
		end
	end,

	draw = function(self)
		self.state:draw(self)
	end,

	getHealth = function(self)
		return self.health
	end,

	getShape = function(self)
		return table.copy(self.shape)
	end,

	collidesWith = function(self, shape)
		return self.state:collidesWith(shape, self)
	end,

	isActive = function(self)
		return self.state:isActive()
	end,
}

return Bomb
