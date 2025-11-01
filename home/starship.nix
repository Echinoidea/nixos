{
  programs.starship = {
    enable = true;
    settings = {
      add_newline = false;

      # A minimal left prompt
      format = "󱄅 $time $directory$character";

      # move the rest of the prompt to the right
      right_format = "$status$git_branch$git_status";

      character = {
        success_symbol = "[](cyan)";
        error_symbol = "[](red)";
        vicmd_symbol = "[󰰔](green)";
        vimcmd_replace_symbol = "[󰰠](red)";
        vimcmd_replace_one_symbol = "[󰰠](blue)";
        vimcmd_visual_symbol = "[󰰬](purple)";
      };

      time = {
        disabled = false;
        format = "[$time]($style)";
        time_format = "%H:%M";
        style = "blue";
      };

      git_branch = {
        format = "[$branch]($style) ";
        style = "bold pink";
      };

      git_status = {
        format = "$all_status$ahead_behind ";
        ahead = "[⬆](bold purple) ";
        behind = "[⬇](bold purple) ";
        staged = "[✚](green) ";
        deleted = "[✖](red) ";
        renamed = "[➜](purple) ";
        stashed = "[✭](cyan) ";
        untracked = "[◼](white) ";
        modified = "[✱](blue) ";
        conflicted = "[═](yellow) ";
        diverged = "⇕ ";
        up_to_date = "";
      };

      directory = {
        style = "yellow";
        truncation_length = 1;
        truncation_symbol = "";
        fish_style_pwd_dir_length = 1;
      };

      cmd_duration = {
        format = "[$duration]($style) ";
      };

      line_break = {
        disabled = true;
      };

      status = {
        disabled = true;
        symbol = "✘ ";
      };
    };
  };
}
