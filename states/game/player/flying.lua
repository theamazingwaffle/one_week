local class   = require "lib.hump.class"
local vector  = require "lib.hump.vector"
local timer   = require "lib.timer"
local Bullet  = require "states.game.bullet"

local init = function(self)
	self.shootingCooldown = timer(0.05)
end

local MAX_LEFT = 80
local MAX_RIGHT = 520
local clamp
local Flying = class {
	init = init,
	onSwitch = init,

	update = function(self, dt, entity)
		self.shootingCooldown:update(dt)
		entity.sprite = entity.sprites.middle
		if love.keyboard.isDown("left") then
			entity.pos.x = entity.pos.x - 400 * dt
			entity.sprite = entity.sprites.left
		elseif love.keyboard.isDown("right") then
			entity.pos.x = entity.pos.x + 400 * dt
			entity.sprite = entity.sprites.right
		end
		if love.keyboard.isDown("up") then
			entity.pos.y = entity.pos.y - 400 * dt
		elseif love.keyboard.isDown("down") then
			entity.pos.y = entity.pos.y + 400 * dt
		end
		entity.pos.x = clamp(entity.pos.x, MAX_LEFT, MAX_RIGHT)
		entity.shape:moveTo(entity.pos:unpack())

		if self.shootingCooldown:hasEnded() then
			entity:addBullet(Bullet(entity.pos + vector(-16, -16), vector(0, -1500)))
			entity:addBullet(Bullet(entity.pos + vector(16, -16), vector(0, -1500)))
		end

		return "flying"
	end,

	hit = function(self, entity)
		entity:damage(1)
		return "iframes"
	end,

	collidesWith = function(self, shape, entity)
		return entity:getShape():collidesWith(shape)
	end,

	draw = function(self, entity)
		entity.sprite:drawCentered(entity.pos.x, entity.pos.y)
	end,

	getName = function(self)
		return "flying"
	end,
}

clamp = function(value, min, max)
	if value > max then return max
	elseif value < min then return min
	else return value end
end

return Flying
