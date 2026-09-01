-- jedha
hl.monitor({
    output   = "desc:LG Electronics LG ULTRAGEAR 311MATWGVY21",
    mode     = "2560x1440@144",
    position = "0x0",
    scale    = 1,
})
hl.monitor({
    output   = "desc:LG Electronics LG HDR 4K 0x00002991",
    mode     = "3840x2160@60.00",
    position = "auto-left",
    scale    = 1.5,
})

-- aldhani
hl.monitor({
    output   = "desc:Lenovo Group Limited 0x40A9",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = 1.0,
})

-- fallback
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})
