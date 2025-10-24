{ pkgs, lib, ... }:

let
  dataDir  = "/var/lib/copyparty";
  shareDir = "/srv/copyparty";
  pyz      = "${dataDir}/copyparty.pyz";
in {
  users.groups.copyparty = { };
  users.users.copyparty = {
    isSystemUser = true;
    group = "copyparty";
    description = "Copyparty service user";
  };

  systemd.tmpfiles.rules = [
    "d ${dataDir} 0750 copyparty copyparty - -"
    "d ${shareDir} 0755 copyparty copyparty - -"
  ];

  systemd.services.copyparty = {
    description = "Copyparty file server (.pyz)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];

    preStart = ''
      mkdir -p ${dataDir} ${shareDir}
      if [ ! -s ${pyz} ]; then
        ${pkgs.curl}/bin/curl -fL --retry 3 -o ${pyz} \
          https://github.com/9001/copyparty/releases/latest/download/copyparty.pyz
        chmod +x ${pyz}
      fi
      chown -R copyparty:copyparty ${dataDir} ${shareDir}
    '';

    serviceConfig = {
      User = "copyparty";
      Group = "copyparty";
      WorkingDirectory = shareDir;
      ExecStart = "${pkgs.python3}/bin/python3 ${pyz} -a 0.0.0.0:3923 -v ${shareDir}:share:rw";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };

  networking.firewall.allowedTCPPorts = [ 3923 ];
}
