{ inputs, pkgs, ...}:
{
  home.packages = with pkgs; [
    # swww
    swaybg
    hyprpicker
    grim
    swappy
    slurp
    wl-clip-persist
    wf-recorder
    glib
    wayland
    direnv
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [ "xdg-desktop-autostart.target" ];
  wayland.windowManager.hyprland = {
    enable = true;
    configType = "lua"; # adopted lua config format (26.05 default)
    xwayland = {
      enable = true;
      # hidpi = true;
    };
    # enableNvidiaPatches = false;
    systemd.enable = true;
  };
}
