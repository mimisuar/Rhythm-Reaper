local player = class("player")

function player:init()
	self.width = 40
	self.height = 40
	self.x = 80
	self.y = (love.graphics.getHeight() - love.graphics.getHeight() / 4) - self.height / 2
	self.y_speed = 0
	self.gravity = 128
	self.start_y = self.y
end

function player:update(dt)
	if game_actions.jump.active and self.y == self.start_y then
		if game_actions.jump.pos then
			if game_actions.jump.pos.y < 200 then
				self.y_speed = -20 * 60
			end
		else
			self.y_speed = -20 * 60
		end
	end
	
	self.y = self.y + self.y_speed * dt
	self.y_speed = self.y_speed + self.gravity
	if self.y > self.start_y then
		self.y = self.start_y
		self.y_speed = 0
	end
end

function player:draw()
	love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return player