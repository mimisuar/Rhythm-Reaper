songeditor = class("songeditor")

function songeditor:init(song_file)
	self.cond = conductor(song_file)
	self.cond:load()
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
end