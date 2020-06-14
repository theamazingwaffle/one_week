local animation = {}
animation.__index = animation

--- creates a new animation
--  is the same as `animate.new`
--  @param imagePath Path to the spritesheet
--  @param x Offset on the x axis
--  @param y Offset on the y axis
--  @param width One frame's width
--  @param height One frame's height
--  @param framesCount Total amount of frames
--  @param fps Framerate.
--  NOTE:
--  If you intend on using FPS, you will need to call
--  animation:update(dt) inside your update function
--  If you don't intend on using FPS, you will need to call
--  animation:next() every frame yourself

local function new(imagePath, x, y, width, height, framesCount, fps)
	imagePath = assert(imagePath, "Please provide an image path")

	local image = love.graphics.newImage(imagePath)
	local fps = fps or 60
	local framesCount = framesCount or 1
	local width = width or select(1, image:getDimensions())/framesCount
	local height = height or select(2, image:getDimensions())
	local x = x or 0
	local y = y or 0
	local t = {
		x = x or 0,
		y = y or 0,
		width = width,
		height = height,
		quad = love.graphics.newQuad(x, y, width, height, image:getDimensions()),
		frame = -1,
		fps = fps,
		timer = 1/fps,
		image = image,
		sx = 1,
		sy = 1,
		dx = 1,
		dy = 1,
		rotation = 0,
		framesCount = framesCount,
		looping = true,
		draw = love.graphics.draw,
	}
	return setmetatable(t, animation)
end

function animation:next()
	if self.frame < self.framesCount then
		self.frame = self.frame + 1
		if self.looping then
			self.frame = self.frame % self.framesCount
		end
	end
	self.quad:setViewport(self.frame * self.width + self.x, self.y, self.width, self.height, self.image:getDimensions())
end

function animation:update(dt)
	self.timer = self.timer - dt
	if self.timer <= 0 then
		self.timer = 1 / self.fps
		self:next()
	end
end

function animation:draw(x, y)
	self.draw(self.image, self.quad, x, y, self.rotation, self.sx * self.dx, self.sy * self.dy)
end

function animation:drawCentered(x, y)
	self:drawOffset(x, y, self.width/2, self.height/2)
end

function animation:drawOffset(x, y, ox, oy)
	self.draw(self.image, self.quad, x, y, self.rotation, self.sx * self.dx, self.sy * self.dy, ox, oy)
end

function animation:rotate(radians)
	self.rotation = self.rotation + radians
end

function animation:reset()
	self.frame = 0
	self.quad:setViewport(self.frame * self.width + self.x, self.y, self.width, self.height, self.image:getDimensions())
end

function animation:setScale(x, y)
	assert(x, "Please provide a scalar")
	self.sx = x
	self.sy = y or x
end

function animation:setDirection(x, y)
	self.dx = x or self.dx
	self.dy = y or self.dy
end

function animation:setRotation(rotation)
	self.rotation = rotation
end

function animation:setFps(fps)
	self.fps = fps
	self.timer = 1/fps
end

function animation:setWidth(w)
	self.width = w
	self.framesCount = math.floor(select(1, self.image:getDimensions())/self.width)
	self.quad:setViewport(self.frame * self.width + self.x, self.y, self.width, self.height, self.image:getDimensions())
end

function animation:setLooping(bool)
	self.looping = bool
end

return setmetatable(
	{
		new = new,
	},
	{
		__call = function(_, ...) return new(...) end
	}
)
