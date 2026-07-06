{ pkgs, ... }:
let
  wechatDesktop = pkgs.makeDesktopItem {
    name = "wechat"; # 这会生成 wechat.desktop
    desktopName = "WeChat";
    genericName = "WeChat Client";
    exec = "${pkgs.wechat}/bin/wechat --enable-features=UseOzonePlatform --ozone-platform=wayland -- %U";
    icon = "wechat";
    comment = "WeChat Client";
    categories = [ "Utility" ];
    terminal = false;
    startupNotify = true;
    startupWMClass = "wechat";
  };

  _wechat = pkgs.symlinkJoin {
    name = "wechat";
    paths = [ pkgs.wechat ];
    postBuild = ''
      rm -f $out/share/applications/wechat.desktop
      cp ${wechatDesktop}/share/applications/* $out/share/applications/
    '';
  };
in
{
  home.packages = [ _wechat ];
}
