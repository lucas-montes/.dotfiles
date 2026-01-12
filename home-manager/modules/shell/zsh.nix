{ pkgs, ... }:
let shellAliases = import ./alias.nix;
in {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = false;
    autocd = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;

    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "direnv" ];
    };

    inherit shellAliases;

    plugins = [{
      name = "you-should-use";
      src = pkgs.zsh-you-should-use;
      file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
    }];

    history.size = 10000;

    initContent = builtins.readFile ./initExtra.sh;
  };
}
