{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "keychron-battery";

  packages = with pkgs; [
    go
    gnumake
    coreutils
    git
    systemd
    udev
    bluez
    upower
    libnotify
  ];
}