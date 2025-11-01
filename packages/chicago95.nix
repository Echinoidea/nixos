{ pkgs, ... }:

let
  chicago95 = pkgs.stdenv.mkDerivation rec {
    pname = "chicago95";
    version = "3.0.1";

    src = pkgs.fetchFromGitHub {
      owner = "grassmunk";
      repo = "Chicago95";
      rev = "v${version}";
      sha256 = "sha256-EHcDIct2VeTsjbQWnKB2kwSFNb97dxuydAu+i/VquBA=";
    };

    nativeBuildInputs = with pkgs; [ glib ];

    installPhase = ''
      runHook preInstall

      mkdir -p $out/share/{themes,icons,fonts}

      cp -r Theme/Chicago95 $out/share/themes/
      cp -r Icons/Chicago95 $out/share/icons/
      find $out/share/icons -xtype l -delete

      [ -d "Cursors" ] && cp -r Cursors/* $out/share/icons/ || true
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
  home-manager.extraSpecialArgs = { inherit chicago95; };
  environment.systemPackages = [ chicago95 ];
}
