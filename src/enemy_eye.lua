local enemy_eye = class("enemy_eye")
local anim = require("anim")

function enemy_eye.load_assets()
	enemy_eye.static.alive_sprite = love.graphics.newImage("evil-eye.png")
	enemy_eye.static.alive_anim = anim(enemy_eye.static.alive_sprite, 40, 40, 0.1, true)
	enemy_eye.static.dead_sprite = love.graphics.newImage("evil-eye-death.png")
	enemy_eye.static.dead_anim = anim(enemy_eye.static.dead_sprite, 40, 40, 0.05, false)
end

function enemy_eye:init(position)
	self.alive = true
	self.x = 0
	self.y = 0
	
	self.position = position -- in the song --
end

function enemy_eye:update(dt, position)
	if self.alive then
		self.x = (self.position - position) * gameplay.get("conductor").speed + gameplay.get("target_x")
		self.y = gameplay.get("player").y
	else
		enemy_eye.dead_anim:update(dt)
		if enemy_eye.dead_anim:is_finished() then
			self.x = -50
		end
	end
end

function enemy_eye:draw()
	--love.graphics.circle("line", self.x, love.graphics.getHeight() - 120, 8)
	
	if self.alive then
		love.graphics.draw(enemy_eye.alive_sprite, enemy_eye.alive_anim:get_frame(), self.x, self.y)
	else
		love.graphics.draw(enemy_eye.dead_sprite, enemy_eye.dead_anim:get_frame(), self.x, self.y)
	end
end

function enemy_eye:kill()
	self.alive = false
	enemy_eye.dead_anim:set_frame(1)
end

return enemy_eye