{ config, pkgs, ... }:

{
  stylix.targets.firefox = {
    enable = true;
    profileNames = [
      "default"
    ];
    colorTheme = {
      enable = true;
    };
  };

  programs.firefox = {
    enable = true;

    policies = {
      Fingerprinting = true;
    };
    
    profiles = {
      default = {
        id = 0;
        name = "default";
        isDefault = true;
        settings = {
          "browser.startup.homepage" = "";
          "browser.search.defaultenginename" = "duckduckgo";
        };
        search = {
          force = true;
          default = "";
          order = [
            "duckduckgo"
          ];
          engines = {
            "Nix Packages" = {
              urls = [
                {
                  template = "https://search.nixos.org/packages";
                  params = [
                    {
                      name = "type";
                      value = "packages";
                    }
                    {
                      name = "query";
                      value = "{searchTerms}";
                    }
                  ];
                }
              ];
              icon = "''${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
              definedAliases = [ "@np" ];
            };
            "NixOS Wiki" = {
              urls = [ { template = "https://nixos.wiki/index.php?search={searchTerms}"; } ];
              icon = "https://nixos.wiki/favicon.png";
              updateInterval = 24 * 60 * 60 * 1000; # every day
              definedAliases = [ "@nw" ];
            };
          };
        };
        extensions = {
          force = true;

          packages = with pkgs.nur.repos.rycee.firefox-addons; [
            ublock-origin
            better-canvas
            bitwarden
            vimium
            youtube-shorts-block
            shinigami-eyes
            return-youtube-dislikes
            darkreader
            # org-capture
          ];
        };
      };
    };
  };
}
