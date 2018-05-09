videooffset = class("videooffset")

function videooffset:init()
	self.times = {}
	self.average = 0
	self.sample = love.audio.newSource("sounds/clap01.ogg", "static")
	
	self.flash_on = false
	
	self.ground = require("ground")()
	self.player = require("player")()
	
	self.target_x = self.player.x + 30
	
	self.obj = {x = original_width + 20, y = self.player.y + 20}
	self.obj_speed = 10 * 60
	
	self.et = 0
	self.time_to_test = 30
end

function videooffset:update(dt)
	self.et = self.et + dt
	self.time_to_test = math.max(self.time_to_test - dt, 0)
	
	self.player:update(dt)
	
	self.obj.x = self.obj.x - self.obj_speed * dt
end

function videooffset:respond()
	if self.time_to_test > 0 then
		local dx = self.target_x - self.obj.x
		table.insert(self.times, dx)
		self.obj.x = original_width + 20
		self.sample:stop()
		self.sample:play()
	
	end
	

	if #self.times > 0 then
		local sum = 0
		for i, time in ipairs(self.times) do
			sum = sum + time
		end
		self.average = sum / #self.times
	end
end

function videooffset:keypressed(key)
	self:respond()
end

function videooffset:mousepressed(x, y)
	self:respond()
	
	if self.time_to_test == 0 then
		global_state = mainmenu()
	end
end

function videooffset:draw()
	
	love.graphics.print("Touch the screen as each object approaches the circle")
	
	screen:set()
	self.ground:draw()
	self.player:draw()
	love.graphics.setColor(1.0, 0.0, 0.0)
	love.graphics.circle("line", self.target_x, self.player.y + 20, 8)
	love.graphics.circle("fill", self.obj.x, self.obj.y, 4)
	
	screen:unset()
	
	love.graphics.setColor(1.0, 1.0, 1.0)
	screen:draw()
	
	if self.time_to_test == 0 then
		love.graphics.print(string.format("Average: %f", self.average), 0, 16)
		love.graphics.print("Press anywhere to continue", 0, 32)
		global_video_offset = self.average
	end
end