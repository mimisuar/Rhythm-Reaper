screen = class("screen")

function screen:init()
	self.canvas = love.graphics.newCanvas()
	self.scale_x = love.graphics.getWidth() / original_width
	self.scale_y = love.graphics.getHeight() / original_height
end

function screen:set()
	love.graphics.setCanvas(self.canvas)
	love.graphics.clear()
end

function screen:unset()
	love.graphics.setCanvas()
end

function screen:draw()
	love.graphics.draw(self.canvas, 0, 0, 0, self.scale_x, self.scale_y)
end