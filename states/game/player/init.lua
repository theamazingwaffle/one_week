local vector = require "lib.hump.vector"
local HC       = require "lib.HC"
local animate  = require "lib.animate"
local fsm = require "lib.statemachine"
local timer = require "lib.timer"

local idle  = require "states.game.player.hitstates.idle"
local iframes = require "states.game.player.hitstates.iframes"
local dead = require "states.game.player.hitstates.dead"

local bullet = require "states.game.player.bullet"

local player = {}
player.__index = player

local SPEED = 300
player.update = function(self, dt)
	self.bulletTimer:update(dt)
	if not (self.hitstate:call("getName") == "dead") then
		self.sprite = self.sprites.middle
		if love.keyboard.isDown("w") then
			self.pos.y = self.pos.y - SPEED * dt
		elseif love.keyboard.isDown("s") then
			self.pos.y = self.pos.y + SPEED * dt
		end
		if love.keyboard.isDown("d") then
			self.sprite = self.sprites.right
			self.pos.x = self.pos.x + SPEED * dt
		elseif love.keyboard.isDown("a") then
			self.sprite = self.sprites.left
			self.pos.x = self.pos.x - SPEED * dt
		end
		self.shape:moveTo(self.pos:unpack())
	end
	self.hitstate:callSwitch("update", dt)

	if not self.shieldActive and self.bulletTimer:hasEnded() and not (self.health <= 0) then
		-- this part shoots
		table.insert(self.bullets, bullet({ x = self.pos.x + 16, y = self.pos.y - 16 }, vector(0, -800)))
		table.insert(self.bullets, bullet({ x = self.pos.x - 16, y = self.pos.y - 16 }, vector(0, -800)))
	end

	for _, bullet in ipairs(self.bullets) do
		bullet:update(dt)
	end
end

player.hit = function(self)
	if not self.shieldActive then
		self.hitstate:callSwitch("hit")
	end
end

player.isFuckingDead = function(self)
	return self.hitstate:call("isFuckingDead")
end

local setLineWidth = love.graphics.setLineWidth
local getLineWidth = love.graphics.getLineWidth
local setColor = love.graphics.setColor
local circle = love.graphics.circle
-- functions that don't switch the state
player.draw = function(self)
	self.hitstate:call("draw")
	if self.shieldActive then
		local lw = getLineWidth()
		setLineWidth(2)
		setColor(86/255, 35/255, 73/255)
		circle("line", self.pos.x, self.pos.y, 32)
		setColor(191/255, 117/255, 133/255, 0.5)
		circle("fill", self.pos.x, self.pos.y, 32)
		setColor(1, 1, 1)
		setLineWidth(lw)
	end
	for _, bullet in ipairs(self.bullets) do
		bullet:draw()
	end
end

player.addBullet = function(self, bullet)
	table.insert(self.bullets, bullet)
end

player.damage = function(self, damage)
	self.health = self.health - damage
end

player.collidesWith = function(self, shape)
	return self.hitstate:call("collidesWith", shape)
end

player.getPos = function(self)
	return table.copy(self.pos)
end

player.getShape = function(self)
	return self.shape
end

player.getBullets = function(self)
	return self.bullets
end

player.removeBullet = function(self, i)
	table.remove(self.bullets, i)
end

player.keypressed = function(self, key)
	if key == "space" then
		self.shieldActive = not self.shieldActive
	end
end

new = function()
	local t = {}
	t.sprites = {
		left   = animate("res/gfx/aircraft3.png"),
		middle = animate("res/gfx/aircraft1.png"),
		right  = animate("res/gfx/aircraft2.png"),
		explosion  = animate("res/gfx/explosion.png"),
	}
	t.sprites.explosion:setFps(10)
	t.sprites.explosion:setWidth(32)
	t.sprites.explosion:setLooping(false)
	for _, sprite in pairs(t.sprites) do
		sprite:setScale(4)
	end
	t.sprite = t.sprites.middle

	t.hitstate = fsm("idle", idle(t))
	t.hitstate:addState("iframes", iframes(t))
	t.hitstate:addState("dead", dead(t))
	-- i would've added a shield state machine but i'm fucking sick
	t.shieldActive = false
	t.bulletTimer = timer(0.05)
	t.bullets = {}
	t.pos = vector(300, 750)
	t.dir = vector(0, 0)
	t.SPEED = 400
	t.shape = HC.circle(t.pos.x, t.pos.y, 25)
	t.health = 4

	t.bullets = {}

	return setmetatable(t, player)
end

return setmetatable(
	{ new = new },
	{ __call = function(_, ...) return new(...) end }
)
