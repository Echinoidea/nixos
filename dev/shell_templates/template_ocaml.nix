# ocaml env flake template
{
  description = "%ENV_NAME%";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-%NIX_VERSION%";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config = {
            permittedInsecurePackages = [
            ];
            allowUnfree = true;
            allowUnfreePredicate = pkg: true;
          };
        };

        ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_3;

        ocamlPkgs = with ocamlPackages; [
          ocaml
          dune_3
          findlib
          ocaml-lsp
          ocamlformat
          utop
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          name = "%ENV_NAME%";
          NIX_CONFIG = "experimental-features = nix-command flakes";
          shellHook = ''
            echo "  OCaml development environment"
            echo "  OCaml version: $(ocaml --version)"
            echo "  Dune version: $(dune --version)"
            echo ""
            echo "Available commands:"
            echo "   dune build"
            echo "   dune exec"
            echo "   dune test"
            echo "   utop"      
            echo "   ocamlformat"
          '';
          buildInputs =
            with pkgs;
            ocamlPkgs
            ++ [
              pkg-config
              glibc
              glibc.static
            ];
        };
      }
    );
}
