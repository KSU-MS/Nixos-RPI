{ config, pkgs, lib, ... }:
{
  # Target platform
  nixpkgs.hostPlatform = "aarch64-linux";
  system.stateVersion = "24.05";
  networking.hostName = "rpi3";

  # Networking: Ethernet only
  networking = {
    wireless.enable = false;
    useDHCP = lib.mkDefault true;   # covers eth0
  };

  # Boot: sd-image (from flake) uses extlinux; keep FS minimal for faster builds
  boot.supportedFilesystems = lib.mkForce [ "vfat" "ext4" ];

  # Filesystems expected by sd-image
  fileSystems."/" = { device = "/dev/disk/by-label/NIXOS_SD"; fsType = "ext4"; };
  fileSystems."/boot" = { device = "/dev/disk/by-label/FIRMWARE"; fsType = "vfat"; };

  # User
  users.users.tochi = {
    isNormalUser = true;
    password = "nixos";   # change after first login
    extraGroups = [ "wheel" "networkmanager" ];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIC6q6gigycXyAhq3PJA6dmzPFx7BZ+Z70bAV1KwjThb2"
    ];
  };

  # Services
  services.openssh.enable = true;
  services.avahi = { enable = true; nssmdns4 = true; };

  environment.systemPackages = with pkgs; [ neovim git htop ];
}
