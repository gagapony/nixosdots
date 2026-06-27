{ config, pkgs, ... }:
{
  services = {
    gvfs.enable = true;
    dbus.enable = true;
    fstrim.enable = true;
    openssh.enable = true;
    # greetd = {
    #   enable = true;
    #   settings = {
    #     default_session = {
    #       # command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland";
    #       # 或者直接启动 Hyprland
    #       command = "Hyprland";
    #     };
    #   };
    # };
    gnome.gnome-keyring.enable = true;
    timesyncd = {
      enable = true;
      servers = [
        "ntp.aliyun.com"
        "ntp1.aliyun.com"
        "ntp.tencent.com" # 腾讯 NTP 服务器
        "ntp.ubuntu.com" # Ubuntu NTP 服务器
        "time.windows.com" # Windows 时间服务器
      ];
    };
    nfs.server = {
      enable = true;
      exports = ''
        /home/${config.var.username}/Share *(rw,sync,no_subtree_check,no_root_squash)
      '';
      mountdPort = 20048;
      statdPort = 4000;
      lockdPort = 4001;
    };
  };
  services.udev.extraRules = ''
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="374b", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3748", MODE="0666"
    SUBSYSTEM=="usb", ATTR{idVendor}=="0483", ATTR{idProduct}=="3744", MODE="0666"
  '';
}
