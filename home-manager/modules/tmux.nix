{
  pkgs,
  config,
  ...
}: let
  colors = import ../colorscheme.nix;
in {
  programs.tmux = {
    enable = true;
    baseIndex = 1;
    keyMode = "vi";
    escapeTime = 0;
    plugins = [
      pkgs.tmuxPlugins.better-mouse-mode
    ];

    extraConfig = ''
      unbind r
      bind r source-file ${config.xdg.configHome}/tmux/tmux.conf \; display-message "Config reloaded!"

      # Mouse works as expected
      set-option -g mouse on
      set -g set-clipboard on
      set-option -g status-position top

      bind-key h select-pane -L
      bind-key j select-pane -D
      bind-key k select-pane -U
      bind-key l select-pane -R

      # Plugin name: tmux-minimal-rounded

      # Top status bar
      set-option -g status-position top


      set-option -g default-terminal "screen-256color"
      set-option -ga terminal-overrides ",xterm-256color:Tc"


      base="#${colors.base00}"
      grey="#${colors.base02}"
      text="#${colors.base05}"
      blue="#${colors.base0D}"
      green="#${colors.base0A}"
      yellow="#${colors.base0A}"
      peach="#${colors.base09}"
      red="#${colors.base08}"
      mauve="#${colors.base0E}"

      # Status bar background and foreground
      set-option -g status-style "bg=$base,fg=$text"
      set-option -g status-left-length 40
      set-option -g status-right-length 100

      setw -g window-status-style "fg=$grey,bg=$base"

      # Left side
      set-option -g status-left "#[fg=$blue,bg=$base]#[bg=$blue,fg=$base] #[fg=$blue,bg=$grey]#[bg=$grey,fg=$text] #S #[fg=$grey,bg=$base]"

      # Window status format (inactive windows)
      setw -g window-status-format "#[fg=$red,bg=$base]#[bg=$red,fg=$base,bold]#I#[fg=$red,bg=$grey]#[bg=$grey,fg=$text] #W #[fg=$grey,bg=$base]"

      # Current window status format (active window)
      setw -g window-status-current-format "#[fg=$green,bg=$base]#[bg=$green,fg=$base,bold]#I#[fg=$green,bg=$grey]#[bg=$grey,fg=$text] #W #[fg=$grey,bg=$base]"

      # Right side
      set-option -g status-right "#[fg=$grey,bg=$base]#[bg=$grey,fg=$text] #{pane_current_command} #[fg=$peach,bg=$grey]#[bg=$peach,fg=$base,bold] #{pane_index} #[fg=$peach,bg=$base]"

      # Window status separator
      setw -g window-status-separator ""

      # Pane borders
      set-option -g pane-border-style "fg=$peach"
      set-option -g pane-active-border-style "fg=$blue"

      # Message styling
      set-option -g message-style "bg=$blue,fg=$base,bold"
      set-option -g message-command-style "bg=$mauve,fg=$text,bold"

      # Copy mode highlight
      set-option -g mode-style "bg=$yellow,fg=$text,bold"

      # Clock mode color
      setw -g clock-mode-colour "$blue"

      # Bell styling
      setw -g window-status-bell-style "bg=$red,fg=$text,bold"
    '';
  };
}
