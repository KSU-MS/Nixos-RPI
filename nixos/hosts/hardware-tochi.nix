{ config, lib, pkgs, modulesPath, ... }:
{
  imports = [ ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.loader.grub.enable = false;
  boot.isContainer = true;

  fileSystems."/" = {
    device = "none";
    fsType = "wslfs";
  };

  fileSystems."/mnt/wsl" = { device = "none"; };

  swapDevices = [ ];
}
