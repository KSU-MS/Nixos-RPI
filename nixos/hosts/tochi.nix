{ pkgs, ... }:
{
  networking.hostName = "tochi";
  time.timeZone = "UTC";

  users.users.tochi = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];
    shell        = pkgs.bashInteractive;
  };

  # WSL integration (provided by nixos-wsl module in flake.nix)
  wsl = {
    enable = true;
    defaultUser = "tochi";
    wslConf.network.generateResolvConf = false;
  };
}
