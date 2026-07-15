{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
{
  programs.tmux = {
    enable = true;
    tmuxinator.enable = true;
    terminal = "tmux-256color";
    historyLimit = 100000;
    keyMode = "vi";
    extraConfig = ''
      # Plugins & status line
      set -g status-interval 5
      set -g status-right-length 60
      set -g status-right '#[bg=yellow] CPU: #{cpu_percentage} #[bg=magenta] RAM: #{ram_percentage} #[bg=cyan] Batt: #{battery_percentage} #[bg=green] %H:%M '
      run-shell ${pkgs.tmuxPlugins.cpu}/share/tmux-plugins/cpu/cpu.tmux
      run-shell ${pkgs.tmuxPlugins.battery}/share/tmux-plugins/battery/battery.tmux

      # Pane splits & new window should open to the same path as the current pane
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"
      bind c new-window -c "#{pane_current_path}"

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

  home.packages = with pkgs; [
    tmuxPlugins.cpu
    tmuxPlugins.battery
    acpi
    sysstat
    xclip
  ];
}
