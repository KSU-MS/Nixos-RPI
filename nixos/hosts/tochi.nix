{ config, lib, pkgs, ... }:
let
  python = pkgs.python3;
in
{
  imports = [ ];

  networking.hostName = "tochi";
  time.timeZone = "UTC";

  users.users.tochi = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.bashInteractive;
  };

  # WSL integration
  wsl = {
    enable = true;
    defaultUser = "tochi";
    wslConf.network.generateResolvConf = false; # we set nameservers below
  };

  # Permanent DNS fix (your “option 1” choice)
  networking.nameservers = [ "1.1.1.1" "8.8.8.8" ];

  # Write /etc/wsl.conf inside the instance as well
  environment.etc."wsl.conf".text = ''
[boot]
systemd=true
[network]
generateResolvConf=false
hostname=tochi
  '';

  # CopyParty runtime user + dirs
  users.groups.copyparty = {};
  users.users.copyparty = {
    isSystemUser = true;
    group = "copyparty";
    home = "/var/lib/copyparty";
    createHome = true;
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/copyparty 0755 copyparty copyparty -"
    "d /srv/copyparty     0755 copyparty copyparty -"
  ];

  # CopyParty service (native, no container)
  systemd.services.copyparty = lib.mkForce {
    description = "CopyParty File Server (native)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      User = "copyparty";
      Group = "copyparty";
      WorkingDirectory = "/var/lib/copyparty";
      ExecStart = ''
        ${pkgs.python3}/bin/python3 \
          /var/lib/copyparty/copyparty.pyz \
          -i 0.0.0.0 \
          -p 3923 \
          -r /srv/copyparty
      '';
      Restart = "always";
      RestartSec = 2;
      NoNewPrivileges = true;
      LimitNOFILE = 65536;
    };
  };

  # Open the port
  networking.firewall.allowedTCPPorts = [ 3923 ];

  system.stateVersion = "24.11";
}
