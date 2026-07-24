local colors = require("colors.mocha")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in          = 4,
        gaps_out         = 8,
        border_size      = 2,

        col              = {
            active_border   = colors.mauve,
            inactive_border = colors.surface1,
        },

        resize_on_border = false,
        allow_tearing    = false,
        layout           = "dwindle",
    },

    decoration = {
        rounding       = 8,
        rounding_power = 2,

        shadow         = {
            enabled = false,
        },

        glow           = {
            enabled = false,
        },

        blur           = {
            enabled = false,
        },
    },

    animations = {
        enabled = true,
    },
})

hl.curve("easeOutQuint", { type = "bezier", points = { { 0.23, 1 }, { 0.32, 1 } } })
hl.curve("easeInOutCubic", { type = "bezier", points = { { 0.65, 0.05 }, { 0.36, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1.0 } } })
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })

hl.animation({ leaf = "global", enabled = true, speed = 9, bezier = "default" })
hl.animation({ leaf = "border", enabled = true, speed = 4.39, bezier = "easeOutQuint" })
hl.animation({ leaf = "windows", enabled = true, speed = 2.79, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.1, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 0.49, bezier = "linear", style = "popin 87%" })
hl.animation({ leaf = "fadeIn", enabled = true, speed = 0.73, bezier = "almostLinear" })
hl.animation({ leaf = "fadeOut", enabled = true, speed = 0.46, bezier = "almostLinear" })
hl.animation({ leaf = "fade", enabled = true, speed = 2.03, bezier = "quick" })
hl.animation({ leaf = "fadeSwitch", enabled = false })
hl.animation({ leaf = "layers", enabled = true, speed = 2.81, bezier = "easeOutQuint" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3, bezier = "easeOutQuint", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 0.5, bezier = "linear", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 0.79, bezier = "almostLinear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 0.39, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = false })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 2, bezier = "easeOutQuint", style = "slidevert" })

hl.config({
    dwindle = {
        force_split = 1,
        preserve_split = true,
    },
})

hl.config({
    master = {
        new_status = "master",
    },
})

hl.config({
    scrolling = {
        fullscreen_on_one_column = true,
    },
})


----------------
----  MISC  ----
----------------

hl.config({
    misc = {
        force_default_wallpaper   = 0,    -- Set to 0 or 1 to disable the anime mascot wallpapers
        disable_hyprland_logo     = true, -- If true disables the random hyprland logo / anime girl background. :(
        mouse_move_enables_dpms   = true,
        key_press_enables_dpms    = true,
        focus_on_activate         = false,
        on_focus_under_fullscreen = 1,
    },
    xwayland = {
        force_zero_scaling = true,
    },
    ecosystem = {
        no_update_news = true,
    },
})
