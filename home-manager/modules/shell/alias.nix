let
  dotfiles = "~/.dotfiles";
in {
  se = "sudoedit";
  docclean = "docker system prune -a --volumes --force";
  cprsync = "rsync -chavzP --stats --progress";
  con-ap = "bluetoothctl connect F8:4D:89:37:41:A0";
  ro = "sudo nixos-rebuild switch --flake";
  #es = "do {cd ${dotfiles} ; vim .}";
  sushell = "sudo -E nix-shell -p gparted --run gparted"; # TODO: replace the gparted with other app
  rs = "home-manager switch --flake ${dotfiles}";
  rt = "tmux source ~/.config/tmux/tmux.conf";
  tx = "_new_named_session";
  notes = "_new_named_session ~/Notes/";
  venv = "nix-shell --command zsh";
  gpj = "_fzf_tmux ~/Projects";
  dw-venv = "venv -p yt-dlp";
  dwm = "yt-dlp -x --audio-format mp3 -o '~/Downloads/music/%(title)s.%(ext)s'";
  lz = "lazygit";
}
