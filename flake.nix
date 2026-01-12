{
  description = "gabriel's nixos configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprspace = {
      url = "github:KZDKM/Hyprspace";
      inputs.hyprland.follows = "hyprland";
    };
    nixy-wallpapers = {
      url = "github:anotherhadi/nixy-wallpapers";
      flake = false;
    };

    catppuccin-bat = {
      url = "github:catppuccin/bat";
      flake = false;
    };
    catppuccin-cava = {
      url = "github:catppuccin/cava";
      flake = false;
    };
    catppuccin-starship = {
      url = "github:catppuccin/starship";
      flake = false;
    };
    catppuccin= {
      url = "github:catppuccin/nix";
      flake = false;
    };
    catppuccin-nix.url = "github:catppuccin/nix";
    stylix.url = "github:danth/stylix";
    hypr-contrib.url = "github:hyprwm/contrib";
    hyprpicker.url = "github:hyprwm/hyprpicker";
    hyprpolkitagent.url = "github:hyprwm/hyprpolkitagent";
    hyprpanel.url = "github:Jas-SinghFSU/HyprPanel";
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    apple-fonts.url = "github:Lyndeno/apple-fonts.nix";
    nur.url = "github:nix-community/NUR";
    alejandra.url = "github:kamadorueda/alejandra/3.0.0";
    nix-gaming.url = "github:fufexan/nix-gaming";

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    anyrun.url = "github:anyrun-org/anyrun";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "github:gagapony/dotfiles";
    };
    nix-colors.url = "github:misterio77/nix-colors";
    opencode.url = "github:anomalyco/opencode";
  };

  outputs = { nixpkgs, self, ... } @ inputs:
    let
      system = "x86_64-linux";
      lib = nixpkgs.lib;
      pkgs = import nixpkgs {
        inherit system;
        overlays = [ inputs.nur.overlay inputs.rust-overlay.overlays.default];
        config.allowUnfree = true; # 如果需要的话
      };
    in
    {
      nixosConfigurations = {
        desktop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [
            (import ./hosts/desktop)
          ];
          specialArgs = { host = "desktop"; inherit self inputs lib; };
        };
        laptop = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/laptop) ];
          specialArgs = { host = "laptop"; inherit self inputs lib; };
        };
        wsl = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/wsl) ];
          specialArgs = { host = "wsl"; inherit self inputs lib; };
        };
        vm = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ (import ./hosts/vm) ];
          specialArgs = { host = "vm"; inherit self inputs lib; };
        };
      };
    };
}
