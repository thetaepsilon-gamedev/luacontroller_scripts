-- probably most useful with the digit_3x5 script.
-- keeps track of a simple score on two mesecons pins,
-- and accepts game reset and enable via a third.

--## config section ##--

-- pin names to use for "L" and "R" team inputs.
local left_pin = "D"
local right_pin = "B"

-- pin name to use for enable / reset.
local enable_pin = "C"

-- channel names for left and right team display encoders.
local left_chan = "digit_l"
local right_chan = "digit_r"

--## end config ##--






assert(left_pin ~= right_pin)
assert(left_pin ~= enable_pin)
assert(right_pin ~= enable_pin)

local function update()
	digiline_send(left_chan, mem.left)
	digiline_send(right_chan, mem.right)
end

local function reset()
	mem.left = 0
	mem.right = 0
	mem.enable = false
	update()
end



local ev = event.type
local p = event.pin
if ev == "program" then
	reset()
elseif p and p.name == enable_pin then
	-- allow either on or off pulse on reset to trigger a reset for more robustness.
	reset()
	mem.enable = (ev == "on")
elseif ev == "on" and mem.enable then
	local n = p.name
	if n == left_pin then
		mem.left = mem.left + 1
		update()
	elseif n == right_pin then
		mem.right = mem.right + 1
		update()
	end
end
