function love.load(args)
	class = require("middleclass")
	require("conductor")
	require("songeditor")
	
	se = songeditor("berserker armor.ogg")
end

function love.update(dt)
	se:update()
end

function love.draw()
	se:draw()
end

function love.keypressed(key)
	se:keypressed(key)
end