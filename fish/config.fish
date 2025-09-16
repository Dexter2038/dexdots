if status is-interactive
    # Starship custom prompt
    starship init fish | source

    # Custom colours
    cat ~/.local/state/caelestia/sequences.txt 2>/dev/null

    # For jumping between prompts in foot terminal
    function mark_prompt_start --on-event fish_prompt
        echo -en "\e]133;A\e\\"
    end

    # Sourcing
    fnm env | source
    zoxide init fish | source
    direnv hook fish | source

    # Aliases
    #alias upgrade="paru -Syu && flatpak update"

    # Fzf find
    alias cd="z"

    # Cool ls
    alias ls='eza -a --icons'
    alias ll='eza -al --icons'
    alias lt='eza -a --tree --level=1 --icons'
end
