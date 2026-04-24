set -U fish_greeting ""

set -gx EDITOR hx
set -gx GPG_TTY (tty)

set -gx CARGO_HOME "$HOME/.cargo"
set -gx PNPM_HOME "$HOME/.local/share/pnpm"

fish_add_path $HOME/.local/bin
fish_add_path $CARGO_HOME/bin
fish_add_path $PNPM_HOME

fastfetch
starship init fish | source

alias ls=eza
alias ll="eza -l"
alias la="eza -la"
