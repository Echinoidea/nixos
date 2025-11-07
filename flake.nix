{
  description = "Gabriel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    aporetic-font = {
      url = "github:Echinoidea/Aporetic-Nerd-Font";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs-swhkd.url = "github:Echinoidea/nixpkgs/swhkd";
  };

  outputs =
    {
      self,
      nixpkgs,
      aporetic-font,
      nixpkgs-swhkd,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass inputs to modules
        modules = [
          ./configuration.nix
          (
            { pkgs, ... }:
            {
              nixpkgs.overlays = [
                (final: prev: {
                  swhkd = nixpkgs-swhkd.legacyPackages.${prev.system}.swhkd;
                })
              ];
            }
          )
        ];
      };

    };
}
