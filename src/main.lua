function love.load()
	class = require("lib.middleclass")
	local p = require("player")
	player = p()
	
	--love._openConsole()
end

function love.update(dt)
	player:update(dt)
end

function love.draw()
	player:draw()
end

function love.keypressed(key)
	for k, value in pairs(game_actions) do
		if value.key and key == value.key then
			value.active = true
		end
	end
end

function love.keyreleased(key)
	for k, value in pairs(game_actions) do
		if value.key and key == value.key then
			value.active = false
		end
	end
end

function love.touchpressed(id, x, y)
	for k, value in pairs(game_actions) do
		if value.touch then
			print(x, y)
			value.active = true
			value.pos = {x = x, y = y}
		end
	end
end

function love.touchreleased(id, x, y)
	for k, value in pairs(game_actions) do
		if value.touch then
			value.active = false
			value.pos = {x = x, y = y}
		end
	end
end

game_actions = {}

game_actions.jump = {
	key = "up",
	touch = true
}

game_actions.swipe = {
	key = "right",
	touch = true
}