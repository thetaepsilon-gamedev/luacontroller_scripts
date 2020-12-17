--## config block ##--

-- channel name to recieve digits on.
local channel_in = ""

-- channel prefix for each lamp's luaC
local channel_out_pre = ""

-- function taking a true-false value and mapping it to what the recievers expect.
-- (e.g. some luaC displays were setup to recieve on or off for instance),
-- in which case the expression would be return bit and "on" or "off".
local map_bit = function(bit)
	return bit
end

--## end config block ##--




-- digits as follows:
-- indexes _0_ to 9, "blank", and "overflow".
-- the latter indicates a recieved value greater than 9.
local T = true
local o = false
local digits = {
	[0] = {
		T, T, T,
		T, o, T,
		T, o, T,
		T, o, T,
		T, T, T,
	},
	{
		o, T, o,
		T, T, o,
		o, T, o,
		o, T, o,
		T, T, T,
	},
	{
		T, T, o,
		o, o, T,
		o, T, o,
		T, o, o,
		T, T, T,
	},
	{
		T, T, o,
		o, o, T,
		T, T, o,
		o, o, T,
		T, T, o,
	},
	{
		T, o, T,
		T, o, T,
		T, T, T,
		o, o, T,
		o, o, T,
	},
	{
		T, T, T,
		T, o, o,
		T, T, o,
		o, o, T,
		T, T, o,
	},
	{
		o, T, T,
		T, o, o,
		T, T, o,
		T, o, T,
		o, T, o,
	},
	{
		T, T, T,
		o, o, T,
		o, o, T,
		o, T, o,
		o, T, o,
	},
	{
		o, T, o,
		T, o, T,
		o, T, o,
		T, o, T,
		o, T, o,
	},
	{
		o, T, o,
		T, o, T,
		o, T, T,
		o, o, T,
		T, T, o,
	},
	blank = {
		o, o, o,
		o, o, o,
		o, o, o,
		o, o, o,
		o, o, o,
	},
	overflow = {
		o, T, o,
		o, T, o,
		o, T, o,
		o, o, o,
		o, T, o,
	},
}




if event.type == "digiline" and event.channel == channel_in then
	local k = "blank"
	local v = event.msg
	if type(v) == "number" and v >= 0 then
		if v >= 10 then
			k = "overflow"
		else
			k = math.floor(v)
		end
	end

	local data = digits[k]
	for i = 1, 15, 1 do
		local tx = channel_out_pre .. i
		local msg = map_bit(data[i])
		digiline_send(tx, msg)
	end
end















