{ config, inputs, ... }: {
  imports = [
    # modules
    inputs.home-manager.nixosModules.home-manager
    # inputs.stylix.nixosModules.stylix
    inputs.nur.modules.nixos.default

    ./addon-configuration.nix
    ./hardware-configuration.nix
    ./../../nixos/variables.nix

    # nixos
    ../../nixos/base.nix
    ../../nixos/users.nix
    ../../nixos/network.nix
    ../../nixos/services.nix
    ../../nixos/home-manager.nix
    ../../nixos/nix.nix
    ../../nixos/sops.nix
    ../../nixos/docker.nix
    ../../nixos/security.nix
    ../../nixos/timezone.nix
    ../../nixos/variables-config.nix

    # Choose your theme here
    # ../../modules/themes/stylix/default.nix
    ];


  home-manager.users."${config.var.username}" = import ../../modules/default.mini.nix;

  # Don't touch this
  # nix.nixPath = lib.mkForce ["/etc/nix/inputs"];
  system.stateVersion = config.var.version;
  powerManagement.cpuFreqGovernor = "performance";
}
