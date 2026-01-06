{ pkgs, config, ... }:
let
  hostname = config.var.hostname;
  allowedTCPPorts = config.var.network.tcpPorts;
  allowedUDPPorts = config.var.network.udpPorts;
in
{
  networking = {
    hostName = "${hostname}";
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = allowedTCPPorts;
      allowedUDPPorts = allowedUDPPorts;
    };
  };

  environment.systemPackages = with pkgs; [
    networkmanagerapplet
  ];
}

