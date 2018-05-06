mainmenu = class("mainmenu")

function mainmenu:init()
	self.select = love.audio.newSource("sounds/snare03.ogg", "static")
	self.elements = {}
		
	local b_armor = {}
	b_armor.text = "Berserker Armor"
	b_armor.x = 10
	b_armor.y = 10
	b_armor.width = 200
	b_armor.height = 20
	b_armor.on_click = function() 
		global_state = gameplay("songs/berserker armor.txt")
	end
	table.insert(self.elements, b_armor)
	
	local id = {}
	id.text = "Configure input delay"
	id.x = 10
	id.y = original_height - 40
	id.width = 140
	id.height = 20
	id.on_click = function()
		global_state = inputdelay()
	end
	table.insert(self.elements, id)
	
	local about = {}
	about.text = "About"
	about.x = id.x + id.width + 20
	about.y = id.y
	about.height = id.height
	about.width = 60
	about.on_click = function()
		love.system.openURL("https://love2d.org/wiki/love.system.openURL")
	end
	table.insert(self.elements, about)
end

function mainmenu:update(dt)
	
end

function mainmenu:draw()
	screen:set()
	
	for i, element in ipairs(self.elements) do
		love.graphics.setColor(0.7, 0.7, 0.7)
		love.graphics.rectangle("fill", element.x, element.y, element.width, element.height)
		love.graphics.setColor(0.0, 0.0, 0.0)
		love.graphics.print(element.text, element.x + 5, element.y + 5)
	end
	screen:unset()
	
	love.graphics.setColor(1.0, 1.0, 1.0)
	screen:draw()
	
	love.graphics.print(string.format("Average delay: %f seconds", global_visual_delay))
end

function mainmenu:mousepressed(x, y)
	x, y = x / screen.scale_x, y / screen.scale_y 
	
	for i, element in ipairs(self.elements) do
		if x > element.x and x < element.x + element.width 
		and y > element.y and y < element.y + element.height then
			self.select:stop()
			self.select:play()
			if element.on_click then element.on_click() end
		end
	end
end