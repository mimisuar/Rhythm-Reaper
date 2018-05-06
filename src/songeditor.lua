songeditor = class("songeditor")
require("Tserial")

function songeditor:init(song_file)
	--love._openConsole()
	self.cond = require("conductor")(song_file)
	self.cond:load()
	
	--self.target_x = 
	self.dot_buffer = 15
	self.current_dot = 1
	self.dot_count = math.floor(self.cond.song:getDuration() / self.cond.eighth)
	self.dots = {} -- this represent the data of the song --
	self:init_dots()
	
	self.target_x = love.graphics.getWidth() / 2
end

function songeditor:init_dots()
	local c = 1
	for i=1, self.dot_count do
		local curr_dot = self.cond.data[c]
		local dot_tmp = {beat = i, type = ""}
		
		if curr_dot and i == curr_dot[1] and curr_dot[2] ~= "" then
			dot_tmp.beat = curr_dot[1]
			dot_tmp.type = curr_dot[2]
			c = c + 1
		end
		
		table.insert(self.dots, dot_tmp)
	end
end

local min = 1
function songeditor:draw_dots()
	local buffer = 15
	local max = self.cond.counted_beat + buffer
	if max > self.dot_count then max = self.dot_count end
	
	local colors = {
		[""] = {255, 255, 255},
		["jump"] = {0, 255, 0},
		["attack"] = {255, 0, 0}
	}
	
	for i=min, max do
		local x = (((self.dots[i].beat - 1) * self.cond.eighth) - self.cond.position) * self.cond.speed
		love.graphics.setColor(colors[self.dots[i].type])
		love.graphics.circle("fill", self.target_x + x - 8, 40, 8)
		
		if self.target_x + x < 0 then
			min = i
		end
	end
	
	love.graphics.setColor(colors[""])
end

function songeditor:update(dt)
	self.cond:update()
end

function songeditor:draw()
	love.graphics.print("Beat counted: " .. tostring(self.cond.counted_beat), 0, 0)
	love.graphics.print("Beat: " .. tostring(self.cond.beat), 0, 16)
	love.graphics.print("Bar: " .. tostring(self.cond.bar), 0, 32)
	love.graphics.print("Position: " .. tostring(self.cond.position), 0, 48)
	
	if not self.cond.playing then
		love.graphics.print("Press space to play/pause", 0, 64)
	end
	
	self:draw_dots()
	love.graphics.rectangle("line", self.target_x - 9, 0, 2, 64)
end

function songeditor:keypressed(key)
	if key == "space" then
		self.cond:toggle_play()
	end
	
	if key == "left" then
		self.cond:set_pos_to_beat(-1)
		min = min - 1
		if min < 1 then
			min = 1
		end
	end
	
	if key == "down" then
		self.cond:set_pos_to_beat(0)
	end
	
	if key == "right" then
		self.cond:set_pos_to_beat(1)
	end
	
	if key == "w" then
		for i=1, self.dot_count do
			if self.dots[i].beat == self.cond.counted_beat then
				self.dots[i].type = "jump"
			end
		end
	end
	
	if key == "e" then
		for i=1, self.dot_count do
			if self.dots[i].beat == self.cond.counted_beat then
				self.dots[i].type = "attack"
			end
		end
	end
	
	if key == "q" then
		for i=1, self.dot_count do
			if self.dots[i].beat == self.cond.counted_beat then
				self.dots[i].type = ""
			end
		end
	end
	
	if key == "s" then
		self:save()
	end
end

function songeditor:save()
	-- go through the dots, picking only the ones that are attack/jump --
	local data = {}
	for i=1, self.dot_count do
		if self.dots[i].type ~= "" then
			table.insert(data, {self.dots[i].beat, self.dots[i].type })
		end
	end
	
	-- literally just copy the string table to the clipboard --
	local str = Tserial.pack(data, function(value)
		print("Unable to pack " .. tostring(value) .. ".")
	end, false)
	
	local f = love.filesystem.newFile(self.cond.song_file)
	local success, err = f:open("w")
	if not success then error(err) end
	
	f:write(self.cond.song_title) f:write("\n")
	f:write(tostring(self.cond.bpm)) f:write("\n")
	f:write(tostring(self.cond.offset)) f:write("\n")
	f:write(str)
end