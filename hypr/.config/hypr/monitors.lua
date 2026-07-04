-- jedha
hl.monitor({
    output   = "desc:LG Electronics LG ULTRAGEAR 311MATWGVY21",
    mode     = "2560x1440@144",
    position = "0x0",
    scale    = 1,
    bitdepth = 10,
    icc      = "/home/dwaris/Nextcloud/Backup/Monitors/LG 27GP850B/rtings-LG 27GP850B.icm"
})
hl.monitor({
    output   = "desc:LG Electronics LG HDR 4K 0x00002991",
    mode     = "3840x2160@60.00",
    position = "auto-left",
    scale    = 1.5,
    bitdepth = 10,
    icc      = "/home/dwaris/Nextcloud/Backup/Monitors/LG-27UN83A/LG HDR 4K.icm",
})

-- aldhani
hl.monitor({
    output   = "desc:Lenovo Group Limited 0x40A9",
    mode     = "1920x1080@60",
    position = "0x0",
    scale    = "1",
    icc      = "/home/dwaris/Nextcloud/Backup/Monitors/T14G2a/R140NWF5_RA.icm"
})

-- fallback
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

hl.workspace_rule({ workspace = "1", monitor = "desc:LG Electronics LG ULTRAGEAR 311MATWGVY21", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "desc:LG Electronics LG HDR 4K 0x00002991", default = true, persistent = true })
hl.workspace_rule({ workspace = "3", monitor = "desc:LG Electronics LG ULTRAGEAR 311MATWGVY21" })
hl.workspace_rule({ workspace = "4", monitor = "desc:LG Electronics LG HDR 4K 0x00002991" })
hl.workspace_rule({ workspace = "5", monitor = "desc:LG Electronics LG ULTRAGEAR 311MATWGVY21" })
