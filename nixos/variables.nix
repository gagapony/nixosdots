{ inputs, config, ... }: {
  imports = [ ./variables-config.nix ];

  config.var = {
    version = "25.05";

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
    extraLocale = "zh_CN.UTF-8";

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
      tcpPorts = [ 22 80 443 2049 59010 59011 8485 10000 16601 8443 8080 26885];
      udpPorts = [ 22 80 443 2049 59010 59011 8485 10000 16601 8443 8080 26885];
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

    colorScheme = inputs.nix-colors.colorSchemes."catppuccin-${config.var.catppuccin.flavor}";

    # theme = import ../../themes/var/pinky.nix;
  };
}
