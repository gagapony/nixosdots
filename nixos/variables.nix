{ inputs, config, ... }: {
  imports = [ ./variables-config.nix ];

  config.var = {
    version = "26.05";

    hsystem = "x86_64-linux";
    hostname = "nixos";
    username = "gabriel";
    password = "1111";

    # The path of the nixos configuration directory
    configDirectory = "/home/" + config.var.username + "/.config/nixos";
    keyboardLayout = "us";
    location = "Beijing";
    timeZone = "Asia/Shanghai";
    defaultLocale = "en_US.UTF-8";
    extraLocale = "en_US.UTF-8";

    autoUpgrade = false;
    autoGarbageCollector = false;

    github = {
      token = "";
      name = "gagapony"; # Add your Git username here
      email = "aoengo@outlook.com"; # Add your Git email here
    };

    network = {
      gateway = "192.168.7.3";
      nameservers = "114.114.114.114;8.8.8.8;";
      # TCP (web, SSH, HAP, NFS, etc. - all preserved)
      tcpPorts = [
        22
        80 443 8443 8080     # Web
        8123 8485 10000 16601 26885 4000 4001  # Preserved services
        59010 59011          # Likely TCP (VNC/apps)
        2049 111 20048       # NFS
        21064 21065                # HomeKit HAP
      ];

      # UDP (only what actually needs UDP)
      udpPorts = [
        5353                 # mDNS (required for HomeKit)
        2049 111 20048       # NFS (conservatively kept on UDP)
      ];
    };

    # Choose your theme variables here
    # theme-name = "FlatColor";
    theme-name = "adw-gtk3";

    catppuccin = {
      flavor = "mocha";
      basic-accent = "lavender";
      fcitx5-accent = "blue";
      cursor-accent = "light";
    };

    # Wallpaper — drop the file in <repo>/assets/ and set its name here.
    # This single value feeds stylix (image), hyprlock (background) and
    # swaybg (desktop background); no other path needs editing.
    wallpaper = ../assets/hyprland.png;

    colorScheme = inputs.nix-colors.colorSchemes."catppuccin-${config.var.catppuccin.flavor}";

    # theme = import ../../themes/var/pinky.nix;
  };
}
