{ pkgs, config, ... }:
{
  services.polybar = {

    enable = true;

    script = ''
            # Kill any existing polybar instances
              pkill polybar
              
              # Wait for them to terminate
              while pgrep -x polybar >/dev/null; do sleep 0.1; done
              
              xrdb -merge ~/.Xresources

      # Always launch on eDP-1
        MONITOR=eDP-1 polybar -c ~/.config/polybar/config.ini top &
        MONITOR=DP-1 polybar -c ~/.config/polybar/config.ini top &

        # for m in $(polybar --list-monitors | cut -d":" -f1); do
        #     MONITOR=$m polybar -c ~/.config/polybar/config.ini top &
        # done
    '';

    config = {
      "colors" = {
        background = "\${xrdb:color0}"; # Base00 - Default Background
        foreground = "\${xrdb:color7}"; # Base05 - Default Foreground

        # 8 base ANSI colors
        black = "\${xrdb:color0}"; # Base00 - Black
        red = "\${xrdb:color1}"; # Base08 - Red
        green = "\${xrdb:color2}"; # Base0B - Green
        yellow = "\${xrdb:color3}"; # Base0A - Yellow
        blue = "\${xrdb:color4}"; # Base0D - Blue
        magenta = "\${xrdb:color5}"; # Base0E - Magenta
        cyan = "\${xrdb:color6}"; # Base0C - Cyan
        white = "\${xrdb:color7}"; # Base05 - White

        # Bright variants (colors 8-15)
        bright-black = "\${xrdb:color8}"; # Base03 - Bright Black (gray)
        bright-red = "\${xrdb:color9}"; # Base08 - Bright Red
        bright-green = "\${xrdb:color10}"; # Base0B - Bright Green
        bright-yellow = "\${xrdb:color11}"; # Base0A - Bright Yellow
        bright-blue = "\${xrdb:color12}"; # Base0D - Bright Blue
        bright-magenta = "\${xrdb:color13}"; # Base0E - Bright Magenta
        bright-cyan = "\${xrdb:color14}"; # Base0C - Bright Cyan
        bright-white = "\${xrdb:color15}"; # Base07 - Bright White

        # Useful aliases for UI elements
        background-alt = "\${xrdb:color8}";
        foreground-alt = "\${xrdb:color15}";
        primary = "\${xrdb:color4}"; # Blue
        secondary = "\${xrdb:color5}"; # Magenta
        alert = "\${xrdb:color1}"; # Red
      };

      "bar/top" = {
        monitor = "\${env:MONITOR}";
        width = "100%";
        height = "24px";
        radius = 0;

 font-0 = "${config.stylix.fonts.monospace.name}:size=${toString config.stylix.fonts.sizes.applications}";
        font-1 = "${config.stylix.fonts.emoji.name}:size=${toString config.stylix.fonts.sizes.applications}";
        
        # Add underline support
        line-size = 2;

        # Add padding around modules
        padding-left = 1;
        padding-right = 1;
        module-margin = 1;

        # Must explicitly reference the colors
        background = "\${colors.background}";
        foreground = "\${colors.foreground}";

        modules-left = "bspwm";
        modules-center = "date";
        modules-right = "battery";
      };

      "module/date" = {
        type = "internal/date";
        interval = 5;
        date = "%a %m/%d/%Y";
        time = "%I:%M";
        label = "%time% %date%";
      };

      "module/bspwm" = {
        type = "internal/bspwm";

        pin-workspaces = true;
        enable-click = true;
        enable-scroll = false;

        format = "<label-state>";

        # Focused - green background with rounded appearance
        label-focused = "%index%";
        label-focused-background = "\${colors.blue}";
        label-focused-foreground = "\${colors.background}";
        label-focused-padding = 2;

        # Occupied - underline with rounded background
        label-occupied = "%index%";
        label-occupied-background = "\${colors.background-alt}";
        label-occupied-foreground = "\${colors.foreground}";
        label-occupied-underline = "\${colors.blue}";
        label-occupied-padding = 2;

        # Empty - subtle appearance
        label-empty = "%index%";
        label-empty-background = "\${colors.background}";
        label-empty-foreground = "\${colors.foreground}";
        label-empty-padding = 2;

        # Urgent
        label-urgent = "%index%";
        label-urgent-background = "\${colors.red}";
        label-urgent-foreground = "\${colors.background}";
        label-urgent-padding = 2;
      };

      "module/battery" = {
        type = "internal/battery";

        full-at = 99;

        low-at = 10;

        battery = "BAT1";
        adapter = "ADP1";

        poll-interval = 5;

        time-format = "%I:%M";

        format-charging = "<animation-charging> <label-charging>";

        format-discharging = "<ramp-capacity> <label-discharging>";

        label-charging = "󰁝 %percentage%%";

        label-discharging = "󰁅 %percentage%%";

        label-full = "Fully charged";

        label-low = "BATTERY LOW";

        ramp-capacity-0 = "󰁺";
        ramp-capacity-1 = "󰁽";
        ramp-capacity-2 = "󰁿";
        ramp-capacity-3 = "󰂀";
        ramp-capacity-4 = "󰁹";

        bar-capacity-width = 10;

        animation-charging-0 = "󰁺";
        animation-charging-1 = "󰁽";
        animation-charging-2 = "󰁿";
        animation-charging-3 = "󰂀";
        animation-charging-4 = "󰁹";
        animation-charging-framerate = 750;

        animation-discharging-4 = "󰁺";
        animation-discharging-3 = "󰁽";
        animation-discharging-2 = "󰁿";
        animation-discharging-1 = "󰂀";
        animation-discharging-0 = "󰁹";
        animation-discharging-framerate = 500;

        animation-low-0 = "󰂃";
        animation-low-1 = "󰁺";
        animation-low-framerate = 200;
      };

    };

  };

  systemd.user.services.polybar = {
    Unit.After = [ "graphical-session.target" ];
    Unit.PartOf = [ "graphical-session-target" ];
    Install.WantedBy = [ "graphical-session.target" ];
  };

  systemd.user.services.polybar.Service.ExecReload = "${pkgs.coreutils}/bin/cut";
}
