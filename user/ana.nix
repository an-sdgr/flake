{ lib, pkgs, ... }:

{
  users.users.ana = {
    isNormalUser = true;
    extraGroups = [ "wheel" "disk" ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDY0XcmEJNdUOVg6xONb8Nr1jSjUnt7M6jSYPPSKPMYD08gW3tDCgXS2p8DJXXxb7mVoyciY56/UJT2GsBvHgC+dSaE6J4rX0AIdwMOwxOrRyENmT3olu2POu5clhvsewlSHIJaJo809TdhtPMywvKTk3WDp+pdoTfBzz+jbvJ61X8PBTKltxI838yE4Jd+rMHeIemXnDjuNiNeCl8vhvzfAolgharhGqafWqD/YiPWqiGZDOiybtxjior2tCBmmB4daJgxF5logEdh7rWYjKOzPrTwoxvFQ/s1eSq3BTcyJNh+DR+hgls+Z5EqvcMKOIb0qkOoxtqr3ASMUc/9SCT9 ana@nomad"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC/uGH1pFZx4221lTvR6tdcdFVsNC1YElPpPm9OYP5cW+h3+K/a/QStcatNAFJzr80cIg61bLVdULy/FTgT58R/gb922QV2Lnz6ZCnzUwT6bDpvmpcMXzUGYGtdUDXLR/Km7fyLSzuxmeGRkRLZxNcntZcrmjVTq1UBl57xgWpWB3Aa+L5/c5X8qaES8+B7x8/8/abtbL7QQe4JxJUZXHjomSiEjFyn2kyMjdZYuaUi6OCZD/ttGQr/zL19ur+ZlgyqCkDM7V6aFKzWxJL4NfJqoepFISDTWrppVvczttzRaifqjK8jcOZ266G2ZnYJJ2GIJCmnALiw+6hmai9hgjo42axMzaEFuwWYKKLKRr4jBLCj5uaF8ZjHqNshiE5LaJ5BZOFMkbkTd+Xf4Q9VVvLNHLu/2rKl7ndoyHMdN4gsZYFl/Papk2zMWFcbZULpAp6XYn/tet1fNfTEa4oO7qs4dOXhVn5j23b68u6tFqLY8eM5a5dOvbmprFxvnb6C/r8= ana@architect"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnk8dbvCu46a5+h3s4SlIH6uC6jq74fTNGW7WMTP013s9U+OPEGElqNYobWL6eyTdo9mEzaSV0pIVw778LBK0Wzt4h1dTHBJ9Y3Fp/4bP9wwvwCnYEVVgtGQwEYuwf3e3bDbOh9LD3VgQUdDBacNwPi6q3wuPLmhpWWRng2BdONhUjIrlI3ee7psSdfeCiHvT0MODEPsmld3PnTuyInh/lbYaXNmiiaBxSGfl7vPbM+BynzmiDaFKuhsqE+4ulJYD1FhX+ZvCE8yFupkz6Bdq7UEvvvme0NlH7FVe9Eo1WnXaI+eaadSc3S5mdBx/GJHoeDwlCk2x0gqvk1gEra+pmqzhmUHkT2h8yrpLW74tqm+vKEWbdEmT5ROFvoS9mVoNLFjmVRCm6vriepnJJ47shF9RIF/VhuSF6maq7x5cXuKeptOo+eduKA4iPTXsWSf/5+QhwMdtqSQar4FC1Mcwm//NC+BS/PToYY25az1YeCKJIfxAG+3+YYyezT8xuVpU= ana@gizmo"
    ];
  };
}
