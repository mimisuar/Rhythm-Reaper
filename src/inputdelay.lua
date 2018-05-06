inputdelay = class("inputdelay")

function inputdelay:init()
	self.times = {}
	self.average = 0
	self.sample = love.audio.newSource("sounds/clap01.ogg", "static")
	
	local ft = require("floating_text")
	self.ft = ft(100, 100)
	
	self.flash_on = false
	
	self.et = 0
	self.beat = 1
	self.time_to_test = 30
	
	self.flash_on_time = 0
end

function inputdelay:update(dt)
	self.et = self.et + dt
	self.time_to_test = math.max(self.time_to_test - dt, 0)
	
	self.ft:update(dt)
	
	if self.time_to_test > 0 and self.et > self.beat then
		self.et = 0
		self.sample:stop()
		self.flash_on = true
		self.flash_on_time = love.timer.getTime()
		self.sample:play()
	end
end

function inputdelay:respond()
	if self.flash_on then
		local response_time = love.timer.getTime()
		local delay = response_time - self.flash_on_time
		table.insert(self.times, delay)
		self.flash_on = false
		
		if #self.times > 0 then
			local sum = 0
			for i, time in ipairs(self.times) do
				sum = sum + time
			end
			self.average = sum / #self.times
		end
		
		self.ft:print("Click!")
	end
	
	
end

function inputdelay:keypressed(key)
	self:respond()
end

function inputdelay:mousepressed(x, y)
	self:respond()
	
	if self.time_to_test == 0 then
		global_state = mainmenu()
	end
end

function inputdelay:draw()
	
	love.graphics.print("Touch the screen when you hear the sound")
	self.ft:draw()
	
	if self.time_to_test == 0 then
		love.graphics.print(string.format("Average: %f s", self.average), 0, 16)
		love.graphics.print("Press anywhere to continue", 0, 32)
		global_visual_delay = self.average
	end
end