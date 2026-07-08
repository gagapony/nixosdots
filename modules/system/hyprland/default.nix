{ inputs, ... }:
{
    imports = [
    ./hyprland.nix
    ./config.nix
    ./hyprlock.nix
    ./hyprsunset.nix
    ./variables.nix
    inputs.hyprland.homeManagerModules.default
  ];
}
