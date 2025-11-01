{
  config,
  pkgs,
  inputs,
  ...
}:

let
  swhkd = pkgs.rustPlatform.buildRustPackage {
    pname = "swhkd";
    version = "1.2.1";

    src = pkgs.fetchFromGitHub {
      owner = "waycrate";
      repo = "swhkd";
      rev = "1.2.1";
      sha256 = "sha256-VQW01j2RxhLUx59LAopZEdA7TyZBsJrF1Ym3LumvFqA=";
    };

    cargoHash = "sha256-RGO9kEttGecllzH0gBIW6FnoSHGcrDfLDf2omUqKxX4=";

    nativeBuildInputs = with pkgs; [
      pkg-config
      scdoc
    ];
    buildInputs = with pkgs; [ libevdev ];

    postInstall = ''
      if [ -d "docs" ]; then
        mkdir -p $out/share/man/man1 $out/share/man/man5
        find docs -name "*.1" -exec cp {} $out/share/man/man1/ \; 2>/dev/null || true
        find docs -name "*.5" -exec cp {} $out/share/man/man5/ \; 2>/dev/null || true
      fi
    '';

    meta = with pkgs.lib; {
      description = "A simple hotkey daemon for Wayland";
      homepage = "https://github.com/waycrate/swhkd";
      license = licenses.bsd2;
      platforms = platforms.linux;
    };
  };
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.gabriel = import ./home.nix;

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  users.users.gabriel = {
    isNormalUser = true;
    description = "Gabriel";
    extraGroups = [
      "networkmanager"
      "wheel"
      "input"
      "docker"
    ];
    packages = with pkgs; [ ];
    shell = pkgs.zsh;
  };

  users.defaultUserShell = pkgs.bash;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  services.displayManager.ly.enable = true;

  services.xserver = {
    enable = true;
    windowManager.bspwm.enable = true;
  };

  programs.niri.enable = true;
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    neovim
    foot
    kitty
    firefox
    git
    ((emacsPackagesFor emacs-pgtk).emacsWithPackages (epkgs: [
      epkgs.treesit-grammars.with-all-grammars
    ]))
    ripgrep
    cmake
    fastfetch
    dunst
    libnotify
    wl-clipboard
    brightnessctl
    fuzzel
    swww
    pywal
    waybar
    nsxiv
    zathura
    python3
    starship
    ffmpeg
    openssl
    rose-pine-cursor
    swhkd
    inotify-tools
    vips
    btop
    vesktop
    xdg-desktop-portal-gnome
    xwayland-satellite
    rmpc
    cava
    mpc
    mpv
    fd
    gnumake
    nixfmt-classic
    emacs-lsp-booster
    yt-dlp
    lm_sensors
    id3v2
    sshpass
  ];

  programs.direnv.enable = true;
  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  fonts.packages = with pkgs; [
    maple-mono.NF
    nerd-fonts.symbols-only
    inputs.aporetic-font.packages.${pkgs.system}.default # access via flake.nix inputs
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "/home/gabriel/Music";
    user = "gabriel";
    startWhenNeeded = true;
    network.listenAddress = "127.0.0.1";
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };

  systemd.services.mpd.environment = {
    XDG_RUNTIME_DIR = "/run/user/1000";
  };

  programs.foot.enableZshIntegration = true;

  services.emacs = {
    enable = false;
    package = pkgs.emacs-pgtk;
    defaultEditor = true;
  };

  environment.variables = {
    XCURSOR_THEME = "BreezeX-RosePineDawn-Linux";
    XCURSOR_SIZE = "22";
    TREE_SITTER_DIR = "${
      pkgs.tree-sitter.withPlugins (p: [
        p.tree-sitter-typescript
        p.tree-sitter-tsx
        p.tree-sitter-javascript
        p.tree-sitter-lua
      ])
    }/lib";
  };

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Touchpad Sensitivity Fix]
    MatchUdevType=touchpad
    AttrPalmPressureThreshold=300
    AttrPalmSizeThreshold=80
    AttrTouchSizeRange=80:120
  '';

  security.polkit.enable = true;
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (action.id == "org.freedesktop.policykit.exec" &&
          subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }
    });
  '';

  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 10d";
  };

  nix.optimise = {
    automatic = true;
    dates = [ "weekly" ];
  };

  boot.loader.systemd-boot.configurationLimit = 10;

  services.openssh.enable = true;
  services.fail2ban.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 3000 ];
  };

  system.stateVersion = "25.05";
}
