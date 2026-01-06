{ pkgs, inputs, nixpkgs, self, config, host, ... }:
let
  username = config.var.username;
  nameservers = config.var.network.nameservers;
  gateway = config.var.network.gateway;
in
{
  networking = {
    networkmanager.ensureProfiles.profiles."enp2s0-static" = {
      connection = {
        id = "enp2s0-static";
        type = "ethernet";
        interface-name = "enp2s0";
        autoconnect = true;
      };
      ipv4 = {
        method = "manual";
        address1 = "192.168.7.60/24,${gateway}";
        dns = nameservers;
      };
    };
  };

  home-manager.users."${username}" = {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        monitor = [
          "DP-2, 3840x2160@59.98, 0x0, 1"
          "eDP-1, 2880x1800@90, 3840x0, 1"
        ];

        bindl = [
          # ", switch:[switch name], exec, swaylock"
          ", switch:on:Lid Switch, exec, hyprctl keyword monitor 'eDP-1, disable'"
          ", switch:off:Lid Switch, exec, hyprctl keyword monitor 'eDP-1, 2880x1800@90, 3840x0, 1'"
        ];
      };
    };
  };
}
