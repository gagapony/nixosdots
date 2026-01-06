{ pkgs, inputs, nixpkgs, self, config, host, ... }:
let
  username = config.var.username;
  nameservers = config.var.network.nameservers;
  gateway = config.var.network.gateway;
in
{
  networking = {
    networkmanager.ensureProfiles.profiles."enp8s0-static" = {
      connection = {
        id = "enp8s0-static";
        type = "ethernet";
        interface-name = "enp8s0";
        autoconnect = true;
      };
      ipv4 = {
        method = "manual";
        address1 = "192.168.7.59/24,${gateway}";
        dns = nameservers;
      };
    };
  };

  home-manager.users.${username} = {
    wayland.windowManager.hyprland.settings.monitor = [
      "DP-2, 3840x2160@60,     0x0, 1"
      "DP-1, 1920x1080@239.99, 3840x0, 1"
    ];
  };
}
