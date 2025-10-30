{ config, pkgs, lib, ... }:

{
  # Open the CopyParty port
  networking.firewall.allowedTCPPorts = [ 3923 ];

  # Create a system user/group for safety
  users.groups.copyparty = {};
  users.users.copyparty = {
    isSystemUser = true;
    group = "copyparty";
    home = "/var/lib/copyparty";
    createHome = true;
  };

  # Make sure directories exist and are owned correctly
  systemd.tmpfiles.rules = [
    "d /srv/copyparty      0755 copyparty copyparty -"
    "d /var/lib/copyparty  0755 copyparty copyparty -"
  ];

  # Install CopyParty globally (for manual testing too)
  environment.systemPackages = [ pkgs.copyparty ];

  # Define and enable the service
  systemd.services.copyparty = {
    description = "CopyParty File Server";
    after = [ "network.target" "network-online.target" ];
    wants = [ "network-online.target" ];
    wantedBy = [ "multi-user.target" ];  # ← ensures automatic startup

    serviceConfig = {
      User = "copyparty";
      Group = "copyparty";
      WorkingDirectory = "/var/lib/copyparty";
      ExecStart = ''
        ${pkgs.copyparty}/bin/copyparty \
          -v \
          -i 0.0.0.0 \
          -p 3923 \
          /srv/copyparty
      '';
      Restart = "on-failure";
      RestartSec = 2;

      NoNewPrivileges = true;
      ProtectSystem = "full";
      ProtectHome = true;
      PrivateTmp = true;
      LimitNOFILE = 65536;
    };
  };
}
