{ config, pkgs, lib, ... }:
let
  flavor = config.var.catppuccin.flavor;
  fcitx5-accent = config.var.catppuccin.fcitx5-accent;
in
{
  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.waylandFrontend = true;
    fcitx5.addons = with pkgs; [
      fcitx5-pinyin-zhwiki
      librime
      fcitx5-rime
      qt6Packages.fcitx5-chinese-addons
    ];

    # fcitx5 config is managed through structured `settings` so it merges into
    # the ~/.config/fcitx5 linkFarm that home-manager creates as a single store
    # symlink. Declaring these as `home.file.".config/fcitx5/..."` instead
    # writes *inside* that symlink, so its realpath escapes the home-files
    # output and the build fails with "installing file ... outside $HOME".
    fcitx5.settings = {
      # ~/.config/fcitx5/profile — default input method group
      inputMethod = {
        "Groups/0" = {
          Name = "Default";
          "Default Layout" = "us";
          DefaultIM = "pinyin";
        };
        "Groups/0/Items/0".Name = "keyboard-us";
        "Groups/0/Items/1".Name = "pinyin";
        GroupOrder."0" = "Default";
      };
      # ~/.config/fcitx5/conf/classicui.conf — stylix already sets Theme and
      # the base fonts here; we override the font (mkForce beats stylix's plain
      # priority) and add Vertical Candidate List.
      addons.classicui.globalSection = {
        "Vertical Candidate List" = false;
        Font = lib.mkForce "MonaspiceAr Nerd Font 13";
      };
    };
  };
}
