songeditor = class("songeditor")

function songeditor:init(song_file)
	love._openConsole()
	self.cond = conductor(song_file)
	self.cond:load()
	self.data = {}
end

function songeditor:update(dt)
	self.cond:update()
end

function songeditor:draw()
	love.graphics.print("Beat: " .. tostring(self.cond.beat))
	love.graphics.print("Bar: " .. tostring(self.cond.bar), 0, 16)
	love.graphics.print("Position: " .. tostring(self.cond.position), 0, 32)
	
	if not self.cond.playing then
		love.graphics.print("Press space to play/pause", 0, 48)
	end
end

function songeditor:keypressed(key)
	if key == "space" then
		self.cond:toggle_play()
	end
	
	if key == "up" then
		table.insert(self.data, { self.cond.counted_beat, "jump" })
		print(self.cond.counted_beat, "jump")
	end
	
	if key == "right" then
		table.insert(self.data, { self.cond.counted_beat, "attack" })
		print(self.cond.counted_beat, "attack")
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
	
	love.system.setClipboardText(str)
	
	print("Copied data to clipboard")
end