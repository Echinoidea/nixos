# c with xlib env flake template
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

        # Add Xlib includes for clangd
        x11Includes = pkgs.lib.makeSearchPath "include" (
          with pkgs.xorg;
          [
            libX11.dev
            libXext.dev
            libXrender.dev
          ]
        );

        # Define library paths
        x11Libs = pkgs.lib.makeSearchPath "lib" (
          with pkgs.xorg;
          [
            libX11
            libXext
            libXrender
          ]
        );

      in
      {
        devShells.default = pkgs.mkShell {
          name = "%ENV_NAME%";
          NIX_CONFIG = "experimental-features = nix-command flakes";
          shellHook = ''
            export CPATH="${x11Includes}"
            export LIBRARY_PATH="${x11Libs}"

            if [ ! -f .gitignore ]; then
               cat > .gitignore << 'EOF'
              .envrc
              .direnv/
              EOF
            elif ! grep -q "^\.envrc$" .gitignore; then
                echo ".envrc" >> .gitignore
                echo ".direnv/" >> .gitignore
                echo "build/" >> .gitignore
            fi
          '';
          nativeBuildInputs = with pkgs; [
            cmake
            clang-tools
            bear
            ccls
            gdb
          ];
          buildInputs = with pkgs; [
            gcc
            lld
            libcxx
            libgcc
            xorg.libX11
            xorg.libXext
            xorg.libXrender
            gnumake
            lldb
          ];
        };
      }
    );
}
