{ pkgs, ... }:

let
  chicago95 = pkgs.stdenv.mkDerivation rec {
    pname = "chicago95";
    version = "3.0.1";

    src = pkgs.fetchFromGitHub {
      owner = "grassmunk";
      repo = "Chicago95";
      rev = "v${version}";
      sha256 = "sha256-OgcsE/LunNe37VaW40++5/KqLpRoYf+qGxr+k1QjAw=";
    };

    nativeBuildInputs = with pkgs; [ glib ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/{themes,icons,fonts}

      # Install themes
      cp -r Theme/Chicago95 $out/share/themes/

      # Install icons and remove broken symlinks
      cp -r Icons/Chicago95 $out/share/icons/
      find $out/share/icons -xtype l -delete

      # Install cursors
      [ -d "Cursors" ] && cp -r Cursors/* $out/share/icons/ || true

      # Install fonts
      [ -d "Fonts/vga_font" ] && cp -r Fonts/vga_font $out/share/fonts/ || true

      runHook postInstall
    '';

    dontBuild = true;

    meta = with pkgs.lib; {
      description = "Windows 95 GTK Theme";
      homepage = "https://github.com/grassmunk/Chicago95";
      license = licenses.gpl3;
      platforms = platforms.linux;
    };
  };
in
{
  # Make chicago95 available to home-manager
  home-manager.extraSpecialArgs = { inherit chicago95; };

  # Optionally install system-wide
  environment.systemPackages = [ chicago95 ];
}
