local gamestate = require "lib.hump.gamestate"

function love.load()
	love.graphics.setDefaultFilter("nearest", "nearest")
	local game = require "states.game"
	gamestate.registerEvents()
	gamestate.switch(game)
end

function table.copy(t)
	local u = { }
	for k, v in pairs(t) do u[k] = v end
	return setmetatable(u, getmetatable(t))
end
