# Nix Flake

You can use this in your own flakes:

# Packages

* `neovimConfigured`: A configured `nvim` with plugins.
* `vscodeConfigured`: A `vscode` with extensions.

# NixOS Configurations

General dogma:

* Only UEFI, with a 512MB+ FAT32 partition on the `/boot` block device.
* BTRFS based root block devices (in a `dm-crypt`).
* Firewalled except port 22.
* Preconfigured, ready to use, global (`nvim`) editor and shell (`bash`) configuration.
* Somewhat hardened hardware nodes.
* Relaxed user access control.
* Nix features `nix-command` and `flake` adopted.

## Partitioning

The machines share a common partitioning strategy, once setting the required environment variables, a script assists:

> **WARNING!:** This script will **destroy** any disks and partitions you point it at, and is not designed for uncareful use.
>
> Be careful! Please!

```shell-session
sudo nix run github:an-sdgr/flake#unsafe-bootstrap
```

## Mini

A dell optiplex k8s server

Set hard drives to AHCI, and disable secure boot.

## Preparation

Requires:

* An `x86_64-linux` based `nix`.
* A USB stick, 8+ GB preferred. ([Ex][parts-usb-stick-ex])

Build a recovery image:

```shell-session
nix build github:an-sdgr/flake#nixosConfigurations.x86_64IsoImage.config.system.build.isoImage --out-link isoImage
```

> locally, you can substitute '.' like `nix build .#nixosConfigurations.x86_64IsoImage.config.system.build.isoImage --out-link isoImage`

Flash it to a USB:

```shell-session
NIXOS_USB=/dev/null
umount $NIXOS_USB
sudo cp -vi isoImage/iso/*.iso $NIXOS_USB
```

To test the image locally:

```shell-session
qemu-system-x86_64 -enable-kvm -m 4096 -cdrom isoImage/iso/*.iso
```

## Bootstrap

Start the machine, or reboot it. Once logged in, partion, format, and mount the NVMe disk:

```shell-session
export TARGET_DEVICE=/dev/nvme0n1
export EFI_PARTITION=/dev/nvme0n1p1
export ROOT_PARTITION=/dev/nvme0n1p2
```

WARNING, THIS SCRIPT WILL WIPE ALL YOUR DISKS. Run the bootstrap script.

```shell-session
sudo nix run github:an-sdgr/flake#unsafe-bootstrap
```

Set a password for your user

```shell-session
nix run nixpkgs#mkpasswd -- --stdin --method=sha-512 > /mnt/persist/encrypted-passwords/nason
```

After, install the system:

```shell-session
sudo bootctl install --esp-path=/mnt/efi
sudo nixos-install --flake github:an-sdgr/flake#mini --impure
```
To customize further, clone this repo, `cd` to it, and run `direnv allow`

After rebooting, the system should be good to go!

## Static analysis

Deadnix (unused code / lambda checks)

```shell-session
nix run github:astro/deadnix .
```

Statix (style / antipatterns)

```shell-session
nix run nixpkgs#statix check .
```

Flake-checker is currently being evaluated, and is happy:

```shell-session
nix run github:DeterminateSystems/flake-checker
```

