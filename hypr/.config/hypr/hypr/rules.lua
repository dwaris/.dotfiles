local colors = require("colors.mocha")

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

-- See https://wiki.hypr.land/Configuring/Basics/Window-Rules/
-- and https://wiki.hypr.land/Configuring/Basics/Workspace-Rules/

hl.window_rule({
    -- Ignore maximize requests from all apps
    name           = "suppress-maximize-events",
    match          = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    -- Fix dragging issues with XWayland
    name     = "fix-xwayland-drags",
    match    = {
        class      = "^$",
        title      = "^$",
        xwayland   = true,
        float      = true,
        fullscreen = false,
        pin        = false,
    },
    no_focus = true,
})

hl.window_rule({
    name         = "border-color-fullscreen",
    match        = { fullscreen = true },
    border_color = colors.lavender
})

-- Floating windows (tag matching)
hl.window_rule({
    name  = "float-floating-window",
    match = { tag = "floating-window" },
    float = true
})
hl.window_rule({
    name   = "center-floating-window",
    match  = { tag = "floating-window" },
    center = true
})

-- Bitwarden extension & popup
hl.window_rule({
    name            = "bitwarden-popup",
    match           = { class = ".*nngceckbapebfimnlniiiahkandclblb.*" },
    float           = true,
    center          = true,
    size            = { 400, 600 },
    no_screen_share = true,
})

-- Layer rules
hl.layer_rule({
    name    = "no-anim-menu",
    match   = { namespace = "^rofi$" },
    no_anim = true
})
