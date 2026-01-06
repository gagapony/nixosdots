{ inputs, pkgs, ... }:
let
  spec-kit-custom = pkgs.callPackage ../../pkgs/spec-kit.nix { };
in
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
    spec-kit-custom
  ]);
}
