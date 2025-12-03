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
      in
      {
        devShells.default = pkgs.mkShell {
          name = "%ENV_NAME%";
          NIX_CONFIG = "experimental-features = nix-command flakes";
          shellHook = ''
            echo " 󰎙 Node development environment"
            echo " 󰎙 Node version: $(node --version)"
            echo " 󰎙 NPM version: $(npm --version)"
          '';
          buildInputs = with pkgs;
            [
                          # Node.js (needed for TypeScript)
            nodejs_22

            # TypeScript
            nodePackages.typescript
            nodePackages.typescript-language-server

            emmet-ls

            html-tidy
            nodePackages.stylelint
            nodePackages.js-beautify
            nodePackages.prettier

            tree-sitter-grammars.tree-sitter-typescript
            tree-sitter-grammars.tree-sitter-tsx

            ];
        };
      }
    );
}
