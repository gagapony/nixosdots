{ config, inputs, ... }: {
  imports = [
    # modules
    inputs.home-manager.nixosModules.home-manager
    inputs.stylix.nixosModules.stylix
    inputs.nur.modules.nixos.default
    inputs.nix-colors.homeManagerModules.default

    ./addon-configuration.nix
    ./hardware-configuration.nix
    ./../../nixos/variables.nix


    # nixos
    ../../nixos/base.nix
    ../../nixos/audio.nix
    ../../nixos/bluetooth.nix
    ../../nixos/bootloader.nix
    ../../nixos/docker.nix
    ../../nixos/fonts.nix
    ../../nixos/graphics.nix
    ../../nixos/home-manager.nix
    ../../nixos/network.nix
    ../../nixos/nix.nix
    ../../nixos/security.nix
    ../../nixos/services.nix
    ../../nixos/timezone.nix
    ../../nixos/users.nix
    ../../nixos/variables-config.nix
    ../../nixos/virtualization.nix
    ../../nixos/xdg-portal.nix
    ../../nixos/gamescope.nix

    # Choose your theme here


    # ./../../modules/themes/catppuccin/nixos.nix
    ./../../modules/themes/stylix/default.nix
    ];


  home-manager.users."${config.var.username}" = import ../../modules/default.full.nix;

  # Don't touch this
  # nix.nixPath = lib.mkForce ["/etc/nix/inputs"];
  system.stateVersion = config.var.version;
  powerManagement.cpuFreqGovernor = "performance";
}
