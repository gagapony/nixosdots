{ inputs, ... }:
{
  wayland.windowManager.hyprland = {
    settings = {

      # 环境变量与自动启动
      exec-once = [
        "systemctl --user import-environment &"
        "hash dbus-update-activation-environment 2>/dev/null &"
        "dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &"
        "nm-applet &"
        "wl-clip-persist --clipboard regular"
        # "swaybg -m fill -i ${inputs.nixy-wallpapers + "/wallpapers/cat-leaves.png"} &"
        "swaybg -m fill -i $(find ~/Pictures/wallpapers/ -maxdepth 1 -type f) &"
        "fcitx5 -d --replace &"
        "poweralertd &"
        "waybar &"
        "swaync &"
        "wl-paste --watch cliphist store &"
        "hyprlock"
      ];

      input = {
        kb_layout = "us,fr";
        kb_options = "grp:alt_caps_toggle";
        numlock_by_default = true;
        follow_mouse = 1;
        sensitivity = 0;
        touchpad = {
          natural_scroll = true;
        };
      };

      general = {
        "$mainMod" = "SUPER";
        layout = "dwindle";
        gaps_in = 5;
        gaps_out = 10;
        border_size = 1;
        # "col.active_border"="#b4befe";
        # "col.inactive_border"="#45475a";
        # 注意：此处已删除 border_part_of_window 和 no_border_on_floating
      };

      misc = {
        disable_autoreload = true;
        disable_hyprland_logo = true;
        always_follow_on_dnd = true;
        layers_hog_keyboard_focus = true;
        animate_manual_resizes = false;
        enable_swallow = true;
        focus_on_activate = true;
      };

      dwindle = {
        force_split = 0;
        special_scale_factor = 1.0;
        split_width_multiplier = 1.0;
        use_active_for_splits = true;
        pseudotile = "yes";
        preserve_split = "yes";
      };

      master = {
        new_status = "master";
        special_scale_factor = 1;
      };

      decoration = {
        rounding = 10;
        active_opacity = 0.80;
        inactive_opacity = 0.80;

        blur = {
          enabled = true;
          size = 5;
          passes = 1;
          brightness = 1;
          contrast = 1.400;
          ignore_opacity = true;
          noise = 0;
          new_optimizations = true;
          xray = false;
        };

        shadow = {
          enabled = true;
          ignore_window = true;
          offset = "0 2";
          range = 20;
          render_power = 3;
        };
      };

      layerrule = [
        {
          name = "waybar";
          "match:namespace" = "waybar";
          ignore_alpha=0.5;
          blur = true;
        }
        {
          name = "rofi";
          "match:namespace" = "rofi";
          ignore_alpha=0.5;
          blur = true;
        }
        {
          name = "swaync-control";
          "match:namespace" = "swaync-control-center";
          ignore_alpha=0.5;
          blur = true;
        }
        {
          name = "swaync-notification";
          "match:namespace" = "swaync-notification-window";
          ignore_alpha=0.5;
          blur = true;
        }
      ];

      animations = {
        enabled = true;
        bezier = [
          "fluent_decel, 0, 0.2, 0.4, 1"
          "easeOutCirc, 0, 0.55, 0.45, 1"
          "easeOutCubic, 0.33, 1, 0.68, 1"
          "easeinoutsine, 0.37, 0, 0.63, 1"
        ];
        animation = [
          "windowsIn, 1, 3, easeOutCubic, popin 30%"
          "windowsOut, 1, 3, fluent_decel, popin 70%"
          "windowsMove, 1, 2, easeinoutsine, slide"
          "fadeIn, 1, 3, easeOutCubic"
          "fadeOut, 1, 2, easeOutCubic"
          "fadeSwitch, 0, 1, easeOutCirc"
          "fadeShadow, 1, 10, easeOutCirc"
          "fadeDim, 1, 4, fluent_decel"
          "border, 1, 2.7, easeOutCirc"
          "borderangle, 1, 30, fluent_decel, once"
          "workspaces, 1, 4, easeOutCubic, slide"
        ];
      };

      bind = [
        "$mainMod, F1, exec, show-keybinds"
        "$mainMod, Delete, exit"
        "$mainMod, Return, exec, kitty"
        "ALT, Return, exec, kitty --title float_label"
        "$mainMod SHIFT, Return, exec, kitty --start-as=fullscreen -o 'font_size=16'"
        "$mainMod, B, exec, hyprctl dispatch exec '[workspace 1 silent] floorp'"
        "$mainMod, Q, killactive,"
        "$mainMod, F, fullscreen, 0"
        "$mainMod SHIFT, F, fullscreen, 1"
        "$mainMod, Space, togglefloating,"
        "$mainMod, Space, centerwindow,"
        "$mainMod, Space, resizeactive, exact 1280 720"
        "$mainMod, A, exec, rofi -show drun || pkill rofi"
        "$mainMod SHIFT, D, exec, hyprctl dispatch exec '[workspace 4 silent] discord --enable-features=UseOzonePlatform --ozone-platform=wayland'"
        "$mainMod SHIFT, S, exec, hyprctl dispatch exec '[workspace 5 silent] SoundWireServer'"
        "$mainMod, Escape, exec, hyprlock"
        "$mainMod SHIFT, Escape, exec, shutdown-script"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, E, exec, thunar"
        "$mainMod SHIFT, B, exec, pkill -SIGUSR1 .waybar-wrapped"
        "$mainMod, C ,exec, hyprpicker -a"
        "$mainMod SHIFT, W, exec, vm-start"
        "$mainMod, S, exec, grim -g \"$(slurp)\" - | swappy -f -"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"
        "$mainMod SHIFT, 1, movetoworkspacesilent, 1"
        "$mainMod SHIFT, 2, movetoworkspacesilent, 2"
        "$mainMod SHIFT, 3, movetoworkspacesilent, 3"
        "$mainMod SHIFT, 4, movetoworkspacesilent, 4"
        "$mainMod SHIFT, 5, movetoworkspacesilent, 5"
        "$mainMod SHIFT, 6, movetoworkspacesilent, 6"
        "$mainMod SHIFT, 7, movetoworkspacesilent, 7"
        "$mainMod SHIFT, 8, movetoworkspacesilent, 8"
        "$mainMod SHIFT, 9, movetoworkspacesilent, 9"
        "$mainMod SHIFT, 0, movetoworkspacesilent, 10"
        "$mainMod CTRL, c, movetoworkspace, empty"
        "$mainMod SHIFT, left, movewindow, l"
        "$mainMod SHIFT, right, movewindow, r"
        "$mainMod SHIFT, up, movewindow, u"
        "$mainMod SHIFT, down, movewindow, d"
        "$mainMod ALT, left, resizeactive, -80 0"
        "$mainMod ALT, right, resizeactive, 80 0"
        "$mainMod ALT, up, resizeactive, 0 -80"
        "$mainMod ALT, down, resizeactive, 0 80"
        "$mainMod CTRL, Right, workspace, r+1"
        "$mainMod CTRL, Left, workspace, r-1"
        ",XF86AudioRaiseVolume,exec, pamixer -i 2"
        ",XF86AudioLowerVolume,exec, pamixer -d 2"
        ",XF86AudioMute,exec, pamixer -t"
        ",XF86AudioPlay,exec, playerctl play-pause"
        ",XF86AudioNext,exec, playerctl next"
        ",XF86AudioPrev,exec, playerctl previous"
        ",XF86AudioStop, exec, playerctl stop"
        ",XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ",XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        "$mainMod, XF86MonBrightnessUp, exec, brightnessctl set 100%+"
        "$mainMod, XF86MonBrightnessDown, exec, brightnessctl set 100%-"
        "$mainMod, V, exec, cliphist list | fuzzel --dmenu | cliphist decode | wl-copy"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];

      windowrule = [
        # --- 基础应用规则 ---
        {
          name = "imv-config";
          "match:class" = "^(imv)$";
          float = true;
          center = true;
          size = "1200 725";
        }
        {
          name = "mpv-config";
          "match:class" = "^(mpv)$";
          float = true;
          center = true;
          size = "1200 725";
          idle_inhibit = "focus"; # 注意下划线
        }
        {
          name = "tile-apps";
          "match:class" = "^(Aseprite|neovide)$";
          tile = true;
        }
        {
          name = "udiskie-float";
          "match:class" = "^(udiskie)$";
          float = true;
        }

        # --- 标题匹配规则 ---
        {
          name = "kitty-float-label";
          "match:title" = "^(float_label)$";
          float = true;
          center = true;
          size = "950 600";
        }
        {
          name = "transmission-float";
          "match:title" = "^(Transmission)$";
          float = true;
        }
        {
          name = "volume-control";
          "match:title" = "^(Volume Control)$";
          float = true;
          center = true;
          size = "700 450";
          move = "40 55%";
        }
        {
          name = "firefox-sharing-indicator";
          "match:title" = "^(Firefox — Sharing Indicator)$";
          float = true;
          move = "0 0";
        }

        # --- 特定应用规则 ---
        {
          name = "audacious-config";
          "match:class" = "^(audacious)$";
          float = true;
          workspace = "8 silent";
        }
        {
          name = "pavucontrol-config";
          "match:class" = "^(pavucontrol)$";
          float = true;
          center = true;
        }
        {
          name = "pip-mode";
          "match:title" = "^(Picture-in-Picture)$";
          float = true;
          pin = true;
          opacity = "1.0 override";
        }
        {
          name = "firefox-inhibit";
          "match:class" = "^(firefox)$";
          idle_inhibit = "fullscreen";
        }
        {
          name = "zenity-config";
          "match:class" = "^(zenity)$";
          float = true;
          center = true;
          size = "850 500";
        }
        {
          name = "other-floats";
          "match:class" = "^(SoundWireServer|.sameboy-wrapped|confirm|dialog|download|notification|error|confirmreset)$";
          float = true;
        }

        # --- XWaylandVideoBridge 修复 (注意 v0.52 属性名变更) ---
        {
          name = "xwayland-bridge-fix";
          "match:class" = "^(xwaylandvideobridge)$";
          opacity = "0.0 override";
          no_anim = true;          # noanim -> no_anim
          no_initial_focus = true; # noinitialfocus -> no_initial_focus
          max_size = "1 1";        # maxsize -> max_size
          no_blur = true;          # noblur -> no_blur
        }
      ];
    };
    extraConfig = ''
      xwayland {
        force_zero_scaling = true
      }
    '';
  };
}
