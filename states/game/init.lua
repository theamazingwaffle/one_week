local vector  = require "lib.hump.vector"
local animate = require "lib.animate"
local timer   = require "lib.timer"

local Player  = require "states.game.player"
local Bullets = require "states.game.bullets"
local Bombarder   = require "states.game.bombarder"

local game = {}
game.bullets = Bullets("bullets", game)
game.player = Player("player", game)
game.bombarder = Bombarder("bombarder", game)
game.bombTimer = timer.new(0.3)

function game:addBullet(bullet)
	self.bullets:addBullet(bullet)
end

local sine = 0
local sin = math.sin
local sinTimer = 0
function game:update(dt)
	sinTimer = (sinTimer + dt) % 6.28
	sine = sin(sinTimer) + 1
	self.bombTimer:update(dt)
	if self.bombTimer:hasEnded() then
		local pos = vector(sine*300, 0)
		self.bombarder:newBomb(pos, vector(-300, 300))
		self.bombarder:newBomb(pos, vector(300, 300))
		self.bombTimer:reset()
	end
	self.bullets:update(dt)
	self.player:update(dt)
	self.bombarder:update(dt)
	for i, bomb in ipairs(self.bombarder:getBombs()) do
		if self.player:collidesWith(bomb:getShape()) then
			self.player:hit()
			self.bombarder:removeBullet(i)
		end

		for j, bullet in ipairs(self.bullets:getBullets()) do
			if bomb:collidesWith(bullet:getShape()) then
				bomb:hit()
				self.bullets:removeBullet(j)
			end
		end
	end
end

function game:draw()
	love.graphics.clear(254/255, 226/255, 179/255)
	self.bullets:draw()
	self.bombarder:draw()
	self.player:draw()
	love.graphics.setLineStyle("rough")
	love.graphics.setLineWidth(2)
end

return game
