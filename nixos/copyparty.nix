{ lib, ... }:
{
  systemd.services.copyparty = {
    description = "CopyParty File Server (native)";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "simple";
      User = "copyparty";
      Group = "copyparty";
      WorkingDirectory = "/var/lib/copyparty";
      # FORCE the exact command so earlier defs don’t conflict
      ExecStart = lib.mkForce ''
        ${lib.getExe pkgs.python3} \
          /var/lib/copyparty/copyparty.pyz \
          -v 2 \
          -i 0.0.0.0 \
          -p 3923 \
          -a '::/srv/copyparty:rw'
      '';
      Restart = "on-failure";
      RestartSec = "2s";
      NoNewPrivileges = true;
      LimitNOFILE = 65536;
    };
  };
}
