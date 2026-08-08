set -g fish_greeting ""
set -g fish_pager_color_progress green

set -g hydro_symbol_start "\n"
set -g hydro_symbol_prompt ❯
set -g hydro_color_prompt magenta
set -g hydro_color_git magenta
set -g hydro_color_pwd blue
set -g hydro_color_duration yellow
set -g hydro_color_error red
set -g hydro_multiline true
set -g hydro_cmd_duration_threshold 5000

set -gx EDITOR hx
set -gx MANPAGER "sh -c 'col -bx | bat -l man -p'"
set -gx MANROFFOPT -c
set -gx GPG_TTY (tty)

# macOS has no XDG_RUNTIME_DIR; launchd already exports a working SSH_AUTH_SOCK there
if test -n "$XDG_RUNTIME_DIR"
    set -gx SSH_AUTH_SOCK $XDG_RUNTIME_DIR/ssh-agent.socket
end

set -gx CARGO_HOME "$HOME/.cargo"
set -gx PNPM_HOME "$HOME/.local/share/pnpm"

fish_add_path $HOME/.local/bin
fish_add_path $CARGO_HOME/bin
fish_add_path $PNPM_HOME/bin

alias ls="eza -la --group-directories-first"
alias z="zellij attach -c"

if status is-interactive
    fastfetch
end

zoxide init fish --cmd cd | source
