local conductor = class("conductor")

function conductor:init(song_file)
	self.song_file = song_file
	self.playing = false
end

function conductor:load()
	local line_count = 1
	for line in love.filesystem.lines(self.song_file) do
		if line_count == 1 then
			self.song_title = line
		elseif line_count == 2 then
			self.bpm = tonumber(line) or 120
		elseif line_count == 3 then
			self.offset = tonumber(line) or 0
		else
			local err
			self.data, err = loadstring("return" .. line), err
			if self.data then
				self.data = self.data()
			else
				error(err)
			end
			
		end
		
		line_count = line_count + 1
	end
	
	self.song = love.audio.newSource(self.song_title, "stream")
	self.position = self.offset
	self.paused = false
	self.quarter = 60 / self.bpm
	self.eighth = self.quarter / 2
	self.beats_per_measure = 4
	self.counted_beat = 1
	self.beat = 1
	self.bar = 1
	self.fading_out = false
	
	self.speed = self.bpm * self.beats_per_measure
	
	self.song:seek(self.offset)
end

function conductor:toggle_play()
	if self.playing then
		self.song:pause()
		self.playing = false
	else
		self.song:play()
		self.playing = true
	end
end

function conductor:update()
	self.position = self.song:tell()
	
	if self.position > self.eighth * self.counted_beat then
		self.counted_beat = self.counted_beat + 1
		self.beat = self.beat + 1
		if self.beat > self.beats_per_measure * 2 then
			self.beat = 1
			self.bar = self.bar + 1
		end
	end
end

function conductor:set_pos_to_beat(db)
	self.counted_beat = self.counted_beat + db
	
	if self.counted_beat < 1 then self.counted_beat = 1 end
	
	self.position = (self.counted_beat - 1) * self.eighth
	self.song:seek(self.position)
	
	self.beat = 0
	self.bar = 1
	
	for i=1, self.counted_beat do
		self.beat = self.beat + 1
		if self.beat > self.beats_per_measure * 2 then
			self.beat = 1
			self.bar = self.bar + 1
		end
	end
end

function conductor:fade_out(dt)
	local v = self.song:getVolume()
	v = v - (0.5 * dt)
	if v < 0 then v = 0 end
	self.song:setVolume(v)
end

return conductor