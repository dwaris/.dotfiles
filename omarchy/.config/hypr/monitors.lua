-- Multi-Monitor Setup: 4K 27" (DP-2) + 1440p 27" (DP-1)

local omarchy_gdk_scale = 1
local omarchy_monitor_scale = "auto"

hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

-- Laptop Internal Display (eDP-1): 1.0x scale
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })

-- 27" 4K Monitor (DP-2): Dynamic scaling bound to omarchy_monitor_scale
hl.monitor({ output = "DP-2", mode = "3840x2160@60", position = "auto-left", scale = 1.6 })

-- 27" 1440p 165Hz Monitor (DP-1): 1.0x native scale
hl.monitor({ output = "DP-1", mode = "2560x1440@144", position = "0x0", scale = omarchy_monitor_scale })

-- Fallback for unmapped monitors
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = omarchy_monitor_scale })


