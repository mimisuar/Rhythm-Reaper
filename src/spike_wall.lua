local spike_wall = class("spike_wall")

function spike_wall.load_assets()
	spike_wall.static.sprite = love.graphics.newImage("jump-ob.png")
end

function spike_wall:init(position)
	self.position = position
	self.y = (original_height - 80)
	self.x = (self.position - position) * gameplay.get("conductor").speed
end

function spike_wall:update(dt, position)
	self.x = (self.position - position) * gameplay.get("conductor").speed + gameplay.get("target_x")
end

function spike_wall:draw()
	love.graphics.draw(spike_wall.static.sprite, self.x + 10, self.y)
	--love.graphics.circle("line", self.x, love.graphics.getHeight() - 120, 8)
end

return spike_wall