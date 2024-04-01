{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = { self , nixpkgs , ...  }@attrs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);
    in
    {
      formatter = forAllSystems (system:
        nixpkgs.legacyPackages.${system}.nixpkgs-fmt
      );

      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        import ./pkgs { inherit pkgs; }
      );

      nixosModules = import ./modules;

      nixosConfigurations = {
        bpir3 = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit self;
            armTrustedFirmwareMT7986 = self.packages.aarch64-linux.armTrustedFirmwareMT7986;
          };
          modules = [
            ./lib/sd-image-mt7986.nix
            ./lib/boot.nix
          ];
        };

	bpir3sdcard = nixpkgs.lib.nixosSystem {
          system = "aarch64-linux";
          specialArgs = {
            inherit self;
            armTrustedFirmwareMT7986 = self.packages.aarch64-linux.armTrustedFirmwareMT7986;
          };
          modules = [
            ./lib/sd-image-mt7986.nix
            ./lib/boot.nix
	    ./lib/sdcard-defaults.nix
          ];
	};
      };
    };
  }
