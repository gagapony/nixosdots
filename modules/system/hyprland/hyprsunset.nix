# hyprsunset — blue-light / gamma filter for Hyprland (replaces wlsunset/gammastep).
# Runs as a daemon; controlled at runtime via `hyprctl hyprsunset ...`.
# Config in $XDG_CONFIG_HOME/hypr/hyprsunset.conf (optional; sensible defaults
# applied below so daytime is neutral and evening is warm).
{ pkgs, ... }:
{
  home.packages = [ pkgs.hyprsunset ];

  xdg.configFile."hypr/hyprsunset.conf".text = ''
    max-gamma = 150

    profile {
        time = 6:00
        identity = true
    }

    profile {
        time = 20:00
        temperature = 4500
        gamma = 0.85
    }

    profile {
        time = 22:30
        temperature = 3500
        gamma = 0.75
    }
  '';
}
