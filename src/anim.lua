local anim = class("anim")

function anim:init(img, frame_width, frame_height, timer, looping)
	local width = img:getWidth()
	local height = img:getHeight()
	
	self.frames = {}
	self.frame = 0
	
	for x=0, width - frame_width, frame_width do
		for y=0, height - frame_height, frame_height do
			table.insert(self.frames, love.graphics.newQuad(x, y, frame_width, frame_height, width, height))
		end
	end
	
	self.frame = 1
	self.timer = timer or -1
	self.et = 0
	
	self.looping = looping
	self.finished = false
end

function anim:update(dt)
	if self.timer > 0 then
		self.et = self.et + dt
		if self.et > self.timer then
			self.et = self.et - self.timer
			self:next_frame()
		end
	end
end

function anim:next_frame()
	self.frame = self.frame + 1
	if self.frame > #self.frames then
		if self.looping then
			self.frame = 1
		else
			self.finished = true
			self.frame = self.frame - 1
		end
	end	
end

function anim:set_frame(frame)
	self.frame = frame
	self.finished = false
end

function anim:set_timer(timer)
	self.timer = timer
	self.et = 0
end

function anim:is_finished()
	return not self.looping and self.finished
end

function anim:get_frame(frame)
	frame = frame or self.frame
	return self.frames[frame]
end

return anim