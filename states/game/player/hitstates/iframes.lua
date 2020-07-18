local timer = require "lib.timer"
local iframes = {}
iframes.__index = iframes

local whiteoutShader = love.graphics.newShader [[ vec4 effect(vec4 color, Image texture, vec2 textureCoords, vec2 screenCoords) {
	return vec4(1, 1, 1, Texel(texture, textureCoords).a) * color;
} ]]

iframes.update = function(self, dt)
	self.blinkingCooldown:update(dt)
	if self.blinkingCooldown:hasEnded() then
		self.whiteout = not self.whiteout
		self.blinkingCooldown:reset()
	end

	self.timer:update(dt)

	if self.timer:hasEnded() then
		return "idle"
	end
	return "iframes"
end

iframes.onSwitch = function(self)
	self.blinkingCooldown = timer(0.08)
	self.whiteout = true
	self.timer = timer(0.8)
end

iframes.hit = function(self)
	return "iframes"
end

iframes.draw = function(self)
	if self.whiteout then
		if self.entity.health == 1 then
			love.graphics.setColor(1, 0, 0)
		end
		love.graphics.setShader(whiteoutShader)
	end
	self.entity.sprite:drawCentered(self.entity.pos:unpack())
	love.graphics.setShader()
	love.graphics.setColor(1, 1, 1)
end

iframes.collidesWith = function()
	return false
end

iframes.getName = function(self)
	return "iframes"
end

iframes.isFuckingDead = function()
	return false
end

local new = function(entity)
	local self = {}
	self.blinkingCooldown = timer(0.08)
	self.whiteout = true
	self.timer = timer(0.8)
	self.entity = entity

	return setmetatable(self, iframes)
end

return setmetatable(
	{ new = new },
	{ __call = function(_, ...) return new(...) end }
)
