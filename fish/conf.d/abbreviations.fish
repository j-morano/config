# Abbreviations
if status --is-interactive
    # Git
    abbr --add -g g 'git'
    abbr --add -g ga 'git add'
    abbr --add -g gb 'git branch'
    abbr --add -g gbl 'git blame'
    abbr --add -g gc 'git commit -m "'
    abbr --add -g gca 'git commit --amend'
    abbr --add -g gco 'git checkout'
    abbr --add -g gcp 'git cherry-pick'
    abbr --add -g gd 'git diff --word-diff'
    abbr --add -g grd 'git diff'
    abbr --add -g gf 'git fetch'
    abbr --add -g gl 'git log'
    abbr --add -g gm 'git merge'
    abbr --add -g gp 'git push'
    abbr --add -g gpf 'git push --force-with-lease'
    abbr --add -g gpl 'git pull'
    abbr --add -g gr 'git remote'
    abbr --add -g grb 'git rebase'
    abbr --add -g gt 'git status'
    abbr --add -g gsh 'git stash'
    # Disks
    abbr --add -g mountsw 'udisksctl mount -b /dev/disk/by-label/SW1000'
    abbr --add -g unmountsw 'udisksctl unmount -b /dev/disk/by-label/SW1000'
    # Open dir
    abbr --add -g o 'nohup nautilus --new-window . </dev/null >/dev/null 2>&1 & disown'
    abbr --add -g oe 'nohup nautilus --new-window . </dev/null >/dev/null 2>&1 & disown && exit'
    # Xclip
    abbr --add -g xc 'xclip -sel clip'
end
