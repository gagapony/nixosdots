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
    # configType = "lua": home-manager renders `settings.monitor` (a list of conf
    # strings) as `hl.monitor("<string>")`, but Hyprland >= 0.47's `hl.monitor`
    # requires an `HL.MonitorSpec` table (see $HYPR/share/hypr/stubs/hl.meta.lua),
    # hence `hl.monitor: argument must be a table`. Declare monitors as native Lua
    # in extraConfig instead. extraConfig is `types.lines`, so this concatenates
    # cleanly with modules/system/hyprland/config.nix.
    wayland.windowManager.hyprland.extraConfig = ''
      -----------------
      ---- MONITORS ----
      -----------------
      hl.monitor({ output = "DP-1", mode = "3840x2160@60",     position = "0x0",    scale = 1 })
      hl.monitor({ output = "DP-2", mode = "1920x1080@239.99", position = "3840x0", scale = 1 })
    '';
  };
}
