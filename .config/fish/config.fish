if status is-interactive
    # Sourcing
    fnm env | source
    zoxide init fish | source
    direnv hook fish | source

    # Bindings
    bind \ct _fzf_search_directory
    bind \ce nvim

    # Aliases
    alias upgrade="paru -Syu && flatpak update"

    # Fzf find
    alias cd="z"

    # Cool ls
    alias ls='eza -a --icons'
    alias ll='eza -al --icons'
    alias lt='eza -a --tree --level=1 --icons'

    fastfetch

    fish_config prompt choose nim

    set -U fish_greeting ""
end
