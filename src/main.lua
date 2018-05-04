function love.load()
	class = require("middleclass")
	objs = {}
	objs.player = require("player")
	objs.conductor = require("conductor")
	objs.ground = require("ground")
	objs.enemy_eye = require("enemy_eye")
	objs.spike_wall = require("spike_wall")
	
	objs.player.load_assets()
	objs.enemy_eye.load_assets()
	objs.spike_wall.load_assets()
	
	player = objs.player()
	conductor = objs.conductor("berserker armor.txt")
	ground = objs.ground(conductor)
	
	conductor:load()
	
	enemies = {}
	for i, element in ipairs(conductor.data) do
		local pos = (element[1] - 1) * conductor.eighth
		if element[2] == "attack" then
			table.insert(enemies, objs.enemy_eye(pos))
		elseif element[2] == "jump" then
			table.insert(enemies, objs.spike_wall(pos))
		end
	end
	
	conductor:toggle_play()
end

function love.update(dt)
	player:update(dt)
	conductor:update()
	ground:update(dt)
	target_x = player.x + 40
	
	for i, enemy in ipairs(enemies) do
		enemy:update(dt, conductor.position)
	end
end

function love.draw()
	player:draw()
	ground:draw()
	
	for i, enemy in ipairs(enemies) do
		enemy:draw()
	end
end