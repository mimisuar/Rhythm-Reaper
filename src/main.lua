function love.load()
	class = require("middleclass")
	objs = {}
	objs.player = require("player")
	objs.conductor = require("conductor")
	objs.ground = require("ground")
	
	objs.player.load_assets()
	
	player = objs.player()
	conductor = objs.conductor("berserker armor.txt")
	ground = objs.ground(conductor)
	
	conductor:load()
end

function love.update(dt)
	player:update(dt)
	conductor:update()
	ground:update(dt)
end

function love.draw()
	player:draw()
	ground:draw()
end