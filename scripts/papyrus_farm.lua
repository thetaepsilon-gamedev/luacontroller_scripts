-- change these to match your pinout.
local function plant_port(v)
  port.a = v
end

local function bonemeal_port(v)
  port.b = v
end

local function dig_port(v)
  port.c = v
end

-- common settings:
-- wait time between steps
local step = 1.0
-- pulse time for mesecons ports
local hold_time = 0.5



-- invoked three times from separate interrupts, hence common function
local function meal_n()
  bonemeal_port(true)
  interrupt(hold_time, "meal_off")
end

local actions = {
  plant = function()
    plant_port(true)
    interrupt(hold_time, "plant_off")
  end,
  plant_off = function() plant_port(false) end,
  meal1 = meal_n,
  meal2 = meal_n,
  meal3 = meal_n,
  meal_off = function() bonemeal_port(false) end,
  dig = function()
    dig_port(true)
    interrupt(hold_time, "dig_off")
  end,
  dig_off = function() dig_port(false) end,
}

if event.type == "on" then
  interrupt(0, "plant")
  interrupt(step, "meal1")
  interrupt(step*2, "meal2")
  interrupt(step*3, "meal3")
  interrupt(step*4, "dig")
elseif event.type == "interrupt" then
  actions[event.iid]()
end

