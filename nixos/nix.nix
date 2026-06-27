{ config, inputs, ... }:
let
  username = config.var.username;
  autoGarbageCollector = config.var.autoGarbageCollector;
in
{
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = true;
  };
  nix = {
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    channel.enable = false;
    extraOptions = ''
      warn-dirty = false
    '';


    settings = {
      trusted-users = [ "root" "${username}" ];
      allowed-users = [ "@wheel" "@nixbld" ];
      auto-optimise-store = true;
      experimental-features = [ "nix-command" "flakes" ];
      # GitHub 鉴权已改用 sops-nix 管理的 netrc-file（见 nixos/sops.nix）。
      substituters = [
        "https://mirrors.ustc.edu.cn/nix-channels/store"
        "https://cache.nixos.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };
    gc = {
      automatic = autoGarbageCollector;
      persistent = true;
      dates = "weekly";
      options = "--delete-older-than 7d";
    };
  };
}
