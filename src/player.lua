local player = class("player")
local anim = require("anim")

function player.load_assets()
	player.static.reaper_sprite = love.graphics.newImage("grim-reaper.png")
	player.static.scythe_sprite = love.graphics.newImage("scythe.png")
	player.static.scythe_swing_sprite = love.graphics.newImage("scythe-swing.png")
	player.static.scythe_swing_anim = anim(player.static.scythe_swing_sprite, 60, 40, 0.1, false)
end

function player:init()
	self.width = 40
	self.height = 40
	self.x = 80
	self.y = (love.graphics.getHeight() - 80)
	self.y_speed = 0
	self.gravity = 128
	self.start_y = self.y
	
	self.float_offset = -4
	self.float_et = 0
	self.float_time = 0.5
	
	self.attacking = false
end

function player:update(dt)
	if love.keyboard.isDown("up") and self.y == self.start_y then
		self.y_speed = -24 * 60
	end
	
	if not self.attacking and love.keyboard.isDown("right") then
		self.attacking = true
		player.scythe_swing_anim:set_frame(1)
	end
		
	
	self.y = self.y + self.y_speed * dt
	self.y_speed = self.y_speed + self.gravity
	if self.y > self.start_y then
		self.y = self.start_y
		self.y_speed = 0
	end
	
	self.float_et = self.float_et + dt
	if self.float_et > self.float_time then
		self.float_et = self.float_et - self.float_time
		if self.float_offset == -4 then self.float_offset = 0 else self.float_offset = -4 end
	end
	
	if self.attacking then
		player.scythe_swing_anim:update(dt)
		if player.scythe_swing_anim:is_finished() then
			self.attacking = false
		end
	end
end

function player:draw()
	love.graphics.draw(player.reaper_sprite, self.x, self.y + self.float_offset)
	if self.attacking then
		love.graphics.draw(player.scythe_swing_sprite, player.scythe_swing_anim:get_frame(), self.x, self.y + self.float_offset)
	else
		love.graphics.draw(player.scythe_sprite, self.x, self.y + self.float_offset)
	end
end

return player