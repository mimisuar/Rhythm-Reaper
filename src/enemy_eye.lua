local enemy_eye = class("enemy_eye")
local anim = require("anim")

function enemy_eye.load_assets()
	enemy_eye.static.alive_sprite = love.graphics.newImage("evil-eye.png")
	enemy_eye.static.alive_anim = anim(enemy_eye.static.alive_sprite, 40, 40, 0.1, true)
	enemy_eye.static.dead_sprite = love.graphics.newImage("evil-eye-dead.png")
	enemy_eye.static.dead_anim = anim(enemy_eye.static.dead_sprite, 40, 40, 0.05, false)
end

function enemy_eye:init()
	self.alive = true
	self.x = 0
	self.y = 0
end

function enemy_eye:update(dt)
	if self.alive then
		-- update the position --
	else
		
	end
end