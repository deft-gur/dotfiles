{
  description = "Nixos flake file.";
  inputs = {
    nixpkgs.url = "nixpkgs/release-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };
  outputs = { self, nixpkgs, home-manager, nixos-hardware, nix-doom-emacs, ... }@attrs:
    let
      lib = nixpkgs.lib;
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      username = "ziwen";
    in {
      nixosConfigurations = {
        nixos-server = lib.nixosSystem {
          #inherit system;
          specialArgs = { 
            inherit username;
            inherit system;
            inherit nix-doom-emacs;
          };
          modules = [
            ./configuration.nix
            # Wait for asus ga403
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
