{
  description = "AMD Gaming-Desktop – Plasma 6 (lightweight), GRUB Dual-Boot, Home Manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";

      # ─────────────────────────────────────────────────────────────
      # HIER ANPASSEN
      hostname = "nixos-desktop";
      username = "user";
      # ─────────────────────────────────────────────────────────────

      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
        inherit system;
        specialArgs = { inherit inputs username hostname; };

        modules = [
          ./hosts/desktop/configuration.nix

          home-manager.nixosModules.home-manager
          {
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "hm-backup";
              extraSpecialArgs = { inherit inputs username; };
              users.${username} = import ./home/home.nix;
            };
          }
        ];
      };

      # nix fmt
      formatter.${system} = pkgs.nixfmt-rfc-style;

      # nix develop  →  Tooling zum Basteln an der Config
      devShells.${system}.default = pkgs.mkShell {
        packages = with pkgs; [
          nixfmt-rfc-style
          nixd
          nix-output-monitor
          nvd
        ];
      };
    };
}
