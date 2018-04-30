function love.load()
	love.audio.stop()
	class = require("middleclass")
	require("conductor")
	require("ground")
	
	c = conductor("berserker armor.txt")
	c:load()
	c:toggle_play()
	lastnote = 0
	beat = 1
	
	--local t_dots = {{2.0404334068298,"jump"},{2.5105330944061,"jump"},{3.3307070732117,"jump"},{3.780802488327,"jump"},{4.0108513832092,"jump"},{4.4909529685974,"jump"},{5.2611165046692,"jump"},{5.7612223625183,"jump"},{6.01127576828,"jump"},{6.5013794898987,"jump"},{7.2815446853638,"jump"},{7.7216382026672,"jump"},{7.9716911315918,"jump"},{8.4918041229248,"jump"},{9.2819757461548,"jump"},{9.742075920105,"jump"},{9.992130279541,"jump"},{10.512243270874,"jump"},{11.302414894104,"jump"},{11.752511978149,"jump"},{12.002566337585,"jump"},{12.482670783997,"jump"},{13.282844543457,"jump"},{13.722940444946,"jump"},{13.972993850708,"jump"},{14.483105659485,"jump"},{15.233267784119,"jump"},{15.703370094299,"jump"},{15.973428726196,"jump"},{16.443531036377,"jump"}}
	local t_dots = {9, 11, 14, 16, 17, 19, 22, 24}
	dots = {}
	for i=1, #t_dots do
		
		--table.insert(dots, t_dots[i][1] )--* c.quarter)
		table.insert(dots, ((t_dots[i] - 1) / 2) * c.quarter)
	end
	
	dot_current = 1
	
	target_x = 80
	dot_speed = c.bpm * c.beats_per_measure -- pixels / second --
	
	epsilon = {}
	epsilon[1] = 0.05
	epsilon[2] = 0.2
	epsilon[3] = 0.3
	
	g = ground(c)
end

function love.update(dt)
	c:update(dt)
	
	g:update(dt)
end

function draw_dots()
	for i=1, #dots do
		love.graphics.circle("fill", ((dots[i] - c.position) * dot_speed) + target_x, 100, 4)
	end
end

function love.draw()
	love.graphics.print("Position: " .. tostring(c.position))
	love.graphics.print("Beat: " .. tostring(c.counted_beat), 0, 16)
	draw_dots()
	g:draw()
	
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