{
  config,
  pkgs,
  inputs,
  ...
}:

let
  emacsPgtk = (
    (pkgs.emacsPackagesFor pkgs.emacs-pgtk).emacsWithPackages (epkgs: [
      epkgs.treesit-grammars.with-all-grammars
      epkgs.vterm
    ])
  );
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.home-manager.nixosModules.default
    # ./packages/chicago95.nix
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

  hardware.graphics = {
    enable = true;
    enable32Bit = true; # Required for most Steam games
    extraPackages = with pkgs; [
      intel-media-driver # For newer Intel GPUs (Broadwell+)
      intel-vaapi-driver # Fallback for older hardware
    ];
  };

  users.defaultUserShell = pkgs.bash;

  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nix.settings.trusted-users = [
    "root"
    "gabriel"
  ];

  # services.displayManager.lemurs.enable = true;
  services.displayManager.ly.enable = true;

  services.xserver = {
    enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras = true;

      extraPackages = hpkgs: [
        hpkgs.xmobar
      ];
    };
    xkb = {
      layout = "us";
      variant = "";
    };
  };

  programs.niri.enable = true;
  programs.zsh.enable = true;
  programs.adb.enable = true;

  environment.systemPackages = with pkgs; [
    # Utils
    git
    cmake
    libnotify
    vips # I dont remember why I need this...
    kitty # Im using kitty because it works better with wallust
    alacritty # Make sure to add cat wal sequences to zsh if using alacritty
    foot
    neovim
    inotify-tools
    gnumake
    sshpass
    jq # Required for my eww config, also good to just have
    tiramisu # Dbus notifications - required for eww notifications
    fzf
    gnupg
    pinentry-curses
    # Graphical Programs
    firefox
    nsxiv
    zathura
    mpv
    vesktop
    eww
    qutebrowser
    yad
    ## Wayland-specific Graphical Programs
    fuzzel
    swww
    waybar
    # CLI Programs
    fastfetch
    wl-clipboard
    brightnessctl
    pywal
    starship
    ffmpeg
    openssl
    swhkd
    btop
    rmpc
    cava
    mpc
    lm_sensors
    id3v2
    yt-dlp
    vim
    wallust
    lynx
    zoxide
    # Emacs and Emacs dependencies
    emacsPgtk
    ripgrep
    fd
    emacs-lsp-booster
    # X11 Stuff
    picom
    xdotool
    xclip
    xmobar
    feh
    # Language dependencies
    python3 # Unfortunately...
    # GTK
    rose-pine-cursor
    # Other Wayland Stuff
    xdg-desktop-portal-gnome
    xdg-desktop-portal-wlr
    xwayland-satellite
    # steamcmd
    # steam-tui
  ];

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true;
  #   dedicatedServer.openFirewall = true;
  #   gamescopeSession.enable = true;
  # };

  services.pcscd.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.direnv.enable = true;
  programs.nix-ld.enable = true;

  virtualisation.docker.enable = true;

  fonts.packages = with pkgs; [
    maple-mono.NF
    nerd-fonts.fantasque-sans-mono
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

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-wlr
    ];
    config = {
      common = {
        default = [
          "wlr"
          "gtk"
          "gnome"
        ];
      };
      niri = {
        default = [
          "wlr"
          "gtk"
          "gnome"
        ];
        "org.freedesktop.impl.portal.ScreenCast" = "wlr";
        "org.freedesktop.impl.portal.Screenshot" = "wlr";
      };
    };
  };

  programs.foot.enableZshIntegration = true;

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
