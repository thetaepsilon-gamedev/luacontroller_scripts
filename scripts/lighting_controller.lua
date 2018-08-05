--[[
A DIGILINES lighting (or other mesecon device) controller script.
Essentially it's just a digiline to mesecons bridge,
that responds to on/off/toggle commands by setting a chosen port output.
]]

-- the channels that should be responded to, individually or groups.
-- the channels used by other digilines devices should prefix this with:
local prefix = "facility_lighting_"
-- you could change this to operate other device types if desired.

-- a tip, don't think in terms of "all lights",
-- think in terms of "all lights in my base" - there is always scope around it.
-- it will make maintaining the groups easier later on.
local groups = {
    "testgroup",
}
-- add the prefix and convert to a true/false map.
local ingroups

-- populate map on first programming only
if event.type == "program" then
    ingroups = {}
    for i, k in ipairs(groups) do
        local tk = prefix..k
        ingroups[tk] = true
    end
    mem.ingroups = ingroups
else
    -- load from memory
    ingroups = mem.ingroups
end

-- which port to control
local outport = "a"



-- message constants - you are advised to leave this alone.
local on = "on"
local off = "off"
local toggle = "toggle"

-- handle the message
local act = function(msg)
    local result
    if msg == on then
        result = true
    elseif msg == off then
        result = false
    elseif msg == toggle then
        -- this will be nil if first run, will end up true.
        result = not mem.previous
    else
        -- wrong message? short-circuit return
        return
    end

    -- save the written output to memory,
    -- in case the next message requests a toggle.
    mem.previous = result
    -- then set the port.
    port[outport] = result
end



if event.type == "digiline" then
    -- check the channel, ensure it's one we should be listening on
    local chan = event.channel
    if not ingroups[chan] then return end

    act(event.msg)  
end

