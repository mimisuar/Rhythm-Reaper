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
	
	local organ = {}
	organ.text = "Organelle"
	organ.x = 10
	organ.y = b_armor.y + b_armor.height + 10
	organ.width = 200
	organ.height = 20
	organ.on_click = function() 
		global_state = gameplay("songs/organelle.txt")
	end
	table.insert(self.elements, organ)
	
	local hell = {}
	hell.text = "Helloween"
	hell.x = 10
	hell.y = organ.y + organ.height + 10
	hell.width = 200
	hell.height = 20
	hell.on_click = function() 
		global_state = gameplay("songs/helloween.txt")
	end
	table.insert(self.elements, hell)
	
	local froz = {}
	froz.text = "Frozen Bits"
	froz.x = 10
	froz.y = hell.y + hell.height + 10
	froz.width = 200
	froz.height = 20
	froz.on_click = function() 
		global_state = gameplay("songs/frozenbits.txt")
	end
	table.insert(self.elements, froz)
	
	local id = {}
	id.text = "Configure audio delay"
	id.x = 10
	id.y = original_height - 40
	id.width = 140
	id.height = 20
	id.on_click = function()
		global_state = inputdelay()
	end
	table.insert(self.elements, id)
	
	local vo = {}
	vo.text = "Configure video offset"
	vo.x = 10
	vo.y = original_height - 70
	vo.width = 140
	vo.height = 20
	vo.on_click = function()
		global_state = videooffset()
	end
	table.insert(self.elements, vo)
	
	local about = {}
	about.text = "About"
	about.x = id.x + id.width + 20
	about.y = id.y
	about.height = id.height
	about.width = 60
	about.on_click = function()
		global_state = aboutpage()
	end
	table.insert(self.elements, about)
	
	local video = {}
	video.text = "Video"
	video.x = about.x + about.width + 20
	video.y = id.y
	video.height = id.height
	video.width = 60
	video.on_click = function()
		love.system.openURL("https://www.youtube.com/watch?v=qKqqRLnmXrg")
	end
	table.insert(self.elements, video)
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
	
	love.graphics.print(string.format("Average audio latency: %.2f seconds", global_audio_delay))
	love.graphics.print(string.format("Average video offset: %.2f", global_video_offset), 400)
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