{ inputs, pkgs, ... }:
{
  home.packages = (with pkgs; [
    home-manager
    yazi
    socat
    usbutils
    minicom
    gemini-cli
    direnv
    nix-direnv
    claude-code
    spec-kit
  ]);
}
