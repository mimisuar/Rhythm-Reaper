local ft = class("floating_text")

function ft:init(x, y)
	self.origin_x = x
	self.origin_y = y
	self.texts = {}
	
	self.text_speed = 1 * 60
	self.alpha_speed = (5 / 255) * 60
end

function ft:print(text, color)
	color = color or {1, 1, 1}
	
	local t = {}
	t.text = text
	t.color = color
	t.color[4] = 1
	t.y_offset = 0
	
	table.insert(self.texts, t)
end

function ft:update(dt)
	for i=#self.texts, 1, -1 do
		local t = self.texts[i]
		
		t.y_offset = t.y_offset - self.text_speed * dt
		t.color[4] = t.color[4] - self.alpha_speed * dt
		
		if t.color[4] <= 0 then
			table.remove(self.texts, i)
		end
	end
end

function ft:draw()
	for i, t in ipairs(self.texts) do
		
		love.graphics.setColor(t.color)
		love.graphics.print(t.text, self.origin_x, self.origin_y + t.y_offset)
		love.graphics.setColor(1, 1, 1, 1)
	end
end

return ft