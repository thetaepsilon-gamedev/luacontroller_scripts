-- a DIGILINES music player that also REQUIRES digistuff.
-- it plays a sequence of notes on one or more digistuff noteblocks.

local song = {
	-- note one can use tables for each list item here,
	-- when one wishes to play multiple sounds at once.
	{"dsharp2", "f"},
	"",	-- rest one note
	"dsharp",
	"asharp",
	"",
	"gsharp",
	"",
	"",
	"dsharp",
	{"asharp", "dsharp"},
	-- anyone recognise the jingle? ;)
}
-- note delay, controls song speed
local delay = 0.2

-- loop at end of song?
local loop = false

-- noteblock channels here
local channel_map = {
	"noteblock1",
	"noteblock2",
}
-- channel to accept song restart requests on
local rchan = "music_controller"





-- how to send each note, send to default channel if string,
-- send to many channels if a table
local play_note = function(note)
	if type(note) == "string" then
		local default = channel_map[1]
		digiline_send(default, note)
	else
		for c, cnote in ipairs(note) do
			local channel = channel_map[c]
			digiline_send(channel, cnote)
		end
	end
end

local next = function()
	interrupt(delay)
end

local src = event.type
if src == "program" then
	mem.sequence = 1	-- start song at this position
	next()	-- then start loop
elseif src == "interrupt" then
	-- progress song on each interrupt
	local note = song[mem.sequence]
	mem.sequence = mem.sequence + 1
	-- don't go past end of song.
	if mem.sequence > #song then
		if loop then
			mem.sequence = 1
			next()
		end
	else
		next()
	end
elseif src == "digiline" and event.channel == rchan and event.msg == "reset" then
	mem.sequence = 1
	next()	
end

