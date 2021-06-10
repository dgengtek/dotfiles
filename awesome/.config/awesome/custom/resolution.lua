#!/bin/env lua
resolution = {}
-- switch window size modes for better quality 
function resolution.switchHZ(spawn)
  function run()
    spawn("xrandr --output DVI-0 --mode 1280x1024 --rate 75 --left-of DVI-1 --primary")
    spawn("xrandr --output DVI-1 --mode 1152x864 --rate 75 --pos 1280x0")
  end
  return run
end
function resolution.switchHD(spawn)
  function run()
    spawn("xrandr --output DVI-0 --mode 1920x1080 --rate 60 --left-of DVI-1 --primary")
    spawn("xrandr --output DVI-1 --mode 1920x1080 --rate 60 --pos 1920x0")
  end
  return run
end

return resolution
