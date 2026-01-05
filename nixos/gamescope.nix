{ pkgs, lib, ... }:
{
  programs.gamemode.enable = true;
  programs = {
    steam = {
      enable = true;

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = false;

      gamescopeSession.enable = true;

      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };

    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
        "--force-aspect-ratio" # 强制保持宽高比
        "--adaptive-sync"      # 如果你的显示器支持自适应同步
        "--stretch"           # 强制拉伸
      ];
    };
  };
}
