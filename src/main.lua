function love.load(args)
	class = require("middleclass")
	require("conductor")
	require("songeditor")
	tserial = require("Tserial")
	local player = require("player")
	
	editing = false
	
	if editing then
		se = songeditor("berserker armor.txt")
	else
		cond = conductor("berserker armor.txt")
		cond:load()
		cond:toggle_play()
	end
	
	p = player()
end

function love.update(dt)
	if editing then
		se:update()
	else
		cond:update()
	end
end

function love.draw()
	if editing then
		se:draw()
	else
		love.graphics.print(cond.position)
	end
	p:draw()
end

function love.keypressed(key)
	if editing then
		se:keypressed(key)
	end
end