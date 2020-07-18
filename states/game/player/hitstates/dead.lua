local dead = {}
dead.__index = dead

dead.onSwitch = function(self)
	self.circle = {}
	self.circle.radius = 0
	self.circle.lineWidth = 50
	self.deadTimer = 1.2
	self.entity.sprite = self.entity.sprites.explosion
	self.entity.sprite:reset()
end

dead.update = function(self, dt)
	if self.circle.lineWidth >= 0 then
		self.circle.lineWidth = math.floor(math.max(0, self.circle.lineWidth - self.circle.lineWidth * 5 * dt))
		self.circle.radius = math.min(128, self.circle.radius + (500 * dt))
	end
	self.entity.sprite:update(dt)
	self.deadTimer = self.deadTimer - dt
	return "dead"
end

dead.hit = function(self)
	return "dead"
end

dead.isFuckingDead = function(self)
	return self.deadTimer <= 0
end

dead.getName = function(self)
	return "dead"
end

dead.draw = function(self)
	self.entity.sprite:drawCentered(self.entity.pos.x, self.entity.pos.y)
	love.graphics.setLineWidth(self.circle.lineWidth)
	if self.circle.lineWidth >= 1 then
		love.graphics.circle("line", self.entity.pos.x, self.entity.pos.y, self.circle.radius)
	end
	love.graphics.setLineWidth(1)
end

dead.collidesWith = function()
	return false
end

local new = function(entity)
	local t = {}
	t.circle = {}
	t.circle.radius = 0
	t.circle.lineWidth = 50
	t.deadTimer = 1.2
	t.entity = entity
	return setmetatable(t, dead)
end

return setmetatable(
	{ new = new },
	{ __call = function(_, ...) return new(...) end }
)
