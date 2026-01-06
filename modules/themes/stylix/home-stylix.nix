{ inputs, config, pkgs, lib, ... }:
let
  flavor = config.var.catppuccin.flavor;
in
{
  home.file = {
    "Pictures/wallpapers/others/cat-leaves.png".source = inputs.nixy-wallpapers + "/wallpapers/cat-leaves.png";
  };

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.catppuccin-papirus-folders.override {
        flavor = "mocha";
        accent = "lavender";
      };
    };
  };

  qt = {
    enable = true;
    platformTheme.name = lib.mkDefault "gtk2";
    style.name = lib.mkDefault "gtk2";
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  stylix = {
    enable = true;
    autoEnable = true;
    # opacity = {
    #   popups = 0.8;
    #   applications = 0.8;
    #   terminal = 0.8;
    #   desktop = 0.8;
    # };
    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-${flavor}.yaml";

    targets = {
      firefox = {
        enable = true;
        profileNames = [ "default" ];
        firefoxGnomeTheme.enable = true;
      };
      rofi.enable = true;
      fcitx5.enable = true;
      spicetify.enable = true;
      hyprpaper.enable = true;
      waybar.enable = true;
      hyprlock.enable = true;
      gedit.enable = true;
      gtk.enable = true;
      swaync.enable = true;
      gtk.flatpakSupport.enable = true;
    };
  };
}
