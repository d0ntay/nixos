{
  description = "dante's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      nixosConfigurations = {
        # desktop
        nixos-d = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/desktop/configuration.nix ];
        };

        # laptop
        nixos-l = nixpkgs.lib.nixosSystem {
          inherit system;
          modules = [ ./hosts/laptop/configuration.nix ];
        };
      };

      homeConfigurations = {
	# desktop
        "d0ntay@nixos-d" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/desktop/home.nix ];
        };

	# laptop
        "d0ntay@nixos-l" = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./hosts/laptop/home.nix ];
        };
      };
    };
}
