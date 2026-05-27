if status is-interactive
    set -x PATH ~/.local/bin $PATH
    function fish_greeting
        fastfetch
    end
    starship init fish | source
    zoxide init fish | source
    atuin init fish | source

    # Aliases
    alias hx="helix"
    alias typ="ttyper"
    alias v="nvim"
    alias vim="nvim"
    alias dotsup="chezmoi re-add"
    alias dotspull="chezmoi update"
    alias mpc="rmpc"
    alias prop="hyprctl clients | grep -i 'class\|title\|xwayland'"
    alias ls='eza --icons=always'
    alias ff='fastfetch'
    alias la='eza --icons=always -a'
    alias lla='eza --icons=always -la'
    alias lt='eza --icons=always -la --tree'
end
