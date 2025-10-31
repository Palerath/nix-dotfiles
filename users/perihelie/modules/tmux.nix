{
   programs.tmux = {
      enable = true;
      # Set prefix key to Ctrl-a instead of default Ctrl-b
      prefix = "C-a";

      # Enable mouse support
      mouse = true;

      # Start window numbering at 1
      baseIndex = 1;

      # Increase scrollback buffer
      historyLimit = 10000;

      # Enable 256 color support
      terminal = "screen-256color";

      # Custom key bindings
      extraConfig = ''
      
      # Terminal colors
      set -g default-terminal "tmux-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      
      # Renumber windows when one is closed
      set -g renumber-windows on

      # Reload config with prefix + r
      bind r source-file ~/.config/tmux/tmux.conf \; display "Config reloaded!"

      # Split panes with | and -
      bind | split-window -h -c "#{pane_current_path}"
      bind - split-window -v -c "#{pane_current_path}"

      # Switch panes with vim-like keys
      bind h select-pane -L
      bind j select-pane -D
      bind k select-pane -U
      bind l select-pane -R

      # Resize panes with Shift + vim keys
      bind -r H resize-pane -L 5
      bind -r J resize-pane -D 5
      bind -r K resize-pane -U 5
      bind -r L resize-pane -R 5

      # Status bar styling
      set -g status-bg black
      set -g status-fg white
      set -g status-left-length 50
      set -g status-right "%H:%M %d-%b-%y"

      # Highlight active window
      setw -g window-status-current-style fg=black,bg=green

      # Enable vi mode for copy
      setw -g mode-keys vi
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      '';
   };
}
