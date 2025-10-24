# KSU NixOS flake
Host: tochi

Rebuild:
  sudo nixos-rebuild switch --impure --flake .#tochi
