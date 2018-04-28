function love.load()
	class = require("middleclass")
	require("conductor")
	
	c = conductor("berserker armor.txt")
	c:load()
	c:toggle_play()
	lastnote = 0
	beat = 1
	
	dots = {}
	dot_current = 1
	
	target_x = 80
	dot_speed = c.bpm * c.beats_per_measure -- pixels / second --
	dot_song_position = 4 * c.quarter -- beat --
	dot_x = ((dot_song_position - c.position) * c.quarter * dot_speed) + target_x
	
	epsilon = {}
	epsilon[1] = 0.05
	epsilon[2] = 0.2
	epsilon[3] = 0.3
end

function love.update(dt)
	c:update(dt)
end

function draw_dots()
	for i=1, #dots do
		love.graphics.circle("fill", ((dots[i] - c.position) * c.quarter * dot_speed) + target_x, 100, 4)
	end
end

function love.draw()
	love.graphics.print("Position: " .. tostring(c.position))
	love.graphics.print("Delta position: " .. tostring(dot_song_position - c.position), 0, 16)
	draw_dots()
	
	--love.graphics.rectangle("line", target_x, 80, 40, 40)
	
	local colors = {
		{0, 255, 0},
		{255, 255, 0},
		{255, 0, 0}
	}
	
	for i=1, #epsilon do
		love.graphics.setColor(colors[i])
		local width = (epsilon[i] + 0.8) * 40
		love.graphics.rectangle("line", target_x - width / 2, 80, width, 40)
		love.graphics.setColor(255, 255, 255)
	end
	
	local text = {
		"PERFECT!",
		"Great",
		"Miss"
	}
	
	if dot_current > 1 then
		love.graphics.setColor(colors[e_level])
		love.graphics.print(text[e_level] .. " " .. tostring(dp), 0, 32)
		love.graphics.setColor(255, 255, 255)
	end
end

function love.keypressed(key)
	if key == "space" and dot_current <= #dots then
		
		dp = math.abs(dots[dot_current] - c.position)
		
		e_level = 3
		for i=1, 3 do
			if dp <= epsilon[i] then
				e_level = i
				break
			end
		end
		
		dot_current = dot_current + 1
	end
	
	if key == "r" then
		love.load()
	end
end