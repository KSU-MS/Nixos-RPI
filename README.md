# NixOS-based image
Host: tochi

Rebuild:
  sudo nixos-rebuild switch --impure --flake .#tochi
