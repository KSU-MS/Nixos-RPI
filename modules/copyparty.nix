{ config, lib, pkgs, ... }:
let cfg = config.services.copyparty; in
{
  options.services.copyparty = {
    enable = lib.mkEnableOption "CopyParty file server";
    port = lib.mkOption { type = lib.types.port; default = 3923; };
    dataDir = lib.mkOption { type = lib.types.path; default = "/srv/copyparty"; };
    user = lib.mkOption { type = lib.types.str; default = "admin"; };
    password = lib.mkOption { type = lib.types.str; default = "admin"; };
    extraArgs = lib.mkOption { type = lib.types.listOf lib.types.str; default = []; };
    image = lib.mkOption { type = lib.types.str; default = "ghcr.io/9001/copyparty:latest"; };
  };

  config = lib.mkIf cfg.enable {
    # Podman on WSL
    virtualisation.podman = {
      enable = true;
      extraPackages = with pkgs; [ slirp4netns fuse-overlayfs ];
      defaultNetwork.settings.dns_enabled = true;
    };

    # storage.conf must be in the [storage] table, not a top-level key
    virtualisation.containers.storage.settings = {
      storage = {
        driver = "vfs";
      };
    };

    # Prefer GHCR to avoid wrong registries
    environment.etc."containers/registries.conf".text = ''
      [registries.search]
      registries = ['ghcr.io']
    '';

    virtualisation.oci-containers = {
      backend = "podman";
      containers.copyparty = {
        image = cfg.image;
        ports = [ "${toString cfg.port}:${toString cfg.port}" ];
        volumes = [ "${cfg.dataDir}:/srv/share" ];   # no :z on WSL
        cmd = [
          "-v"
          "-a" (":${toString cfg.port}:${cfg.user}:${cfg.password}")
          "/srv/share"
        ] ++ cfg.extraArgs;
        autoStart = true;
      };
    };

    systemd.tmpfiles.rules = [ "d ${cfg.dataDir} 0775 root root - -" ];
    networking.firewall.allowedTCPPorts = [ cfg.port ];
  };
}
