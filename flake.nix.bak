{
  description = "NixOS host tochi (WSL)";

  inputs = {
    nixpkgs.url   = "github:NixOS/nixpkgs/nixos-24.11";
    nixos-wsl.url = "github:nix-community/NixOS-WSL";
  };

  outputs = { self, nixpkgs, nixos-wsl, ... }: {
    nixosConfigurations.tochi = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./nixos/hosts/tochi.nix     # your host file
        ./nixos/git.nix             # keep git installed system-wide
        ./nixos/copyparty.nix       # (placeholder OK)
        nixos-wsl.nixosModules.wsl  # <— THIS provides the `wsl.*` options
      ];
    };
  };
}
