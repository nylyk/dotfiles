$env.config.show_banner = false

$env.config.buffer_editor = "hx"
$env.EDITOR = "hx"

$env.CARGO_HOME = ($env.HOME | path join ".cargo")
$env.PNPM_HOME = ($env.HOME | path join ".local" "share" "pnpm")

$env.PATH ++= [
    ($env.HOME | path join ".local" "bin"),
    ($env.CARGO_HOME | path join "bin"),
    $env.PNPM_HOME
]

fastfetch

mkdir ($nu.data-dir | path join "vendor/autoload")
starship init nu | save -f ($nu.data-dir | path join "vendor/autoload/starship.nu")
carapace _carapace nushell | save -f ($nu.data-dir | path join "vendor/autoload/carapace.nu")

$env.GPG_TTY = (tty)
$env.SSH_AUTH_SOCK = (gpgconf --list-dirs agent-ssh-socket)
gpg-connect-agent updatestartuptty /bye | ignore

alias ? = echo $env.LAST_EXIT_CODE
alias ls = eza
alias ll = eza -l
alias la = eza -la
alias y = yazi
alias ssh_kitty = kitty +kitten ssh
