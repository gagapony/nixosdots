{ pkgs, inputs, nixpkgs, self, config, host, lib, ... }:
let
  username = config.var.username;
  nameservers = config.var.network.nameservers;
  gateway = config.var.network.gateway;
in
{
  boot = {
    loader = {
      grub = {
        enable = true;
        device = "/dev/sda";  # 直接指定磁盘设备，如 /dev/sda
        efiSupport = false;   # 禁用 EFI 支持
        configurationLimit = 5;
      };
    };
    kernelPackages = pkgs.linuxPackages_latest; # _zen, _hardened, _rt, _rt_latest, etc.
    consoleLogLevel = 0;
  };
  networking = {
    interfaces.ens18.ipv4.addresses = [{
      address = "192.168.7.12";
      prefixLength = 24;
    }];
    defaultGateway = gateway;
    nameservers = [ "192.168.7.3" "223.5.5.5" ];
  };


  services.openvscode-server = {
    enable = true;
    user = "${username}";
    group = "users";
    host = "0.0.0.0";
    port = 10002;
    # connectionTokenFile = config.sops.secrets.openvscode-server-token.path;

    package = pkgs.vscode-with-extensions.override {
      vscode = pkgs.openvscode-server.overrideAttrs { passthru.executableName = "openvscode-server"; };
      vscodeExtensions = with pkgs.vscode-extensions; [
        asvetliakov.vscode-neovim
        catppuccin.catppuccin-vsc
        bbenoist.nix
        dracula-theme.theme-dracula
        editorconfig.editorconfig
        oderwat.indent-rainbow
        christian-kohler.path-intellisense
        mkhl.direnv
        # Formatter
        hookyqr.beautify
        # Git Plugins
        donjayamanne.githistory
        eamodio.gitlens
        # Golang
        golang.go

        spywhere.guides
        pkief.material-icon-theme
        ryu1kn.partial-diff
        # ms-python.python
        ms-azuretools.vscode-docker
        octref.vetur
        jnoortheen.nix-ide
        llvm-vs-code-extensions.vscode-clangd
        xaver.clang-format
        ms-vscode.cmake-tools
      ];
    };
  };
}
