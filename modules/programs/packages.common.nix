{ inputs, pkgs, ... }:
let
  spec-kit-custom = pkgs.callPackage ../../pkgs/spec-kit.nix { };
  opencode-custom = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
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
    # opencode-custom
    spec-kit-custom
  ]);
}
