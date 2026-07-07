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
      # configType = "lua": home-manager renders `settings.monitor` / `settings.bindl`
      # (conf-string lists) as `hl.monitor("<string>")` etc., but Hyprland >= 0.47's
      # `hl.monitor` requires an `HL.MonitorSpec` table and there is no `bindl` in the
      # Lua API (locked binds use `hl.bind(..., { locked = true })`). Declare both as
      # native Lua in extraConfig instead. extraConfig is `types.lines`, so this
      # concatenates cleanly with modules/system/hyprland/config.nix.
      extraConfig = ''
        -----------------
        ---- MONITORS ----
        -----------------
        hl.monitor({ output = "DP-2",  mode = "3840x2160@59.98", position = "0x0",    scale = 1 })
        hl.monitor({ output = "eDP-1", mode = "2880x1800@90",   position = "3840x0", scale = 1 })

        --------------------
        ---- LID SWITCH ----
        --------------------
        -- Ported from the old `bindl` conf entries. `bindl` (locked) maps to
        -- hl.bind(..., { locked = true }); switch events keep the `switch:on:/off:`
        -- token. Verify lid behaviour after switching this host.
        hl.bind("switch:on:Lid Switch",  hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1, disable'"),               { locked = true })
        hl.bind("switch:off:Lid Switch", hl.dsp.exec_cmd("hyprctl keyword monitor 'eDP-1, 2880x1800@90, 3840x0, 1'"), { locked = true })
      '';
    };
  };
}
