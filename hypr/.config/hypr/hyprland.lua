require("binds")

------------------ Monitors ------------------

hl.monitor({
    output   = "DP-1",
    mode     = "2560x1440@180",
    position = "1080x1440",
    scale    = 1,
    vrr      = 1,
    bitdepth = 10,
    cm       = "dp3",
})
hl.monitor({ output = "DP-2",     mode = "1920x1080@75", position = "3640x1440", scale = 1,   transform = 3 })
hl.monitor({ output = "DP-3",     mode = "3840x2160@60", position = "1080x0",    scale = 1.5 })
hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@75", position = "0x1440",    scale = 1,   transform = 1 })

hl.config({
    render = {
        cm_auto_hdr = 1,
    },
    general = {
        allow_tearing = true,
    },
})

------------------ Environment ------------------

hl.env("XCURSOR_THEME", "ProjectSekai2x")
hl.env("XCURSOR_SIZE", "24")
hl.env("HYPRCURSOR_THEME", "ProjectSekai2x")
hl.env("HYPRCURSOR_SIZE", "24")

------------------ Autostart ------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("~/.config/hypr/brightness.sh init")
    hl.exec_cmd("~/.config/hypr/reload-waybar-swaybg.sh")
    hl.exec_cmd("~/.config/hypr/idle.sh")
    hl.exec_cmd("mako")
    hl.exec_cmd("blueman-applet")
    hl.exec_cmd("xfce-polkit")
    hl.exec_cmd("signal-desktop")
    hl.exec_cmd("sleep 3; spotify")
end)

------------------ Window rules ------------------

hl.window_rule({ match = { class = "^foot" },           no_auto_hdr = true })
hl.window_rule({ match = { class = "^foot_floating$" }, float = true, size = { 1100, 680 } })
hl.window_rule({ match = { class = "^[Ss]ignal$" },     workspace = "6 silent" })
hl.window_rule({ match = { class = "^[Ss]potify$" },    workspace = "6 silent" })

------------------ Workspaces ------------------

hl.workspace_rule({ workspace = "1", monitor = "DP-1", default = true, persistent = true })
hl.workspace_rule({ workspace = "2", monitor = "DP-1" })
hl.workspace_rule({ workspace = "3", monitor = "DP-1" })
hl.workspace_rule({ workspace = "4", monitor = "DP-1" })
hl.workspace_rule({ workspace = "5", monitor = "DP-1" })
hl.workspace_rule({ workspace = "6", monitor = "DP-2",     default = true })
hl.workspace_rule({ workspace = "7", monitor = "DP-3",     default = true })
hl.workspace_rule({ workspace = "8", monitor = "HDMI-A-1", default = true })

------------------ Input ------------------

hl.config({
    input = {
        kb_layout     = "de",
        accel_profile = "flat",
        sensitivity   = -0.4,
    },
    binds = {
        window_direction_monitor_fallback = true,
    },
    dwindle = {
        smart_split        = true,
        preserve_split     = true,
        precise_mouse_move = true,
    },
})

------------------ Appearance ------------------

hl.config({
    general = {
        gaps_in     = 4,
        gaps_out    = 8,
        border_size = 3,
        layout      = "dwindle",
        col = {
            active_border   = "rgba(d4be98ff)",
            inactive_border = "rgba(3c3836ff)",
        },
    },
    decoration = {
        rounding = 6,
        blur     = { enabled = false },
        shadow   = { enabled = false },
    },
    misc = {
        disable_hyprland_logo = true,
        background_color      = "rgb(282828)",
        enable_swallow        = true,
        swallow_regex         = "^foot$",
    },
})

------------------ Animations ------------------

hl.curve("mangoOpen", { type = "bezier", points = { {0.15, 0.9}, {0.1, 1.05}  } })
hl.curve("mangoMove", { type = "bezier", points = { {0.05, 0.9}, {0.1, 1.05}  } })
hl.curve("mangoSoft", { type = "bezier", points = { {0.46, 1.0}, {0.29, 0.99} } })

hl.config({ animations = { enabled = true } })

hl.animation({ leaf = "windowsIn",   enabled = true, speed = 2,   bezier = "mangoOpen", style = "popin 40%" })
hl.animation({ leaf = "windowsOut",  enabled = true, speed = 2.5, bezier = "mangoSoft", style = "popin 40%" })
hl.animation({ leaf = "windowsMove", enabled = true, speed = 2,   bezier = "mangoMove" })
hl.animation({ leaf = "fadeIn",      enabled = true, speed = 2,   bezier = "mangoOpen" })
hl.animation({ leaf = "fadeOut",     enabled = true, speed = 2.5, bezier = "mangoSoft" })
hl.animation({ leaf = "workspaces",  enabled = true, speed = 3.5, bezier = "mangoSoft", style = "slide" })
hl.animation({ leaf = "layers",      enabled = true, speed = 2,   bezier = "mangoOpen" })
