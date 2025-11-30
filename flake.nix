{
  description = "Gabriel's NixOS configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";

    aporetic-font = {
      url = "github:Echinoidea/Aporetic-Nerd-Font";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixpkgs-swhkd.url = "github:Echinoidea/nixpkgs/swhkd";

    stylix = {
      url = "github:nix-community/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # nixcord = {
    #   url = "github:kaylorben/nixcord";
    # };
  };

  outputs =
    {
      self,
      nixpkgs,
      aporetic-font,
      stylix,
      nur,
      # nixcord,
      # home-manager,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; }; # Pass inputs to modules
        modules = [
          stylix.nixosModules.stylix
          ./configuration.nix
          nur.modules.nixos.default
        ];
      };
    };
}
