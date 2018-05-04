local spike_wall = class("spike_wall")

function spike_wall.load_assets()
	spike_wall.static.sprite = love.graphics.newImage("jump-ob.png")
end

function spike_wall:init(position)
	self.position = position
	self.y = (love.graphics.getHeight() - 80)
	self.x = (self.position - position) * conductor.speed
end

function spike_wall:update(dt, position)
	self.x = (self.position - position) * conductor.speed + target_x
end

function spike_wall:draw()
	love.graphics.draw(spike_wall.static.sprite, self.x, self.y)
end

return spike_wall