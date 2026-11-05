local clipDb = (os.getenv("XDG_RUNTIME_DIR") or "/run/user/1000") .. "/cliphist.db"

hl.on("hyprland.start", function()
	hl.exec_cmd("systemctl --user start hyprpolkitagent.service")
	hl.exec_cmd("systemctl --user start hypridle.service")
	hl.exec_cmd("systemctl --user start waybar.service")
	hl.exec_cmd("systemctl --user start hyprpaper.service")
	hl.exec_cmd("systemctl --user start mako.service")
	hl.exec_cmd("uwsm app -- wl-paste --watch cliphist -db-path " .. clipDb .. " store")
end)
