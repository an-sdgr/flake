set -e

#BLUE=34
#CYAN=36
#RED=31


download_config() {
  cd /tmp
  curl -LJ0 https://github.com/na-son/flake/archive/main.zip -o flake.zip
  unzip flake.zip
  cd flake-main
}
setup_files() {
  sudo mkdir -p /mnt/etc/nixos
  sudo cp -r ./* /mnt/etc/nixos
  cd /mnt/etc/nixos
}

run_disko() {
  sudo nix run --extra-experimental-features nix-command --extra-experimental-features flakes \
    github:nix-community/disko -- --mode zap_create_mount /tmp/flake-main/config/disk.nix
}


#install_nixos() {
#  ARCH=$(uname -m)
#
#  case "$ARCH" in
#    x86_64)
#      FLAKE_TARGET="x86_64-linux"
#      ;;
#    aarch64)
#      FLAKE_TARGET="aarch64-linux"
#      ;;
#    *)
#      echo -e "Unsupported architecture: $ARCH"
#      exit 1
#      ;;
#  esac
#
#  echo "Disk initialization complete. ________________________________________"
#  echo "Installing NixOS........................................"
#
#  #sudo nixos-install --flake .#$FLAKE_TARGET $@
#  sudo chmod -R 775 /mnt/etc/nixos
#}

download_config
run_disko
#install_nixos

#lsblk -o name,mountpoint,size,uuid,vendor
#
#TARGET_DEVICE="/dev/nvme0n1"
#EFI_PARTITION="/dev/nvme0n1p1"
#ROOT_PARTITION="/dev/nvme0n1p2"
#
##if test -z "${EFI_PARTITION-}"; then
##	EFI_PARTITION=$(gum input --prompt "What will be the created EFI partition? (EFI_PARTITION): " --placeholder "/dev/nvme?n?p1")
##fi
##echo "Got \`$(gum style --foreground ${BLUE} "EFI_PARTITION")=$(gum style --foreground ${CYAN} "${EFI_PARTITION}")\`"
##
##if test -z "${ROOT_PARTITION-}"; then
##	ROOT_PARTITION=$(gum input --prompt "What will be the created root partition? (ROOT_PARTITION): " --placeholder "/dev/nvme?n?p2")
##fi
##echo "Got \`$(gum style --foreground ${BLUE} "ROOT_PARTITION")=$(gum style --foreground ${CYAN} "${ROOT_PARTITION}")\`"
#
#
#gum style "
#This will irrevocably destroy all data on \`TARGET_DEVICE=${TARGET_DEVICE-/dev/null}\`!!!
#
#An FAT32 EFI system partition will be created as the first partition.
#Expected as: \`EFI_PARTITION=${EFI_PARTITION-/dev/null}\`
#
#An encrypted BTRFS partition will be created as the second partition.
#Expected as: \`ROOT_PARITION=${ROOT_PARTITION-/dev/null}\`
#
#You will be prompted to set encrypted disk passwords.
#
#Several BTRFS subvolumes will be created, then mounted on \`/mnt\`.
#
#Several files will be created in the \`persist\` subvolume.
#
#This script will not install NixOS, but you will be able to run \`nixos-install\` immediately after.
#
#This process is highly experimental and will absolutely toss your machine into the rubbish bin."
#
#gum confirm "Are you ready to have a really bad time?" || (echo "Okay! Then, toodles!" && exit 1)
#
#
#gum style --bold --foreground "${RED}" "Destroying existing partitions on \`TARGET_DEVICE=${TARGET_DEVICE}\` in 10..."
#sleep 10
#gum style --bold --foreground "${RED}" "Let's gooooo!!!"
#
#umount -r /mnt || true
#umount -r "${TARGET_DEVICE}" || true
#cryptsetup luksClose encrypt || true
#sgdisk -Z "${TARGET_DEVICE}"
#sgdisk -o "${TARGET_DEVICE}"
#partprobe || true
#
#sgdisk "${TARGET_DEVICE}" -n 1:0:+1G
#sgdisk "${TARGET_DEVICE}" -t 1:ef00
#sgdisk "${TARGET_DEVICE}" -c 1:efi
#
#sgdisk "${TARGET_DEVICE}" -n 2:0:0
#sgdisk "${TARGET_DEVICE}" -t 2:8309
#sgdisk "${TARGET_DEVICE}" -c 2:encrypt
#
#cryptsetup luksFormat "${ROOT_PARTITION}"
#cryptsetup luksOpen "${ROOT_PARTITION}" encrypt
#
#mkfs.btrfs --label tree /dev/mapper/encrypt
#mount -o compress=zstd,lazytime /dev/mapper/encrypt /mnt/ -v
#btrfs subvolume create /mnt/root
#btrfs subvolume create /mnt/home
#btrfs subvolume create /mnt/nix
#btrfs subvolume create /mnt/persist
#btrfs subvolume create /mnt/log
#btrfs subvolume create /mnt/boot
#mkdir -p /mnt/snapshots/root/
#btrfs subvolume snapshot -r /mnt/root /mnt/snapshots/root/blank
#umount -R /mnt
#mount -o subvol=root,compress=zstd,lazytime /dev/mapper/encrypt /mnt
#mkdir -pv /mnt/home
#mount -o subvol=home,compress=zstd,lazytime /dev/mapper/encrypt /mnt/home
#mkdir -pv /mnt/nix
#mount -o subvol=nix,compress=zstd,lazytime /dev/mapper/encrypt /mnt/nix
#mkdir -pv /mnt/persist
#mount -o subvol=persist,compress=zstd,lazytime /dev/mapper/encrypt /mnt/persist
#mkdir -pv /mnt/var/log
#mount -o subvol=log,compress=zstd,lazytime /dev/mapper/encrypt /mnt/var/log
#mkdir -pv /mnt/boot
#mount -o subvol=boot,compress=zstd,lazytime /dev/mapper/encrypt /mnt/boot
#
#mkfs.vfat -F 32 "${EFI_PARTITION}"
#mkdir -p /mnt/efi
#mount "${EFI_PARTITION}" /mnt/efi
#
## Workaround https://github.com/NixOS/nixpkgs/issues/73404
#mkdir -p /mnt/mnt
#mount --bind /mnt /mnt/mnt
#
#mkdir -pv /mnt/persist/var/lib/NetworkManager/
#touch /mnt/persist/var/lib/NetworkManager/secret_key
#touch /mnt/persist/var/lib/NetworkManager/seen-bssids
#touch /mnt/persist/var/lib/NetworkManager/timestamps
#mkdir -pv /mnt/persist/etc/NetworkManager/system-connections
#mkdir -pv /mnt/persist/var/lib/bluetooth
#mkdir -pv /mnt/persist/etc/ssh
#mkdir -pv /mnt/persist/encrypted-passwords
#gum style --foreground "${CYAN}" "Done! Review the following block listing for the UUIDs to update the platform with."
#lsblk -o name,mountpoint,uuid
#