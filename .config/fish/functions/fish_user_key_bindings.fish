function fish_user_key_bindings
    fish_vi_key_bindings

    bind -M insert jk "set fish_bind_mode default; commandline -f backward-char force-repaint"
    bind -M insert \cd delete-char
    bind -M insert \cd\cd\cd\cd\cd\cd\cd\cd\cd\cd delete-or-exit
    bind -M default \cd delete-char
    bind -M default \cd\cd\cd\cd\cd\cd\cd\cd\cd\cd delete-or-exit
end
