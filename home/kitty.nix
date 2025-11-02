{ config, pkgs, ... }:

{
  programs.kitty = {
    enable = true;
    font.name = "Maple Mono NF";
    font.size = 10;
    shellIntegration.enableZshIntegration = true;
    settings = {
      # Remove confirm close message
      confirm_os_window_close = 0;

      # Other useful settings
      enable_audio_bell = false;
      window_padding_width = 4;
    };

    keybindings = {
      # Tab management
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+q" = "close_tab";
      "alt+shift+l" = "next_tab";
      "alt+shift+h" = "previous_tab";
      "ctrl+shift+." = "move_tab_forward";
      "ctrl+shift+comma" = "move_tab_backward";

      # Window/split management
      "ctrl+shift+enter" = "new_window";
      "ctrl+shift+w" = "close_window";
      "ctrl+shift+]" = "next_window";
      "ctrl+shift+[" = "previous_window";

      # Split windows
      "ctrl+shift+minus" = "launch --location=hsplit --cwd=current";
      "ctrl+shift+backslash" = "launch --location=vsplit --cwd=current";

      # Navigate splits
      "ctrl+shift+k" = "neighboring_window up";
      "ctrl+shift+j" = "neighboring_window down";
      "ctrl+shift+h" = "neighboring_window left";
      "ctrl+shift+l" = "neighboring_window right";

      # Resize windows
      "ctrl+shift+r" = "start_resizing_window";

      "ctrl+shift+space" =
        "pipe @screen_scrollback overlay nvim - -c 'set filetype=scrollback' -c 'source ~/.config/vim/ftplugin/scrollback.vim'";
    };
  };

  home.file.".config/vim/ftplugin/scrollback.vim".text = ''
    set clipboard^=unnamedplus
    set signcolumn=no
    set nolist
    set laststatus=0
    set scrolloff=0
    set nowrapscan
    set relativenumber
    xnoremap <buffer> <cr> "+y
    nnoremap <buffer> q <cmd>q!<cr>
    nnoremap <buffer> i <cmd>q!<cr>
    nnoremap <buffer> I <cmd>q!<cr>
    nnoremap <buffer> A <cmd>q!<cr>
    nnoremap <buffer> H H
    nnoremap <buffer> L L
    if exists(':HideBadWhiteSpace')
        HideBadWhiteSpace
    endif
    call cursor(line('$'), 0)
    silent! call search('\S', 'b')
    silent! call search('\n*\%$')
    execute "normal! \<c-y>"
  '';
}
