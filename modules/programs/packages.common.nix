{ inputs, pkgs, ... }:
let
  opencode-custom = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
in
{
  home.packages = (with pkgs; [
    nodejs
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
    opencode
    spec-kit
  ]);
}
