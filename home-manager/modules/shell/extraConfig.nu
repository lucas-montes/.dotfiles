let carapace_completer = {|spans|
    carapace $spans.0 nushell ...$spans | from json
}

def nufzf [] {$in | each {|i| $i | to json --raw} | str join "\n" | fzf  | from json}

def _tmux_has_session [name: string] {
  let result = (tmux list-sessions | complete)
  $result.exit_code == 0 and ($result.stdout | lines | find $'($name):' | is-not-empty)
}

def _new_named_session [path: path] {
  if not ($path | path exists) {
    echo $"WTF ($path)"
    return 1
  }

  let name = ($path | path basename | str replace -a '.' '_')
  let dir_to_go = ($path | path expand)

  let tmux_running = (tmux has-session 2>/dev/null | complete | $in.exit_code == 0)

  if ($env.TMUX? | is-empty) and (not $tmux_running) {
    tmux new-session -s $name -c $dir_to_go
  } else {
    if not (_tmux_has_session $name) {
      tmux new-session -ds $name -c $dir_to_go | complete
    }

    if ($env.TMUX? | is-empty) {
      tmux attach-session -t $name
    } else {
      tmux switch-client -t $name
    }
  }
}

def _fzf_tmux [path: path] {
  _new_named_session (glob $"($path)/**" --depth 1 --no-file | nufzf)
}


def l [...args] { ls -lsa ...(if $args == [] {["."]} else {$args}) | sort-by type name -i }

$env.config = {
    show_banner: false,
    completions: {
    case_sensitive: false # case-sensitive completions
    quick: true    # set to false to prevent auto-selecting completions
    partial: true    # set to false to prevent partial filling of the prompt
    algorithm: "fuzzy"    # prefix or fuzzy
    external: {
    # set to false to prevent nushell looking into $env.PATH to find more suggestions
        enable: true
    # set to lower can improve completion performance at the cost of omitting some options
        max_results: 100
        completer: $carapace_completer # check 'carapace_completer'
    }
    }
}
