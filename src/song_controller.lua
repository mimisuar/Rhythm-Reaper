song_controller = class("song_controller")

function song_controller:init()
	beat = {}
	ticks = 0
end

function song_controller:update(dt)
	ticks = ticks + 1
end