function love.load(args)
	class = require("middleclass")
	require("secondtry.conductor")
	require("songeditor")
	require("ground")
	tserial = require("Tserial")
	local player = require("player")
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	editing = true
	
	if editing then
		se = songeditor("berserker armor.txt")
		g = ground(se.cond)
	else
		cond = conductor("berserker armor.txt")
		cond:load()
		cond:toggle_play()
		g = ground(cond)
	end
	
	
	p = player()
end

function love.update(dt)
	g:update(dt)
	if editing then
		se:update()
	else
		cond:update()
	end
end

function love.draw()
	
	g:draw()
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