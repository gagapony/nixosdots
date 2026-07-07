{ config, inputs, pkgs, ... }:
let
  colors = config.var.colorScheme.palette;
  flavor = config.var.catppuccin.flavor;
in
{
  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-${flavor}.yaml";
    cursor = {
      package = pkgs.catppuccin-cursors.mochaLight;
      name = "catppuccin-mocha-light-cursors";
      size = 24;
    };

    fonts = {
      monospace = {
        package = pkgs.nerd-fonts.monaspace;
        name = "Monospice Nerd Font";
      };
      sansSerif = {
        package = pkgs.source-sans;
        name = "Source Sans";
      };
      serif = {
        package = pkgs.source-serif;
        name = "Source Serif";
      };
      sizes = {
        applications = 11;
        terminal = 12;
        desktop = 11;
        popups = 11;
      };
    };
    opacity = {
      applications = 0.8;
      terminal = 0.8;
      desktop = 0.8;
      popups = 0.8;
    };
    polarity = "dark";
    targets = {
      grub = {
        enable = true;
        useWallpaper = false;
      };
      gnome.enable = true;
      gtk.enable = true;
      spicetify.enable = true;
      nixos-icons.enable = true;
    };

    image = config.var.wallpaper;
  };
}
