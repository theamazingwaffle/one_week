local timer = {}
timer.__index = timer

local new = function(time)
	return setmetatable({
			clock = time,
			initialClock = time,
		},
		timer
	)
end

function timer:update(dt)
	if not self:hasEnded() then
		self.clock = self.clock - dt
	else
		self:reset()
	end
end

function timer:reset()
	self.clock = self.initialClock
end

function timer:hasEnded()
	return self.clock <= 0
end

return setmetatable(
	{ new = new	},
	{ __call = function(_, ...) return new(...) end }
)
