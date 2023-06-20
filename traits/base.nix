# A trait for all boxxen
{ config, pkgs, ... }:

{
  config = {
    time.timeZone = "America/Vancouver";
    time.hardwareClockInLocalTime = true;

    i18n.defaultLocale = "en_US.UTF-8";
    i18n.supportedLocales = [ "all" ];

    environment.systemPackages = with pkgs; [
      # Shell utilities
      #patchelf
      direnv
      nix-direnv
      git
      jq
      #fzf
      #ripgrep
      lsof
      htop
      #bat
      #grex
      #broot
      #bottom
      #fd
      #sd
      #fio
      #hyperfine
      #tokei
      #bandwhich
      #lsd
      #ntfs3g
      # nvme-cli
      # nvmet-cli
      # libhugetlbfs # This has a build failure.
      #killall
      #gptfdisk
      #fio
      #smartmontools
      neovimConfigured
      rnix-lsp
      #graphviz
      clinfo
    ];

    environment = {
      shellAliases = { };
      variables = { EDITOR = "${pkgs.neovimConfigured}/bin/nvim"; };
      pathsToLink = [ "/share/nix-direnv" ];
    };

    programs.bash = {
      promptInit = ''
        eval "$(${pkgs.starship}/bin/starship init bash)"
      '';
      shellInit = "";
      loginShellInit = ''
        HAS_SHOWN_NEOFETCH=''${HAS_SHOWN_NEOFETCH:-false}
        if [[ $- == *i* ]] && [[ "$HAS_SHOWN_NEOFETCH" == "false" ]]; then
          ${pkgs.neofetch}/bin/neofetch --config ${../config/neofetch/config}
          HAS_SHOWN_NEOFETCH=true
        fi
      '';
      interactiveShellInit = ''
        eval "$(${pkgs.direnv}/bin/direnv hook bash)"
        source "${pkgs.fzf}/share/fzf/key-bindings.bash"
        source "${pkgs.fzf}/share/fzf/completion.bash"
      '';
    };

    security.sudo.wheelNeedsPassword = false;
    security.sudo.extraConfig = ''
      Defaults lecture = never
    '';

    home-manager.useGlobalPkgs = true;
    home-manager.useUserPackages = true;
    nixpkgs.config.allowUnfree = true;
    nix.extraOptions = ''
      experimental-features = nix-command flakes
      builders-use-substitutes = true
    '';

    #isoImage.squashfsCompression = "gzip -Xcompression-level 1";

    system.stateVersion = "23.05";
  };
}
