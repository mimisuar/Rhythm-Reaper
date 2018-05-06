function love.load(args)
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	class = require("middleclass")
	require("gameplay")
	require("songeditor")
	
	args = {"--se", "berserker armor.txt"}
	for i=1, #args do
		if args[i] == "--se" then
			assert(type(args[i + 1]) == "string", "Invalid song title.")
			editing_mode = true
			editing_song = args[i + 1]
		end
	end
	
	if not editing_mode then
		first_level = gameplay()
	else
		se = songeditor(editing_song)
	end
	
end

function love.update(dt)
	if not editing_mode then
		first_level:update(dt)
	else
		se:update(dt)
	end
end

function love.draw()
	if not editing_mode then
		first_level:draw()
	else
		se:draw()
	end
end

function love.mousepressed(x, y, b, isTouch)
	if not editing_mode then
		first_level:mousepressed(x, y)
	else
		se:mousepressed(x, y)
	end
end

function love.keypressed(key)
	if not editing_mode then
		first_level:keypressed(key)
	else
		se:keypressed(key)
	end
end