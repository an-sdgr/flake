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

```bash
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

```bash
nix build github:an-sdgr/flake#nixosConfigurations.x86_64IsoImage.config.system.build.isoImage --out-link isoImage
```

> locally, you can substitute '.' like `nix build .#nixosConfigurations.x86_64IsoImage.config.system.build.isoImage --out-link isoImage`

Flash it to a USB:

```bash
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

```bash
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

```bash
sudo bootctl install --esp-path=/mnt/efi
sudo nixos-install --flake github:an-sdgr/flake#mini --impure
```
To customize further, clone this repo, `cd` to it, and run `direnv allow`

## WSL

A system for on Windows (WSL2).

### Preparation

Build the tarball:

```bash
nix build github:hoverbear-consulting/flake#nixosConfigurations.wsl.config.system.build.installer --out-link installer
```

Ensure the Windows install has WSL(2) enabled:

```powershell
Enable-WindowsOptionalFeature -Online -FeatureName "Microsoft-Windows-Subsystem-Linux"
Enable-WindowsOptionalFeature -Online -FeatureName "VirtualMachinePlatform"
```

Reboot. Then, [install the kernel update](https://docs.microsoft.com/en-gb/windows/wsl/install-manual#step-4---download-the-linux-kernel-update-package)

```powershell
wsl --set-default-version 2
wsl --update
```

### Bootstrap

Import the tarball:


```powershell
wsl --import nixos nixos-wsl-installer.tar.gz --version 2
wsl --set-default nixos
```

Then enter first setup.

```powershell
wsl
```

This may hang at `Opimtizing Store`, give it a minute, then Ctrl+C and run `wsl` again. It should work.

If you do experience that, rebuild the install and it seems to fix it:

```bash
nixos-rebuild switch --flake github:hoverbear-consulting/flake#wsl
```


[hoverbear-consulting]: https://hoverbear.org
[chips-amd3950x]: https://en.wikichip.org/wiki/amd/ryzen_9/3950x
[chips-arm-cortex-a72]: https://en.wikichip.org/wiki/arm_holdings/microarchitectures/cortex-a72
[parts-microusb-to-usb-cable-ex]: https://www.memoryexpress.com/Products/MX30019
[parts-microsd-card-ex]: https://shop.solid-run.com/product/MSD016B/
[parts-usb-stick-ex]: https://www.memoryexpress.com/Products/MX64592
[parts-lx2k]: https://shop.solid-run.com/product/SRLX216S00D00GE064H08CH/
[parts-hyperx-impact-32gb-3200mhz-ddr4-sodimm]: https://www.memoryexpress.com/Products/MX80507
[parts-samsung-970-evo-plus-1tb-m2]: https://www.memoryexpress.com/Products/MX76118
[parts-samsung-970-pro-1tb-m2]: https://www.memoryexpress.com/Products/MX72359
[parts-x570-aorus-pro-wifi]: https://www.memoryexpress.com/Products/MX77641
[parts-gigabyte-x5700-xt]: https://www.gigabyte.com/ca/Graphics-Card/GV-R57XTGAMING-OC-8GD-rev-10#kf
[parts-corsair-vengance-32gb-3200mgz-ddr4-dimm]: https://www.memoryexpress.com/Products/MX00115415
[parts-intel-optane-P4800X]: https://www.intel.com/content/www/us/en/products/memory-storage/solid-state-drives/data-center-ssds/optane-dc-ssd-series/optane-dc-p4800x-series/p4800x-375gb-aic-20nm.html
[machines-hp-spectre-x360]: https://support.hp.com/rs-en/document/c05809809
[references-erase-your-darlings]: https://grahamc.com/blog/erase-your-darlings
