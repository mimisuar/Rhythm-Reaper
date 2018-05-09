function love.load(args)
	love.graphics.setDefaultFilter("nearest", "nearest")
	
	class = require("middleclass")
	require("mainmenu")
	require("gameplay")
	require("songeditor")
	require("inputdelay")
	require("aboutpage")
	require("screen")
	require("videooffset")
	screen:init()
	
	require("player").load_assets()
	require("enemy_eye").load_assets()
	require("spike_wall").load_assets()
	
	--if not love.filesystem.getInfo("songs", "directory") then
	love.filesystem.createDirectory("songs")
	--end
	
	--args = {"--se", "songs/frozenbits.txt"}
	global_state = {}
	for i=1, #args do
		if args[i] == "--se" then
			assert(type(args[i + 1]) == "string", "Invalid song title.")
			editing_mode = true
			editing_song = args[i + 1]
			global_state = songeditor(editing_song)
		end
	end
	
	global_audio_delay = 0 -- seconds
	global_video_offset = 0
	if not editing_mode then
		--global_state = gameplay("songs/berserker armor.txt")
		--global_state = inputdelay()
		global_state = mainmenu()
	end
	
end

function love.update(dt)
	if global_state.update then global_state:update(dt) end
end

function love.draw()
	if global_state.draw then global_state:draw() end
end

function love.mousepressed(x, y, b, isTouch)
	if global_state.mousepressed then global_state:mousepressed(x, y) end
end

function love.keypressed(key)
	if global_state.keypressed then global_state:keypressed(key) end
end