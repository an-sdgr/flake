{ writeShellApplication, bash, gum, cryptsetup, fdisk, btrfs-progs, ... }:

writeShellApplication {
  name = "unsafe-bootstrap";
  runtimeInputs = [
    bash
    gum
    cryptsetup
    fdisk
    btrfs-progs

  ];
  text = builtins.readFile ./unsafe-bootstrap.sh;
}
