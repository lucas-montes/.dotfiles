{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    profiles.default = {
      enableUpdateCheck = false;
      enableExtensionUpdateCheck = false;
      extensions = with pkgs.vscode-extensions;
        [
          jnoortheen.nix-ide
          donjayamanne.githistory
          github.copilot
          github.copilot-chat
          gruntfuggly.todo-tree
          mkhl.direnv
          ms-azuretools.vscode-docker
          ms-python.debugpy
          ms-python.vscode-pylance
          rust-lang.rust-analyzer
          ms-python.python
          bbenoist.nix
          tamasfe.even-better-toml
          # platformio.platformio-ide
          ms-vscode.cpptools
        ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
          name = "cucumberautocomplete";
          publisher = "alexkrechik";
          version = "3.0.5";
          sha256 = "sha256-Tgqd4uoVgGJQKlj4JUM1CrjQhbi0qv9bAGz5NIHyofQ=";
        }];
      userSettings = {
        # Whitespace
        "files.trimTrailingWhitespace" = true;
        "files.trimFinalNewlines" = true;
        "files.insertFinalNewline" = true;
        "diffEditor.ignoreTrimWhitespace" = false;
        # Git
        "git.confirmSync" = false;
        #      "git.enableCommitSigning" = true;
        "git-graph.repository.sign.commits" = true;
        "git-graph.repository.sign.tags" = true;
        "git-graph.repository.commits.showSignatureStatus" = true;
        "files.exclude"."**/.git" = false;

        "chat.editor.fontFamily" = "JetBrains Mono";
        "chat.editor.fontSize" = 16.0;
        "debug.console.fontFamily" = "JetBrains Mono";
        "debug.console.fontSize" = 16.0;

        "editor.fontFamily" = "JetBrains Mono";
        "editor.fontSize" = 16.0;
        "editor.inlayHints.fontFamily" = "JetBrains Mono";
        "editor.inlineSuggest.fontFamily" = "JetBrains Mono";
        "editor.minimap.enabled" = false;
        "editor.minimap.sectionHeaderFontSize" = 10.285714285714286;
        "editor.stickyScroll.enabled" = false;
        "extensions.autoCheckUpdates" = false;

        "diffEditor.diffAlgorithm" = "advanced";
        "diffEditor.experimental.showMoves" = true;

        "markdown.preview.fontFamily" = "DejaVu Sans";
        "markdown.preview.fontSize" = 16.0;
        "scm.inputFontFamily" = "JetBrains Mono";
        "scm.inputFontSize" = 14.857142857142858;
        "screencastMode.fontSize" = 64.0;
        "telemetry.telemetryLevel" = "off";
        "terminal.integrated.fontSize" = 16.0;
        "update.mode" = "none";
        "update.showReleaseNotes" = false;
      };
    };
  };
}
