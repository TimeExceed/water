if status is-interactive
    function fish_prompt 
        printf '\n[%s%s%s %s%s%s]\n$ ' \
            (set_color green) (date +%H:%M:%S) (set_color normal) \
            (set_color blue) (pwd) (set_color normal)
    end

    set --export EDITOR emacs
    alias e=emacs
    alias cat=batcat
    alias ls='eza -lh@'
end
