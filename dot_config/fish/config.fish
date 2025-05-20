if status is-interactive
    # Commands to run in interactive sessions can go here
    # theme_gruvbox dark hard
    starship init fish | source
    # atuin init fish | source
    export BAT_THEME="gruvbox-dark"

    # Aliases
    alias v="nvim"
    alias dotsup="chezmoi re-add"
    alias dotspull="chezmoi update"
    alias mpc="rmpc"
    alias prop="hyprctl clients | grep -i 'class\|title\|xwayland'"
    alias ls='eza --icons=always'
    alias ff='fastfetch'
    alias la='eza --icons=always -a'
    alias lla='eza --icons=always -la'
    alias lt='eza --icons=always -la --tree'
    alias ytm='yt-dlp --cookies-from-browser firefox -o "%(artist)s - %(title)s" -x --embed-metadata'
    alias wlp='swww img'

    # Yazi Integration
    function y
        set tmp (mktemp -t "yazi-cwd.XXXXXX")
        yazi $argv --cwd-file="$tmp"
        if set cwd (command cat -- "$tmp"); and [ -n "$cwd" ]; and [ "$cwd" != "$PWD" ]
            builtin cd -- "$cwd"
        end
        rm -f -- "$tmp"
    end
end
