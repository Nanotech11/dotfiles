function fish_user_key_bindings
    fish_vi_key_bindings

    bind -M insert jk "set fish_bind_mode default; commandline -f backward-char force-repaint"
end
