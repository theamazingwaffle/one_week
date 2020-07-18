local vector  = require "lib.hump.vector"
local animate = require "lib.animate"
local timer   = require "lib.timer"

local Player  = require "states.game.player"
local Bombarder   = require "states.game.bombarder"

local game = {}
function game:enter()
	self.player = Player("player", game)
	self.bombarder = Bombarder("bombarder", game)
	self.bombTimer = timer.new(0.3)
	self.score = {
		val = 0,
		pos = { x = 50, y = 750 }
	}
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
	self.player:update(dt)
	self.bombarder:update(dt)
	for _, bomb in ipairs(self.bombarder:getBombs()) do
		if self.player:collidesWith(bomb:getShape()) then
			self.player:hit()
			self.bombarder:explodeBomb(bomb)
		end

		for j, bullet in ipairs(self.player:getBullets()) do
			if bomb:collidesWith(bullet:getShape()) then
				bomb:hit()
				if bomb:getHealth() < 1 then
					self.score.val = self.score.val + 1
				end
				self.player:removeBullet(j)
			end
		end
	end
	if self.player:isFuckingDead() then
		self:switchState("menu")
	end
end

local colors = {
	[0] = { 254/255, 226/255, 179/255 },
	[1] = { 86/255, 35/255, 73/255 },
	[2] = { 173/255, 105/255, 137/255 },
}
local font = love.graphics.newFont("res/fnt/Mecha_Bold.ttf", 48)
local clear = love.graphics.clear
local rectangle = love.graphics.rectangle
local getFont = love.graphics.getFont
local setFont = love.graphics.setFont
local setColor = love.graphics.setColor
local printCentered = function() end
local scoreWidth, scoreHeight
function game:draw()
	clear(colors[2])
	setFont(font)
	
	-----
	self.bombarder:draw()
	self.player:draw()
	scoreWidth = getFont():getWidth(tostring(self.score.val))
	scoreHeight = getFont():getHeight()
	setColor(colors[0])
	printCentered(self.score.val, self.score.pos.x, self.score.pos.y)
	setColor(1, 1, 1)
end

function game:keypressed(key)
	self.player:keypressed(key)
end

printCentered = function(text, x, y, r, sx, sy)
	love.graphics.print(text, x, y, r, sx, sy, getFont():getWidth(text)/2, getFont():getHeight()/2)
end

return game
