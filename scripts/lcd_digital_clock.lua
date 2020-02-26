-- a DIGILINES clock device using an lcd and an rtc.
-- displays time of day in a 24-hour like format.

-- channels to use
local rtc = "rtc"
local lcd = "lcd"



local t = event.type
local floor = math.floor
local mod = math.mod

local num = function(n)
	return string.format("%02d", n)
end

if t == "interrupt" then
	digiline_send(rtc, "GET")
elseif t == "digiline" and event.channel == rtc then
	local v = event.msg * 24
	local hours, rem = math.modf(v)
	local mins = floor(rem * 60)
	local str = num(hours) .. ":" .. num(mins)
	digiline_send(lcd, str)
	interrupt(0.5)
elseif t == "program" then
	interrupt(0.5)
end

