{ pkgs, config, inputs, lib,... }:
let

in
{
  # stylix.targets.firefox.profileNames = [ "default" ];
  programs.firefox = {
    enable = true;
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        path = "default";
        search = {
          default = "ddg";
          privateDefault = "ddg";
          order = [ "ddg" "google" ];
        };

        settings = {
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
          "svg.context-properties.content.enabled" = true;
        };
      };
    };
  };
  home.activation.cleanFirefoxSearch = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
      $DRY_RUN_CMD rm -f "${config.xdg.configHome}/mozilla/firefox/default/search.json.mozlz4"
      $DRY_RUN_CMD rm -f "${config.xdg.configHome}/mozilla/firefox/default/search.json.mozlz4.hm-backup"
    '';
}

