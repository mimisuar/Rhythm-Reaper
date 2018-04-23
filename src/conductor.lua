conductor = class("conductor")

function conductor:init(song_file)
	self.bpm = 120
	self.song_file = song_file
	self.playing = false
end

function conductor:load()
	self.song = love.audio.newSource(self.song_file, "stream")
	self.position = 0
	self.paused = false
	self.quarter = 60 / self.bpm
	self.beats_per_measure = 4
	self.counted_beat = 1
	self.beat = 1
	self.bar = 1
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
	
	if self.position > self.quarter * self.counted_beat then
		self.counted_beat = self.counted_beat + 1
		self.beat = self.beat + 1
		if self.beat > self.beats_per_measure then
			self.beat = 1
			self.bar = self.bar + 1
		end
	end
end