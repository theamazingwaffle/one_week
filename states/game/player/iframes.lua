local class = require "lib.hump.class"
local timer = require "lib.timer"

local init = function(self)
	self.blinkingCooldown = timer(0.08)
	--self.opacity = 0
	self.whiteout = true
	self.timer = timer(0.8)
end

local whiteoutShader = love.graphics.newShader [[ vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
	return vec4(1, 1, 1, Texel(texture, textureCoords).a) * color;
} ]]

local MAX_LEFT = 80
local MAX_RIGHT = 520
local clamp
local abs = math.abs
local Iframes = class {
	init = init,
	onSwitch = init,

	update = function(self, dt, entity)
		self.blinkingCooldown:update(dt)
		if self.blinkingCooldown:hasEnded() then
			self.whiteout = not self.whiteout
			self.blinkingCooldown:reset()
		end

		self.timer:update(dt)
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
		entity.shape:moveTo(entity.pos.x, entity.pos.y)

		if self.timer:hasEnded() then
			return "flying"
		else
			return "iframes" end
	end,

	hit = function(self)
		return "iframes"
	end,

	draw = function(self, entity)
		if self.whiteout then
			if entity.health == 1 then
				love.graphics.setColor(1, 0, 0)
			end
			love.graphics.setShader(whiteoutShader)
		end
		entity.sprite:drawCentered(entity.pos:unpack())
		love.graphics.setShader()
		love.graphics.setColor(1, 1, 1)
	end,

	collidesWith = function()
		return false
	end,

	getName = function(self)
		return "iframes"
	end,
}

clamp = function(value, min, max)
	if value > max then return max
	elseif value < min then return min
	else return value end
end

return Iframes
