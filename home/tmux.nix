{
  config,
  pkgs,
  ...
}: let
  c = config.lib.stylix.colors.withHashtag;
in {
  stylix.targets.tmux.enable = true;

  programs.tmux = {
    enable = true;
    shell = "${pkgs.zsh}/bin/zsh";
    terminal = "screen-256color";
    baseIndex = 1;
    escapeTime = 0;
    historyLimit = 1000000;
    focusEvents = true;
    keyMode = "vi";
    mouse = true;
    customPaneNavigationAndResize = false;
    shortcut = "space";

    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      {
        plugin = resurrect;
        extraConfig = ''
          set -g @resurrect-capture-pane-contents 'on'
        '';
      }
      {
        plugin = continuum;
        extraConfig = ''
          set -g status-right ""
          # set -g @continuum-restore 'on'
        '';
      }
    ];

    extraConfig = ''
      # True colour
      set -ga terminal-overrides ",*256col*:Tc"

      # Needed for the terminal to report Ctrl+Shift as a distinct modifier,
      # which the C-S-hjkl resize binds below depend on.
      set -s extended-keys on

      # General
      set -g set-clipboard on
      set -g detach-on-destroy off
      set -g status-interval 3
      set -g allow-passthrough on
      set -g renumber-windows on

      set -g status-justify absolute-centre

      set -g status-style bg=default
      set -g status-left-length 99
      set -g status-right-length 99
      set -g status-left '#(cat #{socket_path}-\#{session_id}-vimbridge)'
      set -g status-right '#(cat #{socket_path}-\#{session_id}-vimbridge-R) #S '

      setw -g window-status-separator "  "
      setw -g window-status-format "#[fg=${c.base03},bg=default]#W"
      setw -g window-status-current-format "#[fg=${c.base0A},bg=default,bold]#W"
      setw -g window-status-last-style "fg=${c.base04},bg=default"

      set -g message-style "bg=default,fg=${c.base05}"
      set -g message-command-style "bg=default,fg=${c.base05}"
      set -g mode-style "bg=${c.base02},fg=${c.base05}"

      set -g pane-border-style "fg=${c.base01},bg=default"
      set -g pane-active-border-style "fg=${c.base0A},bg=default"

      unbind r
      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display "Config reloaded"

      unbind d
      bind D detach

      bind c new-window -c "#{pane_current_path}"

      # Splits open in the current pane's directory.
      # | and - are mnemonic for the resulting divider; \ and _ are the
      # unshifted/shifted aliases so either key works without thinking.
      unbind '"'
      unbind %
      bind | split-window -h -c "#{pane_current_path}"
      bind '\' split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"
      bind _ split-window -v -c "#{pane_current_path}"

      bind j select-window -t 1
      bind k select-window -t 2
      bind l select-window -t 3

      bind -n C-S-h resize-pane -L 5
      bind -n C-S-j resize-pane -D 5
      bind -n C-S-k resize-pane -U 5
      bind -n C-S-l resize-pane -R 5

      bind d run-shell "tmux has-session -t default 2>/dev/null && tmux switch-client -t default || (tmux new-session -ds default -c ~/ && tmux switch-client -t default)"

      bind u run-shell "tmux has-session -t uct 2>/dev/null && tmux switch-client -t uct || (tmux new-session -ds uct -c ~/UCT && tmux switch-client -t uct)"

      bind p run-shell "tmux has-session -t personal 2>/dev/null && tmux switch-client -t personal || (tmux new-session -ds personal -c ~/Personal && tmux switch-client -t personal)"

      # Copy mode
      bind-key -T copy-mode-vi 'v' send -X begin-selection
      bind-key -T copy-mode-vi 'y' send-keys -X copy-pipe-and-cancel "${pkgs.wl-clipboard}/bin/wl-copy"
      unbind -T copy-mode-vi MouseDragEnd1Pane
      bind P paste-buffer
    '';
  };
}
