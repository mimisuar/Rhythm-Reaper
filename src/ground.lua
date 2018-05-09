local ground = class("ground")

function ground:init(cond)
	--love._openConsole()
	self.bg = love.graphics.newCanvas(original_width, original_height)
	
	local brick = love.graphics.newImage("graphics/brick1.png")
	love.graphics.setCanvas(self.bg)
	
	local quad = love.graphics.newQuad(40, 0, 40, 40, brick:getWidth(), brick:getHeight())
	local y = self.bg:getHeight() - 40
	for x=0, self.bg:getWidth() - 40, 40 do
		love.graphics.draw(brick, quad, x, y)
	end
	
	love.graphics.setCanvas()
	
	self.cond = cond
	if self.cond then
		self.max_speed = self.cond.speed
	else
		self.max_speed = 0
	end
	self.speed = 0
	
	
	self.x = { 0, self.bg:getWidth() }
	self.target_x = -self.bg:getWidth()
	
	self.slowing_down = false
	self.speeding_up = false
	
end

function ground:draw()
	for i=1, #self.x do
		love.graphics.draw(self.bg, self.x[i])
	end
end

function ground:update(dt)
	if self.cond then
		for i=1, #self.x do
			self.x[i] = self.x[i] - self.speed * dt
			
			if self.x[i] < self.target_x then
				self.x[i] = self.x[i] + self.bg:getWidth() * 2
			end
		end
		
		if self.slowing_down then
			self.speed = math.max(self.speed - (5 * 60) * dt, 0)
			if self.speed == 0 then self.slowing_down = false end
		end
		
		if self.speeding_up then
			self.speed = math.min(self.speed + (5 * 60) * dt, self.max_speed)
			if self.speed == self.max_speed then self.speeding_up = false end
		end
	end
end

function ground:slow_down()
	self.slowing_down = true
end


function ground:speed_up()
	self.speeding_up = true
end

return ground