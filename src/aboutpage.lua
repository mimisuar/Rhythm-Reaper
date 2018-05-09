aboutpage = class("aboutpage")

function aboutpage:init()
	self.ground = require("ground")()
	self.player = require("player")()
	
	self.enemy_eye = require("enemy_eye")
	self.enemy_eye.alive_anim:set_frame(1)
	
	self.spike_wall = require("spike_wall")
	self.spike_wall_y = self.player.y
	
	self.player_attack_timer = 5
	self.player_attack_et = 0
	self.player_jump_timer = 7
	self.player_jump_et = 0
	
	self.text = 
[[Welcome to Reaper Rhythm! A rhythm game staring the legendary Grim Reaper!

The controls are very simple: 
Tap the left side of the screen to jump over the spike walls. 
Tap the right side to attack the evil eye monsters.
All to the beat of a song, of course.

This is a demo version containing four short songs. 
The song editor is only available on the PC version of this game.
This game was made using the amazing Love2D game framework.
All code, music, and art by Miguel Suarez.
 
Before you begin play, be sure to configure the input delay and video offset for your device!
Headphones recommended.

Thanks for playing :-)]]
end

function aboutpage:mousepressed(x, y)
	global_state = mainmenu()
end

function aboutpage:update(dt)
	self.player:update(dt)
	self.enemy_eye.alive_anim:update(dt)

	
	self.player_jump_et = self.player_jump_et + dt
	if self.player_jump_et > self.player_jump_timer then
		self.player_jump_et = 0
		self.player:jump()
	end
	
	self.player_attack_et = self.player_attack_et + dt
	if self.player_attack_et > self.player_attack_timer then
		self.player_attack_et = 0
		self.player:attack()
	end
end

function aboutpage:draw()
	love.graphics.print(self.text)
	
	screen:set()
	self.player:draw()
	self.ground:draw()
	love.graphics.draw(self.enemy_eye.alive_sprite, self.enemy_eye.alive_anim:get_frame(), 120, self.player.y)
	love.graphics.draw(self.spike_wall.sprite, 200, self.spike_wall_y)
	
	
	screen:unset()
	screen:draw()
	
	
end