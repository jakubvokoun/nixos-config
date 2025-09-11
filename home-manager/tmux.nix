{ inputs, lib, config, pkgs, ... }: {
  programs.tmux = {
    enable = true;
    tmuxinator.enable = true;
    terminal = "tmux-256color";
    historyLimit = 100000;
    keyMode = "vi";
    extraConfig = ''
      # Pane splits & new window should open to the same path as the current pane
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

      # Catppuccin Mocha tmux status line (lighter gray)
      set -g status-bg '#45475a'
      set -g status-fg '#cdd6f4'
      set -g status-left-length 20
      set -g status-right-length 60

      # Left side - session name
      set -g status-left '#[bg=#89b4fa,fg=#1e1e2e,bold] #S #[bg=#45475a] '

      # Window status
      set -g window-status-format '#[fg=#a6adc8] #I:#W '
      set -g window-status-current-format '#[bg=#89b4fa,fg=#1e1e2e,bold] #I:#W #[bg=#45475a] '

      # Right side - date and time
      set -g status-right '#[fg=#a6adc8]%Y-%m-%d #[fg=#cdd6f4,bold]%H:%M'

      # Pane borders
      set -g pane-border-style 'fg=#6c7086'
      set -g pane-active-border-style 'fg=#89b4fa'

      # Copy & paste
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "xclip -i -sel clipboard"
      bind-key -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "xclip -i -sel clipboard"

      # Popups
      bind C-n display-popup -E 'bash -i -c "read -p \"Session name: \" name; tmux new-session -d -s \$name && tmux switch-client -t \$name"'
      bind C-s display-popup -E "tmux list-sessions | sed -E 's/:.*$//' | grep -v \"^$(tmux display-message -p '#S')\$\" | fzf --reverse | xargs tmux switch-client -t"
      bind C-g display-popup \
        -d "#{pane_current_path}" \
        -w 80% \
        -h 80% \
        -E "lazygit"
      bind C-f display-popup \
        -d "#{pane_current_path}" \
        -w 80% \
        -h 80% \
        -E "yazi"
    '';
  };

  home.packages = with pkgs; [ xclip ];
}
