ground = class("ground")

function ground:init(cond)
	self.bg = love.graphics.newCanvas(original_width, original_height)
	
	local brick = love.graphics.newImage("bricks1.png")
	love.graphics.setCanvas(self.bg)
	
	local quad = love.graphics.newQuad(40, 40, 40, 40, brick:getWidth(), brick:getHeight())
	local y = self.bg:getHeight() - 40
	for x=0, self.bg:getWidth() - 40, 40 do
		love.graphics.draw(brick, quad, x, y)
	end
	
	love.graphics.setCanvas()
	
	self.cond = cond
	
	self.x = { 0, self.bg:getWidth() }
	self.target_x = -self.bg:getWidth()
end

function ground:draw()
	love.graphics.draw(self.bg, self.x[1])
end

function ground:update(dt)
	self.x[1] = self.x[1] - self.cond.position * self.dot_speed
end