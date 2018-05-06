local ground = class("ground")

function ground:init(cond)
	--love._openConsole()
	self.bg = love.graphics.newCanvas(original_width, original_height)
	
	local brick = love.graphics.newImage("brick1.png")
	love.graphics.setCanvas(self.bg)
	
	local quad = love.graphics.newQuad(40, 0, 40, 40, brick:getWidth(), brick:getHeight())
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
	for i=1, #self.x do
		love.graphics.draw(self.bg, self.x[i])
	end
end

function ground:update(dt)
	if self.cond then
		for i=1, #self.x do
			self.x[i] = self.x[i] - self.cond.speed * dt
			
			if self.x[i] < self.target_x then
				self.x[i] = self.x[i] + self.bg:getWidth() * 2
			end
		end
	end
end

return ground