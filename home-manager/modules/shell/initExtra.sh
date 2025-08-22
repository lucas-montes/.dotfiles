_fzf() {
    find $@ \( -name ".direnv" -o -name ".venv" -o -name "*cache*" -o -name ".git" -o -name "build" -o -name "target" \) -prune -o -type f -o -type d -print | fzf
}

_new_project() {
    cp "$HOME"/.dotfiles/templates/rust/{.gitignore,.envrc,flake.nix} .
}

_fzf_tmux() {
    _new_named_session "$(_fzf $@)"
}

_new_named_session() {

    #if [[ $# -eq 1 ]]; then
    #	selected=$1
    #else
    #	selected=$(find ~/ ~/Projects/ -mindepth 1 -maxdepth 1 -type d | fzf)
    #fi
    if [[ -d $1 || -f $1 ]]; then
        name=$(basename "$1" | tr . _)
        dir_to_go=$(realpath "$1")
    else
        echo "WTF $1"
        return 1
    fi

    tmux_running=$(pgrep tmux)

    if [[ -z $TMUX ]] && [[ -z $tmux_running ]]; then
        tmux new-session -s "$name" -c "$dir_to_go"
        exit 0
    fi

    if ! _tmux_has_session "$name"; then
        tmux new-session -ds "$name" -c "$dir_to_go"
    fi

    if [[ -z $TMUX ]]; then
        tmux attach-session -t "$name"
    else
        tmux switch-client -t "$name"
    fi
}

# Start UWSM
if uwsm check may-start >/dev/null && uwsm select; then
    exec systemd-cat -t uwsm_start uwsm start default
fi

_tmux_has_session() {
    tmux list-sessions | grep -q "^$1:"
}
