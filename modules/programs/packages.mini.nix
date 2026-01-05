{ inputs, pkgs, ... }:
let
  _2048 = pkgs.callPackage ../../pkgs/2048/default.nix { };
  _stm32cubemx = pkgs.callPackage ../../pkgs/stm32cubemx/default.nix { }; # for specific stm32cubemx version
in
{
  home.packages = (with pkgs; [
  ]);
}
