{ pkgs, config, inputs,... }: {

  _module.args = { inherit inputs; };

  imports = [
    ../nixos/variables.nix

    # Programs
    ./programs/python.nix
    ./programs/packages.common.nix
    ./programs/packages.mini.nix
    ./programs/tmux.nix
    ./programs/nvim.nix
    ./programs/zsh.nix
    ./programs/git.nix
    ./programs/lazygit.nix
  ];

  home = {
    inherit (config.var) username;
    homeDirectory = "/home/" + config.var.username;

    # Import my profile picture, used by the hyprpanel dashboard
    # file.".profile_picture.png" = { source = ./profile_picture.png; };

    # Don't touch this
    stateVersion = config.var.version;
  };

  home.sessionVariables = {
    DONT_PROMPT_WSL_INSTALL = "1";
  };

  programs.home-manager.enable = true;
}
