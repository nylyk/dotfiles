------------------ Session / system ------------------

hl.bind("SUPER + SHIFT + CTRL + R", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind("SUPER + CTRL + R",         hl.dsp.exec_cmd("~/.config/hypr/reload-waybar-swaybg.sh"))

------------------ Launchers ------------------

hl.bind("SUPER + Q", hl.dsp.exec_cmd("foot"))
hl.bind("SUPER + R", hl.dsp.exec_cmd("foot --app-id foot_floating"))
hl.bind("SUPER + D", hl.dsp.exec_cmd("fuzzel"))

------------------ Media keys ------------------

hl.bind("code:122", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 2%-"))
hl.bind("code:123", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_SINK@ 2%+"))
hl.bind("code:121", hl.dsp.exec_cmd("playerctl --player=spotify play-pause"))
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl --player=spotify play-pause"))
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl --player=spotify next"))
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl --player=spotify previous"))

hl.bind("SUPER + CTRL + T", hl.dsp.exec_cmd([[playerctl -p spotify metadata --format '{{artist}} - {{title}}' | tr -d '\n' | wl-copy]]))
hl.bind("SUPER + CTRL + A", hl.dsp.exec_cmd([[playerctl -p spotify metadata --format '{{xesam:album}}' | tr -d '\n' | wl-copy]]))

------------------ Screenshots ------------------

hl.bind("Print",         hl.dsp.exec_cmd([[g=$(slurp -d) && [ -n "$g" ] && grim -g "$g" - | tee /storage/tmp/latest_screenshot.png | wl-copy --type image/png]]))
hl.bind("SUPER + Print", hl.dsp.exec_cmd([[g=$(slurp -o) && [ -n "$g" ] && grim -g "$g" - | tee /storage/tmp/latest_screenshot.png | wl-copy --type image/png]]))

------------------ Window state ------------------

hl.bind("SUPER + C", hl.dsp.window.close())
hl.bind("SUPER + F", hl.dsp.window.fullscreen({ mode = "fullscreen", action = "toggle" }))
hl.bind("SUPER + V", hl.dsp.window.float({ action = "toggle" }))

------------------ Focus a window (SUPER) ------------------

hl.bind("SUPER + left",  hl.dsp.focus({ direction = "left" }))
hl.bind("SUPER + right", hl.dsp.focus({ direction = "right" }))
hl.bind("SUPER + up",    hl.dsp.focus({ direction = "up" }))
hl.bind("SUPER + down",  hl.dsp.focus({ direction = "down" }))

------------------ Move a window in-layout (SUPER+SHIFT) ------------------

hl.bind("SUPER + SHIFT + left",  hl.dsp.window.swap({ direction = "left" }))
hl.bind("SUPER + SHIFT + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind("SUPER + SHIFT + up",    hl.dsp.window.swap({ direction = "up" }))
hl.bind("SUPER + SHIFT + down",  hl.dsp.window.swap({ direction = "down" }))

------------------ Resize a window (SUPER+ALT) ------------------

hl.bind("SUPER + ALT + left",  hl.dsp.window.resize({ x = -50, y = 0,   relative = true }))
hl.bind("SUPER + ALT + right", hl.dsp.window.resize({ x = 50,  y = 0,   relative = true }))
hl.bind("SUPER + ALT + up",    hl.dsp.window.resize({ x = 0,   y = -50, relative = true }))
hl.bind("SUPER + ALT + down",  hl.dsp.window.resize({ x = 0,   y = 50,  relative = true }))

------------------ Monitors ------------------

hl.bind("SUPER + CTRL + left",  hl.dsp.focus({ monitor = "l" }))
hl.bind("SUPER + CTRL + right", hl.dsp.focus({ monitor = "r" }))
hl.bind("SUPER + CTRL + up",    hl.dsp.focus({ monitor = "u" }))
hl.bind("SUPER + CTRL + down",  hl.dsp.focus({ monitor = "d" }))

hl.bind("SUPER + CTRL + SHIFT + left",  hl.dsp.window.move({ monitor = "l" }))
hl.bind("SUPER + CTRL + SHIFT + right", hl.dsp.window.move({ monitor = "r" }))
hl.bind("SUPER + CTRL + SHIFT + up",    hl.dsp.window.move({ monitor = "u" }))
hl.bind("SUPER + CTRL + SHIFT + down",  hl.dsp.window.move({ monitor = "d" }))

------------------ Workspaces: view (SUPER) / send window (SUPER+SHIFT) ------------------

for i = 1, 8 do
    hl.bind("SUPER + " .. i,           hl.dsp.focus({ workspace = i }))
    hl.bind("SUPER + SHIFT + " .. i,   hl.dsp.window.move({ workspace = i }))
end

------------------ Mouse ------------------

hl.bind("SUPER + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind("SUPER + mouse:273", hl.dsp.window.resize(), { mouse = true })
