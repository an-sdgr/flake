/*
  A trait for configurations including k3s
*/
{ pkgs, ... }:

{
    networking = {
      networkmanager.enable = true;
      wireless.enable = false; # disable wpa_supplicant
      firewall = {
        enable = true;
        checkReversePath = false;

        allowedTCPPorts = [ 
          6443
          80
          443
          10250
        ];
        allowedUDPPorts = [
          53
          8472
        ];
      };

    };
  
    services.k3s = {
    enable = true;
    role = "server";
    package = pkgs.k3s;
    };

    security.rtkit.enable = true;
    hardware = {
      i2c.enable = true;
      bluetooth.enable = true;
    };

    #virtualisation.podman.enable = true;
}
