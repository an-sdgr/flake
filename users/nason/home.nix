{ config, pkgs, lib, ... }:

{
  home.username = "nason";
  home.homeDirectory = "/home/nason";

  programs.git = {
    enable = true;
    userName = "Austin Nason";
    userEmail = "austin.nason@schrodinger.com";
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
    };
  };

  home.packages = with pkgs; [
    neovimConfigured
  ];

  programs.home-manager.enable = true;
  home.stateVersion = "22.05";
}
