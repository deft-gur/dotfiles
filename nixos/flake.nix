{
  description = "My first flake!";

  inputs = {
    nixpkgs.url = "nixpkgs/release-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, home-manager, nixos-hardware, ... }@attrs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "ziwen";
    in {
      nixosConfigurations = {
        nixos = lib.nixosSystem {
          inherit system;
          specialArgs = { inherit username; };
          modules = [
            ./configuration.nix
            #nixos-hardware.nixosModules.msi-gs60
          ];
        };
      };
      homeConfigurations = {
        ziwen = home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          modules = [ ./home.nix ];
        };
      };

    };
}
