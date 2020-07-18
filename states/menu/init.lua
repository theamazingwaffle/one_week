local menu = {}

local font = love.graphics.newFont("res/fnt/Mecha_Bold.ttf", 48)
local clear = love.graphics.clear
local setFont = love.graphics.setFont
local getFont = love.graphics.getFont
local setColor = love.graphics.setColor
local printCentered = function() end
local colors = {
	[0] = { 254/255, 226/255, 179/255 },
	[1] = { 86/255, 35/255, 73/255 },
	[2] = { 173/255, 105/255, 137/255 },
}
function menu:draw()
	clear(colors[2])
	setFont(font)

	-----
	setColor(colors[0])
	printCentered("Press [space] or [enter] to start.", 300, 400, 0, 0.8, 0.8)
	setColor(1, 1, 1)
end

printCentered = function(text, x, y, r, sx, sy)
	love.graphics.print(text, x, y, r, sx, sy, getFont():getWidth(text)/2, getFont():getHeight()/2)
end

function menu:keypressed(key)
	if key == "space" or key == "return" then
		self:switchState("game")
	end
end

return menu
