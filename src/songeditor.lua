songeditor = class("songeditor")

function songeditor:init(song_file)
	--love._openConsole()
	self.cond = conductor(song_file)
	self.cond:load()
	self.data = {}
	
	--self.target_x = 
	self.dot_buffer = 15
	self.current_dot = 1
	self.dot_count = math.floor(self.cond.song:getDuration() / self.cond.eighth)
	self.dots = {} -- this represent the data of the song --
	
end

function songeditor:update(dt)
	self.cond:update()
end

function songeditor:draw()
	love.graphics.print("Beat: " .. tostring(self.cond.counted_beat))
	love.graphics.print("Bar: " .. tostring(self.cond.bar), 0, 16)
	love.graphics.print("Position: " .. tostring(self.cond.position), 0, 32)
	
	if not self.cond.playing then
		love.graphics.print("Press space to play/pause", 0, 64)
	end
end

function songeditor:draw_dots()
	
end

function songeditor:keypressed(key)
	if key == "space" then
		self.cond:toggle_play()
	end
	
	if key == "up" then
		table.insert(self.data, { self.cond.position, "jump" })
		print(self.cond.position, "jump")
	end
	
	if key == "right" then
		table.insert(self.data, { self.cond.position, "attack" })
		print(self.cond.position, "attack")
	end
	
	if key == "s" then
		self:save()
	end
end

function songeditor:save()
	-- literally just copy the string table to the clipboard --
	local str = tserial.pack(self.data, function(value)
		print("Unable to pack " .. tostring(value) .. ".")
	end, false)
	
	
end