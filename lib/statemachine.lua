local state_machine = {}
state_machine.__index = state_machine

local function new(default_state_name, default_state)
	assert(default_state_name, "Please provide a name for the default state")
	assert(default_state, "Please provide a default state")
	return setmetatable(
		{
			states = {[default_state_name] = default_state},
			current_state = default_state,
			current_state_name = default_state_name
		},
		state_machine
	)
end

function state_machine:addState(name, state)
	self.states[name] = state
end

function state_machine:switch(name)
	if self.current_state_name ~= name then
		self.current_state_name = name
		self.current_state = self.states[name]
		if self.current_state.onSwitch then
			self.current_state:onSwitch()
		end
	end
end

function state_machine:getState()
	return self.current_state
end

function state_machine:call(fn, ...)
	assert(self.current_state[fn], "The state " .. self.current_state_name .. " doesn't have the function " .. fn)
	return self.current_state[fn](self.current_state, ...)
end

function state_machine:callSwitch(fn, ...)
	assert(self.current_state[fn], "The state " .. self.current_state_name .. " doesn't have the function " .. fn)
	self:switch(self.current_state[fn](self.current_state, ...))
end

return setmetatable(
	{ new = new },
	{ __call = function(_, ...) return new(...) end }
)
