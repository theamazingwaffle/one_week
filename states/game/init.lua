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
game.score = {
	val = 0
}

function game.score:add(num)
	self.val = self.val + 1
end

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
	for _, bomb in ipairs(self.bombarder:getBombs()) do
		if bomb:collidesWith(self.player:getShape()) then
			self.player:hit()
			self.bombarder:explodeBomb(bomb)
		end

		for j, bullet in ipairs(self.bullets:getBullets()) do
			if bomb:collidesWith(bullet:getShape()) then
				bomb:hit()
				if bomb:getHealth() < 1 then
					self.score:add(1)
				end
				self.bullets:removeBullet(j)
			end
		end
	end
end

local printCentered = function() end
local font = love.graphics.newFont("res/fnt/Mecha_Bold.ttf", 48)
local print = love.graphics.print
local clear = love.graphics.clear
local setLineWidth = love.graphics.setLineWidth
local setLineStyle = love.graphics.setLineStyle
local setDefaultFilter = love.graphics.setDefaultFilter
local setFont = love.graphics.setFont
function game:draw()
	clear(254/255, 226/255, 179/255)
	
	-----
	self.bullets:draw()
	self.bombarder:draw()
	self.player:draw()
	printCentered(self.score.val, 300, 400)

	-----
	setLineStyle("rough")
	setLineWidth(2)
	setDefaultFilter("nearest", "nearest")
	setFont(font)
end

printCentered = function(text, x, y, r, sx, sy)
	love.graphics.print(text, x, y, r or 0, sx or 1, sy or 1, love.graphics.getFont():getWidth(text)/2, love.graphics.getFont():getHeight()/2)
end

return game
