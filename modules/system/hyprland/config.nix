# Hyprland configuration.
#
# configType = "lua": the whole config is written as raw Lua in `extraConfig`
# and rendered verbatim into $XDG_CONFIG_HOME/hypr/hyprland.lua by Home Manager.
# API reference shipped with hyprland: $HYPR/share/hypr/hyprland.lua (example)
# and $HYPR/share/hypr/stubs/hl.meta.lua (full type stubs).
#
# NOTE: a few dispatchers have `fun(...)` signatures with no documented arg
# shape; those are marked "best-guess" below and are the spots to check first
# if a keybind misbehaves after switching (fullscreen modes, exact resize,
# directional movewindow, silent workspace-move).
{ inputs, ... }:
{
  wayland.windowManager.hyprland.extraConfig = ''
    local mainMod = "SUPER"

    ------------------
    ---- AUTOSTART ----
    ------------------
    -- Runs once on compositor start. Each hl.exec_cmd spawns an independent
    -- process (no need for shell `&` backgrounding).
    hl.on("hyprland.start", function()
      hl.exec_cmd("systemctl --user import-environment")
      hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP")
      hl.exec_cmd("nm-applet")
      hl.exec_cmd("wl-clip-persist --clipboard regular")
      hl.exec_cmd("swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f)")
      hl.exec_cmd("fcitx5 -d --replace")
      hl.exec_cmd("poweralertd")
      hl.exec_cmd("waybar")
      hl.exec_cmd("swaync")
      hl.exec_cmd("wl-paste --watch cliphist store")
      hl.exec_cmd("hyprlock")
    end)

    ----------------------
    ---- CONFIG VALUES ---
    ----------------------
    hl.config({
      input = {
        kb_layout = "us,fr",
        kb_options = "grp:alt_caps_toggle",
        numlock_by_default = true,
        follow_mouse = 1,
        sensitivity = 0,
        touchpad = { natural_scroll = true },
      },
      general = {
        layout = "dwindle",
        gaps_in = 5,
        gaps_out = 10,
        border_size = 1,
      },
      misc = {
        disable_autoreload = true,
        disable_hyprland_logo = true,
        always_follow_on_dnd = true,
        layers_hog_keyboard_focus = true,
        animate_manual_resizes = false,
        enable_swallow = true,
        focus_on_activate = true,
      },
      dwindle = {
        force_split = 0,
        special_scale_factor = 1.0,
        split_width_multiplier = 1.0,
        use_active_for_splits = true,
        pseudotile = true,
        preserve_split = true,
      },
      master = {
        new_status = "master",
        special_scale_factor = 1,
      },
      decoration = {
        rounding = 10,
        active_opacity = 0.80,
        inactive_opacity = 0.80,
        blur = {
          enabled = true,
          size = 5,
          passes = 1,
          brightness = 1,
          contrast = 1.400,
          ignore_opacity = true,
          noise = 0,
          new_optimizations = true,
          xray = false,
        },
        shadow = {
          enabled = true,
          ignore_window = true,
          offset = "0 2",
          range = 20,
          render_power = 3,
        },
      },
      xwayland = { force_zero_scaling = true },
      animations = { enabled = true },
    })

    -----------------
    ---- CURVES ------
    -----------------
    hl.curve("fluent_decel",  { type = "bezier", points = { {0, 0.2},  {0.4, 1} } })
    hl.curve("easeOutCirc",   { type = "bezier", points = { {0, 0.55}, {0.45, 1} } })
    hl.curve("easeOutCubic",  { type = "bezier", points = { {0.33, 1}, {0.68, 1} } })
    hl.curve("easeinoutsine", { type = "bezier", points = { {0.37, 0}, {0.63, 1} } })

    ---------------------
    ---- ANIMATIONS -----
    ---------------------
    hl.animation({ leaf = "windowsIn",   enabled = true,  speed = 3,   bezier = "easeOutCubic",  style = "popin 30%" })
    hl.animation({ leaf = "windowsOut",  enabled = true,  speed = 3,   bezier = "fluent_decel",  style = "popin 70%" })
    hl.animation({ leaf = "windowsMove", enabled = true,  speed = 2,   bezier = "easeinoutsine", style = "slide" })
    hl.animation({ leaf = "fadeIn",      enabled = true,  speed = 3,   bezier = "easeOutCubic" })
    hl.animation({ leaf = "fadeOut",     enabled = true,  speed = 2,   bezier = "easeOutCubic" })
    hl.animation({ leaf = "fadeSwitch",  enabled = false, speed = 1,   bezier = "easeOutCirc" })
    hl.animation({ leaf = "fadeShadow",  enabled = true,  speed = 10,  bezier = "easeOutCirc" })
    hl.animation({ leaf = "fadeDim",     enabled = true,  speed = 4,   bezier = "fluent_decel" })
    hl.animation({ leaf = "border",      enabled = true,  speed = 2.7, bezier = "easeOutCirc" })
    hl.animation({ leaf = "borderangle", enabled = true,  speed = 30,  bezier = "fluent_decel",  style = "once" })
    hl.animation({ leaf = "workspaces",  enabled = true,  speed = 4,   bezier = "easeOutCubic",  style = "slide" })

    ---------------------
    ---- LAYER RULES ----
    ---------------------
    hl.layer_rule({ name = "waybar",              match = { namespace = "waybar" },                    ignore_alpha = 0.5, blur = true })
    hl.layer_rule({ name = "rofi",                match = { namespace = "rofi" },                      ignore_alpha = 0.5, blur = true })
    hl.layer_rule({ name = "swaync-control",      match = { namespace = "swaync-control-center" },     ignore_alpha = 0.5, blur = true })
    hl.layer_rule({ name = "swaync-notification", match = { namespace = "swaync-notification-window" },ignore_alpha = 0.5, blur = true })

    ----------------------
    ---- WINDOW RULES ----
    ----------------------
    hl.window_rule({ name = "imv-config",     match = { class = "^(imv)$" },   float = true, center = true, size = "1200 725" })
    hl.window_rule({ name = "mpv-config",     match = { class = "^(mpv)$" },   float = true, center = true, size = "1200 725", idle_inhibit = "focus" })
    hl.window_rule({ name = "tile-apps",      match = { class = "^(Aseprite|neovide)$" }, tile = true })
    hl.window_rule({ name = "udiskie-float",  match = { class = "^(udiskie)$" }, float = true })

    hl.window_rule({ name = "kitty-float-label",       match = { title = "^(float_label)$" },      float = true, center = true, size = "950 600" })
    hl.window_rule({ name = "transmission-float",      match = { title = "^(Transmission)$" },     float = true })
    hl.window_rule({ name = "volume-control",          match = { title = "^(Volume Control)$" },   float = true, center = true, size = "700 450", move = "40 55%" })
    hl.window_rule({ name = "firefox-sharing-indicator", match = { title = "^(Firefox — Sharing Indicator)$" }, float = true, move = "0 0" })

    hl.window_rule({ name = "audacious-config",   match = { class = "^(audacious)$" },   float = true, workspace = "8 silent" })
    hl.window_rule({ name = "pavucontrol-config", match = { class = "^(pavucontrol)$" }, float = true, center = true })
    hl.window_rule({ name = "pip-mode",           match = { title = "^(Picture-in-Picture)$" }, float = true, pin = true, opacity = "1.0 override" })
    hl.window_rule({ name = "firefox-inhibit",    match = { class = "^(firefox)$" },     idle_inhibit = "fullscreen" })
    hl.window_rule({ name = "zenity-config",      match = { class = "^(zenity)$" },      float = true, center = true, size = "850 500" })
    hl.window_rule({ name = "other-floats",       match = { class = "^(SoundWireServer|.sameboy-wrapped|confirm|dialog|download|notification|error|confirmreset)$" }, float = true })

    -- XWaylandVideoBridge fix
    hl.window_rule({
      name = "xwayland-bridge-fix",
      match = { class = "^(xwaylandvideobridge)$" },
      opacity = "0.0 override",
      no_anim = true,
      no_initial_focus = true,
      max_size = "1 1",
      no_blur = true,
    })

    ----------------------
    ---- KEYBINDINGS -----
    ----------------------
    hl.bind(mainMod .. " + F1",             hl.dsp.exec_cmd("show-keybinds"))
    hl.bind(mainMod .. " + DELETE",         hl.dsp.exit())
    hl.bind(mainMod .. " + RETURN",         hl.dsp.exec_cmd("kitty"))
    hl.bind("ALT + RETURN",                 hl.dsp.exec_cmd("kitty --title float_label"))
    hl.bind(mainMod .. " + SHIFT + RETURN", hl.dsp.exec_cmd("kitty --start-as=fullscreen -o 'font_size=16'"))
    hl.bind(mainMod .. " + B",              hl.dsp.exec_cmd("hyprctl dispatch exec '[workspace 1 silent] floorp'"))
    hl.bind(mainMod .. " + Q",              hl.dsp.window.close())
    hl.bind(mainMod .. " + F",              hl.dsp.window.fullscreen(0))             -- best-guess: mode arg
    hl.bind(mainMod .. " + SHIFT + F",      hl.dsp.window.fullscreen(1))             -- best-guess: mode arg
    -- SUPER+SPACE fires all three together: float-toggle + center + exact size
    hl.bind(mainMod .. " + SPACE",          hl.dsp.window.float({ action = "toggle" }))
    hl.bind(mainMod .. " + SPACE",          hl.dsp.window.center())
    hl.bind(mainMod .. " + SPACE",          hl.dsp.window.resize({ x = 1280, y = 720, relative = false })) -- best-guess: exact size
    hl.bind(mainMod .. " + A",              hl.dsp.exec_cmd("rofi -show drun || pkill rofi"))
    hl.bind(mainMod .. " + SHIFT + D",      hl.dsp.exec_cmd("hyprctl dispatch exec '[workspace 4 silent] discord --enable-features=UseOzonePlatform --ozone-platform=wayland'"))
    hl.bind(mainMod .. " + SHIFT + S",      hl.dsp.exec_cmd("hyprctl dispatch exec '[workspace 5 silent] SoundWireServer'"))
    hl.bind(mainMod .. " + ESCAPE",         hl.dsp.exec_cmd("hyprlock"))
    hl.bind(mainMod .. " + SHIFT + ESCAPE", hl.dsp.exec_cmd("shutdown-script"))
    hl.bind(mainMod .. " + P",              hl.dsp.window.pseudo())
    hl.bind(mainMod .. " + J",              hl.dsp.layout("togglesplit"))
    hl.bind(mainMod .. " + E",              hl.dsp.exec_cmd("thunar"))
    hl.bind(mainMod .. " + SHIFT + B",      hl.dsp.exec_cmd("pkill -SIGUSR1 .waybar-wrapped"))
    hl.bind(mainMod .. " + C",              hl.dsp.exec_cmd("hyprpicker -a"))
    hl.bind(mainMod .. " + SHIFT + W",      hl.dsp.exec_cmd("vm-start"))
    hl.bind(mainMod .. " + S",              hl.dsp.exec_cmd('grim -g "$(slurp)" - | swappy -f -'))

    -- move focus
    hl.bind(mainMod .. " + left",  hl.dsp.focus({ direction = "left" }))
    hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
    hl.bind(mainMod .. " + up",    hl.dsp.focus({ direction = "up" }))
    hl.bind(mainMod .. " + down",  hl.dsp.focus({ direction = "down" }))

    -- workspaces 1-10 (key 0 = workspace 10)
    for i = 1, 10 do
      local key = i % 10
      hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
      hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i })) -- best-guess: silent behavior may differ
    end
    hl.bind(mainMod .. " + CTRL + C", hl.dsp.window.move({ workspace = "empty" }))

    -- move window directionally (swap with neighbor) -- best-guess: move vs swap
    hl.bind(mainMod .. " + SHIFT + left",  hl.dsp.window.move({ direction = "left" }))
    hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
    hl.bind(mainMod .. " + SHIFT + up",    hl.dsp.window.move({ direction = "up" }))
    hl.bind(mainMod .. " + SHIFT + down",  hl.dsp.window.move({ direction = "down" }))

    -- resize (relative deltas)
    hl.bind(mainMod .. " + ALT + left",  hl.dsp.window.resize({ x = -80, y = 0,   relative = true }))
    hl.bind(mainMod .. " + ALT + right", hl.dsp.window.resize({ x = 80,  y = 0,   relative = true }))
    hl.bind(mainMod .. " + ALT + up",    hl.dsp.window.resize({ x = 0,   y = -80, relative = true }))
    hl.bind(mainMod .. " + ALT + down",  hl.dsp.window.resize({ x = 0,   y = 80,  relative = true }))

    -- prev / next workspace
    hl.bind(mainMod .. " + CTRL + right", hl.dsp.focus({ workspace = "r+1" }))
    hl.bind(mainMod .. " + CTRL + left",  hl.dsp.focus({ workspace = "r-1" }))

    -- media / brightness keys
    hl.bind("XF86AudioRaiseVolume",  hl.dsp.exec_cmd("pamixer -i 2"))
    hl.bind("XF86AudioLowerVolume",  hl.dsp.exec_cmd("pamixer -d 2"))
    hl.bind("XF86AudioMute",         hl.dsp.exec_cmd("pamixer -t"))
    hl.bind("XF86AudioPlay",         hl.dsp.exec_cmd("playerctl play-pause"))
    hl.bind("XF86AudioNext",         hl.dsp.exec_cmd("playerctl next"))
    hl.bind("XF86AudioPrev",         hl.dsp.exec_cmd("playerctl previous"))
    hl.bind("XF86AudioStop",         hl.dsp.exec_cmd("playerctl stop"))
    hl.bind("XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 5%+"))
    hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 5%-"))
    hl.bind(mainMod .. " + XF86MonBrightnessUp",   hl.dsp.exec_cmd("brightnessctl set 100%+"))
    hl.bind(mainMod .. " + XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl set 100%-"))
    hl.bind(mainMod .. " + V", hl.dsp.exec_cmd("cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"))

    -- mouse: move / resize with SUPER + drag
    hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
    hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
  '';
}
