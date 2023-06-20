# A trait for headed boxxen
{ config, pkgs, ... }:

{
    hardware.opengl.enable = true;
    hardware.opengl.driSupport = true;
    hardware.opengl.extraPackages = with pkgs; [
      libvdpau
      vdpauinfo
      libvdpau-va-gl
    ];

    fonts.fontconfig = {
      enable = true;
      antialias = true;
      hinting.enable = true;
      hinting.style = "hintfull";
    };

    fonts.enableDefaultFonts = true;
    fonts.fonts = with pkgs; [
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
      jetbrains-mono
      fira-code
      fira-code-symbols
    ];

    # These should only be GUI applications that are desired systemwide
    environment.variables = {
      # VDPAU_DRIVER = "radeonsi";
    };
    environment.systemPackages = with pkgs; [
      virt-manager
      libva-utils
      vdpauinfo
      ffmpeg
      neovimConfigured
    ];

    #services.printing.enable = true;
}

