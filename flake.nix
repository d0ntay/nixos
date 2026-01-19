{
  description = "dante's Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs:
    let
      system = "x86_64-linux";
    in {
      nixosConfigurations = {
        # Desktop
        nixos-d = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; };
          modules = [ ./hosts/desktop/configuration.nix ];
        };

        # Laptop
        nixos-l = nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs; }; 
          modules = [ ./hosts/laptop/configuration.nix ];
        };
      };

      homeConfigurations = {
        "d0ntay@nixos-d" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./hosts/desktop/home.nix ];
        };
        "d0ntay@nixos-l" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./hosts/laptop/home.nix ];
        };
      };
    };
}
