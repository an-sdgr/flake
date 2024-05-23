{ writeShellApplication, bash, gum, cryptsetup, gptfdisk, btrfs-progs
, dosfstools, ... }:

writeShellApplication {
  name = "unsafe-bootstrap";
  runtimeInputs = [ bash gum cryptsetup gptfdisk dosfstools ];
  text = builtins.readFile ./unsafe-bootstrap.sh;
}
