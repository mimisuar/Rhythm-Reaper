gameplay = class("gameplay")

local global_gameplay = nil

function gameplay:init(songfile)
	global_gameplay = self
	
	self.objs = {}
	self.objs.player = require("player")
	self.objs.conductor = require("conductor")
	self.objs.ground = require("ground")
	self.objs.enemy_eye = require("enemy_eye")
	self.objs.spike_wall = require("spike_wall")
	self.objs.ft = require("floating_text")

	self.snare_sound = love.audio.newSource("sounds/snare03.ogg", "static")
	
	self.player = self.objs.player()
	self.conductor = self.objs.conductor(songfile)
	
	
	self.target_x = self.player.x + 30
	
	self.ft = self.objs.ft(self.player.x, self.player.y - 20)
	
	self.score = 0
	self.combo = 0
	
	self.conductor:load()
	self.ground = self.objs.ground(self.conductor)
	
	self.enemies = {}
	self.hit = 0
	self.max_hit = 0
	for i, element in ipairs(self.conductor.data) do
		local pos = (element[1] - 1) * self.conductor.eighth
		if element[2] == "attack" then
			table.insert(self.enemies, self.objs.enemy_eye(pos))
			self.max_hit = self.max_hit + 3
		elseif element[2] == "jump" then
			table.insert(self.enemies, self.objs.spike_wall(pos))
			self.max_hit = self.max_hit + 3
		end
	end
	
	self.current_enemy = 1
	self.ground:speed_up()
	
	self.min = 1
	self.max = #self.enemies
end

function gameplay:update(dt)
	self.conductor:update()
	self.player:update(dt)
	self.ground:update(dt)
	self.ft:update(dt)
	
	self.min = math.max(self.current_enemy - 1, 1)
	self.max = math.min(self.current_enemy + 10, #self.enemies)
	
	for i=1, #self.enemies do
		local enemy = self.enemies[i]
		if enemy.x > -40 then
			enemy:update(dt, self.conductor.position)
		end
		
		
		
		if i == self.current_enemy and enemy.x < self.player.x - 20 then
			self.current_enemy = self.current_enemy + 1
			self.combo = 0
			self.ft:print("MISS!", {1.0, 0.0, 0.0})
		end
	end
	
	if self.ground.speed == self.ground.max_speed and self.current_enemy == 1 then
		self.conductor:play()
	end
	
	if self.current_enemy > #self.enemies then
		-- start fading out the audio --
		self.conductor:fade_out(dt)
		self.ground:slow_down()
	end
	
	
end

function gameplay:draw()
	screen:set()
	
	if self.ground.speed > 0 then
		love.graphics.print("JUMP", original_width / 2 - 100, 32)
		love.graphics.print("ATTACK", original_width / 2 + 20, 32)
	end

	
	self.player:draw()
	self.ground:draw()
	
	for i=self.min, self.max do
		local enemy = self.enemies[i]
		if enemy.x > -40 then
			enemy:draw()
		end
	end
	
	self.ft:draw()
	
	if self.ground.speed == 0 and self.current_enemy > #self.enemies then
		love.graphics.print("Rank " .. self:calc_rank(), 40, 40)
		love.graphics.print(string.format("Accuracy: %02f%%", (self.hit / self.max_hit) * 100), 40, 60)
	end
	
	screen:unset()
	
	screen:draw()
	love.graphics.print(string.format("Score: %07d", self.score))
	love.graphics.print("Combo: " .. tostring(self.combo), 0, 16)
	
end

function gameplay:calc_rank()
	local accuracy = self.hit / self.max_hit
	if accuracy > 0.97 then
		return "S"
	elseif accuracy > 0.93 then
		return "A"
	elseif accuracy > 0.85 then
		return "B"
	elseif accuracy > 0.70 then
		return "C"
	elseif accuracy > 0.50 then
		return "D"
	else
		return "F"
	end
end

function gameplay:attack()
	self.player:attack()
	-- try to attack the current enemy --
	local enemy = self.enemies[self.current_enemy]
	if not enemy then return end
	
	if enemy:isInstanceOf(self.objs.enemy_eye) then
		-- whoop whoop, go ahead --
		local delta = math.abs(enemy.position - self.conductor.position)
		if delta < self.conductor.eighth / 2 then
			enemy:kill()
			self.current_enemy = self.current_enemy + 1
			self:calc_score(delta)
			self:play_snare()
		else 
			-- don't kill it, but cancel the combo --
			self.combo = 0
			self.ft:print("MISS!", {1.0, 0.0, 0.0})
		end
	end
end

function gameplay:jump()
	self.player:jump()
	
	local enemy = self.enemies[self.current_enemy]
	if not enemy then return end
	
	if enemy:isInstanceOf(self.objs.spike_wall) then
		-- whoop whoop, go ahead --
		local delta = math.abs(enemy.position - self.conductor.position)
		if delta < self.conductor.eighth / 2 then
			self.current_enemy = self.current_enemy + 1
			self:calc_score(delta)
			self:play_snare()
		else 
			-- don't kill it, but cancel the combo --
			self.combo = 0
			self.ft:print("MISS!", {1.0, 0.0, 0.0})
		end
	end
end

function gameplay:calc_score(dt)
	-- think about the tiers --
	local db = (self.conductor.eighth)
	local e3 = db -- 50 --
	local e2 = db / 4 -- 100 --
	local e1 = db / 8 -- 500 --
	
	self.combo = self.combo + 1
	
	if dt < e1 then
		self.score = self.score + 500 * self.combo
		self.ft:print("500", {1.0, 1.0, 0.0})
		
		self.hit = self.hit + 3
	elseif dt < e2 then
		self.score = self.score + 100 * self.combo
		self.ft:print("100", {0.0, 1.0, 0.0})

		self.hit = self.hit + 2
	elseif dt < e3 then
		self.score = self.score + 50 * self.combo
		self.ft:print("50", {1.0, 0.0, 1.0})
		self.hit = self.hit + 1
	end
end

function gameplay:mousepressed(x, y)
	if x < love.graphics.getWidth() / 2 then
		self:jump()
	else
		self:attack()
	end
	
	if self.ground.speed == 0 and self.current_enemy > #self.enemies then
		global_state = mainmenu()
	end
end

function gameplay:keypressed(key)
	if key == "up" then
		self:jump()
	elseif key == "right" then
		self:attack()
	end
end

function gameplay:play_snare()
	self.snare_sound:stop()
	self.snare_sound:play()
end

function gameplay.get(var)
	if not var then
		return global_gameplay
	else
		return global_gameplay[var]
	end
end

function gameplay.call(func, ...)
	global_gameplay[func](global_gameplay, ...)
end