{ lib, ... }:
let
  createAllComponent = color: symbol: value:
    "[─](fg:base02)[](fg:${color})[${symbol} ](fg:base01 bg:${color})[](fg:${color} bg:base02)[ ${value}](fg:base05 bg:base02)[](fg:base02)";
  createComponent = color: value: createAllComponent color "$symbol" value;
in {
  programs = {
    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        add_newline = true;

        format = lib.strings.concatStrings [
          "[╭](fg:base02)"
          "$username"
          # "\${custom.user_host}"
          "$directory"

          "$git_branch"
          "$nix_shell"
          "$rust"
          "$python"
          "$package"
          "$cmd_duration"

          "$line_break"
          "$character"
        ];

        fill = {
          symbol = "─";
          style = "fg:base02";
        };

        custom = {
          user_host = {
            command = "echo $USER@$(hostname)";
            when = "true";
            shell = ["bash" "--norc" "--noprofile"];
            format = createAllComponent "purple" "" "$output";
          };
        };

        username = {
          show_always = true;
          disabled = false;
          format = createAllComponent "purple" "" "$user";
        };

         hostname = {
          ssh_only = false;
          format = createAllComponent "purple" "$ssh_symbol" "$hostname";
          disabled = false;
        };


        directory = {
          disabled = false;
          format = createAllComponent "bright-blue" "" "$path";
          home_symbol = "~";
          truncate_to_repo = false;
          truncation_length = 0;
        };

        git_branch = {
          format = createComponent "red" "$branch";
          symbol = "";
        };

        nix_shell = {
          symbol = "";
          format = createComponent "cyan" "$state( ($name))";
        };

        rust = {
          format = createComponent "orange" "$version";
          version_format = "v$raw";
          symbol = "🦀";
          style = "bold red bg:0x86BBD8";
          disabled = false;
          detect_extensions = [ "rs" ];
          detect_files = [ "Cargo.toml" ];
          detect_folders = [ ];
        };
        python = {
          format =
            createComponent "green" "$pyenv_prefix($version )(($virtualenv) )";
          python_binary = [ "python" "python3" "python2" ];
          pyenv_prefix = "pyenv ";
          pyenv_version_name = true;
          symbol = "🐍";
          version_format = "v$raw";
          disabled = false;
          detect_extensions = [ "py" ];
          detect_files = [
            "requirements.txt"
            ".python-version"
            "pyproject.toml"
            "Pipfile"
            "tox.ini"
            "setup.py"
            "__init__.py"
          ];
          detect_folders = [ ];
        };

        package = {
          format = createComponent "green" "$version";
          symbol = "📦";
          display_private = false;
          disabled = false;
          version_format = "v$raw";
        };

        cmd_duration = {
          min_time = 500;
          show_milliseconds = true;
          format = createAllComponent "yellow" "" "$duration";
        };

        character = {
          format = "[╰─$symbol](fg:base02) ";
          success_symbol = "[λ](fg:bold white)";
          error_symbol = "[×](fg:bold red)";
        };
      };
    };
  };
}
