{
  self,
  inputs,
  ...
}: {
  flake.homeModules.shell = {
    pkgs,
    config,
    lib,
    ...
  }: {
    xdg.configFile."fastfetch/logos/cirno.png".source = ./images/cirno.png;

    programs.fastfetch = {
      enable = true;
      settings = {
        logo = {
          # source = "/home/perihelie/.config/fastfetch/logos/cirno.png";
          source = "${config.home.homeDirectory}/.config/fastfetch/logos/cirno.png";
          type = "kitty-direct";
          height = 20;
          width = 40;

          padding = {right = 2;};
        };

        modules = [
          "title"
          "separator"
          "shell"
          "uptime"
          "packages"
          "kernel"
          "os"
          "cpu"
          "gpu"
          "display"
          "memory"
          "swap"
          "disk"
        ];
      };
    };

    programs.tmux = {
      # ======================================================== #
      # config from: https://www.youtube.com/watch?v=XivdyrFCV4M #
      # ======================================================== #
      enable = true;

      prefix = "C-a";

      mouse = true;

      baseIndex = 1;

      historyLimit = 10000;

      terminal = "tmux-256color";

      extraConfig = ''
        set -ga terminal-overrides ",*:RGB"
        set -g set-clipboard on
        set-option -g renumber-windows on

        # Split windows
        unbind %
        unbind '"'
        bind | split-window -h -c "#{pane_current_path}"
        bind - split-window -v -c "#{pane_current_path}"
        bind v split-window -h -c "#{pane_current_path}"
        bind c split-window -v -c "#{pane_current_path}"

        # Vim pane navigation
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        # Move without C-a (alt + hjkl)
        bind -n M-h select-pane -L
        bind -n M-j select-pane -D
        bind -n M-k select-pane -U
        bind -n M-l select-pane -R

        # Shift + arrows to shift windows
        bind -n S-Left previous-window
        bind -n S-Right next-window

        # Alt + numbers to select windows
        bind -n M-1 select-window -t 1
        bind -n M-2 select-window -t 2
        bind -n M-3 select-window -t 3
        bind -n M-4 select-window -t 4
        bind -n M-5 select-window -t 5
        bind -n M-6 select-window -t 6
        bind -n M-7 select-window -t 7
        bind -n M-8 select-window -t 8
        bind -n M-9 select-window -t 9

        # Vim style copying
        set-window-option -g mode-keys vi
        bind-key -T copy-mode-vi v send -X begin-selection
        bind-key -T copy-mode-vi C-v send -X rectangle-toggle
        bind-key -T copy-mode-vi y send -X copy-selection-and-cancel
        unbind -T copy-mode-vi MouseDragEnd1Pane
      '';
    };
  };
}
