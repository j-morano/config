function fish_user_key_bindings
    fish_vi_key_bindings
    for mode in insert default visual
        bind -M $mode \ei forward-char
        bind -M $mode \eo forward-word
    end
    for mode in default visual
        bind -M $mode ñ backward-char
        bind -M $mode \; backward-char
    end
    # bind \ek up-or-search
    # bind \ej down-or-search
end
