/*
  Make a mount tree for adding to `fileSystems`

*/
{ deviceLabel, device, efiDevice }:

{
  "/" = {
    device = "/dev/mapper/${deviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = deviceLabel;
      blkDev = device;
    };
    options = [
      "subvol=root"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/home" = {
    device = "/dev/mapper/${deviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = deviceLabel;
      blkDev = device;
    };
    options = [
      "subvol=home"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/nix" = {
    device = "/dev/mapper/${deviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = deviceLabel;
      blkDev = device;
    };
    options = [
      "subvol=nix"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/persist" = {
    device = "/dev/mapper/${deviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = deviceLabel;
      blkDev = device;
    };
    neededForBoot = true;
    options = [
      "subvol=persist"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/boot" = {
    device = "/dev/mapper/${deviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = deviceLabel;
      blkDev = device;
    };
    neededForBoot = true;
    options = [
      "subvol=boot"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/var/log" = {
    device = "/dev/mapper/${deviceLabel}";
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = deviceLabel;
      blkDev = device;
    };
    neededForBoot = true;
    options = [
      "subvol=log"
      "compress=zstd"
      "lazytime"
    ];
  };
  "/efi" = {
    device = efiDevice;
    fsType = "vfat";
  };
}
