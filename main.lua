local gamestate = require "lib.hump.gamestate"

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	local states = {
		game = require "states.game",
		menu = require "states.menu",
	}

	for _, state in pairs(states) do
		state.switchState = function(self, name)
			gamestate.switch(states[name])
		end
	end
	gamestate.registerEvents()
	gamestate.switch(states.menu)
end

function table.copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end
