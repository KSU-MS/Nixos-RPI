{ pkgs, ... }:
{
  wsl.enable = true;
  wsl.defaultUser = "tochi";

  users.users.tochi = {
    isNormalUser = true;
    extraGroups  = [ "wheel" ];
    shell        = pkgs.bashInteractive;
    home         = "/home/tochi";
  };

  environment.systemPackages = [ pkgs.git pkgs.python3 pkgs.bash pkgs.coreutils ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
