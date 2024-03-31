local config = require("config")
local floors = config.floors
local currentFloor = config.startFloor
local channel = config.channel
local wmodem = peripheral.wrap(config.wmodem)

wmodem.transmit(channel,channel,floors[currentFloor].y)

for i,o in pairs(floors) do
  peripheral.wrap(o.insideMonitor).clear()
end

local function gotoFloor(floor)
  print(floor)
  if floors[floor] then
    local y = floors[floor].y
    currentFloor = floor
    wmodem.transmit(channel,channel,floors[floor].transmit)
  end
end

local function drawMonitors()
  -- monitors to call an elevator
  while true do
    for i,o in pairs(floors) do
      local mon = peripheral.wrap(o.insideMonitor)
      mon.setBackgroundColor(colors.white)
      mon.setTextColor(colors.black)
      mon.setTextScale(0.5)
      mon.clear()
      for i=config.startFloor,config.endFloor do
        local n = config.endFloor - i
        --print(i)
        mon.setCursorPos(1,n + 1)
        mon.write(i .. " - " .. floors[i].description)
      end
      -- monitors to select a floor
    end
  sleep(0.5)
  end
end


local function touchEvent()
  while true do
    local event, side, x, y = os.pullEvent("monitor_touch")
    for i,o in pairs(floors) do
      if o.insideMonitor == side then
        local chosenFloor = -y + config.endFloor + 1
        gotoFloor(chosenFloor)
      end
    end
  end
end


parallel.waitForAny(drawMonitors,touchEvent)