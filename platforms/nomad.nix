{ config, pkgs, lib, modulesPath, ... }:

let
  devices = {
    encrypted = {
      uuid = "20aa0374-602e-4691-8983-c2da891544a0";
      label = "encrypt";
    };
    efi = {
      uuid = "6FA9-1C46";
      label = "efi";
    };
  };
in
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.grub.enable = true;
  boot.loader.grub.efiSupport = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.efiInstallAsRemovable = true;
  boot.loader.grub.device = "nodev";
  boot.loader.grub.version = 2;
  boot.loader.grub.configurationLimit = 10;
  boot.loader.grub.enableCryptodisk = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  boot.initrd.luks.devices = {
    encrypt = {
      device = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
      keyFile = "/keyfile.bin";
      allowDiscards = true;
    };
  };
  boot.initrd.secrets = {
    "keyfile.bin" = "/etc/secrets/initrd/keyfile.bin";
  };

  fileSystems."/" = {
    device = "/dev/mapper/${devices.encrypted.label}";
    fsType = "btrfs";
    encrypted.enable = true;
    encrypted.label = devices.encrypted.label;
    encrypted.blkDev = "/dev/disk/by-uuid/${devices.encrypted.uuid}";
    encrypted.keyfile = "/keyfile.bin";
    options = [
      "compress=zstd"
      "lazytime"
    ];
  };
  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/${devices.efi.uuid}";
    fsType = "vfat";
  };

  #networking.hostId = "938c2500";
  networking.hostName = "nomad";
  networking.domain = "hoverbear.home";
  #networking.interfaces.enp6s0.useDHCP = true;
  #networking.interfaces.wlp5s0.useDHCP = true;

  networking.networkmanager.enable = true;
  programs.nm-applet.enable = true;

  time.timeZone = "America/Vancouver";
  # Windows wants hardware clock in local time instead of UTC
  time.hardwareClockInLocalTime = true;

  hardware.bluetooth.enable = true;

  swapDevices = [ ];
}

